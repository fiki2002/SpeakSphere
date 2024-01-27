import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:speak_sphere/cores/cores.dart';
import 'package:speak_sphere/features/home/home.dart';

class LessonView extends StatefulWidget {
  const LessonView({super.key, required this.slideInAnimation});
  final Animation<double> slideInAnimation;

  @override
  State<LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _slideInAnimation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _slideInAnimation = Tween<double>(begin: -500, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.125,
          curve: Curves.fastLinearToSlowEaseIn,
        ),
      ),
    );
    super.initState();
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
            children: [
              AnimatedBuilder(
                animation: widget.slideInAnimation,
                child: Column(
                  children: [
                    const _Header(),
                    const SizedBox(height: 30),
                    _TabBar(_controller),
                  ],
                ),
                builder: (context, _) {
                  return Transform.translate(
                    offset: Offset(0, widget.slideInAnimation.value),
                    child: _,
                  );
                },
              ),
              const SizedBox(height: 30),
              _Body(_slideInAnimation),
            ],
          ),
        ),
      ),
    );
  }
}

class ListItem {
  final String image;
  final String title;
  final String subtitle;
  final Color color;
  ListItem({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  static List<ListItem> items = [
    ListItem(
      image: bg1,
      title: 'First Trip',
      subtitle:
          'Here you will listen to conversations between tourists, and learn to speak together with them!',
      color: kBg1,
    ),
    ListItem(
      image: bg2,
      title: 'Freelance Work',
      subtitle:
          'After taking this classes, you will be able to take orders from foreigners! ',
      color: containerBgColor,
    ),
    ListItem(
      image: bg3,
      title: 'First Meeting',
      subtitle:
          'You will learn to communicate with your colleagues and understand them!',
      color: kBg2,
    ),
    ListItem(
      image: bg4,
      title: 'Meeting With Partners',
      subtitle:
          'You will learn to communicate with your colleagues and understand them!',
      color: kBlack.withOpacity(.89),
    ),
  ];
}

class _Body extends StatelessWidget {
  const _Body(this._slideInAnimation);
  final Animation<double> _slideInAnimation;

  @override
  Widget build(BuildContext context) {
    return Consumer<NavBarNotifier>(
      builder: (context, notifier, _) => switch (notifier.selectedLesson) {
        Lesson.audio => const AudioView(),
        Lesson.video => AnimatedBuilder(
            animation: _slideInAnimation,
            builder: (context, _) => Transform.translate(
              offset: Offset(0, -_slideInAnimation.value),
              child: const VideoView(),
            ),
          ),
      },
    );
  }
}

class VideoView extends StatelessWidget {
  const VideoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        SvgPicture.asset(broIcon),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 40),
            SvgPicture.asset(spin),
            const SizedBox(width: 50),
          ],
        ),
        const Text(
          'Coming Soon!',
          style: TextStyle(
            fontSize: 32,
            fontFamily: josefinSans,
            fontWeight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'We’ll be up soon, keep an eye\non us.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: josefinSans,
            color: kText3Color,
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 50),
            SvgPicture.asset(flash),
          ],
        ),
      ],
    );
  }
}

class AudioView extends StatefulWidget {
  const AudioView({super.key});

  @override
  State<AudioView> createState() => _AudioViewState();
}

class _AudioViewState extends State<AudioView> {
  @override
  Widget build(BuildContext context) {
    final List<ListItem> items = ListItem.items;
    return ListView.separated(
      separatorBuilder: (context, i) => const SizedBox(height: 35),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, i) => _buildWidget(
        image: items[i].image,
        title: items[i].title,
        subtitle: items[i].subtitle,
        color: items[i].color,
        index: i,
      ),
    );
  }

  Widget _buildWidget({
    required String image,
    required String title,
    required String subtitle,
    required Color color,
    required int index,
  }) {
    final Size size = MediaQuery.sizeOf(context);

    return Consumer<NavBarNotifier>(
      builder: (context, notifier, _) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 500 + (index * 100)),
          curve: Curves.easeInOut,
          transform: Matrix4.translationValues(
            notifier.animationStart ? 0 : size.width,
            0,
            0,
          ),
          height: size.height * .14,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: size.height * .12,
                  width: size.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        image,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          color: kWhite,
                          fontFamily: josefinSans,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: size.width * .4,
                        child: Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: kWhite,
                            fontFamily: josefinSans,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 10,
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: color,
                  child: SvgPicture.asset(playIcon),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar(this.controller);
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<NavBarNotifier>(
      builder: (context, notifier, _) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: kBorderColor2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              _buildContainer(
                title: 'Audio Lesson',
                isSelected: notifier.selectedLesson == Lesson.audio,
                onTap: () => notifier.onTabTapped(Lesson.audio),
              ),
              _buildContainer(
                title: 'Video Lesson',
                isSelected: notifier.selectedLesson == Lesson.video,
                onTap: () {
                  controller
                    ..reset()
                    ..forward();
                  notifier.onTabTapped(Lesson.video);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContainer({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          curve: Curves.easeInCirc,
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? kSecondaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? kWhite : kText1Color,
                fontFamily: josefinSans,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Center(
      child: Container(
        width: size.width * .8,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: kBorderColor2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(flagIcon),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(fayaIcon),
                const Text(
                  '2',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: josefinSans,
                  ),
                ),
              ],
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
    );
  }
}
