import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../helper/location_helper.dart';
import '../pages/maps_page.dart';

class LocationInput extends StatefulWidget {
  final Function selectLocation;
  LocationInput(this.selectLocation);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await Location().getLocation();
      final imageMapUrl = LocationHelper.locationPreviewImage(
        latitude: locationData.latitude,
        longitude: locationData.longitude,
      );
      print(locationData.latitude);
      print(locationData.longitude);

      setState(() {
        _previewImageUrl = imageMapUrl;
      });

      widget.selectLocation(locationData.latitude, locationData.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapsPage(
          isSelectingLocation: true,
        ),
      ),
    );
    if (selectedLocation == null) return;

    final imageMapUrl = LocationHelper.locationPreviewImage(
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
    );
    print(selectedLocation.latitude);
    print(selectedLocation.longitude);

    setState(() {
      _previewImageUrl = imageMapUrl;
    });

    widget.selectLocation(
        selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 200,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.black,
            ),
          ),
          child: _previewImageUrl == null
              ? Text(
                  'choose a location first',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('current location'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentLocation,
            ),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text('select from map'),
              textColor: Theme.of(context).primaryColor,
              onPressed: selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
