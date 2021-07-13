import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/cubit/quick_appointment/case_type_states_cubit.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/case_type_states.dart';
import 'package:YOURDRS_FlutterAPP/network/services/quick_appointments/quick_appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaseTypeStatesDropDown extends StatefulWidget {
  final onTapCaseTypeStates;
  final int selectedCaseTypeStates;
  CaseTypeStatesDropDown({@required this.onTapCaseTypeStates, this.selectedCaseTypeStates});
  @override
  _CaseTypeStatesDropDownState createState() => _CaseTypeStatesDropDownState();
}

class _CaseTypeStatesDropDownState extends State<CaseTypeStatesDropDown> {
  var _currentSelectedState;
  // QuickAppointmentService apiServices = QuickAppointmentService();
  QuickAppointmentService quickAppointmentService = QuickAppointmentService();
  StatesList statesList;
  // ignore: deprecated_member_use
  List<StatesList> data = List();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    BlocProvider.of<CaseTypeStatesCubit>(context)
        .getCaseTypeStates();
  }

  @override
  void initState() {
    super.initState();
    _currentSelectedState = widget.selectedCaseTypeStates;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
        CaseTypeStatesCubit,
        CaseTypeStatesState>(
      listener: (context, state) {
        if (state.errorMsg != null) {
          print(state.errorMsg);
        }
        if (state.statesList != null) {
          data = state.statesList;
          if(_currentSelectedState != null){
            statesList = data.where((element) => element.id ==_currentSelectedState).first;
          }
        }
      },
      child: BlocBuilder<
          CaseTypeStatesCubit,
          CaseTypeStatesState>(
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
              hint: Text(
                AppStrings.select,
                style: TextStyle(fontFamily: AppFonts.regular, fontSize: 14),
              ),

              items: data?.map((item) {
                return DropdownMenuItem<StatesList>(
                    child: Text(
                      item?.name ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: AppFonts.regular,
                          fontSize: 14),
                    ),
                    value: item);
              })?.toList() ?? [],
              isExpanded: true,
              isCaseSensitiveSearch: true,
              underline: Padding(
                padding: EdgeInsets.all(1),
              ),
              value: statesList,
              searchHint: Text(AppStrings.select,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: AppFonts.regular,
                      fontWeight: FontWeight.bold)),
              onChanged: (value) {
                setState(() {
                  statesList = value;
                  widget.onTapCaseTypeStates(value);
                });
                },
            ),
          );
        },
      ),
    );
  }
}
