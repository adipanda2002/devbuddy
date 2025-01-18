import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPageView(),

    );

  }
}


class LoginPageView extends StatelessWidget {
  const LoginPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Image(image: AssetImage("assets/images/db.png"), height: 180,),
            const Text("Find your match"),
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
            OutlinedButton(onPressed: () {}, child: const Text("Login"))
          ]
        ),
      ),
    );
  }
}