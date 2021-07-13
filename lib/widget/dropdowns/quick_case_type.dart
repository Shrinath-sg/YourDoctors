import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/cubit/quick_appointment/quick_appointment_case_types_cubit.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/appointment_case_type.dart';
import 'package:YOURDRS_FlutterAPP/network/services/quick_appointments/quick_appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuickCaseTypeDropDown extends StatefulWidget {
  final onTapCaseType;
  final int selectedCaseType;
  QuickCaseTypeDropDown({@required this.onTapCaseType, this.selectedCaseType});
  @override
  _QuickCaseTypeDropDownState createState() => _QuickCaseTypeDropDownState();
}

class _QuickCaseTypeDropDownState extends State<QuickCaseTypeDropDown> {
  var _currentSelectedCase;
  QuickAppointmentService apiServices = QuickAppointmentService();
  CaseTypes caseTypes;
  // ignore: deprecated_member_use
  List<CaseTypes> data = List();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    BlocProvider.of<QuickAppointmentCaseTypesCubit>(context)
        .getAppointmentCaseTypes();
  }

  @override
  void initState() {
    super.initState();
    _currentSelectedCase = widget.selectedCaseType;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
        QuickAppointmentCaseTypesCubit,
        QuickAppointmentCaseTypesState>(
      listener: (context, state) {
        if (state.errorMsg != null) {
          print(state.errorMsg);
        }
        if (state.casetypeList != null) {
          data = state.casetypeList;
          if(_currentSelectedCase != null){
            caseTypes = data.where((element) => element.id==_currentSelectedCase).first;
          }
        }
      },
      child: BlocBuilder<
          QuickAppointmentCaseTypesCubit,
          QuickAppointmentCaseTypesState>(
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
                return DropdownMenuItem<CaseTypes>(
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
              value: caseTypes,
              searchHint: Text(AppStrings.select,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: AppFonts.regular,
                      fontWeight: FontWeight.bold)),
              onChanged: (value) {
                setState(() {
                  caseTypes = value;
                  widget.onTapCaseType(value);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
