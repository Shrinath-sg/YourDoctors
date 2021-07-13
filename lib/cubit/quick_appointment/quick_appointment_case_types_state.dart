part of 'quick_appointment_case_types_cubit.dart';

class QuickAppointmentCaseTypesState extends BaseBlocState {
  final bool isLoading;
  final String errorMsg;
  final List<CaseTypes> casetypeList;

  factory QuickAppointmentCaseTypesState.initial() => QuickAppointmentCaseTypesState(
    errorMsg: null,
    isLoading:false,
    casetypeList:null,
  );
  QuickAppointmentCaseTypesState reset() => QuickAppointmentCaseTypesState.initial();

  QuickAppointmentCaseTypesState({
    this.isLoading=false,
    this.casetypeList,
    this.errorMsg,
  });

  List<Object> get props => [
    this.isLoading,
    this.errorMsg,
    this.casetypeList,
  ];

  QuickAppointmentCaseTypesState copyWith(
      {
        bool isLoading,
        String errorMsg,
        List<CaseTypes> caseType
      }
      )
  {
    return new QuickAppointmentCaseTypesState(
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      casetypeList: caseType ?? this.casetypeList,
    );
  }

  @override
  String toString() {
    return 'CaseTypeCubitState{isLoading: $isLoading, errorMsg: $errorMsg, appointmentType: $casetypeList}';
  }
}

