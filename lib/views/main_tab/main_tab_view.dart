import 'package:budgetfrontend/views/budgets/subscription_info_view.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:budgetfrontend/views/home/home_view.dart';
import 'package:budgetfrontend/views/budgets/budget_view.dart';
import 'package:budgetfrontend/views/transactions/transaction_view.dart';
import 'package:budgetfrontend/views/report/report_view.dart';

class MainTabView extends StatelessWidget {
  const MainTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      backgroundColor: Colors.transparent,
      tabs: [
        PersistentTabConfig(
          screen: const HomeView(),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: "Home",
          ),
        ),
        PersistentTabConfig(
          screen: const FamilyView(),
          item: ItemConfig(
            icon: const Icon(Icons.wallet),
            title: "Budgets",
          ),
        ),
        PersistentTabConfig(
          screen: const TransactionView(),
          item: ItemConfig(
            icon: const Icon(Icons.calendar_month),
            title: "Loans",
          ),
        ),
        PersistentTabConfig(
          screen: ReportView(),
          item: ItemConfig(
            icon: const Icon(Icons.credit_card),
            title: "Cards",
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style8BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}

class Style8BottomNavBar extends StatelessWidget {
  const Style8BottomNavBar({
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
    this.itemAnimationProperties = const ItemAnimation(),
    this.itemPadding = const EdgeInsets.all(5),
    super.key,
  });

  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;
  final EdgeInsets itemPadding;
  final ItemAnimation itemAnimationProperties;

  Widget _buildItem(ItemConfig item, bool isSelected) => AnimatedContainer(
        width: isSelected ? 120 : 50,
        duration: itemAnimationProperties.duration,
        curve: itemAnimationProperties.curve,
        padding: itemPadding,
        decoration: BoxDecoration(
          color: isSelected
              ? item.activeBackgroundColor
              : item.inactiveBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconTheme(
              data: IconThemeData(
                size: item.iconSize,
                color: isSelected
                    ? item.activeForegroundColor
                    : item.inactiveForegroundColor,
              ),
              child: isSelected ? item.icon : item.inactiveIcon,
            ),
            if (item.title != null && isSelected)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FittedBox(
                    child: Text(
                      item.title!,
                      style: item.textStyle.apply(
                        color: isSelected
                            ? item.activeForegroundColor
                            : item.inactiveForegroundColor,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );

  @override
Widget build(BuildContext context) => DecoratedNavBar(
  decoration: NavBarDecoration(
       color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
  ),
  filter: navBarConfig.selectedItem.filter,
  opacity: navBarConfig.selectedItem.opacity,
  height: navBarConfig.navBarHeight,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: navBarConfig.items.map((item) {
      final int index = navBarConfig.items.indexOf(item);
      return GestureDetector(
        onTap: () => navBarConfig.onItemSelected(index),
        child: _buildItem(
          item,
          navBarConfig.selectedIndex == index,
        ),
      );
    }).toList(),
  ),
);

}
