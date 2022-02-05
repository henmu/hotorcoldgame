import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'question.dart';

void main() {
  //Making android status bar transparent.
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  // ));

  //Might help with quality of gradient background, but needs more testing.
  //Paint.enableDithering = true;

  runApp(const MyApp());
}

class City {
  final double lat;
  final double lon;

  const City({required this.lat, required this.lon});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}

class Temp {
  final double valueTemp;

  const Temp({required this.valueTemp});

  factory Temp.fromJson(Map<String, dynamic> json) {
    return Temp(
      valueTemp: json['main']['temp'],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'hotorcold',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Hotter or Colder Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _score = 0;

  List<String> _cityNames = [];
  late Future<City> futureCity1;
  late Future<City> futureCity2;
  late Future<Temp> futureCity1Temp;
  late Future<Temp> futureCity2Temp;

  List<String> getCityNames() {
    var cityList = [
      'Helsinki',
      'Stockholm',
      'Tokyo',
      'Singapore',
      'Paris',
      'Rome',
      'Moscow',
      'Madrid',
      'Ottawa',
      'Washington D.C',
      'Melbourne',
      'Luxembourg'
    ];

    cityList.shuffle();
    return cityList.take(2).toList();
  }

  Future<City> fetchCityLatLon(String cityName) async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=1&appid=34ac798907aa71668169374a2764f675'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Iterable l = jsonDecode(response.body);
      List<City> cities = List<City>.from(l.map((e) => City.fromJson(e)));
      return cities[0];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Temp> fetchCityTemp(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=34ac798907aa71668169374a2764f675'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Temp.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  //bool isHotter (double temp1, double temp2) => temp1>temp2;

  void _isHotter() async {
    var temp1 = (await futureCity1Temp).valueTemp;
    var temp2 = (await futureCity2Temp).valueTemp;

    print(temp1);
    print(temp2);

    setState(() {
      if (temp1 > temp2) {
        _score++;
      } else {
        _score = 0;
      }
      getCityTemps();
    });
  }

  void _isColder() async {
    var temp1 = (await futureCity1Temp).valueTemp;
    var temp2 = (await futureCity2Temp).valueTemp;

    setState(() {
      if (temp1 < temp2) {
        _score++;
      } else {
        _score = 0;
      }
      _cityNames = getCityNames();
    });
  }

  void getCityTemps() {
    _cityNames = getCityNames();
    futureCity1 = fetchCityLatLon(_cityNames[0]);
    futureCity2 = fetchCityLatLon(_cityNames[1]);
    futureCity1
        .then((value) => futureCity1Temp = fetchCityTemp(value.lat, value.lon));
    futureCity2
        .then((value) => futureCity2Temp = fetchCityTemp(value.lat, value.lon));
  }

  @override
  void initState() {
    super.initState();
    getCityTemps();
  }

  @override
  Widget build(BuildContext context) {
    /*
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    */

    //Answer button size
    // const Size koko = Size(150, 235);

    //Fullscreen enabling
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
        overlays: [SystemUiOverlay.bottom]);

    return Container(
      //Gradiant background color
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(1.0, 0.0),
          end: FractionalOffset(1.0, 1.0),
          colors: [
            Color(0xFF212121),
            Color(0xFF171717),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        primary: false,
        /* Disabled AppBar to see if can design more pleasing UI
      appBar: AppBar(
        title: Text(widget.title),
        //backgroundColor: Colors.white,
        toolbarHeight: 40,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF3366FF),
                Color(0xFF00CCFF),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      ),*/
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Score:  ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 37,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  Text(
                    '$_score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      fontSize: 50,
                    ),
                  ),
                ],
              ),
              Question(cityNames: _cityNames),
              // TopSection(
              //   score: _score,
              //   cityname1: _cityname1,
              //   cityname2: _cityname2,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(double.infinity,
                            235), // TODO: height should be % of screen?
                        // maximumSize: const Size(double.infinity, 1235),
                        // minimumSize: const Size(double.infinity, 235),
                        // padding: const EdgeInsets.only(top: 80, bottom: 80),
                        primary: const Color(0xFFDD3434),
                        onPrimary: Colors.black87,
                        textStyle: const TextStyle(fontSize: 50),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            bottomLeft: Radius.circular(35),
                          ),
                        ),
                      ),
                      //onPressed: _increaseScore,
                      onPressed: () => _isHotter(),
                      child: const Text(
                        'Hot',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 13.0),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(double.infinity,
                            235), // TODO: height should be % of screen?
                        primary: const Color(0xFF1F94DE),
                        onPrimary: Colors.black,
                        textStyle: const TextStyle(fontSize: 50),
                        shape: const RoundedRectangleBorder(
                          // borderRadius: BorderRadius.circular(50),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(35),
                            bottomRight: Radius.circular(35),
                          ),
                        ),
                      ),
                      onPressed: () => _isColder(),
                      child: const Text(
                        'Cold',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
