// * Ignoring rules for test files
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:radio/models/radio_station.dart';
import 'package:radio/services/radio_service.dart';
import 'package:radio/utils/service_result.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late RadioService radioService;
  late MockHttpClient mockClient;

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://dummy.com'));
  });

  setUp(() {
    radioService = RadioService();
    mockClient = MockHttpClient();
  });

  group('fetchStationsWithClient', () {
    test(
      'returns ServiceSuccess with a list of RadioStations if the http call is successful',
      () async {
        final mockResponse = [
          {
            'stationuuid': 'uuid1',
            'name': 'Station 1',
            'url': 'http://example.com/stream1',
            'favicon': 'http://example.com/favicon1.png',
            'country': 'Spain',
          },
          {
            'stationuuid': 'uuid2',
            'name': 'Station 2',
            'url': 'http://example.com/stream2',
            'favicon': 'http://example.com/favicon2.png',
            'country': 'Spain',
          },
        ];

        when(
          () => mockClient.get(any()),
        ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

        final result = await radioService.fetchStationsWithClient(mockClient);

        expect(result, isA<ServiceSuccess<List<RadioStation>>>());

        final stations = (result as ServiceSuccess<List<RadioStation>>).data;
        expect(stations.length, 2);
        expect(stations.first.name, 'Station 1');
        expect(stations.last.name, 'Station 2');
      },
    );

    test(
      'returns ServiceFailure if the http call fails (status != 200)',
      () async {
        when(
          () => mockClient.get(any()),
        ).thenAnswer((_) async => http.Response('Error', 500));

        final result = await radioService.fetchStationsWithClient(mockClient);

        expect(result, isA<ServiceFailure<List<RadioStation>>>());
        expect((result as ServiceFailure).error, contains('Failed to load'));
      },
    );

    test('returns ServiceFailure if an exception is thrown', () async {
      when(() => mockClient.get(any())).thenThrow(Exception('Network error'));

      final result = await radioService.fetchStationsWithClient(mockClient);

      expect(result, isA<ServiceFailure<List<RadioStation>>>());
      expect((result as ServiceFailure).error, contains('Network error'));
    });
  });
}
