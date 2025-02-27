import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final int currentIndex;
  final String profileImageUrl;

  static const IconData accountCircleOutlined =
  IconData(0xee35, fontFamily: 'MaterialIcons');

  const CommonScaffold({
    Key? key,
    required this.body,
    this.title = '',
    this.currentIndex = 0,
    this.profileImageUrl = 'https://via.placeholder.com/150',
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
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: ClipOval(
                child: Image.network(
                  profileImageUrl,
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(accountCircleOutlined, size: 32, color: Colors.black);
                  },
                ),
              ),
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
        selectedFontSize: 14,
        unselectedFontSize: 12,
        onTap: (index) {
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
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Refugee Camp',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8), // Makes the icon bigger
              decoration: BoxDecoration(
                color: Color(0xFFB01629),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.sos, color: Colors.white, size: 40), // Larger size
            ),
            label: 'SOS',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'User Guide',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Call',
          ),
        ],
      ),
    );
  }
}
