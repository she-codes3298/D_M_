import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final int currentIndex;

  const CommonScaffold({
    Key? key,
    required this.body,
    this.title = '',
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0D47A1); // Dark Blue

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(title),
        actions: [
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.pushNamed(context, '/profile');
              } else if (value == 'signout') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed Out')),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('Profile')),
              const PopupMenuItem(value: 'signout', child: Text('Sign Out')),
            ],
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/refugee_camp');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/sos');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/user_guide');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/call');
              break;
          }
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Refugee Camp'),
          BottomNavigationBarItem(
            icon: Icon(Icons.sos, size: 32, color: Color(0xFFB01629)), // 🔴 Bigger & Red SOS Button
            label: 'SOS',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'User Guide'),
          const BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Call'),
        ],
      ),
    );
  }
}
