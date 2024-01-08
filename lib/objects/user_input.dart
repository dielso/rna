import 'dart:math';

import 'package:flutter/material.dart';

abstract class UserInput {
  Widget getInputSummaryWidget();

  double getCL();

  double getVd();
}

class ManualInput implements UserInput {
  final double CL, Vd;

  ManualInput(this.CL, this.Vd);

  @override
  Widget getInputSummaryWidget() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(child: Text('Vd: ${CL.toString()})')),
          const SizedBox(
            width: 30,
          ),
          SizedBox(child: Text('CL: ${Vd.toString()}')),
        ],
      ),
    );
  }

  @override
  double getCL() {
    return CL;
  }

  @override
  double getVd() {
    return Vd;
  }
}

class VancomycinPatientInput implements UserInput {
  final double weight;
  final double sCr;
  final int pma;

  VancomycinPatientInput(this.weight, this.sCr, this.pma);

  @override
  Widget getInputSummaryWidget() {
    // TODO: implement getInputSummaryWidget
    throw UnimplementedError();
  }

  @override
  double getCL() {
    var t50h = pow(46.4, 3.54);
    var pmah = pow(pma, 3.54);
    return 0.273 *
        pow(weight, 0.438) *
        pow((54 / sCr), 0.473) *
        pmah /
        (pmah + t50h);
  }

  @override
  double getVd() {
    return 0.628 * weight;
  }
}