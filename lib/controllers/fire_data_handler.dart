import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FireData {
  final FirebaseApp app;
  FireData({required this.app});
  init() {
    db = FirebaseDatabase(app: app).reference();
  }

  DatabaseReference? db;

  Future<void> saveUser({required UserModel user}) async {
    await FirebaseFirestore.instance
        .collection('testusers')
        .doc(user.userId)
        .set(user.toJson());
  }
}
