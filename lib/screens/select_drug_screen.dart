import 'package:flutter/material.dart';
import 'package:rna/common_variables.dart';
import 'package:rna/screens/input_screen.dart';
import 'package:rna/widgets/input_vanc.dart';

class SelectDrugScreen extends StatelessWidget {
  const SelectDrugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélectionner Médicament'),
        centerTitle: true,
      ),
      body: DrugSelectionList(),
    );
  }
}

class DrugSelectionList extends StatelessWidget {
  final List<DrugData> drugs = [
    DrugData('Vancomycine', Icons.vaccines_outlined, Colors.yellow.shade100, const InputVancomycinWidget()),
  ];

  DrugSelectionList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: drugs.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Container(
            width: 100,
            child: ElevatedButton(
              onPressed: () {
                CommonVariables.drugWidget = drugs[index].inputDrugWidget;
                _navigate(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: drugs[index].color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minimumSize: const Size(0,200),
                elevation: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    drugs[index].icon,
                    size: 40,
                  ),
                  Text(
                    drugs[index].name,
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InputScreen(),
      ),
    );
  }
}


class DrugData {
  final String name;
  final IconData icon;
  final Color color;
  final Widget inputDrugWidget;

  DrugData(this.name, this.icon, this.color, this.inputDrugWidget);
}