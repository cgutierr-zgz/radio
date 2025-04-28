import 'package:freezed_annotation/freezed_annotation.dart';

part 'radio_station.freezed.dart';
part 'radio_station.g.dart';

@freezed
sealed class RadioStation with _$RadioStation {
  factory RadioStation({
    @JsonKey(name: 'stationuuid') required String id,
    required String name,
    required String url,
    required String country,
    @FavIconConverter() required String favicon,
  }) = _RadioStation;

  factory RadioStation.fromJson(Map<String, dynamic> json) =>
      _$RadioStationFromJson(json);
}

class FavIconConverter implements JsonConverter<String, String> {
  const FavIconConverter();

  @override
  String fromJson(String? favicon) {
    if (favicon == null || favicon.isEmpty) return '';

    return favicon;
  }

  @override
  String toJson(String? favicon) {
    if (favicon == null || favicon.isEmpty) return '';

    return favicon;
  }
}
