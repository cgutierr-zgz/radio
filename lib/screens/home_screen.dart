import 'dart:developer' as d;

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:radio/providers/radio_provider.dart';
import 'package:radio/screens/stations_list_screen.dart';
import 'package:radio/utils/build_context_ext.dart';
import 'package:radio/widgets/mini_player.dart';
import 'package:radio/widgets/radio_dial.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final dialKey = Provider.of<GlobalKey<RadioDialState>>(
    context,
    listen: false,
  );
  late final audioPlayer = context.read<AudioPlayer>();
  late final RadioProvider radioProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      radioProvider = context.read<RadioProvider>();
      await radioProvider.loadStations();

      final station = radioProvider.currentStation;

      if (station == null) return;

      await audioPlayer.setUrl(station.url);
      await audioPlayer.play();
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playStation(int index) async {
    if (!mounted) return;

    final stations = radioProvider.stations;

    if (index < 0 || index >= stations.length) return;

    final station = stations[index];

    if (radioProvider.currentStation?.id == station.id) return;

    radioProvider.selectStation(station);

    try {
      await audioPlayer.setVolume(0);
      await audioPlayer.setUrl(station.url);
      await audioPlayer.play();

      var volume = 0.0;
      while (volume < 1.0) {
        volume += 0.1;
        if (volume > 1.0) volume = 1.0;
        await audioPlayer.setVolume(volume);
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }

      dialKey.currentState?.jumpToStation(index);
    } catch (e) {
      d.log('Error playing station: $e');
    }
  }

  void playNextStation() {
    final stations = radioProvider.stations;
    final currentIndex = stations.indexWhere(
      (s) => s.id == radioProvider.currentStation?.id,
    );
    final nextIndex = (currentIndex + 1) % stations.length;
    playStation(nextIndex);
  }

  void playPreviousStation() {
    final stations = radioProvider.stations;
    final currentIndex = stations.indexWhere(
      (s) => s.id == radioProvider.currentStation?.id,
    );
    final previousIndex =
        (currentIndex - 1 + stations.length) % stations.length;
    playStation(previousIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radio 📻'),
        actions: [
          IconButton(
            onPressed: () => context.push(const StationsListScreen()),
            icon: const Icon(Icons.list),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            RadioDial(
              key: dialKey,
              onStationSelected: (index) async => playStation(index),
            ),
            const Spacer(),
            MiniPlayer(
              audioPlayer: audioPlayer,
              onNext: playNextStation,
              onPrevious: playPreviousStation,
            ),
          ],
        ),
      ),
    );
  }
}
