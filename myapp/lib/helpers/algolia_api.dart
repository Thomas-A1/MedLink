import 'package:algolia/algolia.dart';

class AlgoliaService {
  static const Algolia _algolia = Algolia.init(
    applicationId:
        'RLYKL7EYX0',
    apiKey: '51cade69d3e0a0b0b07be392f0a521c0',
  );

  static Algolia get algolia => _algolia;
}
