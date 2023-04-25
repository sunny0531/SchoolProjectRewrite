import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui/util.dart';
import 'package:http/http.dart' as http;

void custom(BuildContext context,TextEditingController controller,String label,String title, Function confirmed,[List<TextInputFormatter>? formatters]){
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
          ),inputFormatters: formatters,),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            confirmed();
            Navigator.pop(context, 'OK');
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
void confirmDialog(BuildContext context,Future<http.Response> response, String title,String process){
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      actions: [
        TextButton(onPressed: () => Navigator.maybePop(context), child: const Text("Ok"))
      ],
      title: Text(title),
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
              return  Column(mainAxisSize: MainAxisSize.min,children: [
                Text(process),
                const CircularProgressIndicator()
              ]);
            }
          }, future: response,);
      },),
    );
  },);
}