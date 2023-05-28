import 'package:flutter/services.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:global_configuration/global_configuration.dart';

Future<SpriteSheet> loadSpriteSheet() async {
  ImageMap imageMap = ImageMap(bundle: rootBundle);

  await imageMap.loadImage(GlobalConfiguration().getString("spriteSheet"));

  String json = await rootBundle
      .loadString(GlobalConfiguration().getString("spriteSheetJson"));

  SpriteSheet spriteSheet = SpriteSheet(
      image: imageMap[GlobalConfiguration().getString("spriteSheet")]!,
      jsonDefinition: json);

  return spriteSheet;
}

Future<ImageMap> loadWeatherImages() async {
  ImageMap imageMap = ImageMap(bundle: rootBundle);
  await imageMap.load(<String>[
    'assets/images/clouds-0.png',
    'assets/images/clouds-1.png',
  ]);
  return imageMap;
}
