
import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart' hide Icon;

import 'map_model.dart' as model;

void main() {
  runApp(MyApp());
  model.registerMap();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  GMap get map => model.mapInstance.value;

  @override
  void initState() {
    super.initState();
    model.mapInstance.addListener(updateState);
    model.mapTypeIdChangeNotifier.addListener(updateState);
  }
  @override
  void dispose() {
    model.mapInstance.removeListener(updateState);
    model.mapTypeIdChangeNotifier.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          HtmlElementView(
            viewType: model.html_id,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: map == null ? Container() : Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    color: Colors.deepOrangeAccent,
                    textColor: Colors.white,
                    onPressed: model.reset,
                    child: Text(
                      ' Reset ',
                    ),
                  ),
                  SizedBox(width: 16,),
                  RaisedButton(
                    onPressed: model.drawPolygon,
                    child: Text(
                      'Draw polygon',
                    ),
                  ),
                  SizedBox(width: 16),
                  RaisedButton(
                    onPressed: model.loadKml,
                    child: Text(
                      'Use kml',
                      key: ValueKey(model.mapType),
                    ),
                  ),
                  SizedBox(width: 16,),
                  FloatingActionButton.extended(
                    onPressed: model.switchMapType,
                    label: Row(
                      children: [
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            '${model.mapTypeName} ',
                            key: ValueKey(model.mapType),
                          ),
                        ),
                        SizedBox(width: 4,),
                        Icon(Icons.refresh),
                      ],
                    ),
                  ),
                ],
              ),
            )
          )
        ],
      )
    );
  }

}

extension on State<MyApp> {
  // ignore: invalid_use_of_protected_member
  updateState() => setState(() { });
}