part of 'practice_cubit.dart';

class PracticeCubitState extends BaseBlocState{
  final bool isLoading;
  final String errorMsg;
  final List<PracticeList> practice;

  factory PracticeCubitState.initial()=> PracticeCubitState(
    isLoading: false,
    errorMsg: null,
    practice:null,
  );
  PracticeCubitState reset()=>PracticeCubitState.initial();

  PracticeCubitState({
    this.practice,
    this.isLoading,
    this.errorMsg,
});
  List<Object> get props =>[
    this.errorMsg,
    this.isLoading,
    this.practice,
  ];

  PracticeCubitState copyWith({
  bool isLoading,
    String errorMsg,
    List<PracticeList> practice
})
  {
    return new PracticeCubitState(
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      practice: practice?? this.practice,
    );
  }

  @override
  String toString() {
    return 'PracticeCubitState{isLoading: $isLoading, errorMsg: $errorMsg, practice: $practice}';
  }
}