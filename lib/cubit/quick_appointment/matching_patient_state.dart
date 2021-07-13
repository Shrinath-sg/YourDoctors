part of 'matching_patient_cubit.dart';

class MatchingPatientState extends BaseBlocState{
  final bool isLoading;
  final String errorMsg;
  final List<PatientList> patients;

  factory MatchingPatientState.initial()=> MatchingPatientState(
    isLoading: false,
    errorMsg: null,
    patients:null,
  );
  MatchingPatientState reset()=>MatchingPatientState.initial();

  MatchingPatientState({
    this.patients,
    this.isLoading,
    this.errorMsg,
  });
  List<Object> get props =>[
    this.errorMsg,
    this.isLoading,
    this.patients,
  ];

  MatchingPatientState copyWith({
    bool isLoading,
    String errorMsg,
    List<PatientList> patients
  })
  {
    return new MatchingPatientState(
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      patients: patients?? this.patients,
    );
  }

  @override
  String toString() {
    return 'MatchingPatientState{isLoading: $isLoading, errorMsg: $errorMsg, patients: $patients}';
  }
}