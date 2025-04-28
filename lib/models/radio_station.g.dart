// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RadioStation _$RadioStationFromJson(Map<String, dynamic> json) =>
    _RadioStation(
      id: json['stationuuid'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      country: json['country'] as String,
      favicon: const FavIconConverter().fromJson(json['favicon'] as String),
    );

Map<String, dynamic> _$RadioStationToJson(_RadioStation instance) =>
    <String, dynamic>{
      'stationuuid': instance.id,
      'name': instance.name,
      'url': instance.url,
      'country': instance.country,
      'favicon': const FavIconConverter().toJson(instance.favicon),
    };
