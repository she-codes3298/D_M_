import 'package:flutter/material.dart';
import 'service/location_service.dart'; // Import the service

class PhoneNumberScreen extends StatefulWidget {
  @override
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _storeUserData() async {
    String phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty || phoneNumber.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid phone number")),
      );
      return;
    }

    await LocationService.requestLocationAndFCM(phoneNumber);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User data stored successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Phone Number")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Enter your phone number",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _storeUserData,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

