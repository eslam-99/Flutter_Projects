import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';
import 'package:news_app/shared/style/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());
  
  static AppCubit get(context) => BlocProvider.of(context);
  
  bool _isDark = false;
  bool _themeInit = false;

  bool get isDark {
    if(!_themeInit) {
      _isDark = CacheHelper.getBool(key: "isDark") ?? false;
      _themeInit = true;
    }
    return _isDark;
  }

  void changeTheme() {
    CacheHelper.setBool(key: "isDark", value: !_isDark).then((value) {
      _isDark = !_isDark;
      emit(AppChangeThemeModeState());
    });
  }
}