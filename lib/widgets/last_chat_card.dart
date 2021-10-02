import 'package:chat/chat/chat_view.dart';
import 'package:chat/controllers/short_calls.dart';
import 'package:chat/models/last_chat_model.dart';
import 'package:flutter/material.dart';


class LastChatcard extends StatelessWidget {
  const LastChatcard({Key? key, required this.last}) : super(key: key);
  final LastChatModel last;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        goTo(context: context, child: ChatView(
          last: last,
        ));
      },
      child: Container(
        height: height(context: context) * .08,
        width: width(context: context),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(last.friendAvatar ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      last.friendname ?? '%%',
                      style: const TextStyle(
                           fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      width: width(context: context)*.65,
                      child: Text(last.lastmessage ?? '#',maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      ))
                  ],
                ),
              ),
              const Spacer(),
              Text(getAgo(epoch: int.parse(last.when ?? '0')),style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
