import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/saved_event.dart';
import 'saved_event_data_source.dart';

class EventSupabaseService implements SavedEventDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<List<SavedEvent>> getSavedEvents() async {
    final data = await _supabase
        .from('saved_events')
        .select()
        .order('id', ascending: false);

    return (data as List)
        .map((e) => SavedEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<SavedEvent> createSavedEvent(SavedEvent event) async {
    final row = await _supabase
        .from('saved_events')
        .insert(event.toJson())
        .select()
        .single();

    return SavedEvent.fromJson(row);
  }

  @override
  Future<void> updateSavedEvent(int id, SavedEvent event) async {
    await _supabase.from('saved_events').update(event.toJson()).eq('id', id);
  }

  @override
  Future<void> deleteSavedEvent(int id) async {
    await _supabase.from('saved_events').delete().eq('id', id);
  }
}
