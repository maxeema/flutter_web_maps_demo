
import 'package:google_maps/google_maps.dart';

const position = [/*lat*/24.886, /*lng*/-70.268];
const zoom = 5;

extension ListLatLngExt on List<double> {
  toLatLng() => LatLng(first, last);
}

/// see https://developers.google.com/maps/documentation/javascript/examples/polygon-simple
polygon() {
  // Define the LatLng coordinates for the polygon's  outer path.
  final outerCoords = [
    LatLng(25.774, -80.19),
    LatLng(18.466, -66.118),
    LatLng(32.321, -64.757),
  ];
  // Define the LatLng coordinates for the polygon's inner path.
  // Note that the points forming the inner path are wound in the
  // opposite direction to those in the outer path, to form the hole.
  final innerCoords = [
    LatLng(28.745, -70.579),
    LatLng(29.57, -67.514),
    LatLng(27.339, -66.668),
  ];
  //
  return Polygon(
    PolygonOptions()
      ..paths = [outerCoords, innerCoords]
      ..strokeColor = "#FFC107"
      ..strokeOpacity = 0.8
      ..strokeWeight = 2
      ..fillColor = "#FFC107"
      ..fillOpacity = 0.35,
  );
}

Polygon? _polygon;
go(GMap map) {
  _polygon ??= polygon();
  map
    ..center = position.toLatLng()
    ..zoom = zoom;
  _polygon.map = map;
}

reset() => _polygon?.map = null;