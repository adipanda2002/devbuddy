import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> getHiringManagers() async {
  final SupabaseClient supabase = Supabase.instance.client;
  final List<Map<String, dynamic>> data = await supabase.from('hiringManagers').select();
  return data;
}