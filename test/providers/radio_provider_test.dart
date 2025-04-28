import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/models/radio_station.dart';
import 'package:radio/providers/radio_provider.dart';
import 'package:radio/services/radio_service.dart';
import 'package:radio/utils/service_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockRadioService extends Mock implements RadioService {}

class RadioProviderTestWrapper extends RadioProvider {
  RadioProviderTestWrapper(RadioService radioService)
    : super(radioService: radioService);
}

void main() {
  late RadioProvider radioProvider;
  late MockRadioService mockService;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    mockService = MockRadioService();
    radioProvider = RadioProviderTestWrapper(mockService);
  });

  group('RadioProvider', () {
    final stationsMock = [
      RadioStation(
        id: '1',
        name: 'Station One',
        url: 'http://station1.com',
        favicon: '',
        country: 'Spain',
      ),
      RadioStation(
        id: '2',
        name: 'Station Two',
        url: 'http://station2.com',
        favicon: '',
        country: 'Spain',
      ),
    ];

    test('loadStations sets stations on success', () async {
      when(
        () => mockService.fetchStations(),
      ).thenAnswer((_) async => ServiceSuccess(stationsMock));

      await radioProvider.loadStations();

      expect(radioProvider.stations.length, 2);
      expect(radioProvider.error, isNull);
    });

    test('loadStations sets error on failure', () async {
      when(
        () => mockService.fetchStations(),
      ).thenAnswer((_) async => const ServiceFailure('Network error'));

      await radioProvider.loadStations();

      expect(radioProvider.stations.isEmpty, true);
      expect(radioProvider.error, 'Network error');
    });

    test('selectStation sets current station', () async {
      final station = stationsMock.first;

      radioProvider.selectStation(station);

      expect(radioProvider.currentStation, station);
    });

    test('toggleFavorite adds and removes favorites', () async {
      const stationId = '123';

      // Initially not favorite
      expect(radioProvider.isFavorite(stationId), false);

      radioProvider.toggleFavorite(stationId);
      expect(radioProvider.isFavorite(stationId), true);

      radioProvider.toggleFavorite(stationId);
      expect(radioProvider.isFavorite(stationId), false);
    });
  });
}
