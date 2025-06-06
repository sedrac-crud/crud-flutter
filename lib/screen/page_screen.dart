import 'package:crud_flutter/screen/person_screen.dart';
import 'package:crud_flutter/screen/profile_screen.dart';
import 'package:flutter/material.dart';

class PageScreen extends StatefulWidget {
  const PageScreen({super.key});

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  final List<WidgetBuilder> _pages = [
        (_) => const ProfileScreen(),
        (_) => const PersonScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: const ClampingScrollPhysics(),
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (page) => setState(() => currentPage = page ),
        itemBuilder: (context, index) => _pages[index](context),
      ),
      bottomNavigationBar: NavigationBar(
        height: 70,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: currentPage,
        destinations: [
          NavigationDestination(icon: Icon(Icons.person_pin), label: "Perfil",),
          NavigationDestination(icon: Icon(Icons.people), label: "Usuários",),
        ],
        onDestinationSelected: (page) {
          _pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        },
      ),
    );
  }
}
