import 'package:flutter/material.dart';

class TabManager extends ChangeNotifier {
  List<TabItem> tabs;
  int currentTab = 0;
  late List<GlobalKey<NavigatorState>> navigatorKeys;

  TabManager(this.tabs) {
    navigatorKeys = tabs.map((e) => GlobalKey<NavigatorState>()).toList();
  }

  NavigatorState? get navigatorState {
    return navigatorKeys[currentTab].currentState;
  }

  void selectTab(int index) {
    if (currentTab == index) {
      navigatorState!.popUntil((r) => r.isFirst);
    } else {
      currentTab = index;
      notifyListeners();
    }
  }
}

class TabItem {
  const TabItem(this.title, this.icon, this.router, {this.badge});
  final String title;
  final IconData icon;
  final Widget? Function(RouteSettings settings) router;
  final BadgeInfo? Function(BuildContext context)? badge;
}

class BadgeInfo {
  const BadgeInfo(this.label, this.color);
  final String label;
  final Color? color;
}
