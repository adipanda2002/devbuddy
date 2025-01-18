import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");
  print('API Key: ${dotenv.env['API_KEY']}');
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  WidgetsFlutterBinding.ensureInitialized();
  final settingsService = SettingsService();
  final settingsController = SettingsController(settingsService);

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}

