import 'package:flutter/material.dart';

import '../models/event_catalog_item.dart';
import 'add_event_note_page.dart';

class EventDetailPage extends StatelessWidget {
  final EventCatalogItem event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Poster Event
            Image.network(
              event.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Container(
                height: 250,
                color: Colors.grey.shade300,
                child: const Icon(
                  Icons.image_not_supported,
                  size: 80,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge Kategori
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      event.type,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Judul Event
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Tanggal Event
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        event.datetimeLocal,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Lokasi / Venue
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${event.venueName}, ${event.venueCity}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Deskripsi
                  const Text(
                    'Deskripsi Acara',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Tombol Simpan Agenda
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigasi ke halaman form tambah agenda beserta data event-nya
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEventNotePage(event: event)),
          );
        },
        icon: const Icon(Icons.bookmark_add),
        label: const Text('Simpan Agenda'),
      ),
    );
  }
}
