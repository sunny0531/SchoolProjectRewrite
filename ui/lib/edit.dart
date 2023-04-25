import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ui/util.dart';

import 'CustomDialog.dart';
import 'global.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreen();
}

class _EditScreen extends State<EditScreen> {
  Future<Count>? _count;
  Count? count;
  final redController = TextEditingController();
  final greenController = TextEditingController();
  final blueController = TextEditingController();
  final yellowController = TextEditingController();

  Future<Count> get_count() async {
    final response = await http.get(Uri.parse("$url/count"));
    if (response.statusCode == 200) {
      return Count.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get setting');
    }
  }

  @override
  void dispose() {
    super.dispose();
    redController.dispose();
    greenController.dispose();
    blueController.dispose();
    yellowController.dispose();
  }

  @override
  void initState() {
    super.initState();

    _count = get_count();
  }
  void update(Count c){
    redController.text=c.red.toString();
    greenController.text=c.green.toString();
    blueController.text=c.blue.toString();
    yellowController.text=c.yellow.toString();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<Count> snapshot) {

        if (snapshot.hasData) {
          count=snapshot.data;
          update(snapshot.data??Count(0, 0, 0, 0));
          return Center(
            child: ListView(children: [
              ListTile(
                title: const Text("Red"),
                subtitle: Text(count?.red.toString() ?? 0.toString()),
                onTap: () {
                  redController.text = count?.red.toString() ?? "null";
                  custom(context, redController, "Red count", "Set the amount of time red is pressed", (){
                      setState(() {
                        count?.red=int.parse(redController.text);
                      });
                  },[FilteringTextInputFormatter.digitsOnly]);
                },
              ),
              ListTile(
                title: const Text("Green"),
                subtitle: Text(count?.green.toString() ?? 0.toString()),
                onTap: () {
                  greenController.text = count?.green.toString() ?? "null";
                  custom(context, greenController, "Red count", "Set the amount of time red is pressed", (){
                    setState(() {
                      count?.green=int.parse(greenController.text);
                    });
                  },[FilteringTextInputFormatter.digitsOnly]);
                },
              ),
              ListTile(
                title: const Text("Blue"),
                subtitle: Text(count?.blue.toString() ?? 0.toString()),
                onTap: () {
                  blueController.text = count?.blue.toString() ?? "null";
                  custom(context, blueController, "Red count", "Set the amount of time red is pressed", (){
                    setState(() {
                      count?.blue=int.parse(blueController.text);
                    });
                  },[FilteringTextInputFormatter.digitsOnly]);
                },
              ),
              ListTile(
                title: const Text("Yellow"),
                subtitle: Text(count?.yellow.toString() ?? 0.toString()),
                onTap: () {
                  yellowController.text = count?.yellow.toString() ?? "null";
                  custom(context, yellowController, "Red count", "Set the amount of time red is pressed", (){
                    setState(() {
                      count?.yellow=int.parse(yellowController.text);
                    });
                  },[FilteringTextInputFormatter.digitsOnly]);
                },
              ),
              ListTile(
                title: Text("Reset"),

              ),
              ListTile(
                title: Text("Save"),
                onTap: (){
                  final response = http.put(Uri.parse("$url/update"),body: json.encode(count?.toJson()));
                  confirmDialog(context, response, "Saving", "Should be quick");
                },
              ),
            ],),
          );
        } else if (snapshot.hasError) {
          return Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(snapshot.error.toString()),
              IconButton(
                  onPressed: () => setState(() {
                        _count = get_count();
                      }),
                  icon: const Icon(Icons.restart_alt))
            ],
          ));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
      future: _count,
    );
  }
}
