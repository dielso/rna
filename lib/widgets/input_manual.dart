import 'package:flutter/material.dart';
import 'package:rna/common_variables.dart';
import 'package:rna/objects/user_input.dart';

class InputManualWidget extends StatefulWidget {
  const InputManualWidget({super.key});

  @override
  InputManualWidgetState createState() => InputManualWidgetState();
}

class InputManualWidgetState extends State<InputManualWidget> {
  double gCL = 0.0;
  double gVd = 0.0;

  void _updateInput(){
    CommonVariables.userInput = ManualInput(gCL, gVd);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Variables PK',
            style: TextStyle(
                fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          TextField(
            decoration:
            const InputDecoration(labelText: 'CL (L/h)'),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              gCL = double.parse(value);
              print(gCL);
              _updateInput();
            },
          ),
          TextField(
            decoration:
            const InputDecoration(labelText: 'Vd (L)'),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              gVd = double.parse(value);
              _updateInput();
            },
          ),
        ],
      ),
    );
  }
}
