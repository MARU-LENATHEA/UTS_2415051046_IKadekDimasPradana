import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/error_state_view.dart';
import 'event_detail_page.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Event'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<EventProvider>().loadCatalogEvents(),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          // 1. Loading State
          if (provider.isLoadingCatalog) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error State
          if (provider.catalogError != null) {
            return ErrorStateView(
              message: provider.catalogError!,
              onRetry: () => context.read<EventProvider>().loadCatalogEvents(),
            );
          }

          // 3. Empty State
          if (provider.catalogEvents.isEmpty) {
            return const Center(child: Text('Tidak ada event ditemukan.'));
          }

          // 4. Data Terisi (Responsive Layout)
          return LayoutBuilder(
            builder: (context, constraints) {
              // Jika lebar layar > 600 (Tablet/Web), gunakan 3 kolom. Jika HP, 1 kolom.
              final crossAxisCount = constraints.maxWidth > 600 ? 3 : 1;
              // Atur rasio kartu agar tidak terpotong (overflow)
              final childAspectRatio = constraints.maxWidth > 600 ? 0.8 : 1.15;

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: provider.catalogEvents.length,
                itemBuilder: (context, index) {
                  final event = provider.catalogEvents[index];
                  return EventCard(
                    event: event,
                    onTap: () {
                      // Navigasi ke Detail & Passing Data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EventDetailPage(event: event),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
