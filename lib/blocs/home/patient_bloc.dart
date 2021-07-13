import 'dart:async';
import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import '../../blocs/home/patient_bloc_event.dart';
import '../../blocs/home/patient_bloc_state.dart';
import '../../network/models/home/schedule.dart';
import '../../network/services/schedules/appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';

class PatientBloc
// ---------> creaeting the constructor and calling PatientAppointmentBlocState.initial <---------
    extends BaseBloc<PatientAppointmentBlocEvent, PatientAppointmentBlocState> {
  PatientBloc() : super(PatientAppointmentBlocState.initial());

  @override
// -----> map event <---------
  Stream<PatientAppointmentBlocState> mapEventToState(
      PatientAppointmentBlocEvent
      event) async* {

    var memberId =
        await MySharedPreferences.instance.getStringValue(Keys.memberId);

// ---------> event for Search Patient <---------
    try {
      if (event is SearchPatientEvent) {
        yield state.copyWith(keyword: event.keyword);
      }
    } catch (e) {
      print(e.toString());
    }

// ---------> event for GetScheduledPatientList <---------
    try {
      if (event is GetSchedulePatientsList) {
        if(state.hasReachedMax && event.pageKey!=1){
          return ;
        }

        if (event.pageKey == 1) {
          yield state.reset();
        }
        yield state.copyWith(
          isLoading: true,
        );
        List<ScheduleGroupList> patients;
// ----> applying the events <-----------
        var list = await Services.getScheduleCountForPracticeLocation(
            event.keyword1,
            event.providerId,
            event.locationId,
            event.dictationId,
            event.startDate,
            event.endDate,
            event.searchString,
            int.tryParse(memberId),
            event.pageKey,
            event.token,
            );
// ---------> exception handling and checkiing the condition patients list is null is or empty <----

        try {
          if (list.isEmpty) {
            yield state.copyWith(hasReachedMax:true);

          }
          patients = state.patients;
          if (patients == null) {
            patients = [];
          }
          patients.addAll(list);

          if (patients.isEmpty) {
            yield state.copyWith(
                isLoading: false,
                errorMsg:AppStrings.errormsg,
                patients: patients);
          } else {
            yield state.copyWith(
                isLoading: false, errorMsg: null, patients: patients);
          }
        } catch (e) {
          print(e.toString());
        }
      } 
    } catch (e) {
      print(e.toString());
    }




  }
}
