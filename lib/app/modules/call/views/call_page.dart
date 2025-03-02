import 'package:flutter/material.dart';
import 'package:d_m/app/common/widgets/common_scaffold.dart';

class CallPage extends StatelessWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Emergency Call',
      currentIndex: 4,
      body: Center(child: Text('Emergency Contact Numbers')),
    );
  }
}
