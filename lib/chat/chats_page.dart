import 'package:chat/controllers/short_calls.dart';
import 'package:chat/models/last_chat_model.dart';
import 'package:chat/widgets/last_chat_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('lastChats')
              .doc(user?.uid ?? 'user')
              .collection('chatswith')
              .orderBy('when')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              List<DocumentSnapshot> items = snapshot.data!.docs;
              var chats = items
                  .map((i) =>
                      LastChatModel.fromJson(i.data()! as Map<String, dynamic>))
                  .toList()
                  .reversed;
                  if(chats.isEmpty){
                    return _nomessages();
                  }
              return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, i) {
                    return LastChatcard(last: chats.elementAt(i));
                  });
            }
            return _nomessages();
          }),
    );
  }

  Center _nomessages() {
    return const Center(
            child: Text("Your chats will be displayed here",textAlign: TextAlign.center,),
          );
  }
}
