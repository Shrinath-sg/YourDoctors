
import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/appointment_type.dart';
import 'package:YOURDRS_FlutterAPP/network/services/external_attachment/all_external_attachment_service.dart';
import 'package:YOURDRS_FlutterAPP/network/services/schedules/appointment_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/app_response.dart';

part 'appointment_type_state.dart';

class AppointmentTypeCubit extends Cubit<AppointmentTypeCubitState>{
  DropdownService appointmentTypeApiService = DropdownService();

  AppointmentTypeCubit() : super(AppointmentTypeCubitState.initial());

  getRecordsDocumentType() async{
    emit(state.reset());

    emit(state.copyWith(isLoading: true));

    var appointmentTypeApiResponse = await appointmentTypeApiService.getAppointmenttype();
    if(appointmentTypeApiResponse?.header?.statusCode=="200"){
      emit(state.copyWith(
          isLoading: false,
          errorMsg: null,
          documentType: appointmentTypeApiResponse.appointmentTypeList
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

