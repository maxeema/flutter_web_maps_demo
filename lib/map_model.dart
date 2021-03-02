import 'dart:async';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps/google_maps.dart';
import 'package:universal_ui/universal_ui.dart';
import 'bermuda.dart' as bermuda;

const html_id = 'my_map';

// const kml = 'https://developers.google.com/maps/documentation/javascript/examples/kml/westcampus.kml';
const kml = 'http://googlearchive.github.io/js-v2-samples/ggeoxml/cta.kml';
// const kml = 'https://maxeema.github.io/flutter_web_maps_demo/doc.kml';

final mapTypes = [ MapTypeId.TERRAIN, MapTypeId.ROADMAP, MapTypeId.SATELLITE, MapTypeId.HYBRID, ];
final mapTypeNames = {
  MapTypeId.HYBRID: "Hybrid",
  MapTypeId.TERRAIN: "Terrain",
  MapTypeId.SATELLITE: "Satellite",
  MapTypeId.ROADMAP: "Roadmap"
};

MapTypeId _type = mapTypes.first;
MapTypeId get type => _type;

GMap _map;
GMap get map => _map;

final _mapInstance = ValueNotifier<GMap>(null);
ValueListenable<GMap> get mapInstanceNotifier => _mapInstance;

final mapTypeIdChangeNotifier = ChangeNotifier();

String get mapTypeName => mapTypeNames[type];

initMap() {
  _map?.center = bermuda.position;
  _map?.zoom = bermuda.zoom;
}
registerMap() {
  PlatformViewRegistryFix().registerViewFactory(html_id, (int viewId) {
    final elem = DivElement()
      ..id = html_id
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.border = 'none';
    
    final mapOptions = MapOptions()
      ..mapTypeId = type;

    _map = GMap(elem, mapOptions);

    Future(() {
      _mapInstance.value = _map;
      initMap();
    });

    return elem;
  });
}

void switchMapType() {
  if (mapTypes.last == type) {
    _switchMapType(mapTypes.first);
  } else {
    _switchMapType(mapTypes[mapTypes.indexOf(type)+1]);
  }
}
void _switchMapType(MapTypeId newValue) {
  _type = newValue;
  map?.mapTypeId = type;
  mapTypeIdChangeNotifier.notifyListeners();
}

KmlLayer _kmlLayer;
loadKml(url) {
  _kmlLayer ??= KmlLayer(KmlLayerOptions()
    ..preserveViewport = false
    ..suppressInfoWindows = true
  );
  _kmlLayer.url = url?.trim();
  _kmlLayer.map = _map;
}

goBermuda() => bermuda.go(map);

reset() {
  initMap();
  _kmlLayer?.map = null;
  bermuda.reset();
  if (_map != null)
    _switchMapType(mapTypes.first);
}
