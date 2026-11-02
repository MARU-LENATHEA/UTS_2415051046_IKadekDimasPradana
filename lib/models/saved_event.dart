class SavedEvent {
  final int? id;
  final String eventId;
  final String title;
  final String venue;
  final String eventDate;
  final String category;
  final String imageUrl;
  final String personalNote;
  final String attendanceStatus; // 'planned', 'booked', 'attended'
  final int priorityRating; // 1 - 5
  final DateTime? createdAt;

  SavedEvent({
    this.id,
    required this.eventId,
    required this.title,
    required this.venue,
    required this.eventDate,
    required this.category,
    this.imageUrl = 'https://picsum.photos/seed/bali/600/400',
    required this.personalNote,
    this.attendanceStatus = 'planned',
    this.priorityRating = 3,
    this.createdAt,
  });

  factory SavedEvent.fromJson(Map<String, dynamic> json) {
    return SavedEvent(
      id: json['id'] as int?,
      eventId: json['event_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      venue: json['venue'] as String? ?? '',
      eventDate: json['event_date'] as String? ?? '',
      category: json['category'] as String? ?? 'FESTIVAL',
      imageUrl:
          json['image_url'] as String? ??
          'https://picsum.photos/seed/bali/600/400',
      personalNote: json['personal_note'] as String? ?? '',
      attendanceStatus: json['attendance_status'] as String? ?? 'planned',
      priorityRating: (json['priority_rating'] as num?)?.toInt() ?? 3,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'title': title,
      'venue': venue,
      'event_date': eventDate,
      'category': category,
      'image_url': imageUrl,
      'personal_note': personalNote,
      'attendance_status': attendanceStatus,
      'priority_rating': priorityRating,
    };
  }
}
