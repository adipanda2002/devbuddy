import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:devbuddy/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:devbuddy/src/tinder_card/tinder_page.dart';
import 'package:devbuddy/src/project_form/project_form_page.dart';
import 'package:devbuddy/src/my_account/my_account_page.dart';
import 'package:devbuddy/src/login_page/google_login.dart';

void main() => runApp(const App());



class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPageView(),

    );

  }
}



class LoginPageView extends StatelessWidget {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Image(image: AssetImage("assets/images/db.png"), height: 180,),
            // const Text("Find your match"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Username'
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Password'
                ),
              ),
            ),
            // ElevatedButton(onPressed: () {}, child: const Text("elevated Button")),
            OutlinedButton(onPressed: () {}, child: const Text("Login")),


            OutlinedButton(onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => DefaultTabController(
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
              )));
              }, child: const Text("SKIP LOGIN")),

            OutlinedButton(onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (container) => GoogleLoginScreen()));
            }, child: const Text("GOOGLE LOGIN")),
          ]
        ),
      ),
    );
  }
}



//
// home: DefaultTabController(

// ),
