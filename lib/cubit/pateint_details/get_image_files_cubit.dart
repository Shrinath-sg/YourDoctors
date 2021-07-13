import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_response.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictations/allImages_models.dart';
import 'package:YOURDRS_FlutterAPP/network/services/dictation/getAllImages_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_image_files_state.dart';

class GetImageFilesCubit extends Cubit<GetImageFilesState> {
  GetAllDictationImages getAllDictationImages=GetAllDictationImages();
  GetImageFilesCubit() : super(GetImageFilesState());

  getImageFiles(int dictationId) async{
    emit(state.reset());

    emit(state.copyWith(isLoading: true));
    var image= await getAllDictationImages.getImages(dictationId);
    if(image?.header?.statusCode=="200"){
      emit(state.copyWith(isLoading: false,errorMsg: null, images:image));
    }
    else{
      emit(state.copyWith(isLoading: false,errorMsg: image?.header?.statusMessage??ApiResponse.DEFAULT_ERROR_MESSAGE));
    }
  }
}
