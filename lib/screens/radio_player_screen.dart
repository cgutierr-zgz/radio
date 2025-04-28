import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:radio/providers/radio_provider.dart';
import 'package:radio/widgets/cover_image.dart';
import 'package:radio/widgets/fav_icon.dart';

final class RadioPlayerScreen extends StatefulWidget {
  const RadioPlayerScreen({required this.audioPlayer, super.key});

  final AudioPlayer audioPlayer;

  @override
  State<RadioPlayerScreen> createState() => _RadioPlayerScreenState();
}

class _RadioPlayerScreenState extends State<RadioPlayerScreen> {
  double currentVolume = 1;

  @override
  void initState() {
    super.initState();
    widget.audioPlayer.volumeStream.listen(
      (volume) => setState(() => currentVolume = volume),
    );
  }

  @override
  Widget build(BuildContext context) {
    final radioProvider = Provider.of<RadioProvider>(context);
    final station = radioProvider.currentStation;

    if (station == null) {
      return const Scaffold(body: Center(child: Text('No station selected')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(station.name, overflow: TextOverflow.ellipsis),
        centerTitle: true,
        actions: const [FavIcon()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            CoverImage(station, size: 200),
            const SizedBox(height: 30),
            Text(
              station.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                const Text('Volume', style: TextStyle(color: Colors.white70)),
                Slider(
                  value: currentVolume,
                  inactiveColor: Colors.white24,
                  activeColor: Colors.white,
                  onChanged: (value) {
                    setState(() => currentVolume = value);
                    widget.audioPlayer.setVolume(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            StreamBuilder<PlayerState>(
              stream: widget.audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return IconButton(
                  iconSize: 80,
                  icon: Icon(
                    playing
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                  ),
                  onPressed:
                      () =>
                          playing
                              ? widget.audioPlayer.pause()
                              : widget.audioPlayer.play(),
                );
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
