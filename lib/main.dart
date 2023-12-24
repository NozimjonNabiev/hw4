import 'package:flutter/material.dart';
import 'package:hw4/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hw4/screens/home/home_screen.dart';
import 'package:hw4/providers/user_data_provider.dart';
import 'package:hw4/screens/welcome/welcome_screen.dart';

const String isFirstLaunchKey = 'isFirstLaunch';
const String isLoggedInKey = 'isLoggedIn';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool(isFirstLaunchKey) ?? true;
  bool isLoggedIn = prefs.getBool(isLoggedInKey) ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataProvider()..loadUserData(),
      child: isFirstLaunch
          ? MyApp(
              onCompleted: () async {
                await prefs.setBool(isFirstLaunchKey, false);
              },
            )
          : isLoggedIn
              ? MyApp(isLoggedIn: true)
              : MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback? onCompleted;

  const MyApp({Key? key, this.isLoggedIn = false, this.onCompleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              foregroundColor: Colors.white,
              backgroundColor: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      home: isLoggedIn ? HomeScreen() : WelcomeScreen(),
    );
  }
}
