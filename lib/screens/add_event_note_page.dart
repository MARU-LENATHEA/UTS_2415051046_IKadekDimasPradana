import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event_catalog_item.dart';
import '../models/saved_event.dart';
import '../providers/event_provider.dart';

class AddEventNotePage extends StatefulWidget {
  final EventCatalogItem event;

  const AddEventNotePage({super.key, required this.event});

  @override
  State<AddEventNotePage> createState() => _AddEventNotePageState();
}

class _AddEventNotePageState extends State<AddEventNotePage> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  String _selectedStatus = 'planned'; // planned, booked, attended
  double _priorityRating = 3; // 1 to 5

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveAgenda() async {
    // Validasi Form
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<EventProvider>();

    // Cek apakah event sudah pernah disimpan (mencegah duplikat)
    if (provider.isEventSaved(widget.event.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event ini sudah ada di daftar agenda Anda!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newEvent = SavedEvent(
      eventId: widget.event.id,
      title: widget.event.title,
      venue: widget.event.venueName,
      eventDate: widget.event.datetimeLocal,
      category: widget.event.type,
      imageUrl: widget.event.imageUrl,
      personalNote: _noteController.text.trim(),
      attendanceStatus: _selectedStatus,
      priorityRating: _priorityRating.toInt(),
    );

    try {
      await provider.addEventToAgenda(newEvent);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agenda berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan agenda: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<EventProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(title: const Text('Simpan Agenda')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Event Singkat
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: ListTile(
                  title: Text(
                    widget.event.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(widget.event.datetimeLocal),
                  leading: const Icon(Icons.event),
                ),
              ),
              const SizedBox(height: 24),

              // Input Catatan (Dengan Validasi)
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan Persiapan (Wajib)',
                  hintText: 'Misal: Beli tiket presale, ajak teman kampus...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Catatan tidak boleh kosong';
                  }
                  if (value.length < 5) {
                    return 'Catatan terlalu pendek (minimal 5 karakter)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Dropdown Status Kehadiran
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

              // Slider Rating Prioritas
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

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: isSaving ? null : _saveAgenda,
                  icon: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(isSaving ? 'Menyimpan...' : 'Simpan Agenda'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
