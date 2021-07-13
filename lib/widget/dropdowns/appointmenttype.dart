import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/network/services/schedules/appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/appointment_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/manual_dictation_cubit/appointment_type_cubit.dart';

class AppointmentDropDown extends StatefulWidget {
  final onTapOfAppointment;
  String selectedAppointmentType;

  AppointmentDropDown(
      {@required this.onTapOfAppointment, this.selectedAppointmentType});
  @override
  _AppointmentDropDownState createState() => _AppointmentDropDownState();
}

class _AppointmentDropDownState extends State<AppointmentDropDown>
    with AutomaticKeepAliveClientMixin {
  String _currSelectedAppointent;
  bool asTabs = false;
  Services apiServices = Services();
  AppointmentTypeList appointmentTypeList;
  //List<LocationList> _list=[];
  List data = List();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    BlocProvider.of<AppointmentTypeCubit>(context).getRecordsDocumentType();

//_currentSelectedValue=data;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _currSelectedAppointent = widget.selectedAppointmentType;
  }

  List<Widget> get appBarActions {
    return ([
      Center(
          child: Text(
            AppStrings.tab,
            style: TextStyle(fontFamily: AppFonts.regular),
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
    return BlocListener<AppointmentTypeCubit,AppointmentTypeCubitState>(listener: (context,state){
      if(state.errorMsg!=null)
      {
        // print(state.errorMsg!=null);
      }
      if(state.appointmentType != null)
      {
        data =state.appointmentType;
      }

    },
      child: BlocBuilder<AppointmentTypeCubit,AppointmentTypeCubitState>(
        builder: (context,state)
        {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: CustomizedColors.accentColor,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(1),
            width: MediaQuery.of(context).size.width * 0.95,
            child: SearchableDropdown.single(
              displayClearIcon: false,
              //validator: (value) => value == null ? 'Cannot be empty' : null,
              hint: Text(
                AppStrings.Appointment_Type,
                style: TextStyle(fontFamily: AppFonts.regular, fontSize: 14),
              ),
              items: data.map((item) {
                return DropdownMenuItem<AppointmentTypeList>(
                    child: Text(
                      item.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: AppFonts.regular,fontSize: 14),
                    ),
                    value: item);
              }).toList(),
              isExpanded: true,
              underline: Padding(
                padding: EdgeInsets.all(1),
              ),

              value: appointmentTypeList,
              searchHint: Text(AppStrings.Appointment_Type,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: AppFonts.regular,
                      fontWeight: FontWeight.bold)),
              onChanged: (value) {
                setState(() {
                  appointmentTypeList = value;
                  widget.onTapOfAppointment(value);
                });
              },
            ),
          );
        },
      ),
    );



  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
