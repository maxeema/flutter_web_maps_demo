// @dart=2.9
// Use dart 2.9 for mix code when our project support Dart null safety
//  but dependencies like 'google_maps' and 'universal_ui' haven't migrated to null safety yet

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  final textController = TextEditingController(text: model.kml);

  @override
  void initState() {
    super.initState();
    model.mapInstanceNotifier.addListener(updateState);
    model.mapTypeIdChangeNotifier.addListener(updateState);
  }
  @override
  void dispose() {
    model.mapInstanceNotifier.removeListener(updateState);
    model.mapTypeIdChangeNotifier.removeListener(updateState);
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
            onPressed: model.switchMapType,
            label: Row(
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    '${model.mapTypeName} ',
                    key: ValueKey(model.type),
                  ),
                ),
                SizedBox(width: 4,),
                Icon(Icons.refresh),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        body: Stack(
          children: [
            HtmlElementView(
              viewType: model.html_id,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: model.map == null ? Container() : Container(
                padding: EdgeInsets.all(16),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 64),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            color: Colors.deepOrangeAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              model.reset();
                              textController.text = model.kml;
                            },
                            child: Text(
                              ' Reset ',
                            ),
                          ),
                          SizedBox(width: 16,),
                          RaisedButton(
                            color: Colors.green,
                            textColor: Colors.white,
                            onPressed: model.goBermuda,
                            child: Text(
                              'Bermuda',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16,),
                      //
                      IntrinsicHeight(
                        child: FractionallySizedBox(
                          widthFactor: .7,
                          child: Material(
                            color: Colors.white70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                RaisedButton(
                                  color: Colors.transparent,
                                  textColor: Colors.black,
                                  onPressed: () => model.loadKml(textController.text),
                                  child: Text(
                                    'Go',
                                    key: ValueKey(model.type),
                                  ),
                                ),
                                SizedBox(width: 16,),
                                Flexible(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 500),
                                    child: TextField(
                                      controller: textController,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }

}

extension on State<MyApp> {
  // ignore: invalid_use_of_protected_member
  updateState() => setState(() { });
}