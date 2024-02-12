import 'package:flutter/material.dart';
import 'package:rna/common_variables.dart';
import 'package:rna/screens/result_screen.dart';
import 'package:rna/widgets/input_manual.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  InputScreenState createState() => InputScreenState();
}

class InputScreenState extends State<InputScreen> {
  bool isManual = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Text('Saisie de CL et Vd manuel?')),
                Center(
                    child: Switch(
                        value: isManual,
                        onChanged: (bool val) {
                          setState(() {
                            isManual = val;
                          });
                        })),
                const SizedBox(height: 10),
                isManual
                    ? const InputManualWidget()
                    : CommonVariables.drugWidget,
                CommonVariables.serviceInputWidget,
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(onPressed: () {
              _navigate(context);
            }, child: const Text("Calculer")),
          )
        ],
      ),
    );
  }
  void _navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResultScreen(),
      ),
    );
  }
}
