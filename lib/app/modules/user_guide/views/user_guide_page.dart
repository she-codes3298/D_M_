import 'package:flutter/material.dart';
import 'package:d_m/app/common/widgets/common_scaffold.dart';

class UserGuidePage extends StatelessWidget {
  const UserGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'User Guide',
      currentIndex: 3,
      body: Center(child: Text('User Guide Content')),
    );
  }
}
