import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:radio/providers/radio_provider.dart';
import 'package:radio/screens/home_screen.dart';
import 'package:radio/widgets/radio_dial.dart';

void main() => runApp(const RadioApp());

final class RadioApp extends StatelessWidget {
  const RadioApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => RadioProvider()),
      Provider<AudioPlayer>(
        create: (_) => AudioPlayer(),
        dispose: (_, player) => player.dispose(),
      ),
      Provider<GlobalKey<RadioDialState>>(
        create: (_) => GlobalKey<RadioDialState>(),
      ),
    ],
    child: MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const HomeScreen(),
    ),
  );
}
