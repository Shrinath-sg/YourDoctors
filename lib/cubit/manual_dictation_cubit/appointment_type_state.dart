part of 'appointment_type_cubit.dart';
class AppointmentTypeCubitState extends BaseBlocState {
  final bool isLoading;
  final String errorMsg;
  final List<AppointmentTypeList> appointmentType;

  factory AppointmentTypeCubitState.initial() => AppointmentTypeCubitState(
    errorMsg: null,
    isLoading:false,
    appointmentType:null,
  );
  AppointmentTypeCubitState reset() => AppointmentTypeCubitState.initial();

  AppointmentTypeCubitState({
    this.isLoading=false,
    this.appointmentType,
    this.errorMsg,
  });

  List<Object> get props => [
    this.isLoading,
    this.errorMsg,
    this.appointmentType,
  ];

  AppointmentTypeCubitState copyWith(
      {
        bool isLoading,
        String errorMsg,
        List<AppointmentTypeList> documentType
      }
      )
  {
    return new AppointmentTypeCubitState(
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      appointmentType: documentType ?? this.appointmentType,
    );
  }

  @override
  String toString() {
    return 'DocumentTypeCubitState{isLoading: $isLoading, errorMsg: $errorMsg, appointmentType: $appointmentType}';
  }
}