import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Utama'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/manageHewan');
              },
              child: Text('Manajemen Hewan'),
            ),
            ElevatedButton(
              onPressed: () {
                int idHewan = 1; // Misalnya, id hewan yang dipilih
                Navigator.pushNamed(
                  context,
                  '/managePerawatan',
                  arguments:
                      idHewan, // Mengirimkan idHewan ke ManagePerawatanScreen
                );
              },
              child: Text('Layanan Perawatan'),
            ),
          ],
        ),
      ),
    );
  }
}
