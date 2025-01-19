import 'package:devbuddy/src/login_page/loginview.dart';
import 'package:devbuddy/src/tinder_card/tinder_page.dart';
import 'package:devbuddy/src/project_form/project_form_page.dart';
import 'package:devbuddy/src/tinder_card/tinder_page_hm.dart';
import 'package:devbuddy/src/matches/matches.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  /// Function to retrieve session information from `SharedPreferences`.
  Future<Map<String, String?>> _getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final role = prefs.getString('role');
    return {'userId': userId, 'role': role};
  }

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

        return FutureBuilder<Map<String, String?>>(
          future: _getSession(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // Show a loading indicator while session data is being retrieved.
              return const MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            final userId = snapshot.data?['userId'];
            final role = snapshot.data?['role'];

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

              // Dynamically determine the home widget based on session data.
              home: userId != null
                  ? DefaultTabController(
                      length: 3,
                      child: Scaffold(
                        appBar: AppBar(
                          title: const Text("DevBuddy"),
                          bottom: const TabBar(
                            tabs: [
                              Tab(icon: Icon(Icons.home), text: 'Home'),
                              Tab(icon: Icon(Icons.edit), text: 'Form'),
                              Tab(icon: Icon(Icons.dashboard), text: 'Matches'),
                            ],
                          ),
                        ),
                        body: TabBarView(
                          children: [
                            role == 'hm'
                                ? TinderPageView2(userId: userId) // Home for hiring managers
                                : TinderPageView(userId: userId), // Home for students
                            FormPage(), // Shared Form Page
                            MatchesPage(userId: userId),
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
                        if (userId != null) {
                          return DefaultTabController(
                            length: 3,
                            child: Scaffold(
                              appBar: AppBar(
                                title: const Text("DevBuddy"),
                                bottom: const TabBar(
                                  tabs: [
                                    Tab(icon: Icon(Icons.home), text: 'Home'),
                                    Tab(icon: Icon(Icons.edit), text: 'Form'),
                                    Tab(
                                        icon: Icon(Icons.dashboard),
                                        text: 'Matches'),
                                  ],
                                ),
                              ),
                              body: TabBarView(
                                children: [
                                  role == 'hm'
                                      ? TinderPageView2(
                                          userId:
                                              userId) // Home for hiring managers
                                      : TinderPageView(
                                          userId: userId), // Home for students
                                  FormPage(), // Shared Form Page
                                  MatchesPage(userId: userId),
                                ],
                              ),
                            ),
                          );
                        }
                        return const LoginPageView();
                      default:
                        return const LoginPageView();
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
