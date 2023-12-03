import 'dart:math';

import 'package:flutter/material.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Vancomycine - Dose adaptée'),
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
      body: InputFactorsWidget(),
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
  double derniereConcentration = 0.0;
  int heures = 0;
  int minutes = 0;
  String? dose;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Concentration cible (mg/L)'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  concentrationCible = double.parse(value);
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Informations du patient',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Poids (kg)'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  poids = double.parse(value);
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'PMA (semaines)'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  pma = int.parse(value);
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'SCr (µmol/L)'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  sCr = double.parse(value);
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Dernière examen',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Dernière concentration (mg/L)'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  derniereConcentration = double.parse(value);
                },
              ),
              const SizedBox(height: 8.0),
              const Text('Combien de temps il y a passé depuis l\'examen?'),
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
                    var vd = 0.628*poids;
                    var t50h = pow(46.4,3.54);
                    var pmah = pow(pma,3.54);
                    var clearance = 0.273 *pow(poids, 0.438)*pow( (54/sCr), 0.473) * pmah/(pmah+t50h);
                    print("CL = $clearance L/h");
                    var ke = clearance/vd;
                    print(ke);
                    var time = minutes/60 + heures;
                    print(time);
                    var ctd = derniereConcentration * exp(-ke*time);
                    print("Ctd = $ctd mg/L");
                    var dtd = ctd*vd;
                    var dtotal = concentrationCible*vd;
                    var dsup = dtotal - dtd;
                    print("Dose sup = $dsup mg");
                    setState(() {
                      dose = dsup.toStringAsPrecision(4);
                    });
                  },
                  child: const Text('Calculer'),
                ),
              ),
              Center(
                child: Visibility(visible: dose != null,child:  Text(
                  'Dose supplementaire = $dose mg',
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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