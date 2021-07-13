import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/cubit/quick_appointment/quick_appointment_type_cubit.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/quick_appointment_type.dart';
import 'package:YOURDRS_FlutterAPP/network/services/quick_appointments/quick_appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuickAppointmentTypeDropDown extends StatefulWidget {
  final onTapAppointmentType;
  final int selectedAppointmentType;
  QuickAppointmentTypeDropDown({@required this.onTapAppointmentType, this.selectedAppointmentType});
  @override
  _QuickAppointmentTypeDropDownState createState() => _QuickAppointmentTypeDropDownState();
}

class _QuickAppointmentTypeDropDownState extends State<QuickAppointmentTypeDropDown> {
  var _currSelectedAppointment;
  QuickAppointmentService apiServices = QuickAppointmentService();
  AppointmentTypeList appointmentTypeList;

  // ignore: deprecated_member_use
  List data = List();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    BlocProvider.of<QuickAppointmentTypeCubit>(context)
        .getAppointmentTypes();
  }

  @override
  void initState() {
    super.initState();
    _currSelectedAppointment = widget.selectedAppointmentType;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
        QuickAppointmentTypeCubit,
        QuickAppointmentTypeState>(
      listener: (context, state) {
        if (state.errorMsg != null) {
          print(state.errorMsg);
        }
        if (state.appointmentTypeList != null) {
          data = state.appointmentTypeList;
          if(_currSelectedAppointment != null) {
            appointmentTypeList = data.where((element) => element.id == _currSelectedAppointment).first;
          }
        }
      },
      child: BlocBuilder<
          QuickAppointmentTypeCubit,
          QuickAppointmentTypeState>(
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
                return DropdownMenuItem<AppointmentTypeList>(
                    child: Text(
                      item?.name ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: AppFonts.regular,
                          fontSize: 14),
                    ),
                    value: item);
              })?.toList() ?? [],
              isExpanded: true,
              underline: Padding(
                padding: EdgeInsets.all(1),
              ),
              value: appointmentTypeList,
              searchHint: Text(AppStrings.select,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: AppFonts.regular,
                      fontWeight: FontWeight.bold)),
              onChanged: (value) {
                setState(() {
                  appointmentTypeList = value;
                  widget.onTapAppointmentType(value);
                });
              },
            ),
          );
        },
      ),
    );
  }
}