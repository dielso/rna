import 'package:flutter/material.dart';
import 'package:rna/common_variables.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({super.key});

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
      body: ListView(
        children: [
          CommonVariables.service!.getGraphWidget(),
          CommonVariables.service!.getResultWidget(),
          CommonVariables.userInput!.getInputSummaryWidget(),

        ],
      ),
    );
  }
}
