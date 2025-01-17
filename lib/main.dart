import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/manage_hewan_screen.dart';
import 'screens/manage_perawatan_screen.dart';
import 'db/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perawatan Hewan',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/menu': (context) => MainMenuScreen(),
        '/manageHewan': (context) => ManageHewanScreen(),
      },
      // Menggunakan onGenerateRoute untuk rute dengan parameter
      onGenerateRoute: (settings) {
        if (settings.name == '/managePerawatan') {
          final int idHewan = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => ManagePerawatanScreen(idHewan: idHewan),
          );
        }
        return null;
      },
    );
  }
}
