// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bangunanmode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bangunanmode _$BangunanmodeFromJson(Map<String, dynamic> json) => Bangunanmode(
  (json['id'] as num).toInt(),
  json['created_at'] as String,
  (json['id_kota'] as num).toInt(),
  json['image_path'] as String,
  json['deskipsi'] as String,
);

Map<String, dynamic> _$BangunanmodeToJson(Bangunanmode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.created_at,
      'id_kota': instance.id_kota,
      'image_path': instance.image_path,
      'deskipsi': instance.deskipsi,
    };
