import 'dart:convert';

class Setting{
  String sender;
  List<dynamic> receiver;
  String password;

  int red;

  int green;

  int blue;

  int yellow;
  Setting( this.sender, this.receiver, this.password,this.red,this.green,this.blue,this.yellow);

  Setting.fromJson(Map<String, dynamic> json)
      :sender=json["sender"],
        receiver=json["receiver"],
        password=json["password"],
        red=json["red"],
        green=json["green"],
        blue=json["blue"],
        yellow=json["yellow"];

  Map<String, dynamic> toJson() => {
    "sender":sender,
    "receiver":receiver,
    "password":password,
    "red": red,
    "green":green,
    "blue": blue,
    "yellow": yellow
  };
}