import 'package:flutter/material.dart';
import 'package:rna/common_variables.dart';
import 'package:rna/screens/select_drug_screen.dart';
import 'package:rna/widgets/input_sup.dart';

class SelectServiceScreen extends StatelessWidget {
  const SelectServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélectionner Service'),
        centerTitle: true,
      ),
      body: ServiceSelectionList(),
    );
  }
}

class ServiceSelectionList extends StatelessWidget {
  final List<ServiceData> services = [
    ServiceData('Dosage Supplémentaire', Icons.local_hospital, Colors.yellow.shade100, const InputSupplementaryWidget()),
    ServiceData('Perfusion Interrompu', Icons.access_time, Colors.red.shade100, const InputSupplementaryWidget()),
    ServiceData('Schéma Posologique', Icons.assignment, Colors.orange.shade100, const InputSupplementaryWidget()),
  ];

  ServiceSelectionList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: services.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Align(
            alignment: Alignment.center,
            child: SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  CommonVariables.serviceInputWidget =  services[index].serviceWidget;
                  _navigate(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: services[index].color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minimumSize: const Size(0,200),
                  maximumSize: const Size(400,double.infinity),
                  elevation: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      services[index].icon,
                      size: 40,
                    ),
                    Text(
                      services[index].name,
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
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
        builder: (context) => const SelectDrugScreen(),
      ),
    );
  }
}

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceData selectedService;

  const ServiceDetailsScreen(this.selectedService, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedService.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selectedService.icon,
              size: 60,
              color: selectedService.color,
            ),
            const SizedBox(height: 20),
            Text(
              'Details for ${selectedService.name}',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceData {
  final String name;
  final IconData icon;
  final Color color;
  final Widget serviceWidget;

  ServiceData(this.name, this.icon, this.color, this.serviceWidget);
}