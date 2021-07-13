import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_response.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/provider_model.dart';
import 'package:YOURDRS_FlutterAPP/network/services/external_attachment/all_external_attachment_service.dart';
import 'package:YOURDRS_FlutterAPP/network/services/schedules/appointment_service.dart';
import 'package:bloc/bloc.dart';

part 'provider_state.dart';

class ProviderCubit extends Cubit<ProviderCubitState> {
  DropdownService providerApiServices = DropdownService();
  String practiceLocationId;

  ProviderCubit() : super(ProviderCubitState.initial());
  getAllRecordsProvider(practiceLocationId) async{
    emit(state.reset());

    emit(state.copyWith(isLoading: true));
    var providerApiResponse= await providerApiServices.getExternalProvider(practiceLocationId);
    if(providerApiResponse?.header?.statusCode=="200"){
      emit(state.copyWith(isLoading: false,errorMsg: null, provider: providerApiResponse.providerList));

    }
    else{
      emit(state.copyWith(isLoading: false,errorMsg: providerApiResponse?.header?.statusMessage??ApiResponse.DEFAULT_ERROR_MESSAGE,provider: null));
    }
  }
}