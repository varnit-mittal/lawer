import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_first/Pages/ResultsPage2.dart';
void main() {
  runApp(Document3());
}

class Document3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String htmlData = ResultsPage2.responsed;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('HTML to Flutter'),
        ),
        body: InteractiveViewer(
          transformationController: TransformationController(),
          minScale: 0.5,   // Set minimum zoom level
          maxScale: 4.0,   // Set maximum zoom level
          panEnabled: false,    // Optionally disable panning for smoother zoom
          scaleEnabled: true,   // Ensure scaling is enabled

          child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(left: 15.0),
                child: HtmlWidget(
                  htmlData,
                  textStyle: const TextStyle(fontSize: 8.0),
                ),
              )
          ),
        ),
      ),
    );
  }
}
