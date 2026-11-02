import '../models/saved_event.dart';

abstract class SavedEventDataSource {
  Future<List<SavedEvent>> getSavedEvents();
  Future<SavedEvent> createSavedEvent(SavedEvent event);
  Future<void> updateSavedEvent(int id, SavedEvent event);
  Future<void> deleteSavedEvent(int id);
}
