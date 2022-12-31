import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/cubit/cubit.dart';
import 'package:news_app/shared/cubit/states.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) => Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: controller,
            decoration: const InputDecoration(
              // border: null,
              hintText: "Search ...",
            ),
            onChanged: (value) {
              NewsCubit.get(context).searchNews(controller.text.trim());
            },
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        body: controller.text.trim().isNotEmpty ? ConditionalBuilder(
          condition: NewsCubit.get(context).search.isNotEmpty,
          builder: (BuildContext context) => buildArticles(NewsCubit.get(context).search),
          fallback: (BuildContext context) => const Center(child: CircularProgressIndicator()),
        ) : Container(),
      ),
    );
  }
}
