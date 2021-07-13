import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/cubit/location_dropdown_cubit.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/searchable_dropdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../network/services/schedules/appointment_service.dart';
import 'package:flutter/material.dart';

import '../../network/models/home/location.dart';

class LocationDropDown extends StatefulWidget {
  final onTapOfLocation;
  final int selectedLocationId;
  LocationDropDown({@required this.onTapOfLocation, this.selectedLocationId});
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<LocationDropDown> {
  Services apiServices = Services();
  LocationList locationList;
  List<LocationList> _list = [];
  var locationvar;
  @override
  void initState() {
    super.initState();
    locationvar=widget.selectedLocationId;
  }
// --------> get and decode the API data <-----------
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // Locations location = await apiServices.getLocation();
    // _list = location.locationList;
    // if (mounted) {
    //   setState(() {});
    // }
    BlocProvider.of<LocationListCubit>(context).getRecordsLocation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationListCubit, LocationListCubitState>(
      listener: (context, state) {
        if (state.errorMsg != null) {
          // print(state.errorMsg);
        }
        if (state.location != null) {
          _list = state.location;
        }
        if(state.location != null){
          _list = state.location;
          if(locationvar!=null) {
            locationList=_list.where((element) => element.locationId==locationvar).first;
          }
        }

      },
      child: BlocBuilder<LocationListCubit, LocationListCubitState>(
          builder: (context, state) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.70,

// ----------> displaying Location list from API in SearchableDropdown <--------
              child: SearchableDropdown.single(
                underline: Padding(
                  padding: EdgeInsets.all(5),
                ),
                displayClearIcon: false,
                icon: const Icon(
                    Icons.arrow_drop_down, color: CustomizedColors.iconColor),
                hint: Text(AppStrings.locationtxt, style: TextStyle(
                    fontFamily: AppFonts.regular,fontSize: 14,
                    color: CustomizedColors.textColor),),

// ----------> displaying the the data which stored in data of list type <--------
                items: _list.map((item) {
                  return DropdownMenuItem<LocationList>(
                      child: Text(
                        item.locationName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: AppFonts.regular,fontSize: 14),
                      ),
                      value: item);
                }).toList(),
                isExpanded: true,
                value: locationList,
                searchHint:
                new Text(AppStrings.locationtxt, style: new TextStyle( fontWeight: FontWeight.bold,
                    fontSize: 14, fontFamily: AppFonts.regular)),
// ----------> called when a new item is selected <--------
                onChanged: (value) {
                  setState(() {
                    locationList = value;
                  });
                  widget.onTapOfLocation(value);
                },
              ),
            );
          }
      ),
    );
  }
}
