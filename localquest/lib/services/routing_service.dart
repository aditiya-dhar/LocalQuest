import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RoutingService {
  Future<List<LatLng>> getRoute(
      double startLat, double startLng, double endLat, double endLng) async {
    final url = "https://router.project-osrm.org/route/v1/walking/"
        "$startLng,$startLat;$endLng,$endLat"
        "?overview=full&geometries=geojson";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body);
    final routes = data["routes"];
    if (routes == null || routes.isEmpty) return [];

    final coords = routes[0]["geometry"]["coordinates"];
    if (coords == null) return [];

    return coords.map<LatLng>((c) => LatLng(c[1], c[0])).toList();
  }
}
