import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rna/common_variables.dart';
import 'package:rna/objects/user_input.dart';

abstract class Service {
  Widget getGraphWidget();

  Widget getResultWidget();
}

class Supplementary implements Service {
  int hours, minutes;
  double lastDose, targetConcentration;
  double perfusionTime = 1;

  Supplementary(this.hours, this.minutes, this.lastDose,
      this.targetConcentration);

  @override
  Widget getGraphWidget() {
    return SizedBox();
  }

  @override
  Widget getResultWidget() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              child: Text(
                'Dose: ${_calculateDose().toStringAsFixed(1)} mg',
                style: const TextStyle(fontSize: 24),
              )),
        ],
      ),
    );
  }

  double _calculateDose() {
    if (CommonVariables.userInput == null)
      throw Exception("User input does not exist");
    double clearance = CommonVariables.userInput!.getCL();
    double vd = CommonVariables.userInput!.getVd();
    var ke = clearance / vd;
    print("CL = $clearance L/h");
    print("Vd = $vd");
    print("ke = $ke");
    var time = minutes / 60 + hours; // time passed
    print(time);
    // concentration à la fin de la première perfusion
    var cti = (lastDose / (vd*perfusionTime)) / ke *
        (1 - exp(-ke * perfusionTime));
    print("Cti = $cti mg/L");
    // concentration à la fin de la première perfusion + temps passé
    var ctd = cti * exp(-ke * time);
    var remainingTargetConcentration = (targetConcentration -
        ctd * exp(-ke * perfusionTime));
    print("Ctd = $ctd mg/L");
    // drug intake per unit of time
    var a = (remainingTargetConcentration * ke /
        (1 - exp(-ke * perfusionTime)));
    return a * perfusionTime * vd;
  }
}

class Interrupted implements Service {
  @override
  UserInput userInput;

  Interrupted(this.userInput);

  @override
  Widget getGraphWidget() {
    // TODO: implement getGraphWidget
    throw UnimplementedError();
  }

  @override
  Widget getResultWidget() {
    // TODO: implement getResultWidget
    throw UnimplementedError();
  }
}

class Regimen implements Service {
  @override
  UserInput userInput;

  Regimen(this.userInput);

  @override
  Widget getGraphWidget() {
    // TODO: implement getGraphWidget
    throw UnimplementedError();
  }

  @override
  Widget getResultWidget() {
    // TODO: implement getResultWidget
    throw UnimplementedError();
  }
}
