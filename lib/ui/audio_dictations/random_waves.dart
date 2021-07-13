import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/widget/audio_wave.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class RandomWaves extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return AudioWave(
      height: height * 0.25,
      width: width * 0.85,
      spacing: 3.5,
      bars: _generateAudioWaveBars(),
    );
  }

  /// generation of audio wave part
  List<AudioWaveBar> _generateAudioWaveBars() {
    List<AudioWaveBar> list = [];

    /// looping number of waves
    for (int i = 0; i < 35; i++) {
      list.add(AudioWaveBar(
          height: getRandomHeight(), color: CustomizedColors.waveColor));
    }
    return list;
  }
}

/// passing height by random function
double getRandomHeight({int min = 25, int max = 100}) {
  final _random = new Random();
  int value = min + (_random.nextInt(max - min) / 1.25).toInt();
  return value.toDouble();
}
