import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';
import '../widgets/error_state_view.dart';

class SavedEventsPage extends StatelessWidget {
  const SavedEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Tersimpan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<EventProvider>().loadSavedEvents(),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (provider.isLoadingSaved) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.savedError != null) {
            return ErrorStateView(
              message: provider.savedError!,
              onRetry: () => context.read<EventProvider>().loadSavedEvents(),
            );
          }
          if (provider.savedEvents.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada agenda yang tersimpan di Supabase.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.savedEvents.length,
            itemBuilder: (context, index) {
              final agenda = provider.savedEvents[index];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: agenda.attendanceStatus == 'planned'
                        ? Colors.orange.shade100
                        : Colors.green.shade100,
                    child: Icon(
                      agenda.attendanceStatus == 'planned'
                          ? Icons.calendar_today
                          : Icons.check_circle,
                      color: agenda.attendanceStatus == 'planned'
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ),
                  title: Text(
                    agenda.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${agenda.eventDate}\nRating Prioritas: ${agenda.priorityRating} ⭐',
                  ),
                  trailing: const Icon(
                    Icons.edit_note,
                    color: Colors.deepPurple,
                  ),
                  isThreeLine: true,
                  onTap: () {
                    // Nanti diarahkan ke halaman Edit/Delete
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Fitur edit/hapus akan diaktifkan di tahap Update/Delete',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
