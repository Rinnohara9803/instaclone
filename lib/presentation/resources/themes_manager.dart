import 'package:flutter/material.dart';

import 'colors_manager.dart';

class ThemeProvider with ChangeNotifier {
  bool _isLightTheme = true;

  bool get isLightTheme {
    return _isLightTheme;
  }

  void toggleThemes() {
    _isLightTheme = !_isLightTheme;
    notifyListeners();
  }
}

ThemeData getDarkApplicationTheme() {
  return ThemeData(
    // primary color
    primaryColor: Colors.black,
    errorColor: Colors.white,
    colorScheme: const ColorScheme.dark(),

    // icon buttom theme
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStatePropertyAll(
          ColorsManager.white,
        ),
      ),
    ),

    // icon theme
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    primaryIconTheme: const IconThemeData(
      color: Colors.white,
    ),

    // text themes
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: ColorsManager.white,
        fontSize: 25,
      ),
      titleMedium: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      titleSmall: const TextStyle(
        color: Colors.white,
        fontSize: 17,
      ),
      bodyMedium: TextStyle(
        color: ColorsManager.white,
        fontSize: 15,
      ),
      bodySmall: TextStyle(
        color: ColorsManager.white,
        fontSize: 11,
      ),
      displayLarge: TextStyle(
        color: ColorsManager.white,
      ),
      displayMedium: TextStyle(
        color: ColorsManager.white,
      ),
      displaySmall: TextStyle(
        color: ColorsManager.white,
      ),
    ),

    // input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      suffixIconColor: Colors.grey,
      prefixIconColor: Colors.grey,
      fillColor: Colors.transparent,
      filled: true,
      labelStyle: TextStyle(
        color: ColorsManager.white,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5, color: Colors.white),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5, color: Colors.red),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5, color: Colors.white),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5, color: Colors.red),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
    ),

    // pop up menu theme
    popupMenuTheme: const PopupMenuThemeData(
      color: Colors.white,
    ),

    // app bar theme
    appBarTheme: const AppBarTheme(
      color: Colors.black,
      elevation: 0,
    ),

    //
    scaffoldBackgroundColor: Colors.black,

    //
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
    ),

    //
    tabBarTheme: const TabBarTheme(
      indicatorColor: Colors.white,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey,
    ),

    //
    dividerTheme: const DividerThemeData(color: Colors.white),

    //
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.white,
    ),

    //
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ),

    //
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromARGB(255, 29, 28, 28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(
            20,
          ),
          topLeft: Radius.circular(
            20,
          ),
        ),
      ),
    ),

    //
    checkboxTheme: const CheckboxThemeData(
      fillColor: MaterialStatePropertyAll(Colors.white),
    ),
  );
}

ThemeData getLightApplicationTheme() {
  return ThemeData(
    // primary color
    primaryColor: Colors.white,
    errorColor: Colors.black,
    colorScheme: const ColorScheme.light(),

    // icon buttom theme
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStatePropertyAll(
          Colors.black,
        ),
      ),
    ),

    // icon theme
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    primaryIconTheme: const IconThemeData(
      color: Colors.black,
    ),

    // text themes
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.black,
        fontSize: 25,
      ),
      titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      titleSmall: TextStyle(
        color: Colors.black,
        fontSize: 17,
      ),
      bodyMedium: TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
      bodySmall: TextStyle(
        color: Colors.black,
        fontSize: 11,
      ),
      displayLarge: TextStyle(
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        color: Colors.black,
      ),
    ),

    // input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      suffixIconColor: Colors.grey,
      prefixIconColor: Colors.grey,
      fillColor: Colors.transparent,
      filled: true,
      labelStyle: TextStyle(
        color: ColorsManager.white,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5, color: Colors.white),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5, color: Colors.red),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5, color: Colors.white),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5, color: Colors.red),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
    ),

    // pop up menu theme
    popupMenuTheme: const PopupMenuThemeData(
      color: Colors.white,
    ),

    // app bar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
    ),

    //
    scaffoldBackgroundColor: Colors.white,

    //
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
    ),

    //
    tabBarTheme: const TabBarTheme(
      indicatorColor: Colors.black,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black54,
    ),

    //
    dividerTheme: const DividerThemeData(color: Colors.black),

    //
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.black,
    ),

    //
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStateProperty.all(Colors.black),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    ),

    //
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(
            20,
          ),
          topLeft: Radius.circular(
            20,
          ),
        ),
      ),
    ),

    //
    checkboxTheme: const CheckboxThemeData(
      fillColor: MaterialStatePropertyAll(Colors.black),
    ),
  );
}
