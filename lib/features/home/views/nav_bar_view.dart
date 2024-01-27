import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:speak_sphere/cores/cores.dart';
import 'package:speak_sphere/features/home/home.dart';
import 'package:speak_sphere/features/home/views/coming_soon.dart';
import 'package:speak_sphere/features/home/views/lesson_view.dart';

class NavBarView extends StatefulWidget {
  const NavBarView({super.key});

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> with TickerProviderStateMixin {
  late AnimationController _controller;

  late AnimationController _comingSoonController;

  late Animation<double> _comingSoonAnimation;

  late Animation<double> _slideInAnimation;

  @override
  void dispose() {
    _controller.dispose();
    _comingSoonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _slideInAnimation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _comingSoonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _comingSoonAnimation = Tween<double>(begin: -500, end: 0).animate(
      CurvedAnimation(
        parent: _comingSoonController,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavBarNotifier>(
      builder: (context, notifier, _) {
        return Scaffold(
          body: IndexedStack(
            index: notifier.currentIndex,
            children: _screens(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: scaffoldBg,
            elevation: 3,
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              notifier.onNavBarTapped(value);

              if (value == 1) {
                context.read<NavBarNotifier>().startAnimation();
                _controller.forward();
              } else if (value == 2 || value == 3 || value == 4) {
                _comingSoonController
                  ..reset()
                  ..forward();
              } else {
                context.read<NavBarNotifier>().resetAnimation();
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: _Icon(
                  icon: homeIcon,
                  isSelected: notifier.currentIndex == 0,
                  title: 'Home',
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _Icon(
                  icon: lessonIcon,
                  isSelected: notifier.currentIndex == 1,
                  title: 'Lessons',
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _Icon(
                  icon: exerciseIcon,
                  isSelected: notifier.currentIndex == 2,
                  title: 'Exercises',
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _Icon(
                  icon: gamesIcon,
                  isSelected: notifier.currentIndex == 3,
                  title: 'Games',
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _Icon(
                  icon: chatIcon,
                  isSelected: notifier.currentIndex == 4,
                  title: 'Chats',
                ),
                label: '',
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _screens() {
    return [
      const HomeView(),
      LessonView(
        slideInAnimation: _slideInAnimation,
      ),
      ComingSoonView(
        slideInAnimation: _comingSoonAnimation,
      ),
      ComingSoonView(
        slideInAnimation: _comingSoonAnimation,
      ),
      ComingSoonView(
        slideInAnimation: _comingSoonAnimation,
      ),
    ];
  }
}

class _Icon extends StatelessWidget {
  const _Icon({
    Key? key,
    required this.icon,
    required this.isSelected,
    required this.title,
  }) : super(key: key);
  final String icon;
  final bool isSelected;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedOpacity(
          opacity: isSelected ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: SvgPicture.asset(tabIcon),
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.bounceIn,
          child: SvgPicture.asset(
            icon,
            // ignore: deprecated_member_use
            color: isSelected ? kSecondaryColor : kText1Color,
          ),
        ),
        const SizedBox(height: 5),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.bounceIn,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontFamily: josefinSans,
              color: isSelected ? kSecondaryColor : kText1Color,
            ),
          ),
        ),
      ],
    );
  }
}
