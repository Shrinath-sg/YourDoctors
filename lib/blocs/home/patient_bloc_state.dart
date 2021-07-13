import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import '../../network/models/home/appointment.dart';
import '../../network/models/home/schedule.dart';

// ---------> declaring the variables for error messages ,loading <------
class PatientAppointmentBlocState extends BaseBlocState {
  final bool isLoading;
  final String errorMsg;
  final List<Patients> users;
  final String keyword;
  final String keyword1;
  final int providerId;
  final int locationId;
  final int dictationId;
  final int practiceLocationId;
  final String startDate;
  final String endDate;
  final String searchString;
  final int memberId;
  final List<ScheduleGroupList> patients;
  final List <ScheduleList>appointments;
  final bool hasReachedMax;

// --------> PatientAppointmentBlocState with init method <----------
  factory PatientAppointmentBlocState.initial() => PatientAppointmentBlocState(
        errorMsg: null,
        isLoading: false,
        users: null,
        patients: null,
        hasReachedMax: false,
        appointments: null
      );

// ------> resets the PatientAppointmentBlocState.initial() <-------
  PatientAppointmentBlocState reset() => PatientAppointmentBlocState.initial();

  PatientAppointmentBlocState({
    this.isLoading = false,
    this.errorMsg,
    this.users,
    this.keyword,
    this.patients,
    this.appointments,
    this.keyword1,
    this.providerId,
    this.dictationId,
    this.locationId,
    this.practiceLocationId,
    this.startDate,
    this.endDate,
    this.searchString,
    this.memberId,
    this.hasReachedMax,
  });
// -------> getting the variables <---------
  @override
  List<Object> get props => [
        this.isLoading,
        this.errorMsg,
        // this.users,
        this.keyword,
        this.patients,
        this.appointments,
        this.hasReachedMax

      ];
// ----------> method for declaring the states for particular class <-----------
  PatientAppointmentBlocState copyWith(
      {bool isLoading,
      String errorMsg,
      List<Patients> users,
      String keyword,
      String keyword1,
      int providerId,
      int locationId,
      int dictationId,
      int practiceLocationId,
      String startDate,
      String endDate,
      String searchString,
      int memberId,
      bool hasReachedMax,
// ----------> calling PatientAppointmentBlocState classs constructor with ScheduleList class <---------
      List<ScheduleGroupList> patients,
      List<ScheduleList>appointments}) {
    return new PatientAppointmentBlocState(
        isLoading: isLoading ?? this.isLoading,
        errorMsg: errorMsg ?? this.errorMsg,
        users: users ?? this.users,
        keyword: keyword ?? this.keyword,
        keyword1: keyword1 ?? this.keyword1,
        providerId: providerId ?? this.providerId,
        locationId: locationId ?? this.locationId,
        dictationId: dictationId ?? this.dictationId,
        practiceLocationId: practiceLocationId??this.practiceLocationId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        patients: patients ?? this.patients,
        appointments: appointments??this.appointments,
        memberId: memberId ?? this.memberId,
        searchString: searchString ?? this.searchString,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax
        );
  }

// ------> writing to string method <------
  @override
  String toString() {
    return 'PatientAppointmentMainState{isLoading: $isLoading, hasReachedMax: $hasReachedMax, errorMsg: $errorMsg, users: $users, keyword: $keyword},patients:$patients,appointments:$appointments';
  }
}
