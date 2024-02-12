import 'package:flutter/material.dart';
import 'package:rna/common_variables.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    if(CommonVariables.service == null) {
      throw Exception("Service not set");
    }
    if(CommonVariables.userInput == null) {
      throw Exception("Input not set");
    }
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonVariables.service!.getGraphWidget(),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.05), borderRadius: const BorderRadius.all(Radius.circular(10.0))),
              child: CommonVariables.service!.getResultWidget()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonVariables.userInput!.getInputSummaryWidget(),
          ),
        ],
      ),
    );
  }
}
