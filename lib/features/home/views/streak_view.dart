import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:speak_sphere/cores/cores.dart';

class StreakView extends StatefulWidget {
  const StreakView({super.key});

  @override
  State<StreakView> createState() => _StreakViewState();
}

class _StreakViewState extends State<StreakView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _textOpacityAnimation;
  late Animation<double> _fadeIn1Animation;
  late Animation<double> _fadeIn2Animation;
  late Animation<double> _slideInAnimation;
  late Animation<double> _fade;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.125, curve: Curves.easeIn),
      ),
    );
    _fadeIn1Animation = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.125, 0.25, curve: Curves.easeOut),
      ),
    );

    _fadeIn2Animation = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.3, curve: Curves.easeOut),
      ),
    );
    _slideInAnimation = Tween<double>(begin: -1000, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.4, curve: Curves.easeOut),
      ),
    );
    _fade = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.4, curve: Curves.easeOut),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    _controller
      ..reset()
      ..forward();

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            const SizedBox(height: 150),
            AnimatedBuilder(
              animation: _textOpacityAnimation,
              child: Row(
                children: [
                  SizedBox(
                    width: size.width * .35,
                  ),
                  SvgPicture.asset(sound),
                ],
              ),
              builder: (context, _) {
                return Opacity(
                  opacity: _textOpacityAnimation.value,
                  child: _,
                );
              },
            ),
            const Hero(
              tag: '2',
              child: Center(
                child: Material(
                  color: scaffoldBg,
                  child: Text(
                    '2',
                    style: TextStyle(
                      fontSize: 150,
                      fontWeight: FontWeight.w600,
                      fontFamily: josefinSans,
                      color: kSecondaryColor,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _fadeIn1Animation,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'days streak!',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: josefinSans,
                      color: kBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 5),
                  SvgPicture.asset(
                    fayaIcon,
                    height: 20,
                  )
                ],
              ),
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeIn1Animation.value,
                  child: child!,
                );
              },
            ),
            const SizedBox(height: 40),
            AnimatedBuilder(
              animation: _fadeIn2Animation,
              child: const _Container(),
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeIn2Animation.value,
                  child: child!,
                );
              },
            ),
            SizedBox(height: size.height * .14),
            AnimatedBuilder(
              animation: _slideInAnimation,
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(0, -_slideInAnimation.value),
                  child: Opacity(opacity: _fade.value, child: const _Buttons()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _Container extends StatelessWidget {
  const _Container();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 27),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ..._text.asMap().entries.map(
                (entry) {
                  int index = entry.key;
                  String value = entry.value;

                  return _ColumnWidget(
                    text: value,
                    isSelected: index == 0 || index == 1 ? true : false,
                  );
                },
              ).toList(),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            'You’re on a roll, great job! Practice each day to keep\nup with your streak and earn XP points.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontFamily: josefinSans,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.800000011920929),
            ),
          )
        ],
      ),
    );
  }
}

List<String> _text = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
];

class _ColumnWidget extends StatelessWidget {
  const _ColumnWidget({
    required this.text,
    required this.isSelected,
  });
  final String text;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: isSelected ? kSecondaryColor : kText1Color,
            fontWeight: FontWeight.w500,
            fontFamily: josefinSans,
          ),
        ),
        const SizedBox(height: 5),
        SvgPicture.asset(
          sound,
          // ignore: deprecated_member_use
          color: isSelected ? kSecondaryColor : kText1Color,
        )
      ],
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Column(
      children: [
        SizedBox(
          height: 56,
          width: size.width,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: kSecondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                fontSize: 20,
                fontFamily: josefinSans,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Share',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: josefinSans,
                color: kSecondaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
