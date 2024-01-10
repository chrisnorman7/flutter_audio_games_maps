/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $SoundsGen {
  const $SoundsGen();

  $SoundsFootstepsGen get footsteps => const $SoundsFootstepsGen();
  $SoundsInterfaceGen get interface => const $SoundsInterfaceGen();
}

class $SoundsFootstepsGen {
  const $SoundsFootstepsGen();

  /// File path: sounds/footsteps/Footstep_ForestFloor_01.wav
  String get footstepForestFloor01 =>
      'sounds/footsteps/Footstep_ForestFloor_01.wav';

  /// File path: sounds/footsteps/Footstep_ForestFloor_02.wav
  String get footstepForestFloor02 =>
      'sounds/footsteps/Footstep_ForestFloor_02.wav';

  /// File path: sounds/footsteps/Footstep_ForestFloor_03.wav
  String get footstepForestFloor03 =>
      'sounds/footsteps/Footstep_ForestFloor_03.wav';

  /// File path: sounds/footsteps/Footstep_ForestFloor_04.wav
  String get footstepForestFloor04 =>
      'sounds/footsteps/Footstep_ForestFloor_04.wav';

  /// File path: sounds/footsteps/Footstep_ForestFloor_05.wav
  String get footstepForestFloor05 =>
      'sounds/footsteps/Footstep_ForestFloor_05.wav';

  /// File path: sounds/footsteps/Footstep_ForestFloor_06.wav
  String get footstepForestFloor06 =>
      'sounds/footsteps/Footstep_ForestFloor_06.wav';

  /// File path: sounds/footsteps/Footstep_ForestFloor_07.wav
  String get footstepForestFloor07 =>
      'sounds/footsteps/Footstep_ForestFloor_07.wav';

  /// File path: sounds/footsteps/Footstep_ForestFloor_08.wav
  String get footstepForestFloor08 =>
      'sounds/footsteps/Footstep_ForestFloor_08.wav';

  /// File path: sounds/footsteps/Footstep_ForestFloor_09.wav
  String get footstepForestFloor09 =>
      'sounds/footsteps/Footstep_ForestFloor_09.wav';

  /// File path: sounds/footsteps/Footstep_ForestFloor_10.wav
  String get footstepForestFloor10 =>
      'sounds/footsteps/Footstep_ForestFloor_10.wav';

  /// List of all assets
  List<String> get values => [
        footstepForestFloor01,
        footstepForestFloor02,
        footstepForestFloor03,
        footstepForestFloor04,
        footstepForestFloor05,
        footstepForestFloor06,
        footstepForestFloor07,
        footstepForestFloor08,
        footstepForestFloor09,
        footstepForestFloor10
      ];
}

class $SoundsInterfaceGen {
  const $SoundsInterfaceGen();

  /// File path: sounds/interface/no_objects.wav
  String get noObjects => 'sounds/interface/no_objects.wav';

  /// File path: sounds/interface/object.wav
  String get object => 'sounds/interface/object.wav';

  /// List of all assets
  List<String> get values => [noObjects, object];
}

class Assets {
  Assets._();

  static const $SoundsGen sounds = $SoundsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
