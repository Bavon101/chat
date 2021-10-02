import 'package:chat/chat/chat_view.dart';
import 'package:chat/controllers/short_calls.dart';
import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommunityUsers extends StatelessWidget {
  const CommunityUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('testusers')
              .where("user_id",isNotEqualTo: user?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: showProgress(),
              );
            } else if (snapshot.hasData) {
              List<DocumentSnapshot> _u = snapshot.data?.docs ?? [];
              var _users = _u
                  .map((i) =>
                      UserModel.fromJson(i.data() as Map<String, dynamic>))
                  .toList();
                  if(_users.isEmpty){
                    return _noUsers();
                  }
              return ListView.separated(
                  itemBuilder: (context, i) => ListTile(
                    onTap: () => goTo(context: context, child: ChatView(otherUser: _users[i],)),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_users[i].userProfilePhoto??
                      'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
                    ),
                    title: Text(_users[i].userName??"user#"),
                  ),
                  separatorBuilder: (context, i) => const Divider(thickness: 3,),
                  itemCount: _users.length);
            }
            return _noUsers();
          }),
    );
  }

  Center _noUsers() {
    return const Center(
            child: Text("There are currently no user record in the system"),
          );
  }
}
