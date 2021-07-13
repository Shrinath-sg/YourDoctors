import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_response.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/practice_locations.dart';
import 'package:YOURDRS_FlutterAPP/network/services/quick_appointments/quick_appointment_service.dart';
import 'package:bloc/bloc.dart';

part 'practice_locations_state.dart';

class PracticeLocationsCubit extends Cubit<PracticeLocationsState> {
  QuickAppointmentService practiceLocationsApiService = QuickAppointmentService();

  PracticeLocationsCubit() :super(PracticeLocationsState.initial());

  getPracticeLocations() async{
    emit(state.reset());
    emit(state.copyWith(isLoading: true));

    var practiceLocationsApiResponse = await practiceLocationsApiService.getPracticeLocations();
    if(practiceLocationsApiResponse?.header?.statusCode=="200"){
      emit(state.copyWith(isLoading: false,
          errorMsg: null,
          practiceLocations: practiceLocationsApiResponse.locationList));
    }
    else{
      emit(state.copyWith(
          isLoading: false,
          errorMsg: practiceLocationsApiResponse?.header?.statusMessage ?? ApiResponse.DEFAULT_ERROR_MESSAGE
      ));
    }
  }
}