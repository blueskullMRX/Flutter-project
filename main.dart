import 'package:flutter/material.dart';
import 'calender.dart';
void main() => runApp(const App());


class App extends StatelessWidget {
  final appTitle = 'Widget Drawer Demo';
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Color.fromARGB(255, 19, 93, 102),
          selectionColor: Color.fromARGB(150, 119, 176, 170),
          cursorColor: Color.fromARGB(255, 19, 93, 102)),
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: Color.fromARGB(255, 19, 93, 102)),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 19, 93, 102),width: 2),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: const Calender(),
    );
  }
}


