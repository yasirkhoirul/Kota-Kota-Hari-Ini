
import 'package:json_annotation/json_annotation.dart';
import 'package:kota_kota_hari_ini/domain/entity/bangunan_entity.dart';

part 'bangunanmode.g.dart';

@JsonSerializable()
class Bangunanmode {
  final int id;
  final String created_at;
  final int id_kota;
  final String image_path;
  final String deskipsi;
  const Bangunanmode(this.id, this.created_at, this.id_kota, this.image_path, this.deskipsi);


  factory Bangunanmode.fromJson(Map<String,dynamic> json)=> _$BangunanmodeFromJson(json);

  BangunanEntity toEntity(Bangunanmode data){
    return BangunanEntity(id, created_at, id_kota, image_path, deskipsi);
  }
}