part of 'login_bloc.dart';

class FormScreenState {
  // boolean value to check true or false
  bool isTrue;
  bool isLoading;
  bool isPinAvailable;
  var memberId;
  var displayName;
  var profileImg;
  String isExceptionError;
  String errorMsg;
  String unHandledException;

  FormScreenState(
      {this.isTrue,
      this.memberId,
      this.isLoading,
      this.isPinAvailable,
      this.displayName,
      this.profileImg,
      this.isExceptionError,
      this.errorMsg,
      this.unHandledException});
}
