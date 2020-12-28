import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/place.dart';
import '../helper/database_helper.dart';
import '../helper/location_helper.dart';
// import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addPlace(
    String selectedTitle,
    File selectedImage,
    PlaceLocation selectedLocation,
  ) async {
    final readableAddress = await LocationHelper.getLocationAddress(
        selectedLocation.latitude, selectedLocation.longitude);

    final newLocation = PlaceLocation(
        latitude: selectedLocation.latitude,
        longitude: selectedLocation.longitude,
        address: readableAddress);

    final newPlace = Place(
      id: DateTime.now().toString(),
      image: selectedImage,
      title: selectedTitle,
      location: newLocation,
    );
    _items.add(newPlace);
    notifyListeners();
    DatabaseHelper.insert('Places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'latitude': newPlace.location.latitude,
      'longitude': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final placesList = await DatabaseHelper.fetchData('places');
    _items = placesList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              location: PlaceLocation(
                latitude: item['latitude'],
                longitude: item['longitude'],
                address: item['address'],
              ),
              image: File(item['image']),
            ))
        .toList();
  }

  notifyListeners();
}
