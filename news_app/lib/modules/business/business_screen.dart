import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/cubit/cubit.dart';
import 'package:news_app/shared/cubit/states.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) => ConditionalBuilder(
        condition: NewsCubit.get(context).business.isNotEmpty,
        builder: (BuildContext context) => buildArticles(NewsCubit.get(context).business),
        fallback: (BuildContext context) => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
