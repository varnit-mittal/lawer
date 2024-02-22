import 'package:flutter/material.dart';
import 'package:flutter_first/main.dart';
import 'package:flutter_first/Pages/ResultsPage2.dart';
import 'dart:convert';
import 'global.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class OptionsPage2 extends StatefulWidget {
  @override
  _OptionsPageState createState() => _OptionsPageState();
  static List atae=[];

}

class _OptionsPageState extends State<OptionsPage2> {

  List<String> options = [
    'Dowry',
    'Arson',
    'Corruption',
    'Kidnapping',
    'Murder',
    'Rape',
    'Smuggling',
    'Suicide',
    'Thievery',
    'Terrorism',
    'Tax Fraud',
    'Sextortion',
  ];
  List<String> svgPaths = [
    'lib/assets/Display_Dowry_value_dowry.svg',
    'lib/assets/Display_Arson_value_arson.svg',
    'lib/assets/Display_Corruption_value_corrupt.svg',
    'lib/assets/Display_Kidnapping_value_kidnap.svg',
    'lib/assets/Display_Murder_value_murder.svg',
    'lib/assets/Display_Rape_value_rape.svg',
    'lib/assets/Display_Smuggling_value_smug.svg',
    'lib/assets/Display_Suicide_value_suicide.svg',
    'lib/assets/Display_Thievery_value_theft.svg',
    'lib/assets/Display_Terrorism_value_terror.svg',
    'lib/assets/Display_Tax_Fraud_value_tax.svg',
    'lib/assets/Display_Sextortion_value_sextor.svg',

    // Add more SVG paths for each option
  ];

  final Map<String, String> customMap = {
    'Dowry': 'dowry',
    'Arson': 'arson',
    'Corruption': 'corrupt',
    'Kidnapping': 'kidnap',
    'Murder': 'murder',
    'Rape': 'rape',
    'Smuggling': 'smug',
    'Suicide': 'suicide',
    'Thievery': 'theft',
    'Terrorism': 'terror',
    'Tax Fraud': 'tax',
    'Sextortion': 'sextor',
  };

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
        childAspectRatio: 1 / 0.8,
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
                    ? getColorFromHex("#496ABF")
                    : Colors.grey.withOpacity(0),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: selectedOptions[index]
                      ? getColorFromHex("0E204E")
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
                      width: 84,
                      height: 84,
                      child:SvgPicture.asset(
                        svgPaths[index],
                        width: 1.2,
                        height:  0.8,
                        fit: BoxFit.cover,
                      ),
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
                            ? Colors.black
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
          onPressed: () async {
            List<String> selected = [];
            for (int i = 0; i < options.length; i++) {
              if (selectedOptions[i]) {
                selected.add(options[i]);
              }
            }

            final url = OpeningPage.baseUrl+'getLaws/';

            List<String> mylist=[];
            for(int i=0;i<selected.length;i++)
            {
              mylist.add(customMap[selected[i]]!);
            }

            final body = jsonEncode({'lawName': mylist});

            // // Create the HTTP request.
            final request = http.Request('GET', Uri.parse(url));
            request.headers['Content-Type'] = 'application/json';
            request.body = body;
            //
            // // Send the request and get the response.
            final response = await request.send();
            final responseBody = await response.stream.bytesToString();
            List myList= jsonDecode(responseBody);
            OptionsPage2.atae=myList;

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ResultsPage2()),
            );
            print(responseBody);

            // Do something with the selected options, for example:
            print('Selected options: $selected');
          },
          backgroundColor: getColorFromHex("0E204E"),
          splashColor: Colors.lightBlue,
          child: Icon(
            Icons.check,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

void main() {
  runApp(MaterialApp(
    home: OptionsPage2(),
  ));
}
