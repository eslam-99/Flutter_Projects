import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/search_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/weather_bloc.dart';
import 'package:weather_app/weather_rebo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[900],
        body: BlocProvider(
          create: (context) {
            return WeatherBloc(WeatherRebo());
          },
          child: SearchPage(),
        ),
      ),
    );
  }
}
