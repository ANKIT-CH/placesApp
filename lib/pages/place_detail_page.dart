import 'package:chat_app/providers/great_places.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../pages/maps_page.dart';

class PlaceDetailsPage extends StatelessWidget {
  static const routeName = 'place-details';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final place = Provider.of<GreatPlaces>(context).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            place.location.address,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            child: Text('View on Map'),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => MapsPage(
                    startLocation: place.location,
                    isSelectingLocation: false,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
