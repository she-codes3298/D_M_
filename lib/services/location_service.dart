import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Request Location, FCM Token, and Store User Data
  static Future<void> requestLocationAndFCM() async {
    try {
      print("📍 Requesting location permission...");
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        print("❌ Location permission denied");
        return;
      }

      print("📍 Getting current location...");
      Position position = await Geolocator.getCurrentPosition();
      String userCity = await getUserCity(position);

      print("📍 User is in: $userCity");

      print("📲 Requesting FCM token...");
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken != null) {
        print("✅ Got FCM Token: $fcmToken");
        print("📤 Storing user data in Firestore...");

        await FirebaseFirestore.instance.collection('users').add({
          'city': userCity,
          'fcmToken': fcmToken,
          'timestamp': FieldValue.serverTimestamp(),
        });

        print("✅ User data stored successfully!");

      } else {
        print("❌ Failed to get FCM Token.");
      }

    } catch (e) {
      print("❌ Error getting location and FCM token: $e");
    }
  }

  // Get city name from latitude and longitude
  static Future<String> getUserCity(Position position) async {
    try {
      print("🔍 Reverse geocoding to get city name...");
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
      );

      if (placemarks.isNotEmpty) {
        String city = placemarks.first.locality ?? "Unknown City";
        print("📍 City detected: $city");
        return city;
      } else {
        print("⚠️ No city found, using default.");
        return "UnknownCity";
      }
    } catch (e) {
      print("❌ Error getting city name: $e");
      return "UnknownCity";
    }
  }
}
