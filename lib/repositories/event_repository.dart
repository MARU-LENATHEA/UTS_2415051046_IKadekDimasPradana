import '../models/event_catalog_item.dart';
import '../models/saved_event.dart';
import '../services/event_api_service.dart';
import '../services/saved_event_data_source.dart';

class EventRepository {
  final EventApiService apiService;
  final SavedEventDataSource dataSource;

  EventRepository({
    required this.apiService,
    required this.dataSource,
  });

  // Operasi Katalog REST API (GET)
  Future<List<EventCatalogItem>> getCatalogEvents({String query = ''}) {
    return apiService.fetchEvents(query: query);
  }

  // Operasi CRUD Database Supabase
  Future<List<SavedEvent>> getSavedEvents() {
    return dataSource.getSavedEvents();
  }

  Future<SavedEvent> addSavedEvent(SavedEvent event) {
    return dataSource.createSavedEvent(event);
  }

  Future<void> updateSavedEvent(int id, SavedEvent event) {
    return dataSource.updateSavedEvent(id, event);
  }

  Future<void> deleteSavedEvent(int id) {
    return dataSource.deleteSavedEvent(id);
  }
}
