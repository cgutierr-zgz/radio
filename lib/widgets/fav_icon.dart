import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio/providers/radio_provider.dart';

class FavIcon extends StatelessWidget {
  const FavIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final radioProvider = Provider.of<RadioProvider>(context);
    final station = radioProvider.currentStation;

    final isFavorite = station != null && radioProvider.isFavorite(station.id);

    return IconButton(
      icon: Icon(
        station == null
            ? null
            : isFavorite
            ? Icons.favorite
            : Icons.favorite_border,
        color: isFavorite ? Colors.redAccent : Colors.white,
      ),
      onPressed:
          station == null
              ? null
              : () => radioProvider.toggleFavorite(station.id),
    );
  }
}
