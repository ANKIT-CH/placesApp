import 'dart:convert';

import 'package:http/http.dart' as http;

const googleApiKey = 'API_KEY';

class LocationHelper {
  static String locationPreviewImage({double latitude, double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:L%7C$latitude,$longitude&key=$googleApiKey';
  }

  static Future<String> getLocationAddress(
      double latitude, double longitude) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleApiKey';
    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
