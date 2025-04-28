import 'package:flutter/material.dart';
import 'package:radio/models/radio_station.dart';

final class CoverImage extends StatelessWidget {
  const CoverImage(this.station, {super.key, this.size = 50});

  final RadioStation? station;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          station?.favicon ?? '',
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Icon(Icons.radio, size: size / 2),
        ),
      ),
    );
  }
}
