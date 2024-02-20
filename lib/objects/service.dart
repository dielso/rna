import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rna/common_variables.dart';
import 'package:rna/objects/user_input.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

abstract class Service {
  Widget getGraphWidget();

  Widget getResultWidget();
}

class Supplementary implements Service {
  int hours, minutes;
  double lastDose, targetConcentration;
  double perfusionTime = 1;

  Supplementary(
      this.hours, this.minutes, this.lastDose, this.targetConcentration);

  @override
  Widget getGraphWidget() {
    if (CommonVariables.userInput == null) {
      throw Exception("User input does not exist");
    }
    List<(double, double)> concentrationGraph = <(double, double)>[];
    List<(double, double)> secondConcentrationGraph = <(double, double)>[];
    List<(double, double)> thirdConcentrationGraph = <(double, double)>[];
    double concentration = 0;
    double dose = _calculateDose();
    double vd = CommonVariables.userInput!.getVd();
    double cl = CommonVariables.userInput!.getCL();
    double ke = cl / vd;
    double a = lastDose /
        (perfusionTime * 60 * vd); // concentration entrant pour minute
    int t = (perfusionTime * 60) as int; // temps total de section
    var exponent = exp(-ke * 1 / 60);
    for (int i = 0; i < t; i++) {
      concentration += a;
      concentration *= exponent; // divise par 60 pq ke est calculee par heure
      concentrationGraph.add((i / 60, concentration));
    }
    int lastT = t;
    t += 60 * hours + minutes;
    for (int i = lastT; i < (t); i++) {
      concentration *= exponent;
      concentrationGraph.add((i / 60, concentration));
    }
    a = dose / (perfusionTime * 60 * vd);
    lastT = t;
    t += (perfusionTime * 60) as int;
    for (int i = lastT; i < (t); i++) {
      concentration += a;
      concentration *= exponent; // divise par 60 pq ke est calculee par heure
      secondConcentrationGraph.add((i / 60, concentration));
    }
    lastT = t;
    t += 6 * 60;
    for (int i = lastT; i < (t); i++) {
      concentration *= exponent;
      thirdConcentrationGraph.add((i / 60, concentration));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfCartesianChart(
          // Initialize category axis
          title: const ChartTitle(text: "Evolution de la concentration"),
          primaryYAxis: const NumericAxis(
            isVisible: true,
            title: AxisTitle(text: "Vancomycine sérique (mg/L)"),
          ),
          primaryXAxis: const NumericAxis(
              isVisible: true,
              title: AxisTitle(text: "Temps depuis la première dose (h)")),
          legend: const Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap),
          series: <LineSeries<(double, double), double>>[
            LineSeries<(double, double), double>(
              // Bind data source
              dataSource: concentrationGraph,
              xValueMapper: ((double, double) entry, _) => entry.$1,
              yValueMapper: ((double, double) entry, _) => entry.$2,
              name: "Cycle première dose",
            ),
            LineSeries<(double, double), double>(
              // Bind data source
              dataSource: secondConcentrationGraph,
              xValueMapper: ((double, double) entry, _) => entry.$1,
              yValueMapper: ((double, double) entry, _) => entry.$2,
              name: "Perfusion deuxième dose",
              color: Colors.red,
            ),
            LineSeries<(double, double), double>(
              // Bind data source
              dataSource: thirdConcentrationGraph,
              xValueMapper: ((double, double) entry, _) => entry.$1,
              yValueMapper: ((double, double) entry, _) => entry.$2,
              name: "Excrétion deuxième dose",
              color: Colors.green,
            ),
          ]),
    );
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
    if (CommonVariables.userInput == null) {
      throw Exception("User input does not exist");
    }
    double clearance = CommonVariables.userInput!.getCL();
    double vd = CommonVariables.userInput!.getVd();
    var ke = clearance / vd;
    print("CL = $clearance L/h");
    print("Vd = $vd");
    print("ke = $ke");
    var time = minutes / 60 + hours; // time passed
    print(time);
    // concentration à la fin de la première perfusion
    var cti =
        (lastDose / (vd * perfusionTime)) / ke * (1 - exp(-ke * perfusionTime));
    print("Cti = $cti mg/L");
    // concentration à la fin de la première perfusion + temps passé
    var ctd = cti * exp(-ke * time);
    var remainingTargetConcentration =
        (targetConcentration - ctd * exp(-ke * perfusionTime));
    print("Ctd = $ctd mg/L");
    // drug intake per unit of time
    var a =
        (remainingTargetConcentration * ke / (1 - exp(-ke * perfusionTime)));
    return a * perfusionTime * vd;
  }
}

