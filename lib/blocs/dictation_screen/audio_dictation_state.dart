import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_state.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

/// audio dictation state to maintain all the required states
// ignore: must_be_immutable
class AudioDictationState extends BaseBlocState {
  final String errorMsg;
  final Recording current;
  final RecordingStatus currentStatus;
  final bool viewVisible;
  final Duration duration;
  String attachmentContentType;
  String attachmentContent;
  factory AudioDictationState.initial() => AudioDictationState(
      errorMsg: null,
      current: null,
      currentStatus: RecordingStatus.Unset,
      viewVisible: false,
      duration: null,
      attachmentContentType: null,
      attachmentContent: null);
  AudioDictationState reset() => AudioDictationState.initial();
  AudioDictationState(
      {this.errorMsg,
      this.current,
      this.currentStatus,
      this.viewVisible,
      this.duration,
      this.attachmentContentType,
      this.attachmentContent});
  @override
  List<Object> get props => [
        this.errorMsg,
        this.current,
        this.currentStatus,
        this.viewVisible,
        this.duration,
        this.attachmentContentType,
        this.attachmentContent
      ];
  AudioDictationState copyWith(
      {String errorMsg,
      Recording current,
      RecordingStatus currentStatus,
      bool viewVisible,
      Duration duration,
      String attachmentContentType,
      String attachmentContent}) {
    return new AudioDictationState(
        errorMsg: errorMsg /*?? this.errorMsg*/,
        current: current ?? this.current,
        currentStatus: currentStatus ?? this.currentStatus,
        viewVisible: viewVisible ?? this.viewVisible,
        duration: duration ?? this.duration,
        attachmentContentType:
            attachmentContentType ?? this.attachmentContentType,
        attachmentContent: attachmentContent ?? this.attachmentContent);
  }
  @override
  String toString() {
    return 'AudioBlocState{errorMsg: $errorMsg, current: $current, currentStatus: $currentStatus, viewVisible: $viewVisible,attachmentContentType:$attachmentContentType}';
  }
}
