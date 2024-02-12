import 'package:flutter/material.dart';
import 'package:rna/common_variables.dart';
import 'package:rna/objects/service.dart';

class InputPerfusionWidget extends StatefulWidget {
  const InputPerfusionWidget({super.key});

  @override
  InputPerfusionWidgetState createState() =>
      InputPerfusionWidgetState();
}

class InputPerfusionWidgetState extends State<InputPerfusionWidget> {
  double targetConcentration = 0.0;
  double lastDose = 0.0;
  double lastChargingDose = 0.0;
  int hours = 0;
  int minutes = 0;
  int stopHours = 0;
  int stopMinutes = 0;

  void _updateService(){
    CommonVariables.service =
        Interrupted(hours, minutes, stopHours, stopMinutes, lastDose, lastChargingDose, targetConcentration);
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
              targetConcentration = double.parse(value);
              _updateService();
            },
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Dernière regimen de perfusion continue',
            style: TextStyle(
                fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          TextField(
            decoration: const InputDecoration(labelText: 'Dernière dose d\'attaque (mg)'),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              lastChargingDose = double.parse(value);
              _updateService();
            },
          ),
          const SizedBox(height: 8.0),
          TextField(
            decoration: const InputDecoration(labelText: 'Dernière dose continue (mg/h)'),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              lastDose = double.parse(value);
              _updateService();
            },
          ),
          const SizedBox(height: 8.0),
          const Text(
              'Combien de temps a duré la perfusion ? (sans compter la dose d\'attaque)'),
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
          const SizedBox(height: 32.0),
          const Text(
              'Combien de temps il y a passé depuis l\'arrêt de la perfusion?'),
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
                      stopHours = int.parse(value);
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
                      stopMinutes = int.parse(value);
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
