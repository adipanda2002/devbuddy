import 'package:mongo_dart/mongo_dart.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class MongoDBService {
  static late Db _db;
  static bool _isConnected = false;

  static Future<void> connect() async {
    if (!_isConnected) {
      _db = await Db.create('YOUR_MONGODB_ATLAS_CONNECTION_STRING');
      await _db.open();
      _isConnected = true;
    }
  }

  static Future<bool> authenticateUser(String email, String password) async {
    if (!_isConnected) await connect();

    final users = _db.collection('users');
    final user = await users.findOne(where.eq('email', email));

    if (user != null) {
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();
      return user['password'] == hashedPassword;
    }

    return false;
  }

  static Future<bool> registerUser(String email, String password) async {
    if (!_isConnected) await connect();

    final users = _db.collection('users');
    final existingUser = await users.findOne(where.eq('email', email));

    if (existingUser == null) {
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();
      await users.insert({
        'email': email,
        'password': hashedPassword,
      });
      return true;
    }

    return false;
  }
}

