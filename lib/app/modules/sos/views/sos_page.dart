import 'package:flutter/material.dart';
import 'package:d_m/app/common/widgets/common_scaffold.dart';

class SOSPage extends StatelessWidget {
  const SOSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'SOS',
      currentIndex: 2,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement SOS action
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFB01629), // 🔴 Red SOS Button
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          child: Text('Activate SOS'),
        ),
      ),
    );
  }
}
