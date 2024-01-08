import 'package:flutter/material.dart';
import 'package:rna/common_variables.dart';
import 'package:rna/objects/service.dart';

class InputSupplementaryWidget extends StatefulWidget {
  const InputSupplementaryWidget({super.key});

  @override
  InputSupplementaryWidgetState createState() => InputSupplementaryWidgetState();
}

class InputSupplementaryWidgetState extends State<InputSupplementaryWidget> {
  double targetDose = 0.0;
  double lastDose = 0.0;
  int hours = 0;
  int minutes = 0;


  @override
  Widget build(BuildContext context) {
    CommonVariables.service = Supplementary(hours, minutes, lastDose, targetDose);
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(
                    labelText: 'Concentration cible (mg/L)'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  targetDose = double.parse(value);
                },
              ),
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
                  lastDose = double.parse(value);
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
                        hours = int.parse(value);
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
            ],
          ),
        ),
      ],
    );
  }
}
