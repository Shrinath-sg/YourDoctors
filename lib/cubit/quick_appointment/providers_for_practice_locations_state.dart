part of 'providers_for_practice_locations_cubit.dart';

class ProvidersForPracticeLocationsState extends BaseBlocState{
  final bool isLoading;
  final String errorMsg;
  final List<MemberList> providers;

  factory ProvidersForPracticeLocationsState.initial()=> ProvidersForPracticeLocationsState(
    isLoading: false,
    errorMsg: null,
    providers:null,
  );
  ProvidersForPracticeLocationsState reset()=>ProvidersForPracticeLocationsState.initial();

  ProvidersForPracticeLocationsState({
    this.providers,
    this.isLoading,
    this.errorMsg,
  });
  List<Object> get props =>[
    this.errorMsg,
    this.isLoading,
    this.providers,
  ];

  ProvidersForPracticeLocationsState copyWith({
    bool isLoading,
    String errorMsg,
    List<MemberList> providers
  })
  {
    return new ProvidersForPracticeLocationsState(
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      providers: providers?? this.providers,
    );
  }

  @override
  String toString() {
    return 'ProvidersForPracticeLocationsState{isLoading: $isLoading, errorMsg: $errorMsg, providers: $providers}';
  }
}