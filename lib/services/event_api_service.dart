import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/event_catalog_item.dart';

class EventApiService {
  final http.Client _client;

  EventApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<EventCatalogItem>> fetchEvents({String query = ''}) async {
    // Kata kunci default jika tidak ada pencarian. Bisa diganti 'Gigs di Jakarta' atau 'Konser di Bali'
    final searchQuery = query.isNotEmpty
        ? query
        : 'Konser musik indie festival di Indonesia';

    final uri = Uri.parse(
      '${ApiConstants.serpApiBaseUrl}?engine=google_events&q=${Uri.encodeComponent(searchQuery)}&hl=id&gl=id&api_key=${ApiConstants.serpApiKey}',
    );

    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> eventsJson =
          data['events_results'] as List<dynamic>? ?? [];

      return eventsJson
          .map(
            (e) => EventCatalogItem.fromSerpApiJson(e as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Gagal memuat event dari Google (HTTP ${response.statusCode})',
      );
    }
  }
}