class Interrupted implements Service {
  int lastHours, lastMinutes;
  int stopHours, stopMinutes;
  double lastDose, lastChargingDose, targetConcentration;
  double perfusionTime = 1.0;

  Interrupted(
      this.lastHours,
      this.lastMinutes,
      this.stopHours,
      this.stopMinutes,
      this.lastDose,
      this.lastChargingDose,
      this.targetConcentration);

  @override
  Widget getGraphWidget() {
    if (CommonVariables.userInput == null) {
      throw Exception("User input does not exist");
    }
    List<(double, double)> doseDeChargeGraph = <(double, double)>[];
    List<(double, double)> concentrationGraph = <(double, double)>[];
    List<(double, double)> perfusionStopGraph = <(double, double)>[];
    List<(double, double)> secondConcentrationGraph = <(double, double)>[];
    List<(double, double)> thirdConcentrationGraph = <(double, double)>[];
    double concentration = 0;
    var doses = _calculateDose();
    double perfusionLastTime = lastMinutes / 60 + lastHours;
    double vd = CommonVariables.userInput!.getVd();
    double cl = CommonVariables.userInput!.getCL();
    double ke = cl / vd;

    // PERFUSION DOSE DE CHARGE

    double a = lastChargingDose /
        (perfusionTime * 60 * vd); // concentration entrant pour minute
    int t = (perfusionTime * 60) as int; // temps total de section
    var exponent = exp(-ke * 1 / 60);
    for (int i = 0; i < t; i++) {
      concentration += a;
      concentration *= exponent; // divise par 60 pq ke est calculee par heure
      doseDeChargeGraph.add((i / 60, concentration));
    }

    // PERFUSION DOSE REGIME PERMANENT ANTERIEUR

    concentrationGraph.add(doseDeChargeGraph.last);
    a = lastDose / (60 * vd); // concentration entrant pour minute
    int lastT = t;
    t += (perfusionLastTime * 60) as int; // temps total de section
    for (int i = lastT; i < t; i++) {
      concentration += a;
      concentration *= exponent; // divise par 60 pq ke est calculee par heure
      concentrationGraph.add((i / 60, concentration));
    }

    // EXCRETION - ARRETE DE LA PERFUSION

    perfusionStopGraph.add(concentrationGraph.last);
    lastT = t;
    t += 60 * stopHours + stopMinutes;
    for (int i = lastT; i < (t); i++) {
      concentration *= exponent;
      perfusionStopGraph.add((i / 60, concentration));
    }

    // NOUVEAU DOSE DE CHARGE

    secondConcentrationGraph.add(perfusionStopGraph.last);
    a = doses.$1 / (perfusionTime * 60 * vd);
    lastT = t;
    t += (perfusionTime * 60) as int;
    for (int i = lastT; i < (t); i++) {
      concentration += a;
      concentration *= exponent; // divise par 60 pq ke est calculee par heure
      secondConcentrationGraph.add((i / 60, concentration));
    }

    // NOUVEAU PERFUSION STEADY STATE

    thirdConcentrationGraph.add(secondConcentrationGraph.last);
    lastT = t;
    t += 2 * 60;
    a = doses.$2 / (60 * vd); // dose steady state
    for (int i = lastT; i < (t); i++) {
      concentration += a;
      concentration *= exponent;
      thirdConcentrationGraph.add((i / 60, concentration));
    }

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.9);
    stops.add(1.0);
    LinearGradient getColorGradient(Color color){
      var colors = <Color>[];
      colors.add(color.withOpacity(0));
      colors.add(color.withOpacity(0.6));
      colors.add(color);
      return LinearGradient(colors: colors, stops: stops,begin: Alignment.bottomCenter, end:  Alignment.topCenter);
    }


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfCartesianChart(
        trackballBehavior: TrackballBehavior(enable: true),
          // Initialize category axis
          title: const ChartTitle(
              text: "Evolution de la concentration",
              textStyle: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 24)),
          primaryYAxis: const NumericAxis(
            isVisible: true,
            title: AxisTitle(text: "Vancomycine sérique (mg/L)"),
          ),
          primaryXAxis: const NumericAxis(
              isVisible: true,
              title: AxisTitle(text: "Temps depuis la première dose (h)")),
          legend: const Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap),
          series: <AreaSeries<(double, double), double>>[
            AreaSeries<(double, double), double>(
              // Bind data source
              dataSource: doseDeChargeGraph,
              xValueMapper: ((double, double) entry, _) => entry.$1,
              yValueMapper: ((double, double) entry, _) => entry.$2,
              name: "Première dose d'attaque",
              gradient: getColorGradient(Colors.blueGrey),
              borderColor: Colors.blueGrey,
            ),
            AreaSeries<(double, double), double>(
              // Bind data source
              dataSource: concentrationGraph,
              xValueMapper: ((double, double) entry, _) => entry.$1,
              yValueMapper: ((double, double) entry, _) => entry.$2,
              name: "Première dose continue",
              gradient: getColorGradient(Colors.orange),
              borderColor: Colors.orange,
            ),
            AreaSeries<(double, double), double>(
              // Bind data source
              dataSource: perfusionStopGraph,
              xValueMapper: ((double, double) entry, _) => entry.$1,
              yValueMapper: ((double, double) entry, _) => entry.$2,
              name: "Perfusion arrêté",
              gradient: getColorGradient(Colors.red),
              borderColor: Colors.red,
            ),
            AreaSeries<(double, double), double>(
              // Bind data source
              dataSource: secondConcentrationGraph,
              xValueMapper: ((double, double) entry, _) => entry.$1,
              yValueMapper: ((double, double) entry, _) => entry.$2,
              name: "Nouveau dose d'attaque",
              gradient: getColorGradient(Colors.lightGreen),
              borderColor: Colors.lightGreen,
            ),
            AreaSeries<(double, double), double>(
              // Bind data source
              dataSource: thirdConcentrationGraph,
              xValueMapper: ((double, double) entry, _) => entry.$1,
              yValueMapper: ((double, double) entry, _) => entry.$2,
              name: "Nouveau dose continue",
              gradient: getColorGradient(Colors.brown),
              borderColor: Colors.brown,
            ),
          ]),
    );
  }

  (double, double) _calculateDose() {
    if (CommonVariables.userInput == null) {
      throw Exception("User input does not exist");
    }
    double clearance = CommonVariables.userInput!.getCL();
    double vd = CommonVariables.userInput!.getVd();
    var ke = clearance / vd;
    print("CL = $clearance L/h");
    print("Vd = $vd");
    print("ke = $ke");
    var time = stopMinutes / 60 + stopHours; // time passed
    print(time);
    // concentration à la fin de la dose de charge
    var cto = (lastChargingDose / (vd * perfusionTime)) /
        ke *
        (1 - exp(-ke * perfusionTime));
    print("Cto = $cto mg/L");
    // concentration à la fin
    double perfusionLastTime = lastMinutes / 60 + lastHours;
    // vd * 1 pq lastDose est compté par heure
    var cti = (lastDose / (vd * 1)) / ke * (1 - exp(-ke * perfusionLastTime)) +
        cto * exp(-ke * perfusionLastTime);
    print("Cti = $cti mg/L");
    // concentration à la fin du première cycle + temps passé
    var ctd = cti * exp(-ke * time);
    var remainingTargetConcentration =
        (targetConcentration - ctd * exp(-ke * perfusionTime));
    print("Ctd = $ctd mg/L");
    // drug intake per unit of time
    var a =
        (remainingTargetConcentration * ke / (1 - exp(-ke * perfusionTime)));
    double doseStable = targetConcentration * clearance;
    return (a * perfusionTime * vd, doseStable);
  }

  @override
  Widget getResultWidget() {
    var doses = _calculateDose();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              child: Text(
            'Dose d\'attaque: ${doses.$1.toStringAsFixed(1)} mg',
            style: const TextStyle(fontSize: 24),
          )),
          SizedBox(
              child: Text(
            'Dose continue: ${doses.$2.toStringAsFixed(1)} mg',
            style: const TextStyle(fontSize: 24),
          )),
        ],
      ),
    );
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
