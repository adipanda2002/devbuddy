import 'package:flutter/material.dart';

import 'package:devbuddy/src/tinder_card/tinder_page.dart';
import 'package:devbuddy/src/project_form/project_form_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPageView(),
    );
  }
}



class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});
  @override
  _LoginPageViewState createState() => _LoginPageViewState();
}


class _LoginPageViewState extends State<LoginPageView> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  bool isLoading = false;

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Check if the user exists
      final response = await supabase
          .from('users')
          .select('id, username, password')
          .eq('username', username)
          .maybeSingle();

      print(response?.entries);
      if (response == null) {
        // User does not exist, create a new user
        final newUser = await supabase.from('users').insert({
          'username': username,
          'password': password,
        }).select('id').single();
        await saveUserSession(newUser['id']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New user created successfully!')),
        );
      } else if (response['password'] != password) {
        // Password mismatch
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid password.')),
        );
        return;
      } else {
        await saveUserSession(response['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
      }

      final userId = response?['id'];
      print('User ID: $userId');


        // Navigate to the main app
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DefaultTabController(
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
                    TinderPageView(userId: userId),
                    const FormPage(),
                  ],
                ),
              ),
            ),
          ),
        );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveUserSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Image(
              image: AssetImage("assets/images/db.png"),
              height: 180,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ),
            OutlinedButton(
              onPressed: isLoading ? null : login,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}