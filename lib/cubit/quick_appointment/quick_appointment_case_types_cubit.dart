import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_response.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/appointment_case_type.dart';
import 'package:YOURDRS_FlutterAPP/network/services/quick_appointments/quick_appointment_service.dart';
import 'package:bloc/bloc.dart';

part 'quick_appointment_case_types_state.dart';

class QuickAppointmentCaseTypesCubit extends Cubit<QuickAppointmentCaseTypesState> {
  QuickAppointmentCaseTypesCubit() : super(QuickAppointmentCaseTypesState());
  QuickAppointmentService quickCaseTypeService = QuickAppointmentService();

  getAppointmentCaseTypes() async{
    emit(state.reset());

    emit(state.copyWith(isLoading: true));

    var apiResponse = await quickCaseTypeService.getQuickAppointmentCaseType();
    if(apiResponse?.header?.statusCode=="200"){
      emit(state.copyWith(
          isLoading: false,
          errorMsg: null,
          caseType: apiResponse.caseTypes
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
