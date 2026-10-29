import 'package:flutter_test/flutter_test.dart';
import 'package:bhumipun_demo/features/order/data/locations_data.dart';

void main() {
  group('LocationsData', () {
    test('returns sorted list of states', () {
      final states = LocationsData.states;
      expect(states, contains('Gujarat'));
      expect(states, contains('Maharashtra'));
      expect(states, contains('Karnataka'));
      expect(states, contains('Rajasthan'));
      expect(states, contains('Madhya Pradesh'));
    });

    test(
      'returns districts for valid state and empty list for invalid/null',
      () {
        expect(LocationsData.getDistricts(null), isEmpty);
        expect(LocationsData.getDistricts('InvalidState'), isEmpty);

        final gujaratDistricts = LocationsData.getDistricts('Gujarat');
        expect(gujaratDistricts, contains('Ahmedabad'));
        expect(gujaratDistricts, contains('Surat'));
        expect(gujaratDistricts, contains('Vadodara'));
      },
    );

    test('returns talukas for valid state and district', () {
      expect(LocationsData.getTalukas(null, 'Ahmedabad'), isEmpty);
      expect(LocationsData.getTalukas('Gujarat', null), isEmpty);

      final talukas = LocationsData.getTalukas('Gujarat', 'Ahmedabad');
      expect(talukas, contains('Sanand'));
      expect(talukas, contains('Daskroi'));
      expect(talukas, contains('Dholka'));
    });

    test('returns cities/villages for valid state, district, and taluka', () {
      expect(LocationsData.getCities(null, 'Ahmedabad', 'Sanand'), isEmpty);
      expect(LocationsData.getCities('Gujarat', null, 'Sanand'), isEmpty);
      expect(LocationsData.getCities('Gujarat', 'Ahmedabad', null), isEmpty);

      final cities = LocationsData.getCities('Gujarat', 'Ahmedabad', 'Sanand');
      expect(cities, contains('Moraiya'));
      expect(cities, contains('Sanand Town'));
      expect(cities, contains('Changodar'));
    });
  });
}
