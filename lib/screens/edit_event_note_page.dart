import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/saved_event.dart';
import '../providers/event_provider.dart';

class EditEventNotePage extends StatefulWidget {
  final SavedEvent savedEvent;

  const EditEventNotePage({super.key, required this.savedEvent});

  @override
  State<EditEventNotePage> createState() => _EditEventNotePageState();
}

class _EditEventNotePageState extends State<EditEventNotePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _noteController;
  late String _selectedStatus;
  late double _priorityRating;

  @override
  void initState() {
    super.initState();
    // Isi awal form dengan data dari database
    _noteController = TextEditingController(
      text: widget.savedEvent.personalNote,
    );
    _selectedStatus = widget.savedEvent.attendanceStatus;
    _priorityRating = widget.savedEvent.priorityRating.toDouble();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _updateAgenda() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedEvent = SavedEvent(
      eventId: widget.savedEvent.eventId,
      title: widget.savedEvent.title,
      venue: widget.savedEvent.venue,
      eventDate: widget.savedEvent.eventDate,
      category: widget.savedEvent.category,
      imageUrl: widget.savedEvent.imageUrl,
      personalNote: _noteController.text.trim(),
      attendanceStatus: _selectedStatus,
      priorityRating: _priorityRating.toInt(),
      createdAt: widget.savedEvent.createdAt,
    );

    try {
      // Panggil fungsi update pada provider (memerlukan ID dari database)
      await context.read<EventProvider>().updateAgendaItem(
        widget.savedEvent.id!,
        updatedEvent,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agenda berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Kembali ke halaman list
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui agenda: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<EventProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Agenda')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: ListTile(
                  title: Text(
                    widget.savedEvent.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(widget.savedEvent.eventDate),
                  leading: const Icon(Icons.edit_calendar),
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan Persiapan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Catatan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status Kehadiran',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.check_circle_outline),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'planned',
                    child: Text('Direncanakan (Planned)'),
                  ),
                  DropdownMenuItem(
                    value: 'booked',
                    child: Text('Tiket Dibeli (Booked)'),
                  ),
                  DropdownMenuItem(
                    value: 'attended',
                    child: Text('Sudah Hadir (Attended)'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _selectedStatus = value);
                },
              ),
              const SizedBox(height: 24),

              const Text(
                'Prioritas Acara (1 - 5)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _priorityRating,
                min: 1,
                max: 5,
                divisions: 4,
                label: _priorityRating.round().toString(),
                onChanged: (value) => setState(() => _priorityRating = value),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: isSaving ? null : _updateAgenda,
                  icon: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.update),
                  label: Text(isSaving ? 'Menyimpan...' : 'Perbarui Agenda'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
