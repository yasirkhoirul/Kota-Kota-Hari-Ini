
import 'package:json_annotation/json_annotation.dart';
import 'package:kota_kota_hari_ini/domain/entity/detail_bangunan_entity.dart';


part 'detailbangunanmodel.g.dart';
@JsonSerializable()
class DetailBangunanModel {
  final int id;
  @JsonKey(name: "id_bangunan")
  final int idBangunan;
  @JsonKey(name: "images_path")
  final String imagePath; // URL gambar per section
  final String deskripsi; // Penjelasan per section

  DetailBangunanModel({
    required this.id,
    required this.idBangunan,
    required this.imagePath,
    required this.deskripsi,
  });

  factory DetailBangunanModel.fromJson(Map<String,dynamic> json)=> _$DetailBangunanModelFromJson(json);

  DetailBangunanEntity toEntity(){
    return DetailBangunanEntity(id, idBangunan, imagePath, deskripsi);
  }

}