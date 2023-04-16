import "package:flutter/material.dart";
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class CommonEmitter extends StatefulWidget{
  CommonEmitter({super.key});

  State<CommonEmitter> createState() => _CommonEmitterState();
}

class _CommonEmitterState extends State<CommonEmitter>{
  double rb = 2000000;
  double rc = 3600;
  double vcc = 15;
  double vbb = 15;

  List<TransistorCurvePoint> chartData = [];

  final TextEditingController rc_controller = TextEditingController();
  final TextEditingController rb_controller = TextEditingController();
  final TextEditingController vbb_controller = TextEditingController();
  final TextEditingController vcc_controller = TextEditingController();
  final TextEditingController hfe_controller = TextEditingController();



  @override
  void dispose(){
    rc_controller.dispose();
    rb_controller.dispose();
    vbb_controller.dispose();
    vcc_controller.dispose();
    hfe_controller.dispose();
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
    else if(number >= 1000 && number < 1000000)
    {
      reduced_number = number / 1000.0;
      dimension = "k";
    }else if(number >= 1000000)
    {
      reduced_number = number / 1000000.0;
      dimension = "M";
    }

    return "${reduced_number.toStringAsFixed(precision)} $dimension";
  }

  List<TransistorCurvePoint> getChartData()
  {
    List<TransistorCurvePoint> chartData = [];
    const double vceMax = 40;
    double currentIc = 0;
    for(double i = 0; i < vceMax; i+=0.1)
    {
      if(i <= 0.7)
      {
        currentIc = ((i)/rc)*1000;
      }else if(i >= vceMax - 0.1)
      {
        currentIc = currentIc*3;
      }

      chartData.add(TransistorCurvePoint(currentIc, i.toDouble()));
    }

    return chartData;
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
              child: Text("VBE = VBB = ${treat_number(vbb)}V"),
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
          Positioned(
            top: 40,
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
                            child: Text('Ganho:'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: hfe_controller,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: "$hfe"
                              ),
                            ),
                          ),
                          TextButton(

                              onPressed: (){
                                setState(() {
                                  if(hfe_controller.text != '')
                                  {
                                    hfe = double.parse(hfe_controller.text);
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
              child: Text("β = ${treat_number(hfe)}"),
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
            child: Text("VEC = VC = ${calculate_vc(calculate_ic(calculate_ib())).toStringAsFixed(2)}V"),
          ),
          Positioned(
            top: 140,
            left: 20,
            child: Text("IC = ${treat_number(calculate_ic(calculate_ib()), precision: 2)}A"),
          ),
          Positioned(
            top: 160,
            left: 20,
            child: Text("IB = ${treat_number(calculate_ib(), precision: 2)}A"),
          ),
          Positioned(
              top: 500,
              left: 120,
              child: ElevatedButton(
                child: Text("Mostrar Curva"),
                onPressed: (){
                  chartData = getChartData();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: SafeArea(
                              child: Container(
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: SfCartesianChart(
                                          title: ChartTitle(text: 'Curva ICxVCE'),
                                          legend: Legend(isVisible: true),
                                          series: <ChartSeries>[
                                          LineSeries<TransistorCurvePoint, double>(
                                            name: 'Corrente do coletor',
                                            dataSource: chartData,
                                            xValueMapper: (TransistorCurvePoint point, _) => point.vec,
                                            yValueMapper: (TransistorCurvePoint point, _) => point.ic,
                                            // dataLabelSettings: const DataLabelSettings(isVisible: true),
                                          )
                                        ],
                                          primaryXAxis: NumericAxis(
                                              labelFormat: "{value}V",
                                              edgeLabelPlacement: EdgeLabelPlacement.shift
                                          ),
                                          primaryYAxis: NumericAxis(
                                              labelFormat: "{value}A"
                                          ),
                                        )
                                    ),
                                    ElevatedButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: Text("Fechar")
                                    )
                                  ],
                                ),
                              ),
                            )
                        ),
                      )
                  );
                },

              )
          )
        ],
      ),
    );
  }
}

class TransistorCurvePoint{
  TransistorCurvePoint(this.ic, this.vec);

  double ic;
  double vec;
}