import 'dart:developer';
import 'package:devbuddy/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    if (kDebugMode) {
      print(status);
    }
    var collection = db.collection(COLLECTION_NAME);
  }
}