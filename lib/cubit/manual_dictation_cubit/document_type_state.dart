part of 'document_type_cubit.dart';

class DocumentTypeCubitState extends BaseBlocState{
  final bool isLoading;
  final String errorMsg;
  final List<ExternalDocumentTypesList> documentType;

  factory DocumentTypeCubitState.initial()=>DocumentTypeCubitState(
    errorMsg:null,
    isLoading:false,
    documentType:null,
  );
  DocumentTypeCubitState reset() =>DocumentTypeCubitState.initial();
  DocumentTypeCubitState({
    this.documentType,
    this.isLoading,
    this.errorMsg
  });

  List<Object> get props =>[
    this.errorMsg,
    this.isLoading,
    this.documentType
  ];

  DocumentTypeCubitState copyWith({
    bool isLoading,
    String errorMsg,
    List<ExternalDocumentTypesList> documentType,

  })
  {
    return new DocumentTypeCubitState(
        isLoading: isLoading ?? this.isLoading,
        errorMsg: errorMsg ?? this.errorMsg,
        documentType: documentType ?? this.documentType
    );
  }

  @override
  String toString() {
    return 'DocumentTypeCubitState{isLoading: $isLoading, errorMsg: $errorMsg, documentType: $documentType}';
  }
}