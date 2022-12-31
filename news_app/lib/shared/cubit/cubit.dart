import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app/modules/business/business_screen.dart';
import 'package:news_app/modules/science/science_screen.dart';
import 'package:news_app/modules/sport/sports_screen.dart';
import 'package:news_app/shared/cubit/states.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int index = 0;

  List<Widget> screens = [
    const BusinessScreen(),
    const SportsScreen(),
    const ScienceScreen(),
  ];

  List business = [];
  List sport = [];
  List science = [];
  List search = [];

  List<BottomNavigationBarItem> navBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: "Business",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.sports),
      label: "sports",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.science),
      label: "science",
    ),
  ];

  void changeNavIndex(int newIndex) {
    index = newIndex;
    emit(NewsChangeNavIndexState());
  }

  void getBusinessNews() {
    emit(NewsGetBusinessLoadingState());
    DioHelper.getNews(url: "v2/top-headlines", query: {"country": "eg", "category": "business"}).then((value) {
      business = value.data["articles"];
      emit(NewsGetBusinessSuccessState());
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: "Please Check Your Internet Connection!");
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }

  void getSportNews() {
    emit(NewsGetSportLoadingState());
    DioHelper.getNews(url: "v2/top-headlines", query: {"country": "eg", "category":"sport"}).then((value) {
      sport = value.data["articles"];
      emit(NewsGetSportSuccessState());
    }).onError((error, stackTrace) {
      emit(NewsGetSportErrorState(error.toString()));
    });
  }

  void getScienceNews() {
    emit(NewsGetScienceLoadingState());
    DioHelper.getNews(url: "v2/top-headlines", query: {"country": "eg", "category":"science"}).then((value) {
      science = value.data["articles"];
      emit(NewsGetScienceSuccessState());
    }).onError((error, stackTrace) {
      emit(NewsGetScienceErrorState(error.toString()));
    });
  }

  void searchNews(String value) {
    emit(NewsSearchLoadingState());
    DioHelper.getNews(url: "v2/everything", query: {"q": value}).then((value) {
      search = value.data["articles"];
      emit(NewsSearchSuccessState());
    }).onError((error, stackTrace) {
      emit(NewsSearchErrorState(error.toString()));
    });
  }

}