import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:eventhub_uts/services/event_api_service.dart';
import 'package:eventhub_uts/models/event_catalog_item.dart';
import 'package:eventhub_uts/models/saved_event.dart';

void main() {
  group('EventApiService Tests', () {
    test('fetchEvents parses response from REST API', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          json.encode({
            'events': [
              {
                'id': 101,
                'title': 'INTEGER HIMATIF 2026',
                'type': 'FESTIVAL',
                'datetime_local': '2026-11-25T18:00:00',
                'venue': {
                  'name': 'Auditorium Undiksha',
                  'city': 'Singaraja',
                  'country': 'ID',
                },
                'performers': [
                  {'image': 'https://picsum.photos/seed/integer/600/400'},
                ],
                'description': 'Festival tahunan mahasiswa TI.',
              },
            ],
          }),
          200,
        );
      });

      final service = EventApiService(client: mockClient);
      final events = await service.fetchEvents(query: 'INTEGER');
      expect(events.length, 1);
      expect(events.first.title, 'INTEGER HIMATIF 2026');
      expect(events.first.venueName, 'Auditorium Undiksha');
      expect(events.first.venueCity, 'Singaraja, ID');
    });

    test('fetchEvents parses MockAPI array response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          json.encode([
            {
              'id': 'skena_01',
              'title': 'Buleleng Skena Night #4',
              'type': 'GIGS / INDIE POP',
              'datetime_local': '2026-11-14T19:00:00',
              'venue': {
                'name': 'Singaraja Creative Hub',
                'city': 'Buleleng',
                'country': 'ID',
              },
              'images': [
                {'url': 'https://picsum.photos/seed/bulelengskena/600/400'},
              ],
              'description': 'Intimate gigs kolektif lokal Buleleng.',
            },
          ]),
          200,
        );
      });

      final service = EventApiService(client: mockClient);
      final events = await service.fetchEvents();
      expect(events.length, 1);
      expect(events.first.title, 'Buleleng Skena Night #4');
      expect(
        events.first.imageUrl,
        'https://picsum.photos/seed/bulelengskena/600/400',
      );
    });

    test('fetchEvents throws exception on API error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final service = EventApiService(client: mockClient);
      expect(() => service.fetchEvents(), throwsA(isA<Exception>()));
    });
  });

  group('Model Tests', () {
    test('SavedEvent instantiates and serializes correctly', () {
      final saved = SavedEvent(
        eventId: 'evt_101',
        title: 'INTEGER 2026',
        venue: 'Auditorium Undiksha, Singaraja, ID',
        eventDate: '2026-11-25',
        category: 'TECH & MUSIC FESTIVAL',
        personalNote: 'Catatan persiapan',
      );

      expect(saved.eventId, 'evt_101');
      expect(saved.title, 'INTEGER 2026');
      expect(saved.attendanceStatus, 'planned');
      expect(saved.priorityRating, 3);

      final json = saved.toJson();
      expect(json['event_id'], 'evt_101');
      expect(json['personal_note'], 'Catatan persiapan');

      final fromJson = SavedEvent.fromJson(json);
      expect(fromJson.title, saved.title);
    });

    test('EventCatalogItem parses SeatGeek JSON correctly', () {
      final item = EventCatalogItem.fromSerpApiJson({
        'id': 12345,
        'title': 'Test Concert',
        'type': 'Concert',
        'datetime_local': '2026-12-01T20:00:00',
        'venue': {
          'name': 'GWK Cultural Park',
          'city': 'Badung',
          'country': 'ID',
        },
        'performers': [
          {'image': 'https://example.com/image.jpg'},
        ],
      });

      expect(item.id, '12345');
      expect(item.title, 'Test Concert');
      expect(item.venueName, 'GWK Cultural Park');
      expect(item.venueCity, 'Badung, ID');
      expect(item.imageUrl, 'https://example.com/image.jpg');
    });
  });
}
