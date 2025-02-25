import 'package:flutter/material.dart';

class UserGuidePage extends StatelessWidget {
  const UserGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Guide')),
      body: const Center(
        child: Text('User Guide and instructions go here.'),
      ),
    );
  }
}
