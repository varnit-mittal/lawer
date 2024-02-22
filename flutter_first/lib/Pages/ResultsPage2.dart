import 'package:flutter/material.dart';
import 'package:flutter_first/Pages/Document2.dart';
import 'package:flutter_first/Pages/OptionPage.dart';
import 'package:flutter_first/Pages/OtpPage.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_first/Pages/SearchPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_first/main.dart';
import 'package:flutter_first/Pages/Document.dart';

class ResultsPage2 extends StatelessWidget {
  final List items = OptionsPage.atae;
  static String responsed ="";

  // Function to handle item click
  void onItemClick(BuildContext context, dynamic item) async {

    String base=OpeningPage.baseUrl;
    final url =  OpeningPage.baseUrl+'getDocument/';
    final body = jsonEncode({'id': item["tid"]});

    final request = http.Request('GET', Uri.parse(url));
    request.headers['Content-Type'] = 'application/json';
    request.body = body;
    //
    // // Send the request and get the response.
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print(responseBody);
    responsed=responseBody;


    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Document2()),
    );



    // can navigate to another screen or perform any other action here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => onItemClick(context, item), // Call onItemClick function on tap
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    item['title'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  // Published Date
                  Row(
                    children: [
                      Text(
                        'Published Date:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(width: 4),
                      Text('${item['publishdate']}'),
                    ],
                  ),
                  SizedBox(height: 4),
                  // Headline (HTML)
                  HtmlWidget(
                    item['headline'],
                  ),
                  SizedBox(height: 4),
                  // Source
                  Row(
                    children: [
                      Text(
                        'Source:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(width: 4),
                      Text('${item['docsource']}'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Number of Citations-:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(width: 4),
                      Text('${item['numcites']}'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Divider(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ResultsPage2(),
  ));
}
