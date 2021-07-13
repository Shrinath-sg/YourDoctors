import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/widget/buttons/raised_buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateFilter extends StatefulWidget {
@override
DateFilterState createState() => DateFilterState();
}

class DateFilterState extends State<DateFilter> {
String range;
String _selectedDate;
String _dateCount;
String _rangeCount;
String startDate;
String endDate;
Object dateRange = [];
bool isEnabled = true;
@override
void initState() {
  range = '';
  isEnabled = false;
  super.initState();
}

onClickOfOk() {
  Navigator.pop(context, dateRange);
}

void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  setState(() {
    try {
      if (args.value is PickerDateRange) {
        startDate = AppConstants.parseDate(-1, AppConstants.MMDDYYYY,
            dateTime: args.value.startDate);
        endDate = AppConstants.parseDate(-1, AppConstants.MMDDYYYY,
            dateTime: args.value.endDate ?? args.value.startDate);
        range = AppStrings. daterangetxt2+ '\t'+
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
        var obj = [startDate, endDate];
        dateRange = obj;
        this.isEnabled = true;
      } else if (args.value is DateTime) {
        _selectedDate = args.value;
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    } catch (e) {
      // print(e);
    }
  });
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  return SafeArea(
      child: Scaffold(
    body: Container(
      child: ListView(
        children: [
          Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 15),
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width,
                color: CustomizedColors.accentColor,
                child: Text(
                AppStrings.calendar,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomizedColors.textColor,
                      fontSize: 20,
                      fontFamily: AppFonts.regular),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  child: Text(
                   range,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: AppFonts.regular),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.60,
                // height: height1,
                child: SfDateRangePicker(
                  view: DateRangePickerView.month,
                  monthViewSettings: DateRangePickerMonthViewSettings(
                      blackoutDates: List<DateTime>()
                        ..add(DateTime(2020, 03, 26)),
                      weekendDays: List<int>()..add(7)..add(6),
                      specialDates: List<DateTime>()
                        ..add(DateTime(2020, 03, 20))
                        ..add(DateTime(2020, 03, 16))
                        ..add(DateTime(2020, 03, 17)),
                      showTrailingAndLeadingDates: true),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    weekendDatesDecoration: BoxDecoration(
                        color: const Color(0xFFDFDFDF),
                        border: Border.all(
                            color: const Color(0xFFB6B6B6), width: 1),
                        shape: BoxShape.circle),
                  ),
                  navigationDirection:
                      DateRangePickerNavigationDirection.vertical,
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  selectionColor: Colors.purple,
                  startRangeSelectionColor: CustomizedColors.accentColor,
                  endRangeSelectionColor: CustomizedColors.accentColor,
                  todayHighlightColor: CustomizedColors.accentColor,
                  initialSelectedRange: PickerDateRange(
                      DateTime.now().subtract(const Duration(days: 4)),
                      DateTime.now().add(const Duration(days: 3))),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.050,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RaisedButtons(
                      text: AppStrings.cancel,
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  RaisedButtons(
                      text: AppStrings.ok,
                      onPressed: isEnabled ? () => onClickOfOk() : null),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  ));
}
}
