import 'package:dio_error_handling/app/data/local/my_shared_pref.dart';
import 'package:dio_error_handling/app/routes/app_pages.dart';
import 'package:dio_error_handling/config/theme/my_theme.dart';
import 'package:dio_error_handling/config/translations/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPref.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, widget) {
        return GetMaterialApp(
          title: "DioTesting",
          useInheritedMediaQuery: true,
          debugShowCheckedModeBanner: false,
          builder: (context,widget) {
            bool themeIsLight = MySharedPref.getThemeIsLight();
            return Theme(
              data: MyTheme.getThemeData(isLight: themeIsLight),
              child: MediaQuery(
                // prevent font from scaling (some people use big/small device fonts)
                // but we want our app font to still the same and dont get affected
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              ),
            );
          },
          initialRoute: AppPages.initial, // first screen to show when app is running
          getPages: AppPages.routes, // app screens
          locale: MySharedPref.getCurrentLocal(), // app language
          translations: LocalizationService.getInstance(), // localization services in app (controller app language)
        );
      },
    );
  }
}
