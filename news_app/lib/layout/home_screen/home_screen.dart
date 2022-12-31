import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/modules/search/search_screen.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/cubit/cubit.dart';
import 'package:news_app/shared/cubit/states.dart';
import 'package:news_app/shared/style/cubit/cubit.dart';
import 'package:news_app/shared/style/cubit/states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (BuildContext context, state) {
        if (state is NewsGetBusinessLoadingState || state is NewsGetSportLoadingState || state is NewsGetScienceLoadingState) {

        }
        else {
          if (state is NewsGetBusinessSuccessState) {

          }
          if (state is NewsGetBusinessErrorState) {

          }
          if (state is NewsGetSportSuccessState) {

          }
          if (state is NewsGetSportErrorState) {

          }
          if (state is NewsGetScienceSuccessState) {

          }
          if (state is NewsGetScienceErrorState) {

          }
        }
      },
      builder: (BuildContext context, Object? state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Latest News",
            ),
            actions: [
              IconButton(
                onPressed: () {
                  NewsCubit.get(context)..getBusinessNews()..getSportNews()..getScienceNews();
                },
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: () {
                  goto(context, SearchScreen());
                },
                icon: const Icon(Icons.search),
              ),
              BlocConsumer<AppCubit, AppStates>(
                listener: (BuildContext context, state) {},
                builder: (BuildContext context, Object? state) {
                  return IconButton(
                    onPressed: () {
                      AppCubit.get(context).changeTheme();
                    },
                    icon: AppCubit.get(context).isDark
                        ? const Icon(Icons.brightness_7)
                        : const Icon(Icons.brightness_4_outlined),
                  );
                },
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: NewsCubit.get(context).index,
            items: NewsCubit.get(context).navBarItems,
            onTap: (index) {
              NewsCubit.get(context).changeNavIndex(index);
            },
            unselectedItemColor: Colors.grey,
          ),
          body: NewsCubit.get(context).screens[NewsCubit.get(context).index],
        );
      },
    );
  }
}
