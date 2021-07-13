import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/helper/db_helper.dart';
import 'package:YOURDRS_FlutterAPP/network/services/schedules/appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/document_type.dart';

class ExternalDocumentDropDown extends StatefulWidget {
  final onTapDocument;
  String selectedDocumentType;
  ExternalDocumentDropDown(
      {@required this.onTapDocument, this.selectedDocumentType});
  @override
  _DocumentState createState() => _DocumentState();
}

class _DocumentState extends State<ExternalDocumentDropDown>
    with AutomaticKeepAliveClientMixin {
  bool asTabs = false;
  var _currSelectedDoc;
  ExternalDocumentTypesList externalDocumentTypesList;
  List<ExternalDocumentTypesList> _ExternalDocumentList = [];
  String _extrenalDocumentName;

  void _getExtrenaldocumnetListtype() async {
    final List<ExternalDocumentTypesList> _list =
        await DatabaseHelper.db.getExternalDocumentType();
    setState(() {
      _ExternalDocumentList = _list;
    });
  }

  @override
  void initState() {
    super.initState();
    _getExtrenaldocumnetListtype();
    _currSelectedDoc = widget.selectedDocumentType;
  }

  List<Widget> get appBarActions {
    return ([
      Center(
          child: Text(
        AppStrings.tab,
        style: TextStyle(fontFamily: AppFonts.regular, fontSize: 14),
      )),
      Switch(
        activeColor: Colors.white,
        value: asTabs,
        onChanged: (value) {
          setState(() {
            asTabs = value;
          });
        },
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomizedColors.accentColor,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      width: MediaQuery.of(context).size.width * 0.95,
      child: SearchableDropdown.single(
        closeButton: AppStrings.close,
        displayClearIcon: false,
        hint: Text(
          AppStrings.doctype,
          style: TextStyle(fontFamily: AppFonts.regular, fontSize: 14),
        ),
        value: externalDocumentTypesList,
        items: _ExternalDocumentList?.map((ExternalDocumentTypesList value) {
              return DropdownMenuItem<ExternalDocumentTypesList>(
                  child: Text(
                    value.externalDocumentTypeName,
                    style:
                        TextStyle(fontFamily: AppFonts.regular, fontSize: 14),
                  ),
                  value: value);
            })?.toList() ??
            [],
        isExpanded: true,
        underline: Padding(
          padding: EdgeInsets.all(1),
        ),
        searchHint: Text(AppStrings.select,
            style: TextStyle(fontSize: 14, fontFamily: AppFonts.regular)),
        onChanged: (value) {
          setState(() {
            externalDocumentTypesList = value;
            widget.onTapDocument(value);
          });
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
