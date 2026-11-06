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

  factory EventCatalogItem.fromJson(Map<String, dynamic> json) {
    final venue = json['venue'] as Map<String, dynamic>? ?? {};
    final images = json['images'] as List<dynamic>? ?? [];
    final imageUrl = images.isNotEmpty
        ? images[0]['url'] as String
        : 'https://picsum.photos/600/400';

    return EventCatalogItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? 'Judul Event',
      type: json['type'] as String? ?? 'EVENT',
      datetimeLocal: json['datetime_local'] as String? ?? 'TBA',
      venueName: venue['name'] as String? ?? 'Venue',
      venueCity: venue['city'] as String? ?? 'Kota',
      imageUrl: imageUrl,
      description:
          json['description'] as String? ?? 'Deskripsi tidak tersedia.',
    );
  }
}
