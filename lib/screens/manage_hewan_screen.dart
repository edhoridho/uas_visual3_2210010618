import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/hewan.dart';

class ManageHewanScreen extends StatefulWidget {
  @override
  _ManageHewanScreenState createState() => _ManageHewanScreenState();
}

class _ManageHewanScreenState extends State<ManageHewanScreen> {
  late Future<List<Hewan>> _hewanList;

  // Controller untuk input form
  final TextEditingController _idHewanController =
      TextEditingController(); // Menambahkan controller untuk ID Hewan
  final TextEditingController _namaHewanController = TextEditingController();
  final TextEditingController _jenisHewanController = TextEditingController();
  final TextEditingController _usiaController = TextEditingController();
  final TextEditingController _namaPemilikController = TextEditingController();
  final TextEditingController _kontakPemilikController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _hewanList = _getHewanList();
  }

  // Fungsi untuk mengambil data hewan dari database
  Future<List<Hewan>> _getHewanList() async {
    final db = DatabaseHelper();
    List<Map<String, dynamic>> data = await db.getHewan();
    return data.map((e) => Hewan.fromMap(e)).toList();
  }

  // Fungsi untuk menambahkan Hewan baru
  void _addHewan() async {
    final db = DatabaseHelper();
    // Buka dialog atau form untuk input data Hewan
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Hewan'),
          content: Column(
            children: [
              TextField(
                controller: _idHewanController,
                decoration: InputDecoration(
                    labelText: 'ID Hewan'), // Kolom untuk ID Hewan
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _namaHewanController,
                decoration: InputDecoration(labelText: 'Nama Hewan'),
              ),
              TextField(
                controller: _jenisHewanController,
                decoration: InputDecoration(labelText: 'Jenis Hewan'),
              ),
              TextField(
                controller: _usiaController,
                decoration: InputDecoration(labelText: 'Usia'),
                keyboardType:
                    TextInputType.text, // Mengubah keyboard ke tipe teks
              ),
              TextField(
                controller: _namaPemilikController,
                decoration: InputDecoration(labelText: 'Nama Pemilik'),
              ),
              TextField(
                controller: _kontakPemilikController,
                decoration: InputDecoration(labelText: 'Kontak Pemilik'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Mengirim data ke database dengan ID Hewan yang dimasukkan
                db.insertHewan({
                  'id': int.tryParse(_idHewanController.text) ??
                      0, // Menambahkan ID Hewan yang diinput
                  'nama_hewan': _namaHewanController.text,
                  'jenis_hewan': _jenisHewanController.text,
                  'usia': _usiaController.text, // Usia tetap sebagai string
                  'nama_pemilik': _namaPemilikController.text,
                  'kontak_pemilik': _kontakPemilikController.text,
                }).then((value) {
                  Navigator.pop(context);
                  setState(() {
                    _hewanList = _getHewanList(); // Refresh data hewan
                  });
                }).catchError((e) {
                  print('Terjadi kesalahan: $e');
                });
              },
              child: Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Menutup dialog tanpa menyimpan
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  // Menampilkan data hewan
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manajemen Hewan"),
      ),
      body: FutureBuilder<List<Hewan>>(
        future: _hewanList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data hewan.'));
          } else {
            List<Hewan> hewan = snapshot.data!;
            return ListView.builder(
              itemCount: hewan.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(hewan[index].namaHewan),
                  subtitle: Text(hewan[index].jenisHewan),
                  onTap: () {
                    // Menampilkan dialog atau form untuk melihat/edit data
                    _showDetailDialog(hewan[index]);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHewan, // Panggil fungsi untuk menambah hewan
        child: Icon(Icons.add),
        tooltip: 'Tambah Hewan',
      ),
    );
  }

  // Menampilkan dialog detail untuk edit atau hapus data hewan
  void _showDetailDialog(Hewan hewan) async {
    final db = DatabaseHelper();

    // Menampilkan dialog untuk melihat/mengedit data
    await showDialog(
      context: context,
      builder: (context) {
        _namaHewanController.text = hewan.namaHewan;
        _jenisHewanController.text = hewan.jenisHewan;
        _usiaController.text = hewan.usia;
        _namaPemilikController.text = hewan.namaPemilik;
        _kontakPemilikController.text = hewan.kontakPemilik;

        return AlertDialog(
          title: Text('Edit Hewan'),
          content: Column(
            children: [
              TextField(
                controller: _namaHewanController,
                decoration: InputDecoration(labelText: 'Nama Hewan'),
              ),
              TextField(
                controller: _jenisHewanController,
                decoration: InputDecoration(labelText: 'Jenis Hewan'),
              ),
              TextField(
                controller: _usiaController,
                decoration: InputDecoration(labelText: 'Usia'),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: _namaPemilikController,
                decoration: InputDecoration(labelText: 'Nama Pemilik'),
              ),
              TextField(
                controller: _kontakPemilikController,
                decoration: InputDecoration(labelText: 'Kontak Pemilik'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Mengupdate data ke database
                db.updateHewan(hewan.id!, {
                  'nama_hewan': _namaHewanController.text,
                  'jenis_hewan': _jenisHewanController.text,
                  'usia': _usiaController.text,
                  'nama_pemilik': _namaPemilikController.text,
                  'kontak_pemilik': _kontakPemilikController.text,
                }).then((value) {
                  Navigator.pop(context);
                  setState(() {
                    _hewanList = _getHewanList(); // Refresh list
                  });
                }).catchError((e) {
                  print('Terjadi kesalahan saat update: $e');
                });
              },
              child: Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                // Menghapus data dari database
                db.deleteHewan(hewan.id!).then((value) {
                  Navigator.pop(context);
                  setState(() {
                    _hewanList = _getHewanList(); // Refresh list
                  });
                }).catchError((e) {
                  print('Terjadi kesalahan saat hapus: $e');
                });
              },
              child: Text('Hapus'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Menutup dialog tanpa perubahan
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }
}
