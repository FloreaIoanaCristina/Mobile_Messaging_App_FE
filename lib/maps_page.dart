import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  LatLng? _selectedDestination;

  // Initial location (optional, e.g., user's current location)
  final LatLng _initialLocation = LatLng(37.7749, -122.4194); // San Francisco coordinates (default)

  // Handle tap on map to select destination
  void _onMapTapped(LatLng position) {
    setState(() {
      _markers.clear(); // Clear any existing markers
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

  // Confirm the selected destination
  void _confirmSelection() {
    if (_selectedDestination != null) {
      print("Destination selected: ${_selectedDestination!.latitude}, ${_selectedDestination!.longitude}");
      // You can send this information or use it to calculate the route
      Navigator.pop(context, _selectedDestination);
    } else {
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
          target: _initialLocation,
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        onTap: _onMapTapped, // Detect taps on the map
        markers: _markers,
      ),
    );
  }
}