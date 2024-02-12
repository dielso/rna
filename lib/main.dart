import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rna/screens/service_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RNA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const MyHomePage(title: 'Vancomycine - Dose adaptée'),
      home: const SelectServiceScreen(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const InputFactorsWidget(),
    );
  }
}

class InputFactorsWidget extends StatefulWidget {
  const InputFactorsWidget({super.key});

  @override
  InputFactorsWidgetState createState() => InputFactorsWidgetState();
}

class InputFactorsWidgetState extends State<InputFactorsWidget> {
  double concentrationCible = 0.0;
  double poids = 0.0;
  int pma = 0;
  double sCr = 0.0;
  double derniereDose = 0.0;
  int heures = 0;
  int minutes = 0;
  String? dose;
  bool isManual = true;
  double gVd = 0.0;
  double gCL = 0.0;


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Switch(value: isManual, onChanged: (bool val){
                setState(() {
                  isManual = val;
                });
              })),
              const Center(child: Text('Saisie de CL et Vd manuel?')),
              TextField(
                decoration: const InputDecoration(
                    labelText: 'Concentration cible (mg/L)'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  concentrationCible = double.parse(value);
                },
              ),
              const SizedBox(height: 16.0),
              Visibility(
                visible: !isManual,
                child: Column(
                  children: [
                    const Text(
                      'Informations du patient',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Poids (kg)'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        poids = double.parse(value);
                      },
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'PMA (semaines)'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        pma = int.parse(value);
                      },
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'SCr (µmol/L)'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        sCr = double.parse(value);
                      },
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isManual,
                child: Column(
                  children: [
                    const Text(
                      'Variables',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      decoration:
                      const InputDecoration(labelText: 'CL (L/h)'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        gCL = double.parse(value);
                      },
                    ),
                    TextField(
                      decoration:
                      const InputDecoration(labelText: 'Vd'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        gVd = double.parse(value);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Dernière dose',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: const InputDecoration(
                    labelText: 'Dernière dose (mg)'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  derniereDose = double.parse(value);
                },
              ),
              const SizedBox(height: 8.0),
              const Text('Combien de temps il y a passé depuis le fin de la perfusion?'),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Heures'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        heures = int.parse(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Minutes'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        minutes = int.parse(value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    double clearance;
                    double vd;
                    var t = 1;
                    if(!isManual){
                      vd = 0.628 * poids;
                      var t50h = pow(46.4, 3.54);
                      var pmah = pow(pma, 3.54);
                      clearance = 0.273 *
                          pow(poids, 0.438) *
                          pow((54 / sCr), 0.473) *
                          pmah /
                          (pmah + t50h);
                      print("CL = $clearance L/h");
                    }
                    else {
                      clearance = gCL;
                      vd = gVd;
                    }
                    print("CL = $clearance L/h");
                    print("Vd = $vd");
                    var ke = clearance / vd;
                    print(ke);
                    var time = minutes / 60 + heures;
                    print(time);
                    var cti = (exp(t*ke)-1)/exp(ke*t)*(derniereDose/vd)/ke;
                    var ctd = cti * exp(-ke * time);
                    print("Ctd = $ctd mg/L");
                    var dsup = ((concentrationCible -
                        ctd*exp(-ke*t))/(1-exp(-ke*t)))*ke*vd;
                    print("Dose sup = $dsup mg");
                    setState(() {
                      dose = dsup.toStringAsPrecision(4);
                    });
                  },
                  child: const Text('Calculer'),
                ),
              ),
              Center(
                child: Visibility(
                  visible: dose != null,
                  child: Text(
                    'Dose supplementaire = $dose mg',
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
