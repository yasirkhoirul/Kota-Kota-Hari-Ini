import 'package:json_annotation/json_annotation.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';

part 'kotamodel.g.dart';

@JsonSerializable()
class Kotamodel {
  final int id;
  final String nama_kota;
  final String deskripsi_singkat;
  final String deskripsi_panjang;
  final List<String> image_path;
  final String created_at;
  final String lokasi;
  Kotamodel(
    this.id,
    this.nama_kota,
    this.deskripsi_singkat,
    this.deskripsi_panjang,
    this.image_path,
    this.created_at,
    this.lokasi,
  );

  factory Kotamodel.fromJson(Map<String, dynamic> json) =>
      _$KotamodelFromJson(json);

  Map<String, dynamic> toJson() => _$KotamodelToJson(this);

  KotaEntity toEntity() => KotaEntity(
    id,
    nama_kota,
    deskripsi_singkat,
    deskripsi_panjang,
    image_path,
    created_at,
    lokasi,
  );
  factory Kotamodel.fromEntity(KotaEntity data) {
    return Kotamodel(
      data.id!,
      data.namaKota,
      data.deskripsiSingkat,
      data.deskripsiPanjang,
      data.imagePath,
      data.createdAt,
      data.lokasi,
    );
  }
}
