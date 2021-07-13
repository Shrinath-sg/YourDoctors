import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_response.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/case_type_states.dart';
import 'package:YOURDRS_FlutterAPP/network/services/quick_appointments/quick_appointment_service.dart';
import 'package:bloc/bloc.dart';

part 'case_type_states_state.dart';

class CaseTypeStatesCubit extends Cubit<CaseTypeStatesState> {
  CaseTypeStatesCubit() : super(CaseTypeStatesState());
  QuickAppointmentService quickAppointmentService = QuickAppointmentService();

  getCaseTypeStates() async{
    emit(state.reset());

    emit(state.copyWith(isLoading: true));

    var apiResponse = await quickAppointmentService.getCaseTypeState();
    if(apiResponse?.header?.statusCode=="200"){
      emit(state.copyWith(
          isLoading: false,
          errorMsg: null,
          states: apiResponse.statesList
      ));
    }
    else{
      emit(state.copyWith(
        isLoading: false,
        errorMsg: apiResponse?.header?.statusMessage ?? ApiResponse.DEFAULT_ERROR_MESSAGE,
      ));
    }

  }
}
