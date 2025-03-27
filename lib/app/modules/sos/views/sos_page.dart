import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class SOSPage extends StatefulWidget {
  const SOSPage({super.key});

  @override
  _SOSPageState createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  bool _isSending = false;

  // 🔹 Function to get user's current location
  Future<String> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return "${position.latitude}, ${position.longitude}";
    } catch (e) {
      return "Location not available";
    }
  }

  // 🔴 Function to send SOS alert to Firebase
  Future<void> _sendSOS() async {
    setState(() {
      _isSending = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? "Unknown User";
    String userName = user?.displayName ?? "Anonymous";
    String userPhone = user?.phoneNumber ?? "No Phone";
    String location = await _getUserLocation();
    String timestamp = DateTime.now().toString();

    await FirebaseFirestore.instance.collection('SOS_ALERTS').add({
      'userId': userId,
      'name': userName,
      'phone': userPhone,
      'location': location,
      'timestamp': timestamp,
      'status': 'pending',
    });

    setState(() {
      _isSending = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🚨 SOS Alert Sent! Help is on the way.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("SOS Emergency"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "🔴 Emergency SOS",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSending ? null : _sendSOS,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
              child:
                  _isSending
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        "SEND SOS",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
            ),
            const SizedBox(height: 20),
            const Text(
              "📡 Your SOS alert will be sent to the nearest rescue team.",
              style: TextStyle(fontSize: 14, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
