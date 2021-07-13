import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_response.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/matching_patient.dart';
import 'package:YOURDRS_FlutterAPP/network/services/quick_appointments/quick_appointment_service.dart';
import 'package:bloc/bloc.dart';

part 'matching_patient_state.dart';

class MatchingPatientCubit extends Cubit<MatchingPatientState> {
  QuickAppointmentService matchingPatientsService = QuickAppointmentService();

  MatchingPatientCubit() :super(MatchingPatientState.initial());

  getPatientList(String firstName, String lastName, String gender, String dob, int pageNumber) async{
    emit(state.reset());
    emit(state.copyWith(isLoading: true));

    var matchingPatientApiResponse = await matchingPatientsService.getMatchingPatients(firstName, lastName, gender, dob, pageNumber);
    if(matchingPatientApiResponse?.header?.statusCode=="200"){
      emit(state.copyWith(isLoading: false,
          errorMsg: null,
          patients: matchingPatientApiResponse.patientList));
    }
    else{
      emit(state.copyWith(
          isLoading: false,
          errorMsg: matchingPatientApiResponse?.header?.statusMessage ?? ApiResponse.DEFAULT_ERROR_MESSAGE
      ));
    }
  }
}