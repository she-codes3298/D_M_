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
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // TODO: Implement drawer or menu action
          },
        ),
        actions: [
          // Profile Icon with Popup Menu (includes sign out)
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              backgroundImage:
              NetworkImage('https://via.placeholder.com/150'),
            ),
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.pushNamed(context, '/profile');
              } else if (value == 'signout') {
                // Dummy sign-out action: show a SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed Out')),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'signout',
                child: Text('Sign Out'),
              ),
            ],
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          // Navigate using named routes based on the selected index.
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/refugee_camp');
              break;
            case 2:
              Navigator.pushNamed(context, '/sos');
              break;
            case 3:
              Navigator.pushNamed(context, '/user_guide');
              break;
            case 4:
              Navigator.pushNamed(context, '/call');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Refugee Camp',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sos),
            label: 'SOS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'User Guide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Call',
          ),
        ],
      ),
    );
  }
}
