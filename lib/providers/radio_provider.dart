import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:radio/models/radio_station.dart';
import 'package:radio/services/radio_service.dart';
import 'package:radio/utils/service_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@macro provider_class}
class RadioProvider extends ChangeNotifier {
  /// {@macro provider_class}
  ///
  /// Initializes the provider by loading favorite stations and the last
  /// selected station from persistent storage.
  RadioProvider({RadioService? radioService})
    : _radioService = radioService ?? RadioService() {
    _loadFavorites();
    _loadLastStation();
  }

  /// Service used to fetch radio station data.
  final RadioService _radioService;

  /// Internal list of available radio stations.
  List<RadioStation> _stations = [];

  /// The currently selected radio station. Null if no station is selected.
  RadioStation? _currentStation;

  /// Set of station IDs marked as favorites.
  Set<String> _favorites = {};

  /// Optional error message if loading stations failed.
  String? _error;

  /// {@macro provider_member}
  /// Returns the list of available radio stations.
  List<RadioStation> get stations => _stations;

  /// {@macro provider_member}
  /// Returns the currently selected radio station.
  RadioStation? get currentStation => _currentStation;

  /// {@macro provider_member}
  /// Returns the set of favorite station IDs.
  Set<String> get favorites => _favorites;

  /// {@macro provider_member}
  /// Returns an error message if station loading failed, otherwise null.
  String? get error => _error;

  /// Key used for storing favorites in [SharedPreferences].
  static const String _favoritesKey = 'favorites';

  /// Key used for storing the last selected station in [SharedPreferences].
  static const String _lastStationKey = 'last_station';

  /// {@macro provider_member}
  /// Fetches the list of radio stations from the [_radioService] and updates
  /// the state. Handles both success and failure responses.
  Future<void> loadStations() async {
    final result = await _radioService.fetchStations();

    switch (result) {
      case ServiceSuccess<List<RadioStation>>():
        _stations = result.data;
        _error = null;
      case ServiceFailure<List<RadioStation>>():
        _stations = [];
        _error = result.error;
    }

    notifyListeners();
  }

  /// {@macro provider_member}
  /// Sets the given [station] as the [_currentStation] and saves it to
  /// persistent storage. Notifies listeners after updating.
  void selectStation(RadioStation station) {
    _currentStation = station;
    _saveLastStation();
    notifyListeners();
  }

  /// {@macro provider_member}
  /// Adds or removes the station with the given [stationId] from the favorites.
  /// Saves the updated favorites list to persistent storage. Notifies listeners
  /// after updating.
  void toggleFavorite(String stationId) {
    _favorites.contains(stationId)
        ? _favorites.remove(stationId)
        : _favorites.add(stationId);

    _saveFavorites();
    notifyListeners();
  }

  /// {@macro provider_member}
  /// Checks if the station with the given [stationId] is marked as a favorite.
  bool isFavorite(String stationId) => _favorites.contains(stationId);

  /// {@macro provider_member}
  /// Loads the list of favorite station IDs from [SharedPreferences].
  /// Notifies listeners after loading.
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = prefs.getStringList(_favoritesKey) ?? [];
    _favorites = favoriteList.toSet();
    notifyListeners();
  }

  /// {@macro provider_member}
  /// Saves the current list of favorite station IDs to [SharedPreferences].
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favorites.toList());
  }

  /// {@macro provider_member}
  /// Saves the [_currentStation] to [SharedPreferences].
  /// Does nothing if [_currentStation] is null.
  Future<void> _saveLastStation() async {
    if (_currentStation == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _lastStationKey,
      jsonEncode(_currentStation!.toJson()),
    );
  }

  /// {@macro provider_member}
  /// Loads the last selected station from [SharedPreferences] and sets it as
  /// the [_currentStation]. Notifies listeners if a station is loaded.
  Future<void> _loadLastStation() async {
    final prefs = await SharedPreferences.getInstance();
    final stationJson = prefs.getString(_lastStationKey);

    if (stationJson == null) return;

    _currentStation = RadioStation.fromJson(
      jsonDecode(stationJson) as Map<String, dynamic>,
    );
    notifyListeners();
  }
}

// * Documentation

/// {@template provider_class}
/// Manages the state for radio stations, including fetching stations,
/// handling the currently selected station, and managing favorite stations.
///
/// It uses [SharedPreferences] to persist favorite stations and the last
/// selected station across app sessions.
/// {@endtemplate}

/// {@template provider_member}
/// Member of the [RadioProvider] class.
/// {@endtemplate}
