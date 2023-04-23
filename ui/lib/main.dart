import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ui/util.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: const MyStatefulWidget(),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromRGBO(178, 57, 80, 255),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  late bool reset;
  late List<Widget> _widgetOptions;
  late Future<Setting> _setting;
  Setting? setting;
  final senderController = TextEditingController();
v  final receiverController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    senderController.dispose();
    receiverController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  Future<Setting> getSetting() async{
    final response=await http.get(Uri.parse("http://raspberrypi.local:8080/setting"));
    print( Setting.fromJson(jsonDecode(response.body)).sender);
    if (response.statusCode == 200) {
      return Setting.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get setting');
    }
  }
  @override
  void initState() {
    super.initState();
    reset = false;
    _setting=getSetting();

  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _widgetOptions = <Widget>[
      const Center(
        child: Text("Home"),
      ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
            Switch(
              value: reset,
              onChanged: (value) {
                setState(() {
                  reset=value;
                });
              },
            ),
          ],
        ),
      ),
      ListView(
        children: [
          ListTile(
            title: const Text("Sender"),
            subtitle: Text(setting?.sender??"null"),
            onTap: () {
              senderController.text=setting?.sender??"null";
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Set sender'p mail"),
                  content: Focus(
                    child: TextFormField(controller: senderController,decoration: const InputDecoration(
                      border: OutlineInputBorder(),

                labelText: "Mail address",
              )),
                    onFocusChange: (value) {
                      if (value){
                        keyboard.show(context, senderController);

                      }else{
                        Future.delayed(const Duration(milliseconds: 500), () {
                          keyboard.hide();
                        });

                      }
                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () { Navigator.pop(context, 'Cancel');keyboard.hide(force:true);},
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        keyboard.hide(force:true);
                        setState(() {
                          setting?.sender=senderController.text;
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
            subtitle: Text(setting?.receiver.join(", ")??"null"),
            onTap: () {
              Setting newSetting=Setting.fromJson(setting!.toJson());
              print(newSetting.receiver);
              receiverController.text=setting?.receiver.join(", ")??"null";
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Add/Remove receivers"),
                  content: SizedBox(
                    width: MediaQuery. of(context). size. width /3.5,
                    height: MediaQuery. of(context). size. height/3.5,
                    child: StatefulBuilder(
                      builder: (context,_setState) {
                        if (setting!.receiver.isNotEmpty){

                        return Column(
                          children: [
                            Flexible(
                              child: ListView.builder(shrinkWrap: true, itemBuilder: (context, index) {
                                  return ListTile(

                                    title: TextFormField(decoration: const InputDecoration(border: OutlineInputBorder()),initialValue: newSetting.receiver[index],onSaved: (newValue) {
                                      newSetting.receiver[index]=newValue;
                                    },),trailing: IconButton(onPressed: () {
                                    _setState(() {
                                      newSetting.receiver.removeAt(index);
                                    });

                                  }, icon: const Icon(Icons.delete)),);
                              },itemCount: newSetting.receiver.length),
                            ),
                            IconButton(
                                onPressed: () {
                                  _setState(() {
                                    newSetting.receiver.add("");
                                  });
                            }, icon: const Icon(Icons.add))
                          ],
                        );}else{
                          return const Center(child: Text("There are no receiver"),);
                        }
                      }
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          newSetting.receiver.removeWhere((element) => element.toString().trim()=="",);
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          newSetting.receiver.removeWhere((element) => element.toString().trim()=="",);
                          setting=Setting.fromJson(newSetting.toJson());
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Accept'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: Text("Password"),
            subtitle: Text("*"*(setting?.password.length??0)),
            onTap: () {

            },
          ),
        ],
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("App"),
        shadowColor: Theme.of(context).shadowColor,
        elevation: 2,
      ),
      body: Row(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _setting,
              builder: (context,AsyncSnapshot<Setting> snapshot) {
                if (snapshot.hasData) {
                  setting=snapshot.data!;
                  return Center(
                    child: _widgetOptions.elementAt(_selectedIndex),
                  );
                }else{
                  return Center(child: CircularProgressIndicator(),);
                }
              }
            ),
          ),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: "Send gmail",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Setting",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
