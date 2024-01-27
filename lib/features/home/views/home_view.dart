import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speak_sphere/cores/cores.dart';
import 'package:speak_sphere/features/home/views/speak_view.dart';
import 'package:speak_sphere/features/home/views/streak_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _slideInAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _gridAnimation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _slideInAnimation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.125, curve: Curves.easeOut),
      ),
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.125, 0.250, curve: Curves.easeIn),
      ),
    );

    _gridAnimation = Tween<double>(begin: -600.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.250, 0.4, curve: Curves.fastLinearToSlowEaseIn),
      ),
    );
    super.initState();

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 19.0,
            right: 19.0,
            top: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedBuilder(
                animation: _slideInAnimation,
                builder: (context, _) {
                  return Transform.translate(
                    offset: Offset(0, _slideInAnimation.value),
                    child: const _Header(),
                  );
                },
              ),
              const SizedBox(height: 40),
              AnimatedBuilder(
                animation: _textOpacityAnimation,
                builder: (context, _) {
                  return Opacity(
                    opacity: _textOpacityAnimation.value,
                    child: const _TextContent(),
                  );
                },
              ),
              const SizedBox(height: 40),
              AnimatedBuilder(
                animation: _gridAnimation,
                builder: (context, _) {
                  return Transform.translate(
                    offset: Offset(0, -_gridAnimation.value),
                    child: GridView.builder(
                      itemCount: _items.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 36,
                        mainAxisSpacing: 36,
                      ),
                      itemBuilder: (context, int i) {
                        String title = _items.keys.elementAt(i);

                        String icon = _items[title]![0];
                        String subtext = _items[title]![1];
                        return _ContainerWidget(
                          onTap: () {
                            if (i == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SpeakView(),
                                ),
                              );
                            }
                          },
                          icon: icon,
                          title: title,
                          subtext: subtext,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Map<String, dynamic> _items = {
  'Reading': [bookIcon, '50'],
  'Listening': [headPhoneIcon, '50'],
  'Writing': [writingIcon, '70'],
  'Speaking': [speakingIcon, '25'],
  'Books': [booksIcon, '80'],
  'Quizzes': [quizIcon, '40'],
};

class _ContainerWidget extends StatelessWidget {
  const _ContainerWidget({
    required this.icon,
    required this.title,
    required this.subtext,
    required this.onTap,
  });
  final String icon;
  final String title;
  final String subtext;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 19),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: kBorderColor,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(icon),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: kBlack,
                fontSize: 20,
                fontFamily: josefinSans,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You completed $subtext%',
              style: const TextStyle(
                fontSize: 13,
                fontFamily: josefinSans,
                fontWeight: FontWeight.w600,
                color: kText1Color,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: 8,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: containerBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: size.width / 3 * (int.tryParse(subtext)! / 100),
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextContent extends StatelessWidget {
  const _TextContent();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Your\nLearning Sphere',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            fontFamily: josefinSans,
            color: kText2Color,
          ),
        ),
        SvgPicture.asset(gridIcon)
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: kBorderColor2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(flagIcon),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StreakView(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(fayaIcon),
                      const Hero(
                        tag: '2',
                        child: Text(
                          '2',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: josefinSans,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(archerIcon),
                    const Text(
                      '17',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: josefinSans,
                      ),
                    ),
                  ],
                ),
                SvgPicture.asset(notifIcon),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        const CircleAvatar(
          backgroundColor: containerBgColor2,
          radius: 20,
          backgroundImage: AssetImage(avatarIcon),
        )
      ],
    );
  }
}
