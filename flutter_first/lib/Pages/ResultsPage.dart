import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart'; // Uncomment this line
import 'package:flutter_first/Pages/SearchPage.dart';

class ResultsPage extends StatelessWidget {
  final List items = SearchPage.myl;

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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                item['title'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              // Published Date
              Text('Published Date: ${item['publishdate']}'),
              SizedBox(height: 4),
              Text('Headline: ${item['headline']}'),
              SizedBox(height: 4),
              // Source
              Text('Source: ${item['docsource']}'),
              SizedBox(height: 4),
              Text('Number of Citations-: ${item['numcites']}'),
              // Headline (HTML)
              Html(data: item['headline']), // Render HTML here
              // Add a divider line
              Divider(),
            ],
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ResultsPage(),
  ));
}
