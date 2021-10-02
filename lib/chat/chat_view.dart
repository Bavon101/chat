import 'dart:async';
import 'dart:io';

import 'package:chat/controllers/short_calls.dart';
import 'package:chat/models/last_chat_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ChatView extends StatefulWidget {
  const ChatView({Key? key, this.otherUser, this.last}) : super(key: key);
  final UserModel? otherUser;
  final LastChatModel? last;

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  ChatUser get user => ChatUser(
        name: state(context: context).currentUser?.userName ?? 'Ivar',
        uid: state(context: context).currentUser?.userId ?? '',
        avatar: state(context: context).currentUser?.userProfilePhoto ??
            "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
      );

  ChatUser get otherUser => widget.otherUser != null
      ? ChatUser(
          name: widget.otherUser!.userName,
          uid: widget.otherUser!.userId,
          avatar: widget.otherUser!.userProfilePhoto)
      : ChatUser(
          name: widget.last?.friendname,
          uid: widget.last?.friendId,
          avatar: widget.last?.friendAvatar);

  List<ChatMessage> messages = <ChatMessage>[];
  var m = <ChatMessage>[];

  var i = 0;

  @override
  void initState() {
    super.initState();
  }

  void systemMessage() {
    Timer(const Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(const Duration(milliseconds: 300), () {
        _chatViewKey.currentState!.scrollController.animateTo(
          _chatViewKey.currentState!.scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      });
    });
  }

  Future<void> _updateLastCharts(ChatMessage message,
      {bool alpha = true}) async {
    LastChatModel _last = LastChatModel(
        friendAvatar: alpha ? otherUser.avatar : user.avatar,
        friendId: alpha ? otherUser.uid : user.uid,
        friendname: alpha ? otherUser.name : user.name,
        lastmessage: message.text ?? '📷',
        when: message.createdAt.millisecondsSinceEpoch.toString());
    final snapshot = await FirebaseFirestore.instance
        .collection('lastChats')
        .doc(alpha ? user.uid : otherUser.uid)
        .collection('chatswith')
        .doc(alpha ? otherUser.uid : user.uid)
        .get();
    if (snapshot.exists) {
      await FirebaseFirestore.instance
          .collection('lastChats')
          .doc(alpha ? user.uid : otherUser.uid)
          .collection('chatswith')
          .doc(alpha ? otherUser.uid : user.uid)
          .update(_last.toJson());
    } else {
      await FirebaseFirestore.instance
          .collection('lastChats')
          .doc(alpha ? user.uid : otherUser.uid)
          .collection('chatswith')
          .doc(alpha ? otherUser.uid : user.uid)
          .set(_last.toJson());
    }
  }

  void onSend(ChatMessage message) {
    print(message.toJson());
    FirebaseFirestore.instance
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(message.toJson());
    try {
      _updateLastCharts(message);
      _updateLastCharts(message, alpha: false);
    } catch (e) {
      print(e.toString());
    }
    
  }

  String get chatId =>
      otherUser.uid![0].codeUnitAt(0) > user.uid![0].codeUnitAt(0)
          ? (otherUser.uid! + user.uid!)
          : (user.uid! + otherUser.uid!);
  Widget buildTextMessage(String? text, [ChatMessage? message]) {
    bool isUser = message!.user.uid == user.uid;
    return ParsedText(
      parse: const [],
      regexOptions: const RegexOptions(unicode: true),
      text: message.text!,
      style: TextStyle(
        color: message.user.color ?? (isUser ? Colors.white70 : Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(otherUser.name ?? ''),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('messages')
                .doc(chatId)
                .collection('messages')
                .orderBy("createdAt")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                );
              } else {
                List<DocumentSnapshot> items = snapshot.data!.docs;
                var messages = items
                    .map((i) =>
                        ChatMessage.fromJson(i.data()! as Map<String, dynamic>))
                    .toList();
                return DashChat(
                  messageTextBuilder: buildTextMessage,
                  height: height(context: context),
                  width: width(context: context),
                  key: _chatViewKey,
                  inverted: false,
                  onSend: onSend,
                  sendOnEnter: true,
                  textInputAction: TextInputAction.send,
                  user: user,
                  inputDecoration: const InputDecoration.collapsed(
                      hintText: "Add message here..."),
                  dateFormat: DateFormat('yyyy-MMM-dd'),
                  timeFormat: DateFormat('HH:mm'),
                  messages: messages,
                  showUserAvatar: false,
                  showAvatarForEveryMessage: false,
                  scrollToBottom: false,
                  onPressAvatar: (ChatUser user) {
                    print("OnPressAvatar: ${user.name}");
                  },
                  onLongPressAvatar: (ChatUser user) {
                    print("OnLongPressAvatar: ${user.name}");
                  },
                  inputMaxLines: 5,
                  messageContainerPadding:
                      EdgeInsets.only(left: 5.0, right: 5.0),
                  alwaysShowSend: true,
                  inputTextStyle: TextStyle(fontSize: 16.0),
                  inputContainerStyle: BoxDecoration(
                    border: Border.all(width: 0.0),
                    color: Colors.white,
                  ),
                  onQuickReply: (Reply reply) {
                    setState(() {
                      messages.add(ChatMessage(
                          text: reply.value,
                          createdAt: DateTime.now(),
                          user: user));

                      messages = [...messages];
                    });

                    Timer(const Duration(milliseconds: 300), () {
                      _chatViewKey.currentState!.scrollController
                        .animateTo(
                          _chatViewKey.currentState!.scrollController.position
                              .maxScrollExtent,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300),
                        );

                      if (i == 0) {
                        systemMessage();
                        Timer(const Duration(milliseconds: 600), () {
                          systemMessage();
                        });
                      } else {
                        systemMessage();
                      }
                    });
                  },
                  onLoadEarlier: () {
                    print("laoding...");
                  },
                  shouldShowLoadEarlier: false,
                  showTraillingBeforeSend: true,
                  trailing: <Widget>[
                    IconButton(
                      icon: Icon(Icons.photo),
                      onPressed: () async {
                        final picker = ImagePicker();
                        // ignore: deprecated_member_use
                        PickedFile? result = await picker.getImage(
                          source: ImageSource.gallery,
                          imageQuality: 80,
                          maxHeight: 400,
                          maxWidth: 400,
                        );

                        if (result != null) {
                          final Reference storageRef = FirebaseStorage.instance
                              .ref()
                              .child("chat_images");

                          final taskSnapshot = await storageRef.putFile(
                            File(result.path),
                            SettableMetadata(
                              contentType: 'image/jpg',
                            ),
                          );

                          String url = await taskSnapshot.ref.getDownloadURL();

                          ChatMessage message =
                              ChatMessage(text: "", user: user, image: url);

                          FirebaseFirestore.instance
                              .collection('messages')
                              .add(message.toJson());
                        }
                      },
                    )
                  ],
                );
              }
            }));
  }
}
