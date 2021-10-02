import 'package:chat/controllers/short_calls.dart';
import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AppState extends ChangeNotifier {
  UserModel? currentUser;
  Future<void> getUser() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('testusers')
          .doc(user?.uid)
          .get();
      currentUser = UserModel.fromJson(snapshot.data()!);
      notifyListeners();
    } catch (e) {}
  }
}
