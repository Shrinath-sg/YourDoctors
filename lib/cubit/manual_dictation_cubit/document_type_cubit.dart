import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_response.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/document_type.dart';
import 'package:YOURDRS_FlutterAPP/network/services/external_attachment/all_external_attachment_service.dart';
import 'package:YOURDRS_FlutterAPP/network/services/schedules/appointment_service.dart';
import 'package:bloc/bloc.dart';
part 'document_type_state.dart';

class DocumentTypeCubit extends Cubit<DocumentTypeCubitState>{
  DropdownService documentTypeApiServices = DropdownService();
  DocumentTypeCubit():super(DocumentTypeCubitState.initial());

  getRecordsDocumentType() async{
    emit(state.reset());
    emit(state.copyWith(isLoading: true));

    var documentTypeApiResponse = await documentTypeApiServices.getDocumenttype();
    if(documentTypeApiResponse ?.header?.statusCode=="200")
    {
      emit(state.copyWith(
          isLoading: false,
          errorMsg: null,
          documentType: documentTypeApiResponse.externalDocumentTypesList
      ));
    }
    else{
      emit(state.copyWith(isLoading: false,
          errorMsg: documentTypeApiResponse?.header?.statusMessage ?? ApiResponse.DEFAULT_ERROR_MESSAGE));
    }

  }
}