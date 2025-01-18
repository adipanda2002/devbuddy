import 'package:devbuddy/src/login_page/loginview.dart';
import 'package:devbuddy/src/tinder_card/tinder_page.dart';
import 'package:devbuddy/src/project_form/project_form_page.dart';
import 'package:devbuddy/src/my_account/my_account_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        if (!settingsController.isInitialized) {
          // Show loading screen until settings are initialized
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        return MaterialApp(
          restorationScopeId: 'app',
          themeMode: settingsController.themeMode,

          // Provide the generated AppLocalizations to the MaterialApp.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          theme: ThemeData.dark(),
          darkTheme: ThemeData.dark(),

          home: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title:
                    Text("DevBuddy"), //AppLocalizations.of(context)!.appTitle),
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.home), text: 'Home'),
                    Tab(icon: Icon(Icons.edit), text: 'Form'),
                    Tab(icon: Icon(Icons.account_circle), text: 'Account'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  TinderPageView(),
                  FormPage(),
                  MyAccountPage(),
                ],
              ),
            ),
          ),

          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case SampleItemDetailsView.routeName:
                    return LoginPageView();
                  case SampleItemListView.routeName:
                  default:
                    return LoginPageView();
                }
              },
            );
          },
        );
      },
    );
  }
}
