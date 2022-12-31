import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/home_screen/home_screen.dart';
import 'package:news_app/shared/bloc_observer.dart';
import 'package:news_app/shared/components/no_glow_scroll.dart';
import 'package:news_app/shared/cubit/cubit.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';
import 'package:news_app/shared/style/cubit/cubit.dart';
import 'package:news_app/shared/style/cubit/states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  Bloc.observer = AppBlocObserver();
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NewsCubit()..getBusinessNews()..getSportNews()..getScienceNews()),
          BlocProvider(create: (context) => AppCubit()),
        ],
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, state) {},
          builder: (BuildContext context, state) {
            return MaterialApp(
              title: 'News App',
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                return ScrollConfiguration(
                  behavior: NoGlowScroll(),
                  child: child!,
                );
              },
              theme: ThemeData(
                appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  titleSpacing: 20.0,
                  titleTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600),
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: Colors.white,
                  elevation: 20.0,
                ),
                textTheme: const TextTheme(
                  headline6: TextStyle(
                    color: Colors.black,
                  ),
                  bodyText1: TextStyle(
                    color: Colors.black,
                  ),
                ),
                scaffoldBackgroundColor: Colors.white,
                primarySwatch: Colors.deepOrange,
              ),
              darkTheme: ThemeData(
                appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Color.fromRGBO(33, 33, 33, 1.0),
                    statusBarIconBrightness: Brightness.light,
                  ),
                  backgroundColor: Color.fromRGBO(33, 33, 33, 1.0),
                  elevation: 0.0,
                  titleSpacing: 20.0,
                  titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600),
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: Color.fromRGBO(33, 33, 33, 1.0),
                  elevation: 20.0,
                ),
                textTheme: const TextTheme(
                  headline6: TextStyle(
                    color: Colors.white,
                  ),
                  bodyText1: TextStyle(
                    color: Colors.white,
                  ),
                ),
                scaffoldBackgroundColor: const Color.fromRGBO(33, 33, 33, 1.0),
                primarySwatch: Colors.deepOrange,
              ),
              themeMode: AppCubit.get(context).isDark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: const HomeScreen(),
            );
          },
        ));
  }
}
