import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:location/location.dart' hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart';

class RefugeeCampMap extends StatefulWidget {
  @override
  _RefugeeCampMapState createState() => _RefugeeCampMapState();
}

class _RefugeeCampMapState extends State<RefugeeCampMap> {
  GoogleMapController? _mapController;
  Location _location = Location();
  LatLng? _currentPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Dio _dio = Dio();

  final String _apiKey =
      "AIzaSyBsaQT5EqQO67yPEQsiwALAatFihQehIjU"; // Replace with your actual API key

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndFetchLocation();
  }

  /// **1️⃣ Check Location Permissions & Fetch User Location**
  Future<void> _checkPermissionsAndFetchLocation() async {
    PermissionStatus permission = await Permission.location.request();
    if (permission.isGranted) {
      _fetchUserLocation();
      _fetchCamps();
    } else {
      print("Location permission denied");
    }
  }

  /// **2️⃣ Fetch User Location & Move Camera**
  void _fetchUserLocation() async {
    var locationData = await _location.getLocation();
    _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('userLocation'),
          position: _currentPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'Your Location'),
        ),
      );
    });

    // Move camera to user's location
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition!, zoom: 14),
      ),
    );
  }

  /// **3️⃣ Fetch Refugee Camps from Firestore**
  void _fetchCamps() {
    FirebaseFirestore.instance.collection('refugee_camps').snapshots().listen((
      snapshot,
    ) {
      setState(() {
        _markers.removeWhere(
          (m) => m.markerId.value != 'userLocation',
        ); // Keep user marker only

        for (var camp in snapshot.docs) {
          var data = camp.data();
          if (data.containsKey('location')) {
            var location = data['location'];
            if (location is Map<String, dynamic> &&
                location.containsKey('latitude') &&
                location.containsKey('longitude')) {
              double? lat = (location['latitude'] as num?)?.toDouble();
              double? lng = (location['longitude'] as num?)?.toDouble();

              if (lat != null && lng != null) {
                LatLng campPosition = LatLng(lat, lng);
                _markers.add(
                  Marker(
                    markerId: MarkerId(camp.id),
                    position: campPosition,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                    infoWindow: InfoWindow(
                      title: data['name'] ?? 'Unknown Camp',
                      snippet: data['address'] ?? 'No Address',
                      onTap: () {
                        _fetchRoute(campPosition);
                      },
                    ),
                  ),
                );
              }
            }
          }
        }
      });
    });
  }

  /// **4️⃣ Fetch Route and Draw Polyline**
  Future<void> _fetchRoute(LatLng destination) async {
    if (_currentPosition == null) return;

    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_apiKey";

    try {
      Response response = await _dio.get(url);
      if (response.statusCode == 200 && response.data["routes"].isNotEmpty) {
        List<LatLng> polylinePoints = _decodePolyline(
          response.data["routes"][0]["overview_polyline"]["points"],
        );
        setState(() {
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: PolylineId("route"),
              points: polylinePoints,
              color: Colors.blue,
              width: 5,
            ),
          );
        });

        // Move camera to show route
        _mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(
            _getLatLngBounds(_currentPosition!, destination),
            100,
          ),
        );
      } else {
        print("No route found");
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
  }

  /// **5️⃣ Decode Polyline**
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int dlat = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int dlng = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  /// **6️⃣ Auto-Zoom to Fit Route**
  LatLngBounds _getLatLngBounds(LatLng point1, LatLng point2) {
    return LatLngBounds(
      southwest: LatLng(
        point1.latitude < point2.latitude ? point1.latitude : point2.latitude,
        point1.longitude < point2.longitude
            ? point1.longitude
            : point2.longitude,
      ),
      northeast: LatLng(
        point1.latitude > point2.latitude ? point1.latitude : point2.latitude,
        point1.longitude > point2.longitude
            ? point1.longitude
            : point2.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Refugee Camps")),
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: LatLng(20.5937, 78.9629), // Default India center
          zoom: 5,
        ),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
      ),
    );
  }
}
