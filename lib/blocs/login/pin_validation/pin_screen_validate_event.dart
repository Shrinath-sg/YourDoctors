part of 'pin_screen_validate_bloc.dart';

// enum PinScreenEvents{verify}
class PinScreenEvent {
  var pin;
  var verify;

  PinScreenEvent(this.pin, this.verify);
}
