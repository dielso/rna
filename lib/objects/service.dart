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
  double lastDose, targetDose;
  double perfusionTime = 1;

  Supplementary(this.hours, this.minutes, this.lastDose, this.targetDose);

  @override
  Widget getGraphWidget() {
    // TODO: implement getGraphWidget
    throw UnimplementedError();
  }

  @override
  Widget getResultWidget() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              child: Text(
            'Dose: ${_calculateDose().toString()} mg',
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
    print(ke);
    var time = minutes / 60 + hours;
    print(time);
    var cti = (exp(perfusionTime * ke) - 1) /
        exp(ke * perfusionTime) *
        (lastDose / vd) /
        ke;
    var ctd = cti * exp(-ke * time);
    print("Ctd = $ctd mg/L");
    return ((targetDose - ctd * exp(-ke * perfusionTime)) /
            (1 - exp(-ke * perfusionTime))) * ke * vd;
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
