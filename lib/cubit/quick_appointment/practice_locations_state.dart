part of 'practice_locations_cubit.dart';

class PracticeLocationsState extends BaseBlocState{
  final bool isLoading;
  final String errorMsg;
  final List<LocationList> practiceLocations;

  factory PracticeLocationsState.initial()=> PracticeLocationsState(
    isLoading: false,
    errorMsg: null,
    practiceLocations:null,
  );
  PracticeLocationsState reset()=>PracticeLocationsState.initial();

  PracticeLocationsState({
    this.practiceLocations,
    this.isLoading,
    this.errorMsg,
  });
  List<Object> get props =>[
    this.errorMsg,
    this.isLoading,
    this.practiceLocations,
  ];

  PracticeLocationsState copyWith({
    bool isLoading,
    String errorMsg,
    List<LocationList> practiceLocations
  })
  {
    return new PracticeLocationsState(
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      practiceLocations: practiceLocations?? this.practiceLocations,
    );
  }

  @override
  String toString() {
    return 'PracticeLocationsState{isLoading: $isLoading, errorMsg: $errorMsg, practiceLocations: $practiceLocations}';
  }
}