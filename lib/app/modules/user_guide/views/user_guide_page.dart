import 'package:flutter/material.dart';
import 'package:d_m/app/common/widgets/common_scaffold.dart';

class UserGuidePage extends StatelessWidget {
  const UserGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'User Guide',
      currentIndex: 3,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: disasterCategories.length,
          itemBuilder: (context, index) {
            String category = disasterCategories.keys.elementAt(index);
            IconData icon = disasterCategories[category]!;

            return Card(
              color: Colors.blue[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(icon, size: 28, color: Color(0xFF5F6898)),
                title: Text(
                  category,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5F6898),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisasterDetailPage(category: category),
                    ),
                  );
                },
                trailing: Icon(Icons.keyboard_arrow_right, color: Color(0xFF5F6898)),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DisasterDetailPage extends StatelessWidget {
  final String category;
  const DisasterDetailPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: category,
      currentIndex: 3,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To-Do List:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text('- Follow safety protocols'),
            Text('- Keep emergency kits ready'),
            SizedBox(height: 8),
            Text(
              "Don'ts:", // Fixed string literal
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text('- Do not panic'),
            Text('- Avoid misinformation'),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Open relevant resource link
              },
              child: Text('Learn More', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}

Map<String, IconData> disasterCategories = {
  'Earthquake': Icons.house,
  'Flood': Icons.water,
  'Cyclone': Icons.air,
  'Fire Safety': Icons.local_fire_department,
  'Tsunami': Icons.waves,
  'Landslide': Icons.terrain,
  'Pandemic': Icons.health_and_safety,
  'Industrial Accidents': Icons.factory,
  'Nuclear Disasters': Icons.volcano, // Updated icon name
};