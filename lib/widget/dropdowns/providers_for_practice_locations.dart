import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/cubit/quick_appointment/providers_for_practice_locations_cubit.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/providers_for_practice_locations.dart';
import 'package:YOURDRS_FlutterAPP/network/services/quick_appointments/quick_appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderForPracticeLocationsDropDown  extends StatefulWidget {
  final int practiceLocationId;
  final int selectedProviderId;
  final onTapOfProvider;
  const ProviderForPracticeLocationsDropDown (
      {@required this.onTapOfProvider, @required this.practiceLocationId, @required this.selectedProviderId});
  @override
  _ProviderForPracticeLocationsDropDownState createState() =>
      _ProviderForPracticeLocationsDropDownState();
}

class _ProviderForPracticeLocationsDropDownState extends State<ProviderForPracticeLocationsDropDown > {
  QuickAppointmentService quickAppointmentService = QuickAppointmentService();
  MemberList memberList;
  // ignore: deprecated_member_use
  List<MemberList> data = List();
  int practiceLocationId;
  final key = GlobalKey<SearchableDropdownState>();

  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.practiceLocationId != null &&
        practiceLocationId != widget.practiceLocationId) {
      practiceLocationId = widget.practiceLocationId;
      BlocProvider.of<ProvidersForPracticeLocationsCubit>(context).getProvidersForPracticeLocations(practiceLocationId);
    }

    return BlocListener<ProvidersForPracticeLocationsCubit, ProvidersForPracticeLocationsState>(
      listener: (context, state) {
        if (state.errorMsg != null) {
          print(state.errorMsg);
        }
        if (state.providers != null) {
          data = state.providers;
          if(widget.selectedProviderId != null){
            memberList = data.where((element) => element.memberId==widget.selectedProviderId).first;
          }
        }
      },
      child: BlocBuilder<ProvidersForPracticeLocationsCubit, ProvidersForPracticeLocationsState>(
          builder: (context, state) {
            return Container(
              //height: 100,
              width: MediaQuery.of(context).size.width * 0.95,

              child: SearchableDropdown.single(
                // key: key,
                underline: Padding(padding: EdgeInsets.all(1)),
                displayClearIcon: false,
                hint: Text(
                  AppStrings.selectpractice_text,
                  style: TextStyle(fontFamily: AppFonts.regular, fontSize: 14),
                ),
                items: data?.map((item) {
                  return DropdownMenuItem<MemberList>(
                      child: Text(
                        item?.displayName ?? "",
                        overflow: TextOverflow.ellipsis,
                        style:
                        TextStyle(fontFamily: AppFonts.regular, fontSize: 14),
                      ),
                      value: item);
                })?.toList() ?? [],
                isExpanded: true,
                isCaseSensitiveSearch: true,
                value: memberList,
                searchHint: Text(AppStrings.select,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: AppFonts.regular,
                        fontWeight: FontWeight.bold)),
                onChanged: (value) {
                  setState(() {
                    memberList = value;
                    widget.onTapOfProvider(value);
                  });
                  // widget.onTapOfProvider(value);

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
