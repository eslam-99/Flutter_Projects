import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:weather_app/weather_bloc.dart';
import 'package:weather_app/weather_model.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPage();
  }
}

class _SearchPage extends State<SearchPage> {
  var cityController = TextEditingController();
  GlobalKey<ScaffoldState> keyboardDetector;
  var typing = false;

  Future<bool> _onWillPop() {
    return (showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Exit?'),
            content: new Text('Do you want to exit?'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              SizedBox(width: MediaQuery.of(context).size.width / 3),
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    keyboardDetector = GlobalKey<ScaffoldState>();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (!visible) {
        typing = false;
        FocusScope.of(context).unfocus();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 7,
          ),
          if (!typing)
            Center(
              child: Container(
                height: MediaQuery.of(context).size.width * 2 / 3,
                width: MediaQuery.of(context).size.width * 2 / 3,
                child: FlareActor(
                  "assets/images/WorldSpin.flr",
                  fit: BoxFit.contain,
                  animation: "roll",
                ),
              ),
            ),
          BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
            if (state is WeatherIsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WeatherIsLoaded)
              return ShowWeather(state.getWeather, cityController.text);
            else {
              if (state is WeatherIsNotLoaded) {
                return Container(
                  padding: EdgeInsets.only(left: 32, right: 32),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Invalid City",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: MaterialButton(
                          onPressed: () {
                            typing = false;
                            weatherBloc.add(ResetWeather());
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          color: Colors.lightBlue,
                          child: Text(
                            "Go Back",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is ServerError) {
                return Container(
                  padding: EdgeInsets.only(left: 32, right: 32),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Connection Error",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: MaterialButton(
                          onPressed: () {
                            typing = false;
                            weatherBloc.add(ResetWeather());
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          color: Colors.lightBlue,
                          child: Text(
                            "Go Back",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container(
                padding: EdgeInsets.only(left: 32, right: 32),
                child: Column(
                  children: [
                    Text(
                      "Search Weather",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70),
                    ),
                    Text(
                      "City",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w200,
                          color: Colors.white70),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      height: 60,
                      child: TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white70,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.white70,
                                style: BorderStyle.solid,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                style: BorderStyle.solid,
                              )),
                          hintText: "City Name",
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                        onTap: () {
                          typing = true;
                        },
                        onEditingComplete: () {
                          typing = false;
                          FocusScope.of(context).unfocus();
                          weatherBloc.add(FetchWeather(cityController.text));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: () {
                          typing = false;
                          weatherBloc.add(FetchWeather(cityController.text));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        color: Colors.lightBlue,
                        child: Text(
                          "Search",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          })
        ],
      ),
    );
  }
}

class ShowWeather extends StatelessWidget {
  final WeatherModel weatherModel;
  final city;

  ShowWeather(this.weatherModel, this.city);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 32, left: 32, top: 10),
      child: Column(
        children: [
          Text(
            city,
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            weatherModel.getTemp.round().toString() + " C",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),
          ),
          Text(
            "Temperature",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    weatherModel.getMinTemp.round().toString() + " C",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    "Min Temperature",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    weatherModel.getMaxTemp.round().toString() + " C",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    "Max Temperature",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            width: double.infinity,
            child: MaterialButton(
              onPressed: () {
                BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              color: Colors.lightBlue,
              child: Text(
                "Search",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
