import 'package:flutter/material.dart';
import 'package:d_m/app/common/widgets/common_scaffold.dart';

class PredictiveAIPage extends StatelessWidget {
  const PredictiveAIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Predictive AI',
      currentIndex: 0,
      body: const Center(child: Text('Predictive AI functionality goes here.')),
    );
  }
}
