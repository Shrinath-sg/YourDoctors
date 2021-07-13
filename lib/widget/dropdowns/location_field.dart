import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/cubit/manual_dictation_cubit/location_cubit.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/location_field_model.dart';
import 'package:YOURDRS_FlutterAPP/network/services/schedules/appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Locations extends StatefulWidget {
  final String PracticeIdList;
  final onTapOfLocation;
  final String selectedLocationId;
  const Locations(
      {@required this.onTapOfLocation, @required this.PracticeIdList, this.selectedLocationId});
  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  bool asTabs = false;
  Services apiServices = Services();
  LocationList locationsList;
  var _currentSelectedValue;
  
   List<LocationList> data = List();
  String practiceId;
  void initState() {
    super.initState();
    _currentSelectedValue = widget.PracticeIdList;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // BlocProvider.of<LocationCubit>(context).getAllRecordsLocation();
    // if (widget.PracticeIdList != null &&
    //         practiceId != widget.PracticeIdList) {
    //   practiceId = widget.PracticeIdList;
    //   apiServices.getExternalLocation(practiceId).then((value) {
    //     data = value.locationList;
    //     // if (mounted) {
    //     //   setState(() {});
    //     // }
    //   });
    // }
  }

  List<Widget> get appBarActions {
    return ([
      Center(
          child: Text(
        AppStrings.tab,
        style: TextStyle(
          fontFamily: AppFonts.regular,
          fontSize: 14,
        ),
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
    if (practiceId == null || (widget.PracticeIdList != null &&
        practiceId != widget.PracticeIdList)) {
      practiceId = widget.PracticeIdList;
      BlocProvider.of<LocationCubit>(context).getAllRecordsLocation(practiceId);
    }
    return BlocListener<LocationCubit, LocationCubitState>(
      listener: (context, state) {
        if (state.errorMsg != null) {
          // print(state.errorMsg);
        }
        if (state.location != null) {
          data = state.location;
           if (widget.selectedLocationId != null &&
              widget.selectedLocationId.isNotEmpty &&
              data != null &&
              data.isNotEmpty) {
            locationsList = data.firstWhere(
              (element) => element.id == int.tryParse(widget.selectedLocationId),
              orElse: () => null,
            );
          }
        }

      },
      child: BlocBuilder<LocationCubit, LocationCubitState>(
        builder: (context, state) {
          // if (practiceId == null ||
          //     (widget.PracticeIdList != null &&
          //         practiceId != widget.PracticeIdList)) {
          //   practiceId = widget.PracticeIdList;
          //   apiServices.getExternalLocation(practiceId).then((value) {
          //     data = value.locationList;
          //     if (mounted) {
          //       setState(() {});
          //     }
          //   });
          // }
          return Container(
            width: MediaQuery.of(context).size.width * 0.95,
            child: SearchableDropdown.single(
              underline: Padding(padding: EdgeInsets.all(1)),
              displayClearIcon: false,
              hint: Text(
                AppStrings.selectpractice_text,
                style: TextStyle(
                  fontFamily: AppFonts.regular,
                  fontSize: 14,
                ),
              ),
              items: data?.map((item) {
                return DropdownMenuItem<LocationList>(
                    child: Text(
                      item?.name ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppFonts.regular,
                        fontSize: 14,
                      ),
                    ),
                    value: item);
              })?.toList()??[],
              isExpanded: true,
              value: locationsList,
              searchHint: Text(AppStrings.select,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: AppFonts.regular,
                      fontWeight: FontWeight.bold)),
              onChanged: (value) {
                // setState(() {
                  //  locationsList = value;
                  // _currentSelectedValue = value;
                  widget.onTapOfLocation(value);
                // });
              },
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: CustomizedColors.accentColor,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          );
        },
      ),
    );
  }
}
