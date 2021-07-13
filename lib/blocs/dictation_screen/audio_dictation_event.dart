import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_event.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

abstract class AudioDictationEvent extends BaseBlocEvent {}
/// event initialize record
class InitRecord extends AudioDictationEvent {
  @override
  List<Object> get props => [];
}
/// event start recording
class StartRecord extends AudioDictationEvent {
  @override
  List<Object> get props => [];
}
/// event timer
class TimerTicked extends AudioDictationEvent {
  final Recording recording;
  TimerTicked(this.recording);
  @override
  List<Object> get props => [this.recording];
}
/// event pause recording
class PauseRecord extends AudioDictationEvent {
  @override
  List<Object> get props => [];
}
/// event resume recording
class ResumeRecord extends AudioDictationEvent {
  @override
  List<Object> get props => [];
}
/// event stop recording
class StopRecord extends AudioDictationEvent {
  @override
  List<Object> get props => [];
}
/// event delete record
class DeleteRecord extends AudioDictationEvent {
  @override
  List<Object> get props => [];
}
