import 'dart:math' as math;

import 'package:easy_date/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class LogoLoading extends StatefulWidget {
  const LogoLoading({super.key});

  @override
  State<LogoLoading> createState() => _LogoLoadingState();
}

class _LogoLoadingState extends State<LogoLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _sizeAnimation = Tween<double>(begin: 60.0, end: 80.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: child,
        );
      },
      child: SizedBox(
        width: _sizeAnimation.value,
        height: _sizeAnimation.value,
        child: SvgPicture.asset(
          Assets.ASSETS_ICONS_APP_ICON2_SVG,
          width: 80,
          height: 80,
        ),
      ),
    );
  }
}
