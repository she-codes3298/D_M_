import 'package:flutter/material.dart';

class CommunityHistoryPage extends StatelessWidget {
  const CommunityHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community History')),
      body: const Center(
        child: Text('Previous community posts and history go here.'),
      ),
    );
  }
}
