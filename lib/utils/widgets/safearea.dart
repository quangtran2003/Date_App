import 'package:easy_date/features/feature_src.dart';

class SDSSafeArea extends StatelessWidget {
  const SDSSafeArea({
    Key? key,
    required this.child,
    this.top = false,
    this.bottom = false,
    this.left = false,
    this.right = false,
  }) : super(key: key);

  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: bottom,
      left: left,
      right: right,
      top: top,
      child: child,
    );
  }
}
