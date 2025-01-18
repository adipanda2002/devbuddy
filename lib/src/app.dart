import 'package:devbuddy/src/login_page/loginview.dart';
import 'package:devbuddy/src/project_form/project_form_page.dart';
import 'package:devbuddy/src/tinder_card/tinder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        if (!settingsController.isInitialized) {
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

          // Set the initial route dynamically based on session.
          home: Supabase.instance.client.auth.currentSession != null
              ? DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("DevBuddy"),
                bottom: const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.home), text: 'Home'),
                    Tab(icon: Icon(Icons.edit), text: 'Form'),
                    Tab(icon: Icon(Icons.account_circle), text: 'Account'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  TinderPageView(
                    userId: Supabase.instance.client.auth.currentUser?.id ?? '',
                  ),
                  const FormPage(),
                ],
              ),
            ),
          )
              : const LoginPageView(),

          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case 'login':
                    return const LoginPageView();
                  case 'main':
                    return DefaultTabController(
                      length: 3,
                      child: Scaffold(
                        appBar: AppBar(
                          title: const Text("DevBuddy"),
                          bottom: const TabBar(
                            tabs: [
                              Tab(icon: Icon(Icons.home), text: 'Home'),
                              Tab(icon: Icon(Icons.edit), text: 'Form'),
                              Tab(icon: Icon(Icons.account_circle), text: 'Account'),
                            ],
                          ),
                        ),
                        body: TabBarView(
                          children: [
                            TinderPageView(
                              userId: Supabase.instance.client.auth.currentUser?.id ?? '',
                            ),
                            const FormPage(),
                          ],
                        ),
                      ),
                    );
                  default:
                    return const LoginPageView();
                }
              },
            );
          },
        );
      },
    );
  }
}
