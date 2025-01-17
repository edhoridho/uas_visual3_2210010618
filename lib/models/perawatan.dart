class Perawatan {
  int? id;
  int idHewan;
  String jenisPerawatan;
  String tanggalPerawatan;
  int biaya;
  String keterangan;

  Perawatan({
    this.id,
    required this.idHewan,
    required this.jenisPerawatan,
    required this.tanggalPerawatan,
    required this.biaya,
    required this.keterangan,
  });

  // Konversi ke Map untuk database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_hewan': idHewan,
      'jenis_perawatan': jenisPerawatan,
      'tanggal_perawatan': tanggalPerawatan,
      'biaya': biaya,
      'keterangan': keterangan,
    };
  }

  // Konversi dari Map
  factory Perawatan.fromMap(Map<String, dynamic> map) {
    return Perawatan(
      id: map['id'],
      idHewan: map['id_hewan'],
      jenisPerawatan: map['jenis_perawatan'],
      tanggalPerawatan: map['tanggal_perawatan'],
      biaya: map['biaya'],
      keterangan: map['keterangan'],
    );
  }
}
