import 'package:flutter/material.dart';

class SOSPage extends StatelessWidget {
  const SOSPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SOS')),
      body: const Center(
        child: Text('SOS emergency services page.'),
      ),
    );
  }
}
