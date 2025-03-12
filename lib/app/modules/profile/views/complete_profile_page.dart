import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteProfilePage extends StatefulWidget {
  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final Color accentColor = const Color(0xFF5F6898);
  final Color backgroundColor = const Color(0xFFE3F2FD);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emergencyContactController = TextEditingController();
  final TextEditingController abhaIdController = TextEditingController();
  final TextEditingController medicalHistoryController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();

  String? selectedBloodGroup;
  List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

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
      emergencyContactController.text = prefs.getString('emergencyContact') ?? '';
      abhaIdController.text = prefs.getString('abhaId') ?? '';
      medicalHistoryController.text = prefs.getString('medicalHistory') ?? '';
      allergiesController.text = prefs.getString('allergies') ?? '';
      selectedBloodGroup = prefs.getString('bloodGroup') ?? null;
    });
  }

  Future<void> _saveProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('age', ageController.text);
    await prefs.setString('bloodGroup', selectedBloodGroup ?? '');
    await prefs.setString('emergencyContact', emergencyContactController.text);
    await prefs.setString('abhaId', abhaIdController.text);
    await prefs.setString('medicalHistory', medicalHistoryController.text);
    await prefs.setString('allergies', allergiesController.text);

    Navigator.pop(context, true); // Refresh Profile Page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Complete Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: accentColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField("Name", nameController),
            buildTextField("Age", ageController, keyboardType: TextInputType.number),
            buildDropdownField("Blood Group", bloodGroups, selectedBloodGroup, (value) {
              setState(() {
                selectedBloodGroup = value;
              });
            }),
            buildTextField("Emergency Contact", emergencyContactController, keyboardType: TextInputType.phone),
            buildTextField("ABHA ID", abhaIdController),
            SizedBox(height: 20),

            // Medical History Section
            Text("Medical History", style: sectionTitleStyle()),
            buildTextField("Previous Medical Conditions", medicalHistoryController, maxLines: 3),
            buildTextField("Allergies", allergiesController, maxLines: 2),

            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _saveProfileData,
                style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                child: Text('Save Profile', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            items: items.map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
            isExpanded: true,
          ),
        ),
      ),
    );
  }

  TextStyle sectionTitleStyle() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accentColor);
  }
}
