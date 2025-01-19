import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapsPage extends StatefulWidget {

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  LatLng? _selectedDestination;
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      if (_currentLocation != null && _mapController != null) {
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
            target: _currentLocation!,
            zoom: 14.0,
          )),
        );
      }
    } catch (e) {
      print("Failed to get location: $e");
    }
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _markers.clear();
      _selectedDestination = position;
      _markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position: position,
          infoWindow: InfoWindow(title: 'Destination', snippet: '${position.latitude}, ${position.longitude}'),
        ),
      );
    });
  }

  void _confirmSelection() async {
    if (_selectedDestination != null && _currentLocation != null) {
      // Step 1: Prepare the location data
      final locationData = {
        'currentLocation': {
          'latitude': _currentLocation!.latitude,
          'longitude': _currentLocation!.longitude,
        },
        'destination': {
          'latitude': _selectedDestination!.latitude,
          'longitude': _selectedDestination!.longitude,
        },
        'estimatedArrival': '10 minutes',  // Replace this with actual ETA logic
      };

      // Step 2: Encode the data as a JSON string
      String jsonString = json.encode(locationData);

      // Step 3: Convert the JSON string to bytes (UTF-8 encoding)
      List<int> bytes = utf8.encode(jsonString);

      // Step 4: Convert the bytes to a Base64 string
      String base64String = base64Encode(bytes);

      // Step 5: Pass the data back to the previous screen
      Navigator.pop(context, {
        'base64String': base64String, // The actual Base64 encoded string
        'fileName': 'location',
        'fileType': 'location',
      });
    } else {
      // Show an error if no destination is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a destination on the map")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Destination'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _confirmSelection,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation ?? LatLng(37.7749, -122.4194),
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        onTap: _onMapTapped,
        markers: _markers,
      ),
    );
  }
}
