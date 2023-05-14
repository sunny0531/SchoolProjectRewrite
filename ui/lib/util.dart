import 'dart:convert';
import 'package:http/http.dart' as http;

import 'global.dart';

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
class Count{
  int red;
  int green;
  int blue;
  int yellow;
  Count(this.red,this.green, this.blue, this.yellow);
  Count.fromJson(Map<String, dynamic> json)
      :red=json["red"],
        green=json["green"],
        blue=json["blue"],
        yellow=json["yellow"];

  Map<String, dynamic> toJson() => {
    "red": red,
    "green":green,
    "blue": blue,
    "yellow": yellow
  };
}
Future<Count> get_count() async {
  final response = await http.get(Uri.parse("$url/count"));
  if (response.statusCode == 200) {
    return Count.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get setting');
  }
}