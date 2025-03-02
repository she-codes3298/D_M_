
import 'package:flutter/material.dart';
import 'package:d_m/app/common/widgets/common_scaffold.dart';

class RefugeeCampPage extends StatelessWidget {
  const RefugeeCampPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Refugee Camp',
      currentIndex: 1,
      body: Center(child: Text('Refugee Camp Information')),
    );
  }
}
