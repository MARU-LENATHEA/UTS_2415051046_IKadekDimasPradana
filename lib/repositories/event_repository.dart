import '../models/event_catalog_item.dart';
import '../models/saved_event.dart';
import '../services/event_api_service.dart';
import '../services/saved_event_data_source.dart';

class EventRepository {
  final EventApiService _apiService;
  final SavedEventDataSource _dataSource;

  EventRepository({
    required EventApiService apiService,
    required SavedEventDataSource dataSource,
  }) : _apiService = apiService,
       _dataSource = dataSource;

  // Operasi Katalog REST API (GET)
  Future<List<EventCatalogItem>> getCatalogEvents({String query = ''}) {
    return _apiService.fetchEvents(query: query);
  }

  // Operasi CRUD Database Supabase
  Future<List<SavedEvent>> getSavedEvents() {
    return _dataSource.getSavedEvents();
  }

  Future<SavedEvent> addSavedEvent(SavedEvent event) {
    return _dataSource.createSavedEvent(event);
  }

  Future<void> updateSavedEvent(int id, SavedEvent event) {
    return _dataSource.updateSavedEvent(id, event);
  }

  Future<void> deleteSavedEvent(int id) {
    return _dataSource.deleteSavedEvent(id);
  }
}
