import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/event_catalog_item.dart';

class EventApiService {
  final http.Client _client;

  EventApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<EventCatalogItem>> fetchEvents({String query = ''}) async {
    final uri = Uri.parse('${ApiConstants.mockApiBaseUrl}/events');
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final list = data
          .map((e) => EventCatalogItem.fromJson(e as Map<String, dynamic>))
          .toList();

      if (query.isNotEmpty) {
        return list
            .where(
              (item) =>
                  item.title.toLowerCase().contains(query.toLowerCase()) ||
                  item.venueCity.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
      return list;
    } else {
      throw Exception(
        'Gagal memuat event dari MockAPI (HTTP ${response.statusCode})',
      );
    }
  }
}
