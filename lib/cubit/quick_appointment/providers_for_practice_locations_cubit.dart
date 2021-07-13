import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/providers_for_practice_locations.dart';
import 'package:YOURDRS_FlutterAPP/network/services/quick_appointments/quick_appointment_service.dart';
import 'package:bloc/bloc.dart';

part 'providers_for_practice_locations_state.dart';

class ProvidersForPracticeLocationsCubit extends Cubit<ProvidersForPracticeLocationsState> {
  QuickAppointmentService providersForPracticeLocationsServices = QuickAppointmentService();
  int practiceLocationId;

  ProvidersForPracticeLocationsCubit() : super(ProvidersForPracticeLocationsState.initial());
  getProvidersForPracticeLocations(practiceLocationId) async{
    emit(state.reset());

    emit(state.copyWith(isLoading: true));
    var providersForPracticeLocationsApiResponse = await providersForPracticeLocationsServices.getProviders(practiceLocationId);
    if(providersForPracticeLocationsApiResponse?.header?.statusCode=="200"){
      emit(state.copyWith(isLoading: false,errorMsg: null, providers: providersForPracticeLocationsApiResponse.memberList));

    }
    else{
      emit(state.copyWith(isLoading: false,errorMsg: providersForPracticeLocationsApiResponse?.header?.statusMessage));
    }
  }
}