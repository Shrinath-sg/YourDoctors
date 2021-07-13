import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_response.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/location_field_model.dart';
import 'package:YOURDRS_FlutterAPP/network/services/external_attachment/all_external_attachment_service.dart';
import 'package:YOURDRS_FlutterAPP/network/services/schedules/appointment_service.dart';
import 'package:bloc/bloc.dart';


part 'location_state.dart';

class LocationCubit extends Cubit<LocationCubitState> {
  DropdownService locationApiServices = DropdownService();
  String practiceIdList;

  LocationCubit() : super(LocationCubitState.initial());
  getAllRecordsLocation(practiceIdList) async{
    emit(state.reset());

    emit(state.copyWith(isLoading: true));
    var locationApiResponse = await locationApiServices.getExternalLocation(practiceIdList);
    if(locationApiResponse?.header?.statusCode=="200"){
      emit(state.copyWith(isLoading: false,errorMsg: null, location: locationApiResponse.locationList));

    }
    else{
      emit(state.copyWith(isLoading: false,errorMsg: locationApiResponse?.header?.statusMessage??ApiResponse.DEFAULT_ERROR_MESSAGE));
    }
  }
}
