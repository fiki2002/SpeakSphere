import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:speak_sphere/cores/cores.dart';
import 'package:speak_sphere/features/features.dart';

class SelectInterestView extends StatefulWidget {
  const SelectInterestView({super.key});

  @override
  State<SelectInterestView> createState() => _SelectInterestViewState();
}

class _SelectInterestViewState extends State<SelectInterestView>
    with TickerProviderStateMixin {
  late AnimationController _slideLeftController;
  late Animation<Offset> _slideLeftAnimation;

  late AnimationController _fadeInController;
  late Animation<double> _fadeInAnimation;

  late AnimationController _slideBottomController;
  late Animation<double> _slideBottomAnimation;

  @override
  void dispose() {
    _slideLeftController.dispose();
    _fadeInController.dispose();
    _slideBottomController.dispose();
    
    super.dispose();
  }

  @override
  void initState() {
    _slideLeftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _slideLeftAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _slideLeftController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeInController,
        curve: Curves.easeInOut,
      ),
    );

    _slideBottomController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _slideBottomAnimation = Tween<double>(
      begin: -600,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _slideBottomController,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );

    _slideLeftController.forward();
    Future.delayed(const Duration(seconds: 1), () {
      _fadeInController.forward();
    });
    Future.delayed(const Duration(seconds: 2), () {
      _slideBottomController.forward();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 10.0,
            left: 10.0,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedBuilder(
                  animation: _fadeInAnimation,
                  builder: (context, _) {
                    return Opacity(
                      opacity: _fadeInAnimation.value,
                      child: const _Header(),
                    );
                  },
                ),
                const SizedBox(height: 30),
                SlideObject(
                  slideAnimation: _slideLeftAnimation,
                  child: const _TextContent(),
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _fadeInAnimation,
                  builder: (context, _) {
                    return Opacity(
                      opacity: _fadeInAnimation.value,
                      child: _SelectInterestChips(),
                    );
                  },
                ),
                SizedBox(height: size.height * .2),
                AnimatedBuilder(
                  animation: _slideBottomAnimation,
                  builder: (context, _) {
                    return Transform.translate(
                      offset: Offset(0, -_slideBottomAnimation.value),
                      child: const _Buttons(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TextContent extends StatelessWidget {
  const _TextContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          whatInterestsYou,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: josefinSans,
            color: kBlack,
          ),
        ),
        SizedBox(height: 10),
        Text(
          selectAllThatApplies,
          style: TextStyle(
            fontSize: 13,
            fontFamily: josefinSans,
            fontWeight: FontWeight.w600,
            color: kText1Color,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Consumer<SelectionNotifier>(
      builder: (context, viewModel, _) {
        return Row(
          children: [
            SvgPicture.asset(arrowLeftIcon),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 15,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: containerBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: ((size.width * .9) / 6) *
                      viewModel.selectedIndices.length,
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.bounceIn,
              child: Text(
                '${viewModel.selectedIndices.length}/6',
                style: const TextStyle(
                  color: kBlack,
                  fontWeight: FontWeight.w600,
                  fontFamily: josefinSans,
                  fontSize: 13,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class _SelectInterestChips extends StatefulWidget {
  @override
  _SelectInterestChipsState createState() => _SelectInterestChipsState();
}

class _SelectInterestChipsState extends State<_SelectInterestChips> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionNotifier>(
      builder: (context, notifier, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                notifier.list.length,
                (index) => _SelectChipSection(
                  text: notifier.list[index],
                  onTap: () => notifier.toggleChip(index),
                  isSelected: notifier.isSelectedList[index],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: containerBgColor1,
                border: Border.all(color: kBorderColor1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add other',
                    style: TextStyle(
                      color: kWhite,
                      fontFamily: josefinSans,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.add,
                    size: 15,
                    color: kWhite,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SelectChipSection extends StatelessWidget {
  const _SelectChipSection({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        switchInCurve: Curves.bounceInOut,
        duration: const Duration(milliseconds: 300),
        child: isSelected
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: containerBgColor1,
                  border: Border.all(color: kBorderColor1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: kWhite,
                    fontFamily: josefinSans,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : DottedBorder(
                borderType: BorderType.RRect,
                color: kBorderColor,
                dashPattern: const [6, 4],
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                radius: const Radius.circular(30),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: kBlack,
                    fontFamily: josefinSans,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
      ),
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NavBarView(),
              ),
            ),
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NavBarView(),
              ),
            ),
            child: const Text(
              'Skip for now',
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
