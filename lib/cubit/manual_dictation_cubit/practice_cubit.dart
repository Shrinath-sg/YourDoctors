import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_response.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/practice.dart';
import 'package:YOURDRS_FlutterAPP/network/services/external_attachment/all_external_attachment_service.dart';
import 'package:YOURDRS_FlutterAPP/network/services/schedules/appointment_service.dart';
import 'package:bloc/bloc.dart';

part 'practice_state.dart';

class PracticeListCubit extends Cubit<PracticeCubitState> {
  DropdownService practiceApiService = DropdownService();

  PracticeListCubit() :super(PracticeCubitState.initial());

  getRecordsPractice() async{
    emit(state.reset());
    emit(state.copyWith(isLoading: true));

    var practiceApiResponse = await practiceApiService.getPratices();
    if(practiceApiResponse?.header?.statusCode=="200"){
      emit(state.copyWith(isLoading: false,
      errorMsg: null,
      practice: practiceApiResponse.practiceList));
    }
    else{
      emit(state.copyWith(
        isLoading: false,
        errorMsg: practiceApiResponse?.header?.statusMessage ?? ApiResponse.DEFAULT_ERROR_MESSAGE
      ));
    }
  }
}