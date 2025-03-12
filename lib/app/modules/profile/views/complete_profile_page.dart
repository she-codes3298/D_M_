import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteProfilePage extends StatefulWidget {
  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emergencyNameController = TextEditingController();
  final TextEditingController emergencyContactController = TextEditingController();
  final TextEditingController abhaIdController = TextEditingController();

  final TextEditingController otherMedicalHistoryController = TextEditingController();
  final TextEditingController otherAllergiesController = TextEditingController();
  final TextEditingController otherMedicationsController = TextEditingController();
  final TextEditingController otherDisabilitiesController = TextEditingController();

  String? selectedBloodGroup;
  String? selectedEmergencyRelation;

  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  final List<String> emergencyRelations = ['Father', 'Mother', 'Sibling', 'Spouse', 'Friend', 'Other'];

  final List<String> medicalHistoryOptions = ['Diabetes', 'Hypertension', 'Asthma', 'Heart Disease', 'Other'];
  final List<String> allergiesOptions = ['Peanuts', 'Pollen', 'Dust', 'Gluten', 'Other'];
  final List<String> medicationsOptions = ['Insulin', 'Aspirin', 'Antibiotics', 'Other'];
  final List<String> disabilitiesOptions = ['Hearing Impairment', 'Vision Impairment', 'Other'];

  List<String> selectedMedicalHistory = [];
  List<String> selectedAllergies = [];
  List<String> selectedMedications = [];
  List<String> selectedDisabilities = [];

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
      emergencyNameController.text = prefs.getString('emergencyName') ?? '';
      emergencyContactController.text = prefs.getString('emergencyContact') ?? '';
      abhaIdController.text = prefs.getString('abhaId') ?? '';
      selectedBloodGroup = prefs.getString('bloodGroup');
      selectedEmergencyRelation = prefs.getString('emergencyRelation');

      selectedMedicalHistory = prefs.getStringList('medicalHistory') ?? [];
      selectedAllergies = prefs.getStringList('allergies') ?? [];
      selectedMedications = prefs.getStringList('medications') ?? [];
      selectedDisabilities = prefs.getStringList('disabilities') ?? [];
    });
  }

  Future<void> _saveProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (selectedMedicalHistory.contains('Other')) {
      selectedMedicalHistory.remove('Other');
      selectedMedicalHistory.add('Other: ${otherMedicalHistoryController.text}');
    }
    if (selectedAllergies.contains('Other')) {
      selectedAllergies.remove('Other');
      selectedAllergies.add('Other: ${otherAllergiesController.text}');
    }
    if (selectedMedications.contains('Other')) {
      selectedMedications.remove('Other');
      selectedMedications.add('Other: ${otherMedicationsController.text}');
    }
    if (selectedDisabilities.contains('Other')) {
      selectedDisabilities.remove('Other');
      selectedDisabilities.add('Other: ${otherDisabilitiesController.text}');
    }

    await prefs.setString('name', nameController.text);
    await prefs.setString('age', ageController.text);
    await prefs.setString('bloodGroup', selectedBloodGroup ?? '');
    await prefs.setString('emergencyName', emergencyNameController.text);
    await prefs.setString('emergencyContact', emergencyContactController.text);
    await prefs.setString('emergencyRelation', selectedEmergencyRelation ?? '');
    await prefs.setString('abhaId', abhaIdController.text);

    await prefs.setStringList('medicalHistory', selectedMedicalHistory);
    await prefs.setStringList('allergies', selectedAllergies);
    await prefs.setStringList('medications', selectedMedications);
    await prefs.setStringList('disabilities', selectedDisabilities);

    Navigator.pop(context, true);
  }

  Widget buildMultiSelectField(String label, List<String> items, List<String> selectedValues, TextEditingController otherController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MultiSelectDialogField(
          title: Text(label),
          buttonText: Text("Select $label"),
          items: items.map((e) => MultiSelectItem<String>(e, e)).toList(),
          initialValue: selectedValues,
          onConfirm: (values) {
            setState(() {
              selectedValues.clear();
              selectedValues.addAll(values);
            });
          },
        ),
        if (selectedValues.contains('Other')) buildTextField("Specify Other $label", otherController),
        SizedBox(height: 12),
      ],
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complete Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField("Name", nameController),
            buildTextField("Age", ageController),
            buildMultiSelectField("Medical History", medicalHistoryOptions, selectedMedicalHistory, otherMedicalHistoryController),
            buildMultiSelectField("Allergies", allergiesOptions, selectedAllergies, otherAllergiesController),
            buildMultiSelectField("Medications", medicationsOptions, selectedMedications, otherMedicationsController),
            buildMultiSelectField("Disabilities", disabilitiesOptions, selectedDisabilities, otherDisabilitiesController),
            ElevatedButton(onPressed: _saveProfileData, child: Text('Save Profile')),
          ],
        ),
      ),
    );
  }
}
