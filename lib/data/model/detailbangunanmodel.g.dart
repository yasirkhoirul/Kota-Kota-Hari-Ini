// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detailbangunanmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailBangunanModel _$DetailBangunanModelFromJson(Map<String, dynamic> json) =>
    DetailBangunanModel(
      id: (json['id'] as num).toInt(),
      idBangunan: (json['id_bangunan'] as num).toInt(),
      imagePath: json['images_path'] as String,
      deskripsi: json['deskripsi'] as String,
    );

Map<String, dynamic> _$DetailBangunanModelToJson(
  DetailBangunanModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'id_bangunan': instance.idBangunan,
  'images_path': instance.imagePath,
  'deskripsi': instance.deskripsi,
};
