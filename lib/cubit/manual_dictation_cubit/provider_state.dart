part of 'provider_cubit.dart';

class ProviderCubitState extends BaseBlocState{
  final bool isLoading;
  final String errorMsg;
  final List<ProviderList> provider;

  factory ProviderCubitState.initial()=> ProviderCubitState(
    isLoading:false,
    errorMsg:null,
    provider:null,
  );
  ProviderCubitState reset()=>ProviderCubitState.initial();

  ProviderCubitState({
    this.provider,
    this.errorMsg,
    this.isLoading,
  });

  List<Object> get props =>[
    this.isLoading,
    this.errorMsg,
    this.provider,
  ];

  ProviderCubitState copyWith({
    bool isLoading,
    String errorMsg,
    List<ProviderList> provider
  })
  {
    return new ProviderCubitState(
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      provider: provider ?? this.provider,
    );
  }

  @override
  String toString() {
    return 'ProviderCubitState{isLoading: $isLoading, errorMsg: $errorMsg, provider: $provider}';
  }
}