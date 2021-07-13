import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_loader.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_all_external_attachments_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_external_document_details.dart';
import 'package:YOURDRS_FlutterAPP/network/services/external_attachment/all_external_attachment_service.dart';
import 'package:YOURDRS_FlutterAPP/ui/external_attachment/allattachment/external_localfile/externalallattachment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'externalattachment_lists.dart';

class GetMyAttachments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GetMyAttachmentsState();
  }
}

class GetMyAttachmentsState extends State<GetMyAttachments> {
  /// Declaring variables
  AppToast appToast = AppToast();
  bool _hasMore = true;
  int _pageNumber = 0;
  bool _error = false;
  bool _loading = false;
  List<ExternalDocumentList> _externalAttachments = [];
  int thresholdValue = 0;
  bool isInternetAvailable;
  int externalAttachmentId;
  String imageName;
  String attachmentName;
  bool hasData = false;
  List imageList = [];

  AllMyExternalAttachments apiServices = AllMyExternalAttachments();
  GetExternalDocumentDetailsService apiService2 =
      GetExternalDocumentDetailsService();
  GetExternalPhotosService apiService3 = GetExternalPhotosService();
  //Infinite Scroll Pagination related code//
  var _scrollController = ScrollController();
  double maxScroll, currentScroll;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    isInternetAvailable = await AppConstants.checkInternet();
    _getApiExternalAttachments();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    try {
      if (maxScroll > 0 && currentScroll > 0 && maxScroll == currentScroll) {
        _getApiExternalAttachments();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      controller: _scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExternalAllattachment(),
          getExternalDocsList(),
        ],
      ),
    );
  }

  Widget getExternalDocsList() {
    if (_loading && _pageNumber == 1) {
      return _loader();
    }

    if (_error) {
      return _errorText(message: AppStrings.somethingwentwrong_text);
    }

    return _externalAttachments?.isNotEmpty ?? false
        ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _externalAttachments.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _externalAttachments.length) {
                return _loader();
              }

              final ExternalDocumentList externalDocuments =_externalAttachments[index];
              return AnimationLimiter(
                  child: Column(children: [
                AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 250),
                    child: FadeInAnimation(
                        child: SlideAnimation(
                            horizontalOffset:
                                MediaQuery.of(context).size.width / 2,
                            child: InkWell(
                              onTap: () async {
                                showLoaderDialog(context,
                                    text: AppStrings.loading);

                                int externalAttachmentId =
                                    externalDocuments.externalAttachmentId;

                                GetExternalDocumentDetails
                                    getExternalDocumentDetails =
                                    await apiService2
                                        .getExternalDocumentDetails(
                                            externalAttachmentId);

                                if (getExternalDocumentDetails != null) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ExternalAttachmentScreen(),
                                      settings: RouteSettings(arguments: {
                                        "getExternalDocumentDetails":
                                            getExternalDocumentDetails,
                                        "externalDocuments": externalDocuments,
                                      }),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.all(3),
                                child: Card(
                                  child: Row(
                                    children: [
                                         Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                                padding: new EdgeInsets.all(3.0)),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.8,
                                              child: Text(
                                                externalDocuments.displayFileName,
                                                style: TextStyle(
                                                    fontFamily: AppFonts.regular,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                         IconButton(
                                          icon: Icon(
                                            Icons.cloud_done,
                                            size: 34,
                                            color: CustomizedColors.primaryColor,
                                          ),
                                          onPressed: () {
                                            appToast.showToast(
                                                AppStrings.alreadyuploaded_text);
                                          },
                                        ),

                                    ],
                                  ),
                                ),
                              ),
                            ))))
              ]));
            })
        : _errorText(message: AppStrings.noexternaldocumentsfound_text);
  }

  _getApiExternalAttachments() async {
    if (!mounted) return;

    if (isInternetAvailable) {
      if (!_hasMore) {
        appToast.showToast(AppStrings.nofurtherdocumentsfound_text);
        return;
      }

      setState(() {
        _loading = true;
        _error = false;
      });

      _pageNumber = _pageNumber + 1;
      GetAllExternalAttachments allMyExternalAttachments =
          await apiServices.getMyAllExternalAttachemnts(_pageNumber);
      if(mounted){
      setState(() {
        _loading = false;
      });}

      if (allMyExternalAttachments != null) {
        if (allMyExternalAttachments.externalDocumentList == null ||
            allMyExternalAttachments.externalDocumentList.isEmpty) {
          _hasMore = false;
          _error = true;
        } else {
          _externalAttachments
              .addAll(allMyExternalAttachments?.externalDocumentList);
          _error = false;
        }
      } else {
        _error = true;
      }
    } else {
      appToast.showToast(AppStrings.connection_text);
    }
  }

  Widget _loader() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8),
      child: CupertinoActivityIndicator(
        radius: 20,
      ),
    ));
  }

  Widget _errorText({String message}) {
    return Center(
        child: InkWell(
      onTap: () {
        _pageNumber = 0;
        _hasMore = true;
        _getApiExternalAttachments();
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message ?? AppStrings.errorloadingphotos_text,
          style: TextStyle(
            fontFamily: AppFonts.regular,
          ),
        ),
      ),
    ));
  }

  //dispose methods//
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
