import 'package:flutter/material.dart';
import 'package:rna/common_variables.dart';
import 'package:rna/objects/service.dart';

class InputSupplementaryWidget extends StatefulWidget {
  const InputSupplementaryWidget({super.key});

  @override
  InputSupplementaryWidgetState createState() =>
      InputSupplementaryWidgetState();
}

class InputSupplementaryWidgetState extends State<InputSupplementaryWidget> {
  double targetDose = 0.0;
  double lastDose = 0.0;
  int hours = 0;
  int minutes = 0;

  void _updateService(){
    CommonVariables.service =
        Supplementary(hours, minutes, lastDose, targetDose);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Paramètres nouveau regimen',
            style: TextStyle(
                fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          TextField(
            decoration:
                const InputDecoration(labelText: 'Concentration cible (mg/L)'),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              targetDose = double.parse(value);
              _updateService();
            },
          ),
          const SizedBox(height: 8.0),
          TextField(
            decoration: const InputDecoration(labelText: 'Dernière dose (mg)'),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              lastDose = double.parse(value);
              _updateService();
            },
          ),
          const SizedBox(height: 32.0),
          const Text(
              'Combien de temps il y a passé depuis le fin de la perfusion?'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: SizedBox(
                  width: 100,
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Heures',),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      hours = int.parse(value);
                      _updateService();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 15,),
              Flexible(
                child: SizedBox(
                  width: 100,
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Minutes'),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      minutes = int.parse(value);
                      _updateService();
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
