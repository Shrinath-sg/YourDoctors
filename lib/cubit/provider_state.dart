import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/network/models/home/provider.dart';

class ProviderListCubitState extends BaseBlocState {
  final bool isLoading;
  final String errorMsg;
  final List<ProviderList> providers;

  factory ProviderListCubitState.initial() => ProviderListCubitState(
        errorMsg: null,
        isLoading: false,
        providers: null,
      );

  ProviderListCubitState reset() => ProviderListCubitState.initial();


  ProviderListCubitState({
    this.isLoading = false,
    this.errorMsg,
    this.providers,
  });

  @override
  List<Object> get props => [
        this.isLoading,
        this.errorMsg,
        this.providers,
      ];

  ProviderListCubitState copyWith(
      {bool isLoading,
      String errorMsg,
     List<ProviderList> providers}) {
    return new ProviderListCubitState(
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      providers:
          providers ?? this.providers,
    );
  }

  @override
  String toString() {
    return 'RecordsCountState{isLoading: $isLoading, errorMsg: $errorMsg, providers: $providers}}';
  }
}
