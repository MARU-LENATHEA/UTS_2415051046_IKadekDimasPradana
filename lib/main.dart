import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'constants/supabase_constants.dart';
import 'services/event_api_service.dart';
import 'services/event_supabase_service.dart';
import 'repositories/event_repository.dart';
import 'providers/event_provider.dart';
import 'screens/responsive_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabaseAnonKey,
  );

  // Inisialisasi Arsitektur
  final apiService = EventApiService();
  final supabaseService = EventSupabaseService();
  final repository = EventRepository(
    apiService: apiService,
    dataSource: supabaseService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EventProvider(repository)
            ..loadCatalogEvents()
            ..loadSavedEvents(),
        ),
      ],
      child: const EventHubApp(),
    ),
  );
}

class EventHubApp extends StatelessWidget {
  const EventHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventHub UTS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const ResponsiveShell(),
    );
  }
}
