import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ui/util.dart';

import 'not_mine/persentation.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  Timer? timer;
  late Future<Count> c;
  Color? red=Colors.red[400];
  Color? green=Colors.green[500];
  Color? blue=Colors.lightBlue[400];
  Color? yellow=Colors.amber[300];
  void getCount() {
    c = get_count();
  }

  @override
  void initState() {
    super.initState();
    getCount();
    timer =
        Timer.periodic(const Duration(seconds: 3), (Timer t) {
          setState(() {
            getCount();
          });});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  List<PieChartSectionData> showingSections(Count d,double shortest) {
    int sum = d.red + d.green + d.blue + d.yellow;
    return List.generate(4, (i) {
      switch (i) {
        case 0:
          return PieChartSectionData(
              color: red, value: d.red / sum * 360, radius: shortest/2,title: d.red.toString());
        case 1:
          return PieChartSectionData(
              color: green, value: d.green / sum * 360, radius: shortest/2,title: d.green.toString());
        case 2:
          return PieChartSectionData(
              color: blue, value: d.blue / sum * 360, radius: shortest/2,title: d.blue.toString());
        case 3:
          return PieChartSectionData(
              color: yellow, value: d.yellow / sum * 360, radius: shortest/2,title: d.yellow.toString());
        default:
          throw Error();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: c,
      builder: (context, snapshot) {
        Count? d = snapshot.data;

        if (snapshot.hasData && d != null) {
        if (d!.red + d.green + d.blue + d.yellow==0){
        return const Center(child: Text("No data"),);
        }else{
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Indicator(
                      color: red,
                      text: 'Red',
                      isSquare: false,
                    ),
                    Indicator(
                      color: green,
                      text: 'Green',
                      isSquare: false,
                    ),
                    Indicator(
                      color: blue,
                      text: 'Blue',
                      isSquare: false,
                    ),
                    Indicator(
                      color: yellow,
                      text: 'Yellow',
                      isSquare: false,
                    ),
                  ],
                ),
                 SizedBox(
                  height: MediaQuery. of(context). size. height/12,
                ),
                SizedBox(
                  height: MediaQuery. of(context). size. height/2,
                  width: MediaQuery. of(context). size. width/2,
                  child: LayoutBuilder(
                    builder: (context,constrains) {
                      final double shortest=constrains.biggest.shortestSide;
                      return PieChart(PieChartData(
                          startDegreeOffset: 180,
                          borderData: FlBorderData(
                            show: false,
                          ),
                          centerSpaceRadius: 0, sections: showingSections(d,shortest)));
                    }
                  ),
                ),
              ],
            ),
          );}
        } else if (snapshot.hasError || d == null) {
          return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(snapshot.error.toString()),
                  IconButton(
                      onPressed: () => setState(() {
                            getCount();
                          }),
                      icon: const Icon(Icons.restart_alt))
                ]),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
