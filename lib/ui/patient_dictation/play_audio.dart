import 'dart:async';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../common/app_text.dart';

class PlayerWidget extends StatefulWidget {
  final String url;
  final displayFileName;
  final PlayerMode mode;

  const PlayerWidget({
    Key key,
    this.displayFileName,
    @required this.url,
    this.mode = PlayerMode.MEDIA_PLAYER,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState(url, mode);
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  String url;
  var kUrl;
  PlayerMode mode;
  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  AudioPlayerState _playerState = AudioPlayerState.STOPPED;
  // PlayingRoute _playingRouteState = PlayingRoute.SPEAKERS;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;
  StreamSubscription<PlayerControlCommand> _playerControlCommandSubscription;

  bool get _isPlaying => _playerState == AudioPlayerState.PLAYING;
  bool get _isPaused => _playerState == AudioPlayerState.PAUSED;
  String get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  String get _positionText => _position?.toString()?.split('.')?.first ?? '';

  // bool get _isPlayingThroughEarpiece =>
  //     _playingRouteState == PlayingRoute.EARPIECE;

  _PlayerWidgetState(this.url, this.mode);

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    kUrl = widget.url;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerControlCommandSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Text(
          widget.displayFileName,
          style: TextStyle(
            fontSize: 24,
            fontFamily: AppFonts.regular,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              key: const Key('play_button'),
              onPressed: _isPlaying ? null : _play,
              iconSize: 64.0,
              icon: const Icon(Icons.play_arrow),
              color: CustomizedColors.accentColor,
            ),
            IconButton(
              key: const Key('pause_button'),
              onPressed: _isPlaying ? _pause : null,
              iconSize: 64.0,
              icon: const Icon(Icons.pause),
              color: CustomizedColors.accentColor,
            ),
            IconButton(
              key: const Key('stop_button'),
              onPressed: _isPlaying || _isPaused ? _stop : null,
              iconSize: 64.0,
              icon: const Icon(Icons.stop),
              color: CustomizedColors.accentColor,
            ),
            // IconButton(
            //   onPressed: _earpieceOrSpeakersToggle,
            //   iconSize: 64.0,
            //   icon: _isPlayingThroughEarpiece
            //       ? const Icon(Icons.volume_up)
            //       : const Icon(Icons.hearing),
            //   color: Colors.cyan,
            // ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  Slider(
                    onChanged: (v) {
                      final Position = v * _duration.inMilliseconds;
                      _audioPlayer
                          .seek(Duration(milliseconds: Position.round()));
                    },
                    value: (_position != null &&
                            _duration != null &&
                            _position.inMilliseconds > 0 &&
                            _position.inMilliseconds < _duration.inMilliseconds)
                        ? _position.inMilliseconds / _duration.inMilliseconds
                        : 0.0,
                  ),
                ],
              ),
            ),
            Text(
              _position != null
                  ? '$_positionText / $_durationText'
                  : _duration != null
                      ? _durationText
                      : '',
              style: const TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      ],
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = AudioPlayerState.STOPPED;
        _duration = const Duration();
        _position = const Duration();
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _audioPlayerState = state;
        });
      }
    });

    //   _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
    //     if (mounted) {
    //       setState(() => _audioPlayerState = state);
    //     }
    //   });

    //   _playingRouteState = PlayingRoute.SPEAKERS;
    // }
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(kUrl, position: playPosition);
    if (result == 1) {
      setState(() => _playerState = AudioPlayerState.PLAYING);
    }

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate();

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) {
      setState(() => _playerState = AudioPlayerState.PAUSED);
    }
    return result;
  }

  // Future<int> _earpieceOrSpeakersToggle() async {
  //   final result = await _audioPlayer.earpieceOrSpeakersToggle();
  //   if (result == 1) {
  //     setState(() => _playingRouteState = _playingRouteState.toggle());
  //   }
  //   return result;
  // }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = AudioPlayerState.STOPPED;
        _position = const Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = AudioPlayerState.STOPPED);
  }
}
