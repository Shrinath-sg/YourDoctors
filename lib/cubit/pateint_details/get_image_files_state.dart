part of 'get_image_files_cubit.dart';

class GetImageFilesState extends BaseBlocState {

  final bool isLoading;
  final String errorMsg;
  final GetAllImages image;

  factory GetImageFilesState.initial()=> GetImageFilesState(
    isLoading:false,
    errorMsg:null,
    image:null,
  );
  GetImageFilesState reset()=>GetImageFilesState.initial();

  GetImageFilesState({
    this.image,
    this.errorMsg,
    this.isLoading,
  });

  List<Object> get props =>[
    this.isLoading,
    this.errorMsg,
    this.image,
  ];

  GetImageFilesState copyWith({
    bool isLoading,
    String errorMsg,
    GetAllImages images
  })
  {
    return new GetImageFilesState(
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      image: images ?? this.image,
    );
  }

  @override
  String toString() {
    return 'GetImageFilesState{isLoading: $isLoading, errorMsg: $errorMsg, image: $image}';
  }


}


