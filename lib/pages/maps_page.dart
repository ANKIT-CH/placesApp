import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MapsPage extends StatefulWidget {
  final PlaceLocation startLocation;
  final bool isSelectingLocation;
  MapsPage(
      {this.startLocation =
          const PlaceLocation(latitude: 37.442, longitude: -122.084),
      this.isSelectingLocation = false});

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  LatLng _selectedLocation;

  void _chooseLocation(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('opened MAP'),
        actions: <Widget>[
          if (widget.isSelectingLocation)
            IconButton(
              icon: Icon(
                Icons.check,
              ),
              onPressed: _selectedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_selectedLocation);
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.startLocation.latitude,
            widget.startLocation.longitude,
          ),
          zoom: 16,
        ),
        onTap: widget.isSelectingLocation ? _chooseLocation : null,
        markers: (_selectedLocation == null && widget.isSelectingLocation)
            ? null
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: _selectedLocation ??
                      LatLng(
                        widget.startLocation.latitude,
                        widget.startLocation.longitude,
                      ),
                ),
              },
      ),
    );
  }
}
