import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_response.dart';
import 'package:YOURDRS_FlutterAPP/network/models/home/location.dart';
import 'package:YOURDRS_FlutterAPP/network/services/schedules/appointment_service.dart';
import 'package:bloc/bloc.dart';

part 'location_dropdown_state.dart';

class LocationListCubit extends Cubit<LocationListCubitState>{
  Services locationApiService = Services();

  LocationListCubit() : super(LocationListCubitState.initial());

  getRecordsLocation() async{
    emit(state.reset());

    emit(state.copyWith(isLoading: true));

    var locationApiResponse = await locationApiService.getLocation();
    if(locationApiResponse?.header?.statusCode=="200"){
      emit(state.copyWith(
          isLoading: false,
          errorMsg: null,
          location: locationApiResponse.locationList
      ));
    }
    else{
      emit(state.copyWith(
        isLoading: false,
        errorMsg: locationApiResponse?.header?.statusMessage ?? ApiResponse.DEFAULT_ERROR_MESSAGE,
      ));
    }

  }
}
