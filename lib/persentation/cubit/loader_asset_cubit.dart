import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kota_kota_hari_ini/common/constant.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'loader_asset_state.dart';

class LoaderAssetCubit extends Cubit<LoaderAssetState> {
  LoaderAssetCubit() : super(LoaderAssetInitial());

  void onloaded(BuildContext context) async {
    emit(LoaderAssetLoading());
    try {
      // Future.wait memungkinkan kita meload semua gambar secara PARALEL (bersamaan)
      // jadi lebih cepat daripada meload satu per satu.
      await Future.wait([
        ...Images.svgAssets.map((path) async {
          final loader = SvgAssetLoader(path);

          // 2. Paksa load bytes-nya ke memori sekarang
          // 'null' di sini adalah context (tidak wajib diisi untuk sekedar load bytes)
          await loader.loadBytes(null);
          
        }),
        ...Images.pngImage.map((path) async {
          // precacheImage butuh context untuk tahu ukuran layar/pixel ratio
          await precacheImage(AssetImage(path), context);
        }),
      ]);
      emit(LoaderAssetLoaded("done"));
    } catch (e) {
      emit(LoaderAssetError(e.toString()));
    }
  }
}
