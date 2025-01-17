import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/perawatan.dart';
import '../models/hewan.dart';

class ManagePerawatanScreen extends StatefulWidget {
  final int idHewan; // ID Hewan yang dipilih di ManageHewanScreen

  ManagePerawatanScreen({required this.idHewan});

  @override
  _ManagePerawatanScreenState createState() => _ManagePerawatanScreenState();
}

class _ManagePerawatanScreenState extends State<ManagePerawatanScreen> {
  late Future<List<Perawatan>> _perawatanList;
  late Future<List<Hewan>> _hewanList;
  int? selectedHewanId; // Untuk menyimpan id hewan yang dipilih pada dropdown

  @override
  void initState() {
    super.initState();
    _perawatanList = _getPerawatanList(widget.idHewan);
    _hewanList = _getHewanList();
  }

  Future<List<Perawatan>> _getPerawatanList(int idHewan) async {
    final db = DatabaseHelper();
    List<Map<String, dynamic>> data = await db.getPerawatanByIdHewan(idHewan);
    return data.map((e) => Perawatan.fromMap(e)).toList();
  }

  Future<List<Hewan>> _getHewanList() async {
    final db = DatabaseHelper();
    List<Map<String, dynamic>> data =
        await db.getAllHewan(); // Ambil semua data hewan
    return data.map((e) => Hewan.fromMap(e)).toList();
  }

  void _addPerawatan() async {
    final db = DatabaseHelper();
    TextEditingController _jenisPerawatanController = TextEditingController();
    TextEditingController _tanggalPerawatanController = TextEditingController();
    TextEditingController _biayaController = TextEditingController();
    TextEditingController _keteranganController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Perawatan'),
          content: Column(
            children: [
              TextField(
                controller: _jenisPerawatanController,
                decoration: InputDecoration(labelText: 'Jenis Perawatan'),
              ),
              TextField(
                controller: _tanggalPerawatanController,
                decoration: InputDecoration(labelText: 'Tanggal Perawatan'),
              ),
              TextField(
                controller: _biayaController,
                decoration: InputDecoration(labelText: 'Biaya'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _keteranganController,
                decoration: InputDecoration(labelText: 'Keterangan'),
              ),
              // Dropdown untuk memilih ID Hewan
              FutureBuilder<List<Hewan>>(
                future: _hewanList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Terjadi kesalahan saat memuat data hewan');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Tidak ada data hewan');
                  } else {
                    List<Hewan> hewanList = snapshot.data!;
                    return DropdownButton<int>(
                      value: selectedHewanId ?? widget.idHewan,
                      items: hewanList.map((hewan) {
                        return DropdownMenuItem<int>(
                          value: hewan.id,
                          child: Text(hewan.namaHewan),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedHewanId = newValue;
                        });
                      },
                      isExpanded: true,
                    );
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                db.insertPerawatan({
                  'id_hewan': selectedHewanId ??
                      widget.idHewan, // Menggunakan idHewan yang dipilih
                  'jenis_perawatan': _jenisPerawatanController.text,
                  'tanggal_perawatan': _tanggalPerawatanController.text,
                  'biaya': int.parse(_biayaController.text),
                  'keterangan': _keteranganController.text,
                }).then((value) {
                  Navigator.pop(context);
                  setState(() {
                    _perawatanList =
                        _getPerawatanList(selectedHewanId ?? widget.idHewan);
                  });
                }).catchError((e) {
                  print('Terjadi kesalahan saat menambah: $e');
                });
              },
              child: Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog tanpa menyimpan
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manajemen Layanan Perawatan"),
      ),
      body: FutureBuilder<List<Perawatan>>(
        future: _perawatanList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data perawatan.'));
          } else {
            List<Perawatan> perawatan = snapshot.data!;
            return ListView.builder(
              itemCount: perawatan.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(perawatan[index].jenisPerawatan),
                  subtitle: Text(perawatan[index].tanggalPerawatan),
                  onTap: () {
                    // Tampilkan dialog edit perawatan jika item diklik
                    _showDetailDialog(perawatan[index]);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPerawatan, // Tambah perawatan saat tombol ditekan
        child: Icon(Icons.add),
        tooltip: 'Tambah Perawatan',
      ),
    );
  }

  // Dialog untuk melihat/edit perawatan
  void _showDetailDialog(Perawatan perawatan) async {
    final db = DatabaseHelper();
    TextEditingController _jenisPerawatanController =
        TextEditingController(text: perawatan.jenisPerawatan);
    TextEditingController _tanggalPerawatanController =
        TextEditingController(text: perawatan.tanggalPerawatan);
    TextEditingController _biayaController =
        TextEditingController(text: perawatan.biaya.toString());
    TextEditingController _keteranganController =
        TextEditingController(text: perawatan.keterangan);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Perawatan'),
          content: Column(
            children: [
              TextField(
                controller: _jenisPerawatanController,
                decoration: InputDecoration(labelText: 'Jenis Perawatan'),
              ),
              TextField(
                controller: _tanggalPerawatanController,
                decoration: InputDecoration(labelText: 'Tanggal Perawatan'),
              ),
              TextField(
                controller: _biayaController,
                decoration: InputDecoration(labelText: 'Biaya'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _keteranganController,
                decoration: InputDecoration(labelText: 'Keterangan'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Update data perawatan
                db.updatePerawatan(perawatan.id!, {
                  'id_hewan': perawatan.idHewan,
                  'jenis_perawatan': _jenisPerawatanController.text,
                  'tanggal_perawatan': _tanggalPerawatanController.text,
                  'biaya': int.parse(_biayaController.text),
                  'keterangan': _keteranganController.text,
                }).then((value) {
                  Navigator.pop(context);
                  setState(() {
                    _perawatanList = _getPerawatanList(widget.idHewan);
                  });
                }).catchError((e) {
                  print('Terjadi kesalahan saat update: $e');
                });
              },
              child: Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                db.deletePerawatan(perawatan.id!).then((value) {
                  Navigator.pop(context);
                  setState(() {
                    _perawatanList = _getPerawatanList(widget.idHewan);
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
