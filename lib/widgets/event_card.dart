import 'package:flutter/material.dart';

import '../models/event_catalog_item.dart';

import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final EventCatalogItem event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Event
            Container(
              height: 140,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Image.network(
                event.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => const Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
            // Informasi Event
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      event.type,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatDate(event.datetimeLocal),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.venueCity,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
