import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

class RefugeeCampMap extends StatefulWidget {
  @override
  _RefugeeCampMapState createState() => _RefugeeCampMapState();
}

class _RefugeeCampMapState extends State<RefugeeCampMap> {
  GoogleMapController? _mapController;
  Location _location = Location();
  LatLng? _currentPosition;
  Set<Marker> _markers = {};
  bool _locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndFetch();
  }

  /// ✅ Step 1: Check location permissions and fetch location & camp data
  void _checkPermissionsAndFetch() async {
    perm.PermissionStatus status = await perm.Permission.location.request();
    if (status.isGranted) {
      setState(() {
        _locationPermissionGranted = true;
      });
      _fetchUserLocation();
      _fetchCamps();
    } else {
      print("❌ Location permission denied.");
    }
  }

  /// ✅ Step 2: Fetch user's current location
  void _fetchUserLocation() async {
    var locationData = await _location.getLocation();
    setState(() {
      _currentPosition = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
      _markers.add(
        Marker(
          markerId: MarkerId('userLocation'),
          position: _currentPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'Your Location'),
        ),
      );
      _moveCameraToUser();
    });
  }

  /// ✅ Step 3: Fetch refugee camps from Firestore
  void _fetchCamps() {
    FirebaseFirestore.instance
        .collection('refugee_camps')
        .snapshots()
        .listen(
          (snapshot) {
            if (snapshot.docs.isEmpty) {
              print("⚠️ No refugee camps found.");
            } else {
              Set<Marker> tempMarkers = {};

              for (var camp in snapshot.docs) {
                var data = camp.data();
                if (data.containsKey('location') &&
                    data['location'] is GeoPoint) {
                  GeoPoint geoPoint = data['location'];
                  LatLng campPosition = LatLng(
                    geoPoint.latitude,
                    geoPoint.longitude,
                  );

                  tempMarkers.add(
                    Marker(
                      markerId: MarkerId(data['name']),
                      position: campPosition,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                      infoWindow: InfoWindow(
                        title: data['name'],
                        snippet:
                            "Capacity: ${data['capacity']} | Resources: ${data['resources']}",
                      ),
                      onTap: () => _showRouteToCamp(campPosition),
                    ),
                  );
                }
              }

              setState(() {
                _markers = tempMarkers;
              });

              print("✅ Real-time camps updated: ${tempMarkers.length}");
            }
          },
          onError: (e) {
            print("❌ Firestore Error: $e");
          },
        );
  }

  /// ✅ Step 4: Move camera to user location after fetching
  void _moveCameraToUser() {
    if (_mapController != null && _currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 12.0),
      );
    }
  }

  /// ✅ Step 5: Show route to selected refugee camp (Polyline)
  void _showRouteToCamp(LatLng campPosition) {
    if (_currentPosition == null) return;

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('routeStart'),
          position: _currentPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(title: 'Starting Point'),
        ),
      );

      _markers.add(
        Marker(
          markerId: MarkerId('routeEnd'),
          position: campPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'Refugee Camp'),
        ),
      );
    });

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            _currentPosition!.latitude < campPosition.latitude
                ? _currentPosition!.latitude
                : campPosition.latitude,
            _currentPosition!.longitude < campPosition.longitude
                ? _currentPosition!.longitude
                : campPosition.longitude,
          ),
          northeast: LatLng(
            _currentPosition!.latitude > campPosition.latitude
                ? _currentPosition!.latitude
                : campPosition.latitude,
            _currentPosition!.longitude > campPosition.longitude
                ? _currentPosition!.longitude
                : campPosition.longitude,
          ),
        ),
        50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Refugee Camps")),
      body:
          _locationPermissionGranted
              ? GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(20.5937, 78.9629), // Default position (India)
                  zoom: 5,
                ),
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              )
              : Center(child: Text("Please grant location permissions.")),
    );
  }
}
