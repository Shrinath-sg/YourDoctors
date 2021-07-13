part of 'case_type_states_cubit.dart';

class CaseTypeStatesState extends BaseBlocState {
  final bool isLoading;
  final String errorMsg;
  final List<StatesList> statesList;

  factory CaseTypeStatesState.initial() => CaseTypeStatesState(
    errorMsg: null,
    isLoading:false,
    statesList:null,
  );
  CaseTypeStatesState reset() => CaseTypeStatesState.initial();

  CaseTypeStatesState({
    this.isLoading=false,
    this.statesList,
    this.errorMsg,
  });

  List<Object> get props => [
    this.isLoading,
    this.errorMsg,
    this.statesList,
  ];

  CaseTypeStatesState copyWith(
      {
        bool isLoading,
        String errorMsg,
        List<StatesList> states
      }
      )
  {
    return new CaseTypeStatesState(
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      statesList: states ?? this.statesList,
    );
  }

  @override
  String toString() {
    return 'CaseTypeCubitState{isLoading: $isLoading, errorMsg: $errorMsg, statesList: $statesList}';
  }
}

