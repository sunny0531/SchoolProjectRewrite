import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui/util.dart';

class SettingScreen extends StatefulWidget {
  late Setting? setting;

  SettingScreen({super.key, required this.setting});

  @override
  State<SettingScreen> createState() => _SettingScreen();
}

class _SettingScreen extends State<SettingScreen> {
  Setting? setting;
  final senderController = TextEditingController();
  final receiverController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setting = widget.setting;
  }

  @override
  void dispose() {
    senderController.dispose();
    receiverController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text("Sender"),
          subtitle: Text(setting?.sender ?? "null"),
          onTap: () {
            senderController.text = setting?.sender ?? "null";
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text("Set sender's mail"),
                content: TextFormField(
                    controller: senderController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Mail address",
                    )),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        setting?.sender = senderController.text;
                      });
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        ),
        ListTile(
          title: Text("Recivers"),
          subtitle: Text(setting?.receiver.join(", ") ?? "null"),
          onTap: () {
            bool save=false;
            print(setting?.receiver);
            Setting newSetting=Setting.fromJson( json.decode(json.encode(setting!.toJson())));
            //Setting newSetting =  Setting.fromJson(jsonDecode('{"receiver": ["sunny.ayyl@gmail.com"], "sender": "sunnnyayylproject@gmail.com", "password": "qcnoiftdonefphxt","red": 15,"green": 11,"blue": 16,"yellow": 13}'));
            //print(newSetting.receiver);
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => WillPopScope(
                onWillPop: () async {
                  print(save);
                  newSetting.receiver.removeWhere((element) => element.toString().trim()=="",);
                  if (save){
                    setting=Setting.fromJson( json.decode(json.encode(newSetting!.toJson())));
                  }else{
                    newSetting=Setting.fromJson( json.decode(json.encode(setting!.toJson())));
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
                                        initialValue: newSetting.receiver[index],
                                        onChanged: (newValue) {
                                          newSetting?.receiver[index] = newValue;
                                        },
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            _setState(() {
                                              newSetting.receiver.removeAt(index);
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
                          save=false;
                          Navigator.maybePop(context);
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {

                        setState(() {
                         save=true;
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
          onTap: () {},
        ),
      ],
    );
  }
}
