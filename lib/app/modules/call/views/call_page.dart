import 'package:flutter/material.dart';

class CallPage extends StatelessWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Call')),
      body: const Center(
        child: Text('Direct call functionality goes here.'),
      ),
    );
  }
}
