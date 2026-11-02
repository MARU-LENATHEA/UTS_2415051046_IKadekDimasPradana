import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';
import '../widgets/error_state_view.dart';
import 'edit_event_note_page.dart';

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
                        : (agenda.attendanceStatus == 'attended'
                              ? Colors.green.shade100
                              : Colors.blue.shade100),
                    child: Icon(
                      agenda.attendanceStatus == 'planned'
                          ? Icons.calendar_today
                          : (agenda.attendanceStatus == 'attended'
                                ? Icons.check_circle
                                : Icons.confirmation_num),
                      color: agenda.attendanceStatus == 'planned'
                          ? Colors.orange
                          : (agenda.attendanceStatus == 'attended'
                                ? Colors.green
                                : Colors.blue),
                    ),
                  ),
                  title: Text(
                    agenda.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${agenda.eventDate}\nCatatan: ${agenda.personalNote}\nRating: ${agenda.priorityRating} ⭐',
                  ),
                  isThreeLine: true,

                  // Tombol Hapus (Delete)
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      // Tampilkan Dialog Konfirmasi (Syarat Wajib UTS)
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Hapus Agenda?'),
                          content: Text(
                            'Apakah Anda yakin ingin menghapus "${agenda.title}" dari daftar agenda?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Batal'),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                context.read<EventProvider>().removeAgendaItem(
                                  agenda.id!,
                                );
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Agenda berhasil dihapus'),
                                  ),
                                );
                              },
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Klik kartu untuk menuju form Edit (Update)
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditEventNotePage(savedEvent: agenda),
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
