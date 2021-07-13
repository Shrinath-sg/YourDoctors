part of 'location_dropdown_cubit.dart';

class LocationListCubitState extends BaseBlocState{
  final bool isLoading;
  final String errorMsg;
  final List<LocationList> location;

  factory LocationListCubitState.initial() => LocationListCubitState(
    errorMsg: null,
    isLoading:false,
    location:null,
  );
  LocationListCubitState reset() => LocationListCubitState.initial();

  LocationListCubitState({
    this.isLoading=false,
    this.location,
    this.errorMsg,
  });

  List<Object> get props => [
    this.isLoading,
    this.errorMsg,
    this.location,
  ];

  LocationListCubitState copyWith(
      {
        bool isLoading,
        String errorMsg,
        List<LocationList> location
      }
      )
  {
    return new LocationListCubitState(
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      location: location ?? this.location,
    );
  }

  @override
  String toString() {
    return 'LocationListCubitState{isLoading: $isLoading, errorMsg: $errorMsg, location: $location}';
  }
}