import 'package:chat/chat/chats_page.dart';
import 'package:chat/chat/community.dart';
import 'package:chat/controllers/short_calls.dart';
import 'package:chat/main.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              title: const Text(
                "Bavon Chat",
              ),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      service.signOutFromDevice();
                      setState(() {});
                    },
                    icon: const Icon(Icons.logout_rounded))
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: "Users",
                  ),
                  Tab(
                    text: "Chats",
                  ),
                ],
              )),
          body: const TabBarView(children: [CommunityUsers(), ChatsPage()])),
    );
  }
}
