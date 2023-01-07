

import 'package:hive_flutter/hive_flutter.dart';

import '../models/user_model.dart';

class DBFunctions {
  //Singleton
  DBFunctions._internal();

  static DBFunctions instance = DBFunctions._internal();

  factory DBFunctions() {
    return instance;
  }
  //Add users
  Future<void> userSignup(UserModel user) async {
    final db = await Hive.openBox<UserModel>('User');
    db.put(user.id, user);
  }

  //getUsers
  Future<List<UserModel>> getUsers() async {
    final db = await Hive.openBox<UserModel>('User');
    
    return db.values.toList();
  }
}