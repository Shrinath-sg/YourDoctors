import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_response.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/quick_appointment_type.dart';
import 'package:YOURDRS_FlutterAPP/network/services/quick_appointments/quick_appointment_service.dart';
import 'package:bloc/bloc.dart';

part 'quick_appointment_type_state.dart';

class QuickAppointmentTypeCubit extends Cubit<QuickAppointmentTypeState> {
  QuickAppointmentTypeCubit() : super(QuickAppointmentTypeState.initial());
  QuickAppointmentService _quickAppointmentTypeService = QuickAppointmentService();

  getAppointmentTypes() async{
    emit(state.reset());

    emit(state.copyWith(isLoading: true));

    var appointmentTypeApiResponse = await _quickAppointmentTypeService.getQuickAppointmentType();
    if(appointmentTypeApiResponse?.header?.statusCode=="200"){
      emit(state.copyWith(
          isLoading: false,
          errorMsg: null,
          appointmentTypeList: appointmentTypeApiResponse.appointmentTypeList
      ));
    }
    else{
      emit(state.copyWith(
        isLoading: false,
        errorMsg: appointmentTypeApiResponse?.header?.statusMessage ?? ApiResponse.DEFAULT_ERROR_MESSAGE,
      ));
    }

  }
}
