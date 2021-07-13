part of 'quick_appointment_type_cubit.dart';

class QuickAppointmentTypeState extends BaseBlocState {
  final bool isLoading;
  final String errorMsg;
  final List<AppointmentTypeList> appointmentTypeList;

  factory QuickAppointmentTypeState.initial() => QuickAppointmentTypeState(
    errorMsg: null,
    isLoading:false,
    appointmentTypeList:null,
  );
  QuickAppointmentTypeState reset() => QuickAppointmentTypeState.initial();

  QuickAppointmentTypeState({
    this.isLoading=false,
    this.appointmentTypeList,
    this.errorMsg,
  });

  List<Object> get props => [
    this.isLoading,
    this.errorMsg,
    this.appointmentTypeList,
  ];

  QuickAppointmentTypeState copyWith(
      {
        bool isLoading,
        String errorMsg,
        List<AppointmentTypeList> appointmentTypeList
      }
      )
  {
    return new QuickAppointmentTypeState(
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      appointmentTypeList: appointmentTypeList ?? this.appointmentTypeList,
    );
  }

  @override
  String toString() {
    return 'CaseTypeCubitState{isLoading: $isLoading, errorMsg: $errorMsg, appointmentType: $appointmentTypeList}';
  }
}
