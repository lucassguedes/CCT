import "dart:developer";
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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

class CommonEmitter extends StatefulWidget{
  CommonEmitter({super.key});

  State<CommonEmitter> createState() => _CommonEmissorState();
}

class _CommonEmissorState extends State<CommonEmitter>{
  double rb = 2000000;
  double rc = 3600;
  double vcc = 15;
  double vbb = 15;

  final TextEditingController rc_controller = TextEditingController();
  final TextEditingController rb_controller = TextEditingController();
  final TextEditingController vbb_controller = TextEditingController();
  final TextEditingController vcc_controller = TextEditingController();



  @override
  void dispose(){
    rc_controller.dispose();
    rb_controller.dispose();
    vbb_controller.dispose();
    vcc_controller.dispose();
    super.dispose();
  }


  double hfe = 100;

  double calculate_ib()
  {
    return (vbb - 0.7)/rb;
  }

  double calculate_ic(double ib)
  {
    return ib*hfe;
  }

  double calculate_vc(double ic){
    return vcc - ic*rc;
  }

  String treat_number(double number, {int precision = 1})
  {
    String dimension;
    double reduced_number;

    reduced_number = number;
    dimension = "";

    
    if(number <= 0.00001)
    {
      reduced_number = number * 1000000;
      dimension = "μ";
    }
    else if(number <= 0.1)
    {
      reduced_number = number * 1000;
      dimension = "m";
    }
    else if(number > 1000 && number < 1000000)
    {
      reduced_number = number / 1000.0;
      dimension = "k";
    }else if(number > 1000000)
    {
      reduced_number = number / 1000000.0;
      dimension = "M";
    }

    return "${reduced_number.toStringAsFixed(precision)} $dimension";
  }

  Widget build(BuildContext context)
  {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/circuito_ec.png'),
            fit: BoxFit.contain
        ),
      ),
      child: Stack(
        children: [
          Positioned(
              top: 210,
              left: 180,
              child: TextButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text('Valor do resistor do coletor (Ω).'),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: rc_controller,
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: "$rc"
                                  ),
                                ),
                            ),
                            TextButton(

                                onPressed: (){
                                  setState(() {
                                    if(rc_controller.text != '')
                                    {
                                      rc = double.parse(rc_controller.text);
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('Confirmar')
                            )
                          ],
                        ),
                      ),
                    )
                ),
                child: Text("RC = ${treat_number(rc)} Ω"),
              )
          ),
          Positioned(
              top: 250,
              left: 50,
              child: TextButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.all(15),
                              child: Text('Valor do resistor da base (Ω).'),
                            ),
                            Padding(
                                padding: EdgeInsets.all(15.0),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: rb_controller,
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: "$rb"
                                  ),
                                ),
                            ),
                            const SizedBox(height: 15),
                            TextButton(
                                onPressed: (){
                                  setState(() {
                                    if(rb_controller.text != '')
                                    {
                                      rb = double.parse(rb_controller.text);
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('Confirmar')
                            )
                          ],
                        ),
                      ),
                    )
                ),
                child: Text("RB = ${treat_number(rb)} Ω"),
              )
          ),
          Positioned(
              top: 0,
              left: 10,
              child: TextButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text('Valor da tensão na base (V).'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: vbb_controller,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: "$vbb"
                                ),
                              ),
                            ),
                            TextButton(

                                onPressed: (){
                                  setState(() {
                                    if(vbb_controller.text != '')
                                    {
                                      vbb = double.parse(vbb_controller.text);
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('Confirmar')
                            )
                          ],
                        ),
                      ),
                    )
                ),
                child: Text("VBB = ${treat_number(vbb)}V"),
              ),

          ),
          Positioned(
            top: 20,
            left: 10,
            child: TextButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text('Valor da tensão de alimentação (V).'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: vcc_controller,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: "$vcc"
                              ),
                            ),
                          ),
                          TextButton(

                              onPressed: (){
                                setState(() {
                                  if(vcc_controller.text != '')
                                  {
                                    vcc = double.parse(vcc_controller.text);
                                  }
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('Confirmar')
                          )
                        ],
                      ),
                    ),
                  )
              ),
              child: Text("VCC = ${treat_number(vcc)}V"),
            ),
          ),
          const Positioned(
            top: 80,
            left: 20,
            child: Text("Dados calculados:"),
          ),
          Positioned(
            top: 120,
            left: 20,
            child: Text("Vc = ${calculate_vc(calculate_ic(calculate_ib())).toStringAsFixed(2)}V"),
          ),
          Positioned(
            top: 140,
            left: 20,
            child: Text("Ic = ${treat_number(calculate_ic(calculate_ib()), precision: 2)}A"),
          ),
          Positioned(
            top: 160,
            left: 20,
            child: Text("Ib = ${treat_number(calculate_ib(), precision: 2)}A"),
          ),
        ],
      ),
    );
  }
}