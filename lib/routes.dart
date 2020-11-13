import 'package:flutter/widgets.dart';

import 'package:yellow_vbox/homepage.dart';
import 'package:yellow_vbox/loginscreen.dart';
import 'package:yellow_vbox/registerscreen.dart';

class Approutes {
  Approutes._();

  static const String authLogin = '/authLogin';
  static const String authRegister = '/authRegister';
  static const String homePage = '/homePage';

  static Map<String, WidgetBuilder> define() {
    return {
      authLogin: (context) => LoginScreen(),
      authRegister: (context) => RegisterScreen(),
      homePage: (context) => HomePage(),
    };
  }
}