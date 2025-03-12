import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteProfilePage extends StatefulWidget {
  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController emergencyContactController = TextEditingController();
  final TextEditingController abhaIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name') ?? '';
      ageController.text = prefs.getString('age') ?? '';
      bloodGroupController.text = prefs.getString('bloodGroup') ?? '';
      emergencyContactController.text = prefs.getString('emergencyContact') ?? '';
      abhaIdController.text = prefs.getString('abhaId') ?? '';
    });
  }

  Future<void> _saveProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('age', ageController.text);
    await prefs.setString('bloodGroup', bloodGroupController.text);
    await prefs.setString('emergencyContact', emergencyContactController.text);
    await prefs.setString('abhaId', abhaIdController.text);

    Navigator.pop(context, true); // Go back and refresh ProfilePage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complete Profile')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: ageController, decoration: InputDecoration(labelText: 'Age')),
            TextField(controller: bloodGroupController, decoration: InputDecoration(labelText: 'Blood Group')),
            TextField(controller: emergencyContactController, decoration: InputDecoration(labelText: 'Emergency Contact')),
            TextField(controller: abhaIdController, decoration: InputDecoration(labelText: 'ABHA ID')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfileData,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
