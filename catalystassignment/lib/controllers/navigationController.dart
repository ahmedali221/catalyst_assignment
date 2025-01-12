import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppPage {
  users,
  properties,
  bookings,
}

// Navigation Controller
class NavigationController extends StateNotifier<AppPage> {
  NavigationController() : super(AppPage.users);

  void setPage(AppPage page) {
    state = page;
  }
}

final navigationControllerProvider =
    StateNotifierProvider<NavigationController, AppPage>(
  (ref) => NavigationController(),
);
