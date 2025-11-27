// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kotamodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kotamodel _$KotamodelFromJson(Map<String, dynamic> json) => Kotamodel(
  (json['id'] as num).toInt(),
  json['nama_kota'] as String,
  json['deskripsi_singkat'] as String,
  json['deskripsi_panjang'] as String,
  (json['image_path'] as List<dynamic>).map((e) => e as String).toList(),
  json['created_at'] as String,
  json['lokasi'] as String,
);

Map<String, dynamic> _$KotamodelToJson(Kotamodel instance) => <String, dynamic>{
  'id': instance.id,
  'nama_kota': instance.nama_kota,
  'deskripsi_singkat': instance.deskripsi_singkat,
  'deskripsi_panjang': instance.deskripsi_panjang,
  'image_path': instance.image_path,
  'created_at': instance.created_at,
  'lokasi': instance.lokasi,
};
