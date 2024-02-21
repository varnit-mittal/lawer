import 'package:flutter/material.dart';


class OptionsPage extends StatefulWidget {
  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  List<String> options = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
    'Option 6',
    'Option 7',
    'Option 8',
    'Option 9',
    'Option 10',
    'Option 11',
  ];
  List<String> svgPaths = [
    '',
    '',
    // Add more SVG paths for each option
  ];

  List<bool> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    selectedOptions = List<bool>.filled(options.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Options'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.5 / 1,
        mainAxisSpacing: 20,
        children: List.generate(options.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedOptions[index] = !selectedOptions[index];
              });
            },
            child: Container(
              margin: EdgeInsets.all(8),
              width: 10,
              height: 20,
              decoration: BoxDecoration(
                color: selectedOptions[index]
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.grey.withOpacity(0),
                borderRadius: BorderRadius.circular(0),
                border: Border.all(
                  color: selectedOptions[index]
                      ? Colors.blue
                      : Colors.grey.withOpacity(0.7),
                  width: 2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Add your SVG icon here
                    SizedBox(
                      width: 24,
                      height: 24,
                      // child: CustomPaint(
                      //   painter: _MyPainter(svgPath: svgPaths[index]),
                      // ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      options[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: selectedOptions[index]
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: selectedOptions[index]
                            ? Colors.blue
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
      floatingActionButton: SizedBox(
        width: 100,
        height: 100,
        child: FloatingActionButton(
          onPressed: () {
            List<String> selected = [];
            for (int i = 0; i < options.length; i++) {
              if (selectedOptions[i]) {
                selected.add(options[i]);
              }
            }
            // Do something with the selected options, for example:
            print('Selected options: $selected');
          },
          backgroundColor: Colors.blue,
          splashColor: Colors.lightBlue,
          child: Icon(
            Icons.check,
            size: 36,
          ),
        ),
      ),
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: OptionsPage(),
  ));
}
