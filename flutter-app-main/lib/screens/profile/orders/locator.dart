import 'package:get_it/get_it.dart';
import 'package:grocapp/screens/profile/orders/core/firestore_model.dart';

import 'core/api.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Api('orders'));
  locator.registerLazySingleton(() => FirestoreModel());
}
