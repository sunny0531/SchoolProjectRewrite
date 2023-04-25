import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ui/setting.dart';
import 'package:ui/util.dart';

import 'global.dart';

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
  final receiverController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    senderController.dispose();
    receiverController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<http.Response> _send_mail() async {
    final response = await http.post(Uri.parse("$url/mail"));
    return response;
  }

  void send_mail() {
    Future<http.Response> response = _send_mail();
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        actions: [
          TextButton(onPressed: () => Navigator.maybePop(context), child: const Text("Ok"))
        ],
        title: const Text("Sending mail"),
        content: StatefulBuilder(builder: (context, setState) {
          return FutureBuilder(
            builder: (context, AsyncSnapshot<http.Response> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.statusCode == 204){
                  return const Text("Succeed");
                }else{
                  return Text("Error: ${snapshot.data?.body??"Unknown"}");
                }
              } else {
                return const Column(mainAxisSize: MainAxisSize.min,children: [
                  Text("Sending the mail"),
                  CircularProgressIndicator()
                ]);
              }
            }, future: response,);
        },),
      );
    },);
  }

  Future<Setting> _getSetting() async {
    final response = await http.get(Uri.parse("$url/setting"));
    print(Setting
        .fromJson(jsonDecode(response.body))
        .sender);
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
    get_setting();
  }

  void get_setting() {
    _setting = _getSetting();
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
                  reset = value;
                });
              },
            ),
          ],
        ),
      ),
      Builder(builder: (context) {
        get_setting();
        return FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              setting = snapshot.data!;
              return SettingScreen(setting: setting);
            } else if (snapshot.hasError) {
              return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.error.toString()),
                      IconButton(
                          onPressed: () =>
                              setState(() {
                                get_setting();
                              }),
                          icon: const Icon(Icons.restart_alt))
                    ],
                  ));
            } else {
              return const CircularProgressIndicator();
            }
          },
          future: _setting,
        );
      })
    ];
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        send_mail();
      }, child: const Icon(Icons.send)),
      appBar: AppBar(
        title: const Text("App"),
        shadowColor: Theme
            .of(context)
            .shadowColor,
        elevation: 2,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
