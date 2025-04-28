import 'dart:developer' as d;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:radio/providers/radio_provider.dart';

final class RadioDial extends StatefulWidget {
  const RadioDial({required this.onStationSelected, super.key});

  final void Function(int index) onStationSelected;

  @override
  State<RadioDial> createState() => RadioDialState();
}

class RadioDialState extends State<RadioDial> with TickerProviderStateMixin {
  late AudioPlayer whiteNoisePlayer;

  final anglePerStation = pi / 10;
  final _center = Offset.zero;

  double rotationAngle = 0;
  int selectedIndex = 0;
  double startAngle = 0;
  bool isSpinning = false;

  void jumpToStation(int index) => setState(() {
    rotationAngle = index * anglePerStation;
    selectedIndex = index;
  });

  @override
  void initState() {
    super.initState();
    whiteNoisePlayer = AudioPlayer();
    loadWhiteNoise();
  }

  Future<void> loadWhiteNoise() async {
    await whiteNoisePlayer.setAsset('assets/audio/white_noise.mp3');
    await whiteNoisePlayer.setLoopMode(LoopMode.all);
  }

  double calculateAngle(Offset position) {
    final dx = position.dx - _center.dx;
    final dy = position.dy - _center.dy;

    return atan2(dy, dx);
  }

  Future<void> startWhiteNoise() async {
    if (isSpinning) return;

    await whiteNoisePlayer.play();
    isSpinning = true;
  }

  Future<void> stopWhiteNoise() async {
    if (!isSpinning) return;

    try {
      var volume = whiteNoisePlayer.volume;

      while (volume > 0.0) {
        volume -= 0.1;

        if (volume < 0.0) volume = 0.0;

        await whiteNoisePlayer.setVolume(volume);
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }

      await whiteNoisePlayer.stop();
      await whiteNoisePlayer.setVolume(1);
    } catch (e) {
      d.log('Error stopping white noise: $e');
    }
    isSpinning = false;
  }

  @override
  void dispose() {
    whiteNoisePlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radioProvider = Provider.of<RadioProvider>(context);
    final stations = radioProvider.stations;

    if (stations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 30),
        SizedBox(
          width: 300,
          height: 300,
          child: GestureDetector(
            onPanStart: (details) {
              final touchPosition = details.localPosition;
              startAngle = calculateAngle(touchPosition);

              if (isSpinning) return;

              startWhiteNoise();
            },
            onPanUpdate: (details) {
              final touchPosition = details.localPosition;
              final currentAngle = calculateAngle(touchPosition);
              final angleDelta = currentAngle - startAngle;

              rotationAngle += angleDelta;
              startAngle = currentAngle;

              final normalizedRotation =
                  (rotationAngle / anglePerStation) % stations.length;
              final newIndex = normalizedRotation.round() % stations.length;

              stopWhiteNoise();
              if (newIndex != selectedIndex) {
                selectedIndex = newIndex;
                widget.onStationSelected(selectedIndex);
                HapticFeedback.heavyImpact();
              }
              setState(() {});
            },
            onPanEnd: (_) => stopWhiteNoise(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade800,
                    border: Border.all(color: Colors.grey.shade600, width: 5),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(50),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: rotationAngle,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade600,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
