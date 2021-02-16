import 'dart:async';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:google_maps/google_maps.dart';
import 'package:universal_ui/universal_ui.dart';

const html_id = 'my_map';

// const kml = 'http://googlearchive.github.io/js-v2-samples/ggeoxml/cta.kml';
const kml = 'https://maxeema.github.io/arkroot/doc.kml';

final startPosition = LatLng(25.77427, -80.19366);
final startZoom = 11;
final polygonStep = 0.075;

final mapTypes = [ MapTypeId.TERRAIN, MapTypeId.ROADMAP, MapTypeId.SATELLITE, MapTypeId.HYBRID, ];
final mapTypeNames = {
  MapTypeId.HYBRID: "Hybrid",
  MapTypeId.TERRAIN: "Terrain",
  MapTypeId.SATELLITE: "Satellite",
  MapTypeId.ROADMAP: "Roadmap"
};

MapTypeId mapType = mapTypes.first;

final mapInstance = ValueNotifier<GMap>(null);
final mapTypeIdChangeNotifier = ChangeNotifier();

String get mapTypeName => mapTypeNames[mapType];

registerMap() {
  PlatformViewRegistryFix().registerViewFactory(html_id, (int viewId) {
    final mapOptions = MapOptions()
      ..center = startPosition
      ..zoom = startZoom
      ..mapTypeId = mapType;

    final elem = DivElement()
      ..id = html_id
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.border = 'none';

    final map = GMap(elem, mapOptions);

    Future(() {
      mapInstance.value = map;
    });

    return elem;
  });
}

void switchMapType() {
  if (mapTypes.last == mapType) {
    _switchMapType(mapTypes.first);
  } else {
    _switchMapType(mapTypes[mapTypes.indexOf(mapType)+1]);
  }
}
void _switchMapType(MapTypeId newValue) {
  mapType = newValue;
  mapInstance.value.mapTypeId = mapType;
  mapTypeIdChangeNotifier.notifyListeners();
}

KmlLayer _kmlLayer;
loadKml() {
  _kmlLayer ??= KmlLayer(KmlLayerOptions()
    ..preserveViewport = false
    ..suppressInfoWindows = true
    ..url = kml
  );
  _kmlLayer.map = mapInstance.value;
}

Polygon _polygon;
drawPolygon() {
  _polygon ??= Polygon(
    PolygonOptions()
      ..fillColor = "#00ff00"
      ..paths = [
        LatLng(startPosition.lat + polygonStep, startPosition.lng - polygonStep),
        LatLng(startPosition.lat + polygonStep, startPosition.lng + polygonStep),
        LatLng(startPosition.lat - polygonStep , startPosition.lng + polygonStep),
        LatLng(startPosition.lat - polygonStep, startPosition.lng - polygonStep),
      ]
  );
  _polygon.map = mapInstance.value;
}

reset() {
  mapInstance?.value?.center = startPosition;
  mapInstance?.value?.zoom = startZoom;
  _kmlLayer?.map = null;
  _polygon?.map = null;
  _switchMapType(mapTypes.first);
}
