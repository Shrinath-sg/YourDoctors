part of 'location_cubit.dart';

class LocationCubitState extends BaseBlocState{
  final bool isLoading;
  final String errorMsg;
  final List<LocationList> location;

  factory LocationCubitState.initial()=> LocationCubitState(
    isLoading:false,
    errorMsg:null,
    location:null,
  );
  LocationCubitState reset()=>LocationCubitState.initial();

  LocationCubitState({
    this.location,
    this.errorMsg,
    this.isLoading,
});

  List<Object> get props =>[
    this.isLoading,
    this.errorMsg,
    this.location,
  ];

  LocationCubitState copyWith({
  bool isLoading,
  String errorMsg,
    List<LocationList> location
})
  {
    return new LocationCubitState(
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      location: location ?? this.location,
    );
  }

  @override
  String toString() {
    return 'LocationCubitState{isLoading: $isLoading, errorMsg: $errorMsg, location: $location}';
  }
}