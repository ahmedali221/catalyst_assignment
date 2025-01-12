import 'package:flutter_riverpod/flutter_riverpod.dart';

final roleProvider = StateProvider<String?>((ref) => null);
final statusProvider = StateProvider<String?>((ref) => null);

enum AppPage {
  users,
  properties,
  bookings,
}

final currentPageProvider = StateProvider<AppPage>((ref) => AppPage.users);
