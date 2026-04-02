import 'package:easy_date/features/feature_src.dart';

class SDSSafeArea extends StatelessWidget {
  const SDSSafeArea({
    super.key,
    required this.child,
    this.top = false,
    this.bottom = false,
    this.left = false,
    this.right = false,
  });

  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: child,
    );
  }
}
