// To parse this JSON data, do
//
//     final lastChatModel = lastChatModelFromJson(jsonString);

import 'dart:convert';

LastChatModel lastChatModelFromJson(String str) =>
    LastChatModel.fromJson(json.decode(str));

String lastChatModelToJson(LastChatModel data) => json.encode(data.toJson());

class LastChatModel {
  LastChatModel({
    this.friendname,
    this.friendId,
    this.friendAvatar,
    this.lastmessage,
    this.when,
  });

  String? friendname;
  String? friendId;
  String? friendAvatar;
  String? lastmessage;
  String? when;

  factory LastChatModel.fromJson(Map<String, dynamic> json) => LastChatModel(
        friendname: json["friendname"] == null ? null : json["friendname"],
        friendId: json["friendId"] == null ? null : json["friendId"],
        friendAvatar:
            json["friendAvatar"] == null ? null : json["friendAvatar"],
        lastmessage: json["lastmessage"] == null ? null : json["lastmessage"],
        when: json["when"] == null ? null : json["when"],
      );

  Map<String, dynamic> toJson() => {
        "friendname": friendname == null ? null : friendname,
        "friendId": friendId == null ? null : friendId,
        "friendAvatar": friendAvatar == null ? null : friendAvatar,
        "lastmessage": lastmessage == null ? null : lastmessage,
        "when": when == null ? null : when,
      };
}
