import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/cubit/manual_dictation_cubit/practice_cubit.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/practice.dart';
import 'package:YOURDRS_FlutterAPP/network/services/schedules/appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PracticeDropDown extends StatefulWidget {
  final onTapOfPractice;
  final String selectedPracticeId;
  PracticeDropDown({@required this.onTapOfPractice, this.selectedPracticeId});
  @override
  _PracticeState createState() => _PracticeState();
}

class _PracticeState extends State<PracticeDropDown> {
  var _currentSelectedValue;
  bool asTabs = false;
  Services apiServices = Services();
  PracticeList practiceList;
  //List<LocationList> _list=[];
  List data = List();

  @override
  void initState() {
    super.initState();
    _currentSelectedValue = widget.selectedPracticeId;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    BlocProvider.of<PracticeListCubit>(context).getRecordsPractice();

    if (mounted) {
      setState(() {});
    }
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
    return BlocListener<PracticeListCubit, PracticeCubitState>(
      listener: (context, state) {
        if (state.errorMsg != null) {
          print(state.errorMsg);
        }
        if (state.practice != null) {
          data = state.practice;
        }
      },
      child: BlocBuilder<PracticeListCubit, PracticeCubitState>(
          builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.95,
          child: SearchableDropdown.single(
            underline: Padding(padding: EdgeInsets.all(1)),
            displayClearIcon: false,
            hint: Text(
              AppStrings.selectpractice_text,
              style: TextStyle(
                fontFamily: AppFonts.regular,
                fontSize: 12,
              ),
            ),
            items: data.map((item) {
              return DropdownMenuItem<PracticeList>(
                  child: Text(
                    item?.name ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.regular,
                      fontSize: 14,
                    ),
                  ),
                  value: item);
            }).toList(),
            isExpanded: true,
            value: practiceList,
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
