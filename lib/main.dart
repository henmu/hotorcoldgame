import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotorcoldgame/score.dart';
import 'package:http/http.dart' as http;

import 'question.dart';
import 'answerButtons.dart';
import 'score.dart';
import 'temp.dart';
import 'city.dart';

void main() {
  //Might help with quality of gradient background, but needs more testing.
  //Paint.enableDithering = true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'hotorcold',
      home: HotOrCold(title: 'Hotter or Colder Game'),
    );
  }
}

class HotOrCold extends StatefulWidget {
  const HotOrCold({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HotOrCold> createState() => _HotOrColdState();
}

class _HotOrColdState extends State<HotOrCold> {
  int _score = 0;
  List<String> _cityNames = [];
  late Future<City> futureCity1;
  late Future<City> futureCity2;
  late Future<Temp> futureCity1Temp;
  late Future<Temp> futureCity2Temp;

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

  void isHotter() async {
    var temp1 = (await futureCity1Temp).valueTemp;
    var temp2 = (await futureCity2Temp).valueTemp;

    setState(() {
      if (temp1 > temp2) {
        _score++;
      } else {
        _score = 0;
      }
      getCityTemps();
    });
  }

  void isColder() async {
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
    //Make the app fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
        overlays: [SystemUiOverlay.bottom]);

    //Container is for making gradient bg color.
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
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Score(score: _score),
              Question(cityNames: _cityNames),
              AnswerButtons(isHotter: isHotter, isColder: isColder),
            ],
          ),
        ),
      ),
    );
  }
}
