class EventCatalogItem {
  final String id;
  final String title;
  final String type;
  final String datetimeLocal;
  final String venueName;
  final String venueCity;
  final String imageUrl;
  final String description;

  EventCatalogItem({
    required this.id,
    required this.title,
    required this.type,
    required this.datetimeLocal,
    required this.venueName,
    required this.venueCity,
    required this.imageUrl,
    required this.description,
  });

  // Pemetaan JSON daripada respons SeatGeek REST API
  factory EventCatalogItem.fromSeatGeekJson(Map<String, dynamic> json) {
    final venue = json['venue'] as Map<String, dynamic>? ?? {};
    final performers = json['performers'] as List<dynamic>? ?? [];
    String image =
        'https://picsum.photos/seed/${json['id'] ?? 'event'}/600/400';

    if (performers.isNotEmpty && performers.first['image'] != null) {
      image = performers.first['image'] as String;
    }

    return EventCatalogItem(
      id: json['id']?.toString() ?? '',
      title:
          json['title'] as String? ??
          json['short_title'] as String? ??
          'Unnamed Event',
      type: (json['type'] as String? ?? 'concert').toUpperCase(),
      datetimeLocal: json['datetime_local'] as String? ?? '2026-11-20T19:00:00',
      venueName: venue['name'] as String? ?? 'Main Arena Stage',
      venueCity: '${venue['city'] ?? 'Bali'}, ${venue['country'] ?? 'ID'}',
      imageUrl: image,
      description:
          json['description'] as String? ??
          'Pertunjukan langsung dan festival hiburan eksklusif di ${venue['name'] ?? 'venue utama'}. Tempah kehadiran dan urus nota peribadi anda melalui EventHub.',
    );
  }
}
