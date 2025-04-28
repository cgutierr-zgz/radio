import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:radio/models/radio_station.dart';
import 'package:radio/providers/radio_provider.dart';
import 'package:radio/widgets/radio_dial.dart';

final class StationsListScreen extends StatefulWidget {
  const StationsListScreen({super.key});

  @override
  State<StationsListScreen> createState() => _StationsListScreenState();
}

class _StationsListScreenState extends State<StationsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radioProvider = Provider.of<RadioProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emisoras'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Todas'), Tab(text: 'Favoritas')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStationsList(
            stations: radioProvider.stations,
            radioProvider: radioProvider,
          ),
          _buildStationsList(
            stations:
                radioProvider.stations
                    .where((s) => radioProvider.isFavorite(s.id))
                    .toList(),
            radioProvider: radioProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildStationsList({
    required List<RadioStation> stations,
    required RadioProvider radioProvider,
  }) {
    if (stations.isEmpty) {
      return const Center(
        child: Text(
          'No hay emisoras disponibles',
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        final isFavorite = radioProvider.isFavorite(station.id);

        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                station.favicon.isNotEmpty
                    ? Image.network(
                      station.favicon,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, _, _) => const Icon(Icons.radio, size: 40),
                    )
                    : const Icon(Icons.radio, size: 40),
          ),
          title: Text(
            station.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            station.country,
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.redAccent : Colors.white,
            ),
            onPressed: () {
              radioProvider.toggleFavorite(station.id);
            },
          ),
          onTap: () async {
            // 1. Cambiamos la emisora
            radioProvider.selectStation(station);

            // 2. Cambiamos la URL del audioPlayer
            final audioPlayer = Provider.of<AudioPlayer>(
              context,
              listen: false,
            );

            try {
              await audioPlayer.setUrl(station.url);
              await audioPlayer.play();
            } catch (e) {
              print('Error reproduciendo nueva estación: $e');
            }

            // 3. Mover el Dial
            final dialKey = Provider.of<GlobalKey<RadioDialState>>(
              context,
              listen: false,
            );
            final indexInStations = radioProvider.stations.indexWhere(
              (s) => s.id == station.id,
            );
            if (indexInStations != -1) {
              dialKey.currentState?.jumpToStation(indexInStations);
            }

            // 4. Volver atrás
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }
}
