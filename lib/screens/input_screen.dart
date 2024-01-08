import 'package:flutter/material.dart';
import 'package:rna/common_variables.dart';
import 'package:rna/widgets/input_manual.dart';

class InputScreen extends StatefulWidget {
  InputScreen({super.key});

  @override
  InputScreenState createState() => InputScreenState();
}

class InputScreenState extends State<InputScreen> {
  bool isManual = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Switch(value: isManual, onChanged: (bool val){
                  setState(() {
                    isManual = val;
                  });
                })),
                const Center(child: Text('Saisie de CL et Vd manuel?')),
                Container(constraints: BoxConstraints(maxHeight: 200),
                    child: isManual ? const InputManualWidget() : CommonVariables.drugWidget),
                Container(constraints: BoxConstraints(maxHeight: 400),
                    child: CommonVariables.serviceInputWidget),
                SizedBox(height: 60,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
