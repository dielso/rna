import 'dart:math';

import 'package:flutter/material.dart';

abstract class UserInput {
  Widget getInputSummaryWidget();

  double getCL();

  double getVd();
}

class ManualInput implements UserInput {
  final double cl, vd;

  ManualInput(this.cl, this.vd);

  @override
  Widget getInputSummaryWidget() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(child: Text('Vd: $vd')),
          const SizedBox(
            width: 30,
          ),
          SizedBox(child: Text('CL: $cl')),
        ],
      ),
    );
  }

  @override
  double getCL() {
    return cl;
  }

  @override
  double getVd() {
    return vd;
  }
}

class VancomycinPatientInput implements UserInput {
  final double weight;
  final double sCr;
  final int pma;

  VancomycinPatientInput(this.weight, this.sCr, this.pma);

  @override
  Widget getInputSummaryWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Weight: $weight"),
        const SizedBox(
          width: 30,
        ),
        Text("sCr: $sCr"),
        const SizedBox(
          width: 30,
        ),
        Text("PMA: $pma"),
      ],
    );
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