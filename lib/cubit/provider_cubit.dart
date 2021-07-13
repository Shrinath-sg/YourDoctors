import 'package:YOURDRS_FlutterAPP/common/app_response.dart';
import 'package:YOURDRS_FlutterAPP/cubit/provider_state.dart';
import 'package:YOURDRS_FlutterAPP/network/services/schedules/appointment_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderListCubit extends Cubit<ProviderListCubitState> {
  Services apiServices = Services();


  ProviderListCubit() : super(ProviderListCubitState.initial());

  getRecordsCount() async {
    emit(state.reset());

    /// for loader
    emit(state.copyWith(
      isLoading: true,
    ));

 var apiResponse = await apiServices.getProviders();
    // var apiResponse = await _repo.somaGetPatientRecordsCount(patientId);

      if (apiResponse?.header?.statusCode == "200") {
        emit(state.copyWith(
            isLoading: false,
            errorMsg: null,
            providers: apiResponse.providerList));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMsg: apiResponse?.header?.statusMessage ??
              ApiResponse.DEFAULT_ERROR_MESSAGE,
        ));
      }

  }
}
