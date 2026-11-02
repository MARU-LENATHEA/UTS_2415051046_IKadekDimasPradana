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

  // Pemetaan JSON dari respons SerpApi (Google Events Real-Time)
  factory EventCatalogItem.fromSerpApiJson(Map<String, dynamic> json) {
    final venueInfo = json['address'] as List<dynamic>? ?? [];
    String city = 'Indonesia';
    String venue = 'Venue TBA';

    // Google Events biasanya memisahkan nama tempat dan kota dalam array 'address'
    if (venueInfo.length >= 2) {
      venue = venueInfo[0].toString();
      city = venueInfo[1].toString();
    } else if (venueInfo.isNotEmpty) {
      venue = venueInfo[0].toString();
    }

    final dateInfo = json['date'] as Map<String, dynamic>? ?? {};
    final startDate = dateInfo['start_date'] as String? ?? 'TBA';
    final when = json['when'] as String? ?? '';

    // Kombinasi tanggal dan waktu yang lebih ramah dibaca
    final formattedDate = when.isNotEmpty ? '$startDate ($when)' : startDate;

    // Google Events memiliki thumbnail atau image. Jika kosong, gunakan dummy image.
    final image =
        json['thumbnail'] as String? ??
        json['image'] as String? ??
        'https://picsum.photos/seed/${json['title'].hashCode}/600/400';

    return EventCatalogItem(
      // Buat ID unik berdasarkan hashcode judul atau waktu saat ini
      id:
          json['title']?.hashCode.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? 'Unnamed Event',
      type: 'LIVE EVENT', // Bisa disesuaikan jika ingin mengambil tag spesifik
      datetimeLocal: formattedDate.trim(),
      venueName: venue,
      venueCity: city,
      imageUrl: image,
      description:
          json['description'] as String? ??
          'Pertunjukan langsung dari ${json['title'] ?? 'event ini'}. Temukan informasi lebih lanjut dan amankan tiket Anda.',
    );
  }
}
