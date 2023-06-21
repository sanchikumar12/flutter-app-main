import 'package:algolia/algolia.dart';

class AlgoliaApplication {
  static final Algolia algolia = Algolia.init(
    applicationId: 'RQVIN5NV9T', //ApplicationID
    apiKey:
        '4bba0d3037e6185e128a3aa76592f98c', //search-only api key in flutter code
  );
}
