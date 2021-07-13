part of 'quick_time_slots_cubit.dart';

class QuickTimeSlotsState extends BaseBlocState {
  final bool isLoading;
  final String errorMsg;
  final List<AppointmentTimeSlots> timeSlots;

  factory QuickTimeSlotsState.initial() => QuickTimeSlotsState(
    errorMsg: null,
    isLoading:false,
    timeSlots:null,
  );
  QuickTimeSlotsState reset() => QuickTimeSlotsState.initial();

  QuickTimeSlotsState({
    this.isLoading=false,
    this.timeSlots,
    this.errorMsg,
  });

  List<Object> get props => [
    this.isLoading,
    this.errorMsg,
    this.timeSlots,
  ];

  QuickTimeSlotsState copyWith(
      {
        bool isLoading,
        String errorMsg,
        List<AppointmentTimeSlots> timeSlots
      }
      )
  {
    return new QuickTimeSlotsState(
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      timeSlots: timeSlots ?? this.timeSlots,
    );
  }

  @override
  String toString() {
    return 'QuickTimeSlotsCubitState{isLoading: $isLoading, errorMsg: $errorMsg, appointmentType: $timeSlots}';
  }
}
