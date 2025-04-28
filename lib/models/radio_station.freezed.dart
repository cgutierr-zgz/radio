// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'radio_station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RadioStation {

@JsonKey(name: 'stationuuid') String get id; String get name; String get url; String get country;@FavIconConverter() String get favicon;
/// Create a copy of RadioStation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadioStationCopyWith<RadioStation> get copyWith => _$RadioStationCopyWithImpl<RadioStation>(this as RadioStation, _$identity);

  /// Serializes this RadioStation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadioStation&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.country, country) || other.country == country)&&(identical(other.favicon, favicon) || other.favicon == favicon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,url,country,favicon);

@override
String toString() {
  return 'RadioStation(id: $id, name: $name, url: $url, country: $country, favicon: $favicon)';
}


}

/// @nodoc
abstract mixin class $RadioStationCopyWith<$Res>  {
  factory $RadioStationCopyWith(RadioStation value, $Res Function(RadioStation) _then) = _$RadioStationCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'stationuuid') String id, String name, String url, String country,@FavIconConverter() String favicon
});




}
/// @nodoc
class _$RadioStationCopyWithImpl<$Res>
    implements $RadioStationCopyWith<$Res> {
  _$RadioStationCopyWithImpl(this._self, this._then);

  final RadioStation _self;
  final $Res Function(RadioStation) _then;

/// Create a copy of RadioStation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? url = null,Object? country = null,Object? favicon = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,favicon: null == favicon ? _self.favicon : favicon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _RadioStation implements RadioStation {
   _RadioStation({@JsonKey(name: 'stationuuid') required this.id, required this.name, required this.url, required this.country, @FavIconConverter() required this.favicon});
  factory _RadioStation.fromJson(Map<String, dynamic> json) => _$RadioStationFromJson(json);

@override@JsonKey(name: 'stationuuid') final  String id;
@override final  String name;
@override final  String url;
@override final  String country;
@override@FavIconConverter() final  String favicon;

/// Create a copy of RadioStation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadioStationCopyWith<_RadioStation> get copyWith => __$RadioStationCopyWithImpl<_RadioStation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RadioStationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadioStation&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.country, country) || other.country == country)&&(identical(other.favicon, favicon) || other.favicon == favicon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,url,country,favicon);

@override
String toString() {
  return 'RadioStation(id: $id, name: $name, url: $url, country: $country, favicon: $favicon)';
}


}

/// @nodoc
abstract mixin class _$RadioStationCopyWith<$Res> implements $RadioStationCopyWith<$Res> {
  factory _$RadioStationCopyWith(_RadioStation value, $Res Function(_RadioStation) _then) = __$RadioStationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'stationuuid') String id, String name, String url, String country,@FavIconConverter() String favicon
});




}
/// @nodoc
class __$RadioStationCopyWithImpl<$Res>
    implements _$RadioStationCopyWith<$Res> {
  __$RadioStationCopyWithImpl(this._self, this._then);

  final _RadioStation _self;
  final $Res Function(_RadioStation) _then;

/// Create a copy of RadioStation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? url = null,Object? country = null,Object? favicon = null,}) {
  return _then(_RadioStation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,favicon: null == favicon ? _self.favicon : favicon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
