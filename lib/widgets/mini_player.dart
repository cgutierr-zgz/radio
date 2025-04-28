import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:radio/providers/radio_provider.dart';
import 'package:radio/screens/radio_player_screen.dart';
import 'package:radio/utils/build_context_ext.dart';
import 'package:radio/widgets/cover_image.dart';
import 'package:radio/widgets/fav_icon.dart';

final class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    required this.audioPlayer,
    required this.onNext,
    required this.onPrevious,
    super.key,
  });

  final AudioPlayer audioPlayer;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    final radioProvider = Provider.of<RadioProvider>(context);
    final station = radioProvider.currentStation;

    if (station == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => context.push(RadioPlayerScreen(audioPlayer: audioPlayer)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            CoverImage(station),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 20,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final textPainter = TextPainter(
                      text: TextSpan(
                        text: station.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    )..layout(maxWidth: constraints.maxWidth);

                    final isOverflowing = textPainter.didExceedMaxLines;

                    if (isOverflowing) {
                      return Marquee(
                        text: station.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 20,
                        velocity: 30,
                        pauseAfterRound: const Duration(seconds: 2),
                        startPadding: 10,
                        accelerationDuration: const Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: const Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      );
                    } else {
                      return Text(
                        station.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                  },
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: onPrevious,
                ),
                StreamBuilder<PlayerState>(
                  stream: audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data?.playing ?? false;
                    return IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        playing
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed:
                          () =>
                              playing
                                  ? audioPlayer.pause()
                                  : audioPlayer.play(),
                    );
                  },
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  onPressed: onNext,
                ),
              ],
            ),
            const FavIcon(),
          ],
        ),
      ),
    );
  }
}
