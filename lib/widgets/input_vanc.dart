import 'package:flutter/material.dart';
import 'package:rna/common_variables.dart';
import 'package:rna/objects/user_input.dart';

class InputVancomycinWidget extends StatefulWidget {
  const InputVancomycinWidget({super.key});

  @override
  InputVancomycinWidgetState createState() => InputVancomycinWidgetState();
}

class InputVancomycinWidgetState extends State<InputVancomycinWidget> {
  double weight = 0.0;
  double sCr = 0.0;
  int pma = 0;


  @override
  Widget build(BuildContext context) {
    CommonVariables.userInput = VancomycinPatientInput(weight, sCr, pma);
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child:  Column(
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
                  weight = double.parse(value);
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
      ],
    );
  }
}
