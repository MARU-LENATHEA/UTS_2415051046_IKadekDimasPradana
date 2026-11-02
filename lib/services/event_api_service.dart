import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/event_catalog_item.dart';

class EventApiService {
  final http.Client _client;

  EventApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<EventCatalogItem>> fetchEvents({String query = ''}) async {
    final bool hasValidKey = ApiConstants.seatGeekClientId.isNotEmpty &&
        !ApiConstants.seatGeekClientId.contains('MASUKKAN');

    if (hasValidKey) {
      final queryParam = query.isNotEmpty ? '&q=${Uri.encodeComponent(query)}' : '';
      final uri = Uri.parse(
        '${ApiConstants.seatGeekBaseUrl}/events?client_id=${ApiConstants.seatGeekClientId}&per_page=15$queryParam',
      );

      final response = await _client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> eventsJson = data['events'] as List<dynamic>? ?? [];
        return eventsJson
            .map((e) => EventCatalogItem.fromSeatGeekJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Gagal memuat katalog event dari REST API (HTTP ${response.statusCode})');
      }
    } else {
      // Simulasi REST JSON Response jika key belum diisi / mode demo lokal
      await Future.delayed(const Duration(milliseconds: 700));
      final List<Map<String, dynamic>> mockApiEvents = [
        {
          'id': 'evt_101',
          'title': 'INTEGER 2026',
          'type': 'TECH & MUSIC FESTIVAL',
          'datetime_local': '2026-11-25T18:00:00',
          'venue': {'name': 'Auditorium Undiksha', 'city': 'Singaraja', 'country': 'ID'},
          'performers': [{'image': 'https://picsum.photos/seed/integer26/600/400'}],
          'description': 'Puncak perayaan teknologi informasi, pameran karya mahasiswa, dan konser musik tahunan terbesar di Buleleng.'
        },
        {
          'id': 'evt_102',
          'title': 'Soundrenaline Bali Arts & Music',
          'type': 'CONCERT',
          'datetime_local': '2026-12-05T16:00:00',
          'venue': {'name': 'Garuda Wisnu Kencana (GWK)', 'city': 'Badung', 'country': 'ID'},
          'performers': [{'image': 'https://picsum.photos/seed/soundrenaline/600/400'}],
          'description': 'Festival musik lintas genre berskala nasional yang menghadirkan musisi indie, rock, dan pop terbaik.'
        },
        {
          'id': 'evt_103',
          'title': 'Buleleng Cultural & Digital Expo',
          'type': 'CULTURAL FESTIVAL',
          'datetime_local': '2026-11-30T15:00:00',
          'venue': {'name': 'Taman Kota Singaraja', 'city': 'Singaraja', 'country': 'ID'},
          'performers': [{'image': 'https://picsum.photos/seed/buleleng/600/400'}],
          'description': 'Kolaborasi pertunjukan seni tradisional Bali, baleganjur modern, dan pameran inovasi UMKM.'
        },
        {
          'id': 'evt_104',
          'title': 'Bali Indie Soundwave Night',
          'type': 'MUSIC GIGS',
          'datetime_local': '2026-12-12T19:30:00',
          'venue': {'name': 'Pantai Mertasari', 'city': 'Denpasar', 'country': 'ID'},
          'performers': [{'image': 'https://picsum.photos/seed/indiebali/600/400'}],
          'description': 'Malam keakraban komunitas musik indie Bali menampilkan band pop-punk dan alternative rock lokal.'
        },
        {
          'id': 'evt_105',
          'title': 'Bali Startup & Dev Summit 2026',
          'type': 'CONFERENCE',
          'datetime_local': '2026-12-18T09:00:00',
          'venue': {'name': 'Bali Nusa Dua Convention Center', 'city': 'Badung', 'country': 'ID'},
          'performers': [{'image': 'https://picsum.photos/seed/devsummit/600/400'}],
          'description': 'Konferensi pengembang aplikasi mobile, AI, dan cloud computing bersama praktisi industri.'
        },
        {
          'id': 'evt_106',
          'title': 'Tejakula Heritage Art Performance',
          'type': 'TRADITIONAL ART',
          'datetime_local': '2026-12-22T17:00:00',
          'venue': {'name': 'Lapangan Teja Harum', 'city': 'Tejakula, Buleleng', 'country': 'ID'},
          'performers': [{'image': 'https://picsum.photos/seed/tejakula/600/400'}],
          'description': 'Pementasan fragmentari tari tradisional, gamelan, dan dokumentasi warisan budaya pesisir Bali Utara.'
        },
      ];

      final list = mockApiEvents
          .map((e) => EventCatalogItem.fromSeatGeekJson(e))
          .toList();

      if (query.isNotEmpty) {
        return list
            .where((item) =>
                item.title.toLowerCase().contains(query.toLowerCase()) ||
                item.venueCity.toLowerCase().contains(query.toLowerCase()) ||
                item.type.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      return list;
    }
  }
}