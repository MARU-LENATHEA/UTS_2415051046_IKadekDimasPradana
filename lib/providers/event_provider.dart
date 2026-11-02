import 'package:flutter/foundation.dart';

import '../models/event_catalog_item.dart';
import '../models/saved_event.dart';
import '../repositories/event_repository.dart';

class EventProvider extends ChangeNotifier {
  final EventRepository _repository;

  EventProvider(this._repository);

  // State Katalog REST API
  List<EventCatalogItem> _catalogEvents = [];
  bool _isLoadingCatalog = false;
  String? _catalogError;
  String _searchQuery = '';
  String _selectedCategory = 'ALL';

  // State Database Supabase (Saved Events)
  List<SavedEvent> _savedEvents = [];
  bool _isLoadingSaved = false;
  String? _savedError;
  bool _isSaving = false;

  // Getters
  List<EventCatalogItem> get catalogEvents {
    if (_selectedCategory == 'ALL') return _catalogEvents;
    return _catalogEvents
        .where((e) => e.type.toUpperCase().contains(_selectedCategory))
        .toList();
  }

  bool get isLoadingCatalog => _isLoadingCatalog;
  String? get catalogError => _catalogError;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<SavedEvent> get savedEvents => _savedEvents;
  bool get isLoadingSaved => _isLoadingSaved;
  String? get savedError => _savedError;
  bool get isSaving => _isSaving;

  // Shared State helper: Cek apakah event katalog sudah disimpan di database
  bool isEventSaved(String eventId) {
    return _savedEvents.any((item) => item.eventId == eventId);
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // 1. Fetch Katalog dari REST API
  Future<void> loadCatalogEvents({String query = ''}) async {
    _searchQuery = query;
    _isLoadingCatalog = true;
    _catalogError = null;
    notifyListeners();

    try {
      _catalogEvents = await _repository.getCatalogEvents(query: query);
    } catch (e) {
      _catalogError = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingCatalog = false;
      notifyListeners();
    }
  }

  // 2. Read Saved Events dari Database Supabase
  Future<void> loadSavedEvents() async {
    _isLoadingSaved = true;
    _savedError = null;
    notifyListeners();

    try {
      _savedEvents = await _repository.getSavedEvents();
    } catch (e) {
      _savedError = 'Gagal memuat agenda dari database: $e';
    } finally {
      _isLoadingSaved = false;
      notifyListeners();
    }
  }

  // 3. Create Saved Event ke Database Supabase
  Future<void> addEventToAgenda(SavedEvent newEvent) async {
    _isSaving = true;
    notifyListeners();

    try {
      await _repository.addSavedEvent(newEvent);
      await loadSavedEvents();
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // 4. Update Saved Event di Database Supabase
  Future<void> updateAgendaItem(int id, SavedEvent updatedEvent) async {
    _isSaving = true;
    notifyListeners();

    try {
      await _repository.updateSavedEvent(id, updatedEvent);
      await loadSavedEvents();
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // 5. Delete Saved Event dari Database Supabase
  Future<void> removeAgendaItem(int id) async {
    await _repository.deleteSavedEvent(id);
    await loadSavedEvents();
  }
}
