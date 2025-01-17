class Hewan {
  int? id;
  String namaHewan;
  String jenisHewan;
  String usia;
  String namaPemilik;
  String kontakPemilik;

  Hewan({
    this.id,
    required this.namaHewan,
    required this.jenisHewan,
    required this.usia,
    required this.namaPemilik,
    required this.kontakPemilik,
  });

  // Konversi ke Map untuk database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_hewan': namaHewan,
      'jenis_hewan': jenisHewan,
      'usia': usia,
      'nama_pemilik': namaPemilik,
      'kontak_pemilik': kontakPemilik,
    };
  }

  // Konversi dari Map
  factory Hewan.fromMap(Map<String, dynamic> map) {
    return Hewan(
      id: map['id'],
      namaHewan: map['nama_hewan'],
      jenisHewan: map['jenis_hewan'],
      usia: map['usia'],
      namaPemilik: map['nama_pemilik'],
      kontakPemilik: map['kontak_pemilik'],
    );
  }
}
