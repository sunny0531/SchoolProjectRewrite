import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ui/CustomDialog.dart';
import 'package:ui/util.dart';

import 'global.dart';

class SettingScreen extends StatefulWidget {
  late Setting? setting;

  SettingScreen({super.key, required this.setting});

  @override
  State<SettingScreen> createState() => _SettingScreen();
}

class _SettingScreen extends State<SettingScreen> {
  Setting? setting;
  final senderController = TextEditingController();
  final passwordController = TextEditingController();
  final redController = TextEditingController();
  final greenController = TextEditingController();
  final blueController = TextEditingController();
  final yellowController = TextEditingController();
  Future<http.Response>? response;

  @override
  void initState() {
    super.initState();
    setting = widget.setting;
    response = update();
  }

  @override
  void dispose() {
    senderController.dispose();
    passwordController.dispose();
    redController.dispose();
    greenController.dispose();
    blueController.dispose();
    yellowController.dispose();
    super.dispose();
  }

  Future<http.Response> update() async {
    return http.put(Uri.parse("$url/setting"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(setting?.toJson()));
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: response,
      builder: (context, AsyncSnapshot<http.Response> snapshot) {
        if (snapshot.hasData) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (snapshot.data!.statusCode == 500) {
              custom(context, null, null, "Warning", () {}, null,
                  Text(jsonDecode(snapshot.data!.body)["error"]+"\nDo not panic, check if there are incorrect pin\nIf the incorrect pin is fixed, this will still pop up once"));
            }
          });
            return ListView(
            children: [
              ListTile(
                title: const Text("Sender"),
                subtitle: Text(setting?.sender ?? "null"),
                onTap: () {
                  senderController.text = setting?.sender ?? "null";
                  custom(context, senderController, "Mail address",
                      "Set sender's mail", () {
                    setState(() {
                      setting?.sender = senderController.text;
                      response = update();
                    });
                  });
                },
              ),
              ListTile(
                title: Text("Recivers"),
                subtitle: Text(setting?.receiver.join(", ") ?? "null"),
                onTap: () {
                  bool save = false;
                  print(setting?.receiver);
                  Setting newSetting = Setting.fromJson(
                      json.decode(json.encode(setting!.toJson())));
                  //Setting newSetting =  Setting.fromJson(jsonDecode('{"receiver": ["sunny.ayyl@gmail.com"], "sender": "sunnnyayylproject@gmail.com", "password": "qcnoiftdonefphxt","red": 15,"green": 11,"blue": 16,"yellow": 13}'));
                  //print(newSetting.receiver);
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => WillPopScope(
                      onWillPop: () async {
                        print(save);
                        newSetting.receiver.removeWhere(
                          (element) => element.toString().trim() == "",
                        );
                        if (save) {
                          setting = Setting.fromJson(
                              json.decode(json.encode(newSetting!.toJson())));
                        } else {
                          newSetting = Setting.fromJson(
                              json.decode(json.encode(setting!.toJson())));
                        }
                        return true;
                      },
                      child: AlertDialog(
                        title: const Text("Add/Remove receivers"),
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width / 3.5,
                          height: MediaQuery.of(context).size.height / 3.5,
                          child: StatefulBuilder(builder: (context, _setState) {
                            return Column(
                              children: [
                                Flexible(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: TextFormField(
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder()),
                                            initialValue:
                                                newSetting.receiver[index],
                                            onChanged: (newValue) {
                                              newSetting?.receiver[index] =
                                                  newValue;
                                            },
                                          ),
                                          trailing: IconButton(
                                              onPressed: () {
                                                _setState(() {
                                                  newSetting.receiver
                                                      .removeAt(index);
                                                });
                                              },
                                              icon: const Icon(Icons.delete)),
                                        );
                                      },
                                      itemCount: newSetting.receiver.length),
                                ),
                                IconButton(
                                    onPressed: () {
                                      _setState(() {
                                        newSetting.receiver.add("");
                                      });
                                    },
                                    icon: const Icon(Icons.add))
                              ],
                            );
                          }),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              setState(() {
                                save = false;
                                Navigator.maybePop(context);
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                save = true;
                                Navigator.maybePop(context);
                              });
                            },
                            child: const Text('Accept'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Password"),
                subtitle: Text("*" * (setting?.password.length ?? 0)),
                onTap: () {
                  passwordController.text = setting?.password ?? "null";
                  custom(context, passwordController, "Password",
                      "Set sender's password", () {
                    setState(() {
                      setting?.password = passwordController.text;
                      response = update();
                    });
                  });
                },
              ),
              ListTile(
                title: Text("Red pin"),
                subtitle: Text(setting?.red.toString() ?? "null"),
                onTap: () {
                  redController.text = setting?.red.toString() ?? "null";
                  custom(context, redController, "Pin", "Set red pin", () {
                    setState(() {
                      setting?.red = int.parse(redController.text);
                      response = update();
                    });
                  });
                },
              ),
              ListTile(
                title: Text("Green pin"),
                subtitle: Text(setting?.green.toString() ?? "null"),
                onTap: () {
                  greenController.text = setting?.green.toString() ?? "null";
                  custom(context, greenController, "Pin", "Set green pin", () {
                    setState(() {
                      setting?.green = int.parse(greenController.text);
                      response = update();
                    });
                  });
                },
              ),
              ListTile(
                title: Text("Blue pin"),
                subtitle: Text(setting?.blue.toString() ?? "null"),
                onTap: () {
                  blueController.text = setting?.blue.toString() ?? "null";
                  custom(context, blueController, "Pin", "Set blue pin", () {
                    setState(() {
                      setting?.blue = int.parse(blueController.text);
                      response = update();
                    });
                  });
                },
              ),
              ListTile(
                title: Text("Yellow pin"),
                subtitle: Text(setting?.yellow.toString() ?? "null"),
                onTap: () {
                  yellowController.text = setting?.yellow.toString() ?? "null";
                  custom(context, yellowController, "Pin", "Set yellow pin",
                      () {
                    setState(() {
                      setting?.yellow = int.parse(yellowController.text);
                      response = update();
                    });
                  });
                },
              ),
            ],
          );
        }else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
