import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_response.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/time_slots.dart';
import 'package:YOURDRS_FlutterAPP/network/services/quick_appointments/quick_appointment_service.dart';
import 'package:bloc/bloc.dart';

part 'quick_time_slots_state.dart';

class QuickTimeSlotsCubit extends Cubit<QuickTimeSlotsState> {
  QuickTimeSlotsCubit() : super(QuickTimeSlotsState.initial());

  QuickAppointmentService timeSlotService = QuickAppointmentService();

  getQuickTimeSlots() async{
    emit(state.reset());

    emit(state.copyWith(isLoading: true));

    var apiResponse = await timeSlotService.getAppointmentTimeSlots();
    if(apiResponse?.header?.statusCode=="200"){
      emit(state.copyWith(
          isLoading: false,
          errorMsg: null,
          timeSlots: apiResponse.appointmentTimeSlots
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
