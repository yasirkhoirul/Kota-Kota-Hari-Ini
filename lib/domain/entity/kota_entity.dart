class KotaEntity {
  final int? id;
  final String namaKota;
  final String deskripsiSingkat;
  final String deskripsiPanjang;
  final List<String> imagePath;
  final String createdAt;
  final String lokasi;
  KotaEntity(
    this.id,
    this.namaKota,
    this.deskripsiSingkat,
    this.deskripsiPanjang,
    this.imagePath,
    this.createdAt,
    this.lokasi,
  );
}
