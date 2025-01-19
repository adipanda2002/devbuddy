import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchesPage extends StatefulWidget {
  final String userId;

  const MatchesPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> matches = [];
  bool isLoading = true;
  String? role; // Role of the current user

  @override
  void initState() {
    super.initState();
    _fetchRoleAndMatches();
  }

  // Fetch the user's role and then load the matches
  Future<void> _fetchRoleAndMatches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userRole = prefs.getString('role');
      setState(() {
        role = userRole;
      });

      // Once the role is fetched, load matches
      await _fetchMatches();
    } catch (e) {
      print('Error fetching role: $e');
    }
  }

  Future<void> _fetchMatches() async {
    try {
      // Query for reverse matches where both parties swiped each other
      final response = await supabase.from('swipes').select('''
      swipee_id,
      swiper_id,
      users:swipee_id(
        id,
        name,
        role,
        degree,
        university,
        organisation
      )
    ''').eq('swiper_id', widget.userId);

      if (response != null && response is List) {
        // Filter matches where swipee_id has also swiped the current user
        final List<Map<String, dynamic>> mutualMatches = [];
        for (var swipe in response) {
          final reverseMatch = await supabase
              .from('swipes')
              .select('id')
              .eq('swiper_id', swipe['swipee_id'])
              .eq('swipee_id', widget.userId)
              .maybeSingle();

          if (reverseMatch != null) {
            mutualMatches.add(swipe['users']);
          }
        }

        setState(() {
          matches = mutualMatches;
          isLoading = false;
        });
        print(mutualMatches);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching matches: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Matches'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : matches.isEmpty
              ? const Center(
                  child: Text(
                    'No matches yet!',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        title: Text(
                          match['name'] ?? 'Unknown Name',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: role == 'hm'
                            ? _buildHiringManagerDetails(match)
                            : _buildStudentDetails(match),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildHiringManagerDetails(Map<String, dynamic> match) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Degree: ${match['degree'] ?? 'N/A'}'),
        Text('University: ${match['university'] ?? 'N/A'}'),
      ],
    );
  }

  Widget _buildStudentDetails(Map<String, dynamic> match) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Organisation: ${match['organisation'] ?? 'N/A'}'),
      ],
    );
  }
}
