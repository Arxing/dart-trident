library trident_builder.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:trident_generator/src/trident_generator.dart';

Builder tridentGenerator(BuilderOptions options) {
  return PartBuilder([TridentGenerator()], '.tg.dart');
}
