import "dart:developer";
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eletro_calc/screens/common_emitter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Circuitaria',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int value){
    setState(() {
      selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch(selectedIndex)
    {
      case 0:
        page = CommonEmitter();
      break;
      default:
        page = Center();
    }


    return LayoutBuilder(builder: (context, constraints){
      return Scaffold(
        appBar: AppBar(
          title: const Text("Calc. de Circuitos Transistorizados"),
        ),
        body: Center(
          child: page,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.bolt),
              label: 'Bancada',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.emoji_objects_outlined),
                label: 'Circuitos'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Conceitos'
            )
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      );
    });
  }
}

