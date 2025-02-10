import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:day_night_switcher/day_night_switcher.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = true;

  bool _allowBigLetters = false;
  bool _allowSmalLetters = false;
  bool _allowNumbers = false;
  bool _allowSpecialChar = false;

  final String _bigLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final String _smallLetters = 'abcdefghijklmnopqrstuvwxyz';
  final String _numbers = '0123456789';
  final String _specialChar = '!@#\$%^&*()-_=+[]{}|;:\'",.<>?/`~\\';

  double _lengthPass = 6;

  final TextEditingController _passController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        home: Scaffold(
          appBar: appBar(),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                passEdit(),
                blocPassLength(),
                blocPassDifficulty(),
                Expanded(child: Container()),
                blocButtons()
              ],
            ),
          ),
        ));
  }

////////////////////////////////////////////////////////////////////////////////
// ВІДЖЕТИ

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: RichText(
          text: const TextSpan(
        children: [
          TextSpan(
              text: 'Pass',
              style: TextStyle(color: Colors.white, fontSize: 25)),
          TextSpan(
              text: 'Craft',
              style: TextStyle(color: Color(0xff009F85), fontSize: 30)),
        ],
      )),
      actions: [
        DayNightSwitcher(
          isDarkModeEnabled: isDarkTheme,
          onStateChanged: (value) => setState(() {
            isDarkTheme = value;
          }),
        )
      ],
    );
  }

  Widget passEdit() {
    return TextField(
      readOnly: true,
      enabled: false,
      controller: _passController,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 20),
      decoration: InputDecoration(
        hintText: '- - -',
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 2.5,
            color: Color(0xff009F85),
          ),
        ),
      ),
    );
  }

  Widget blocPassLength() {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      width: double.infinity,
      child: settingsCard(
        title: "Довжина",
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              _lengthPass.toInt().toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          Slider(
            value: _lengthPass,
            min: 6,
            max: 20,
            divisions: 14,
            label: _lengthPass.toString(),
            onChanged: (value) {
              setState(() {
                _lengthPass = value;
                _passController.text = '';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget blocPassDifficulty() {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      width: double.infinity,
      child: settingsCard(
        title: 'Складність',
        children: [
          Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: _allowBigLetters,
                  onChanged: (value) {
                    setState(() {
                      _allowBigLetters = value!;
                      _passController.text = '';
                    });
                  },
                ),
              ),
              const Text('Великі літери'),
            ],
          ),
          Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: _allowSmalLetters,
                  onChanged: (value) {
                    setState(() {
                      _allowSmalLetters = value!;
                      _passController.text = '';
                    });
                  },
                ),
              ),
              const Text('Малі літери'),
            ],
          ),
          Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: _allowNumbers,
                  onChanged: (value) {
                    setState(() {
                      _allowNumbers = value!;
                      _passController.text = '';
                    });
                  },
                ),
              ),
              const Text('Цифри'),
            ],
          ),
          Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: _allowSpecialChar,
                  onChanged: (value) {
                    setState(() {
                      _allowSpecialChar = value!;
                      _passController.text = '';
                    });
                  },
                ),
              ),
              const Text('Спеціальні символи'),
            ],
          ),
        ],
      ),
    );
  }

  Widget blocButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => generatePass(),
            style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: Text(
              'Згенерувати',
              style: TextStyle(
                  fontSize: 20,
                  color: isDarkTheme ? Colors.white : Colors.black),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => copyTyClipboard(),
          style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromHeight(60),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: Icon(
            Icons.copy,
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget settingsCard({required String title, required List<Widget> children}) {
    return Card(
      child: Column(
        children: [
          // - - - Заголовок
          Container(
            padding: const EdgeInsets.only(left: 15, top: 10),
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xff009F85),
                fontSize: 21,
              ),
            ),
          ),
          Column(children: children)
        ],
        //
      ),
    );
  }

  SnackBar _snackBar(String title) {
    return SnackBar(
      elevation: 0,
      duration: const Duration(milliseconds: 1370),
      padding: const EdgeInsets.only(bottom: 110),
      backgroundColor: Colors.transparent,
      content: Container(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 159, 133),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

////////////////////////////////////////////////////////////////////////
// МЕТОДИ

  void generatePass() {
    if (!_allowBigLetters &&
        !_allowSmalLetters &&
        !_allowNumbers &&
        !_allowSpecialChar) {
      scaffoldMessengerKey.currentState
          ?.showSnackBar(_snackBar('Налаштуйте складність паролю👆'));

      return;
    }

    Random randomGet = Random();

    List newPass = [];
    while (true) {
      if (_allowBigLetters && randomGet.nextInt(2) == 1) {
        newPass.add(_bigLetters[randomGet.nextInt(_bigLetters.length)]);
      }

      if (newPass.length == _lengthPass) break;

      if (_allowSmalLetters && randomGet.nextInt(2) == 1) {
        newPass.add(_smallLetters[randomGet.nextInt(_smallLetters.length)]);
      }
      if (newPass.length == _lengthPass) break;
      if (_allowNumbers && randomGet.nextInt(2) == 1) {
        newPass.add(_numbers[randomGet.nextInt(_numbers.length)]);
      }
      if (newPass.length == _lengthPass) break;
      if (_allowSpecialChar && randomGet.nextInt(2) == 1) {
        newPass.add(_specialChar[randomGet.nextInt(_specialChar.length)]);
      }
      if (newPass.length == _lengthPass) break;
    }

    setState(() {
      _passController.text = newPass.join();
    });
  }

  void copyTyClipboard() {
    String textMessage = 'Згенеруйте пароль';

    if (_passController.text.isNotEmpty) {
      textMessage = 'Скопійовано в буфер 🎉';
      Clipboard.setData(ClipboardData(text: _passController.text));
    }

    scaffoldMessengerKey.currentState?.showSnackBar(_snackBar(textMessage));
  }
}

////////////////////////////////////////////////////////////////////////////////
// ТЕМИ

ThemeData darkTheme = ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(8),
        shadowColor: WidgetStateProperty.all(const Color(0xff009F85)),
        backgroundColor: WidgetStateProperty.all(const Color(0xff009F85)),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.all(const Color(0xff202020)),
    ),
    cardTheme: const CardTheme(
      elevation: 15,
      shadowColor: Color(0xff009F85),
      color: Color(0xff202020),
    ),
    sliderTheme: const SliderThemeData(
      showValueIndicator: ShowValueIndicator.never,
      inactiveTickMarkColor: Colors.transparent,
      secondaryActiveTrackColor: Colors.transparent,
      valueIndicatorColor: Color(0xff009F85),
      activeTickMarkColor: Colors.transparent,
      activeTrackColor: Colors.white,
      inactiveTrackColor: Colors.white,
      thumbColor: Color(0xff009F85),
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff272727),
        surfaceTintColor: Colors.transparent),
    colorScheme: const ColorScheme.dark(
      surface: Color(0xff272727),
    ));

ThemeData lightTheme = ThemeData(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(const Color(0xff009F85)),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor: WidgetStateProperty.all(Colors.black),
    fillColor: WidgetStateProperty.all(Colors.white),
  ),
  cardTheme: const CardTheme(
    elevation: 15,
    shadowColor: Color(0xff009F85),
    color: Colors.white,
  ),
  sliderTheme: const SliderThemeData(
    trackHeight: 2,
    showValueIndicator: ShowValueIndicator.never,
    inactiveTickMarkColor: Colors.transparent,
    secondaryActiveTrackColor: Colors.transparent,
    valueIndicatorColor: Color(0xff009F85),
    activeTickMarkColor: Colors.transparent,
    activeTrackColor: Color(0xff272727),
    inactiveTrackColor: Color(0xff272727),
    thumbColor: Color(0xff009F85), // Колір маркерів неактивних
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff272727),
    surfaceTintColor: Colors.transparent,
  ),
  colorScheme: const ColorScheme.light(
    surface: Colors.white,
  ),
);
