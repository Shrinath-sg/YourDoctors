import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/cubit/quick_appointment/practice_locations_cubit.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/practice_locations.dart';
import 'package:YOURDRS_FlutterAPP/network/services/quick_appointments/quick_appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PracticeLocationsDropDown extends StatefulWidget {
  final onTapOfPractice;
  final String selectedPracticeId;
  PracticeLocationsDropDown({@required this.onTapOfPractice, this.selectedPracticeId});
  @override
  _PracticeLocationsState createState() => _PracticeLocationsState();
}

class _PracticeLocationsState extends State<PracticeLocationsDropDown> {
  var _currentSelectedValue;
  bool asTabs = false;
  QuickAppointmentService apiServices = QuickAppointmentService();
  LocationList locationList;
  // ignore: deprecated_member_use
  List data = List();

  @override
  void initState() {
    super.initState();
    _currentSelectedValue = widget.selectedPracticeId;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    BlocProvider.of<PracticeLocationsCubit>(context).getPracticeLocations();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<PracticeLocationsCubit, PracticeLocationsState>(
      listener: (context, state) {
        if (state.errorMsg != null) {
          print(state.errorMsg);
        }
        if (state.practiceLocations != null) {
          data = state.practiceLocations;
        }
      },
      child: BlocBuilder<PracticeLocationsCubit, PracticeLocationsState>(
          builder: (context, state) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: SearchableDropdown.single(
                underline: Padding(padding: EdgeInsets.all(1)),
                displayClearIcon: false,
                hint: Text(
                  AppStrings.select,
                  style: TextStyle(
                    fontFamily: AppFonts.regular,
                    fontSize: 12,
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
                })?.toList() ?? [],
                isExpanded: true,
                isCaseSensitiveSearch: true,
                value: locationList,
                searchHint: Text(AppStrings.select,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: AppFonts.regular,
                        fontWeight: FontWeight.bold)),
                onChanged: (value) {
                  setState(() {
                    _currentSelectedValue = value;
                    widget.onTapOfPractice(value);
                  });
                },
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: CustomizedColors.accentColor,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            );
          }),
    );
  }
}
