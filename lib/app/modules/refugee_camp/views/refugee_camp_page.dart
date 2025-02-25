import 'package:flutter/material.dart';

class RefugeeCampPage extends StatelessWidget {
  const RefugeeCampPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Refugee Camp')),
      body: const Center(
        child: Text('Information about Refugee Camp locations.'),
      ),
    );
  }
}
