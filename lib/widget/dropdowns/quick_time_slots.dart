import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/cubit/quick_appointment/quick_time_slots_cubit.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/time_slots.dart';
import 'package:YOURDRS_FlutterAPP/network/services/quick_appointments/quick_appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TimeSlotsDropDown extends StatefulWidget {
  final onTapTimeSlots;
  final String selectedTimeSlots;
  final bool todayDate;
  final selectedDos;
  TimeSlotsDropDown({@required this.onTapTimeSlots, this.selectedTimeSlots, this.todayDate = false, this.selectedDos});
  @override
  _TimeSlotsDropDownState createState() => _TimeSlotsDropDownState();
}

class _TimeSlotsDropDownState extends State<TimeSlotsDropDown> {
  var _currentSelectedTime;
  QuickAppointmentService apiServices = QuickAppointmentService();
  AppointmentTimeSlots _timeSlots;
  var todayDate =
  DateFormat(AppStrings.dateFormatForDatePicker)
      .format(DateTime.now());
  List<AppointmentTimeSlots> data = List();
  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.selectedDos != "" &&
        _currentSelectedTime != widget.selectedDos){
      _currentSelectedTime = widget.selectedDos;
      BlocProvider.of<QuickTimeSlotsCubit>(context)
            .getQuickTimeSlots();
    }
    return BlocListener<
        QuickTimeSlotsCubit,
        QuickTimeSlotsState>(
      listener: (context, state) {
        if (state.errorMsg != null) {
          print(state.errorMsg);
        }
        if (state.timeSlots != null) {
          data = state.timeSlots;
          if(widget.selectedDos == todayDate){
            final now =  DateTime.now();
            data = data.where((element) {
              DateTime elementDate = DateFormat("hh:mm a").parse(element.standardTime);
              DateTime fullDateTime = DateTime(now.year,now.month,now.day,elementDate.hour,elementDate.minute,elementDate.second);
              return now.isBefore(fullDateTime);
            }).toList();
          }
        }
      },
      child: BlocBuilder<
          QuickTimeSlotsCubit,
          QuickTimeSlotsState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: CustomizedColors.accentColor,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.95,
            child: SearchableDropdown.single(
              displayClearIcon: false,
              //validator: (value) => value == null ? 'Cannot be empty' : null,
              hint: Text(
                AppStrings.select,
                style: TextStyle(fontFamily: AppFonts.regular, fontSize: 14),
              ),

              items: data?.map((item) {
                return DropdownMenuItem<AppointmentTimeSlots>(
                    child: Text(
                      item?.standardTime ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: AppFonts.regular,
                          fontSize: 14),
                    ),
                    value: item);
              })?.toList() ??[],
              isExpanded: true,
              isCaseSensitiveSearch: true,
              underline: Padding(
                padding: EdgeInsets.all(1),
              ),
              value: _timeSlots ?? null,
              searchHint: Text(AppStrings.select,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: AppFonts.regular,
                      fontWeight: FontWeight.bold)),
              onChanged: (value) {
                  _timeSlots = value;
                  widget.onTapTimeSlots(value);
              },
            ),
          );
        },
      ),
    );
  }
}
