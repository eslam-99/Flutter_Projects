import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/weather_model.dart';
import 'package:weather_app/weather_rebo.dart';

class WeatherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherEvent {
  final city;

  FetchWeather(this.city);

  @override
  List<Object> get props {
    return [city];
  }
}

class ResetWeather extends WeatherEvent {}

class NoConnection extends WeatherEvent {}

class WeatherState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class WeatherIsNotSearched extends WeatherState {}

class WeatherIsLoading extends WeatherState {}

class WeatherIsLoaded extends WeatherState {
  final weather;

  WeatherIsLoaded(this.weather);

  WeatherModel get getWeather => weather;

  @override
  List<Object> get props {
    return [weather];
  }
}

class WeatherIsNotLoaded extends WeatherState {}

class ServerError extends WeatherState {}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherRebo weatherRebo;

  WeatherBloc(this.weatherRebo) : super(null);

  WeatherState get initialState => WeatherIsNotSearched();

  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield WeatherIsLoading();
      try {
        WeatherModel weatherModel = await weatherRebo.getWeather(event.city);
        yield WeatherIsLoaded(weatherModel);
      } catch (ex) {
        if (ex.toString() == "FormatException: Invalid City")
          yield WeatherIsNotLoaded();
        else if (ex.toString() == "FormatException: Connection Error")
          yield ServerError();
      }
    } else if (event is ResetWeather) {
      yield WeatherIsNotSearched();
    } else if (event is NoConnection) {
      yield ServerError();
    }
  }
}
