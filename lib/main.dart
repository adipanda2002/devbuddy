import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    debug: true,
  );

  WidgetsFlutterBinding.ensureInitialized();
  final settingsService = SettingsService();
  final settingsController = SettingsController(settingsService);

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Check if a user session exists (via SharedPreferences or Supabase).
  final userId = Supabase.instance.client.auth.currentSession?.user.id;
  final initialRoute = userId == null ? 'login' : 'main';

  // Run the app, passing in the user ID
  runApp(MyApp(
    settingsController: settingsController,
  ));
  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
}

final supabase = Supabase.instance.client;

