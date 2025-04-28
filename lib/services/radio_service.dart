import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:radio/models/radio_station.dart';
import 'package:radio/utils/service_result.dart'; // O donde guardes ServiceResult

/// {@macro service_class}
class RadioService {
  /// {@macro service_member}
  /// Fetches a list of [RadioStation] using the default [http.Client].
  ///
  /// This is a convenience method that delegates to [fetchStationsWithClient].
  Future<ServiceResult<List<RadioStation>>> fetchStations() async =>
      fetchStationsWithClient(http.Client());

  /// {@macro service_member}
  /// Fetches a list of [RadioStation] from the Radio Browser API
  /// using the provided [http.Client].
  ///
  /// Stations are filtered by country (Spain), ordered by votes,
  /// and limited to 20 results.
  ///
  /// Always returns a [ServiceResult], never throws.
  Future<ServiceResult<List<RadioStation>>> fetchStationsWithClient(
    http.Client client,
  ) async {
    try {
      final response = await client.get(
        Uri.parse(
          'https://de1.api.radio-browser.info/json/stations/bycountry/Spain?order=votes&limit=100',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        final stations = List<RadioStation>.from(
          data.map(
            (json) => RadioStation.fromJson(json as Map<String, dynamic>),
          ),
        );
        return ServiceSuccess(stations);
      } else {
        return ServiceFailure(
          'Failed to load radio stations (Status ${response.statusCode})',
        );
      }
    } catch (e) {
      return ServiceFailure('Network error: $e');
    }
  }
}

// * Documentation

/// {@template service_class}
/// Provides methods to interact with the Radio Browser API,
/// mainly used to fetch available radio stations.
///
/// Includes methods to fetch stations with the default HTTP client,
/// or with a custom client (useful for testing).
/// {@endtemplate}

/// {@template service_member}
/// Member of the [RadioService] class.
/// {@endtemplate}
