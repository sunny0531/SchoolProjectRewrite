import 'dart:convert';

class Setting {
  final String file;
  String sender;
  List<dynamic> receiver;
  String password;
  Setting(this.file, this.sender, this.receiver, this.password);

  Setting.fromJson(Map<String, dynamic> json)
      : file=json["file"],
        sender=json["sender"],
        receiver=json["receiver"],
        password=json["password"];

  Map<String, dynamic> toJson() => {
    "file": file,
    "sender":sender,
    "receiver":receiver,
    "password":password
  };
}