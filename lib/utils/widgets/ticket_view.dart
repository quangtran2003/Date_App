import 'package:flutter/material.dart';

class CuponClipper extends CustomClipper<Path> {
  final double? radiusWith;
  final double? position;
  final int? quantity;
  final double? dotQuantity;
  CuponClipper({
    this.radiusWith,
    this.position,
    this.quantity,
    this.dotQuantity,
  });

  @override
  Path getClip(Size size) {
    Path path = Path();
    var right = position ?? size.width / 2;

    path
      ..lineTo(0, size.height)
      ..moveTo(0, 0)
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - right, size.height)
      ..arcToPoint(
        Offset(size.width - right, size.height),
        clockwise: false,
        radius: const Radius.circular(1),
      )
      ..lineTo(0.0, size.height)
      ..close();

    final radius = radiusWith ?? size.height * .05;

    final quantityTemp = quantity ?? 4;
    final dotQuantityTemp =
        dotQuantity != null ? (size.height * dotQuantity!) : (size.height * .2);

    Path holePath = Path();

    for (int i = 1; i <= quantityTemp; i++) {
      holePath.addOval(
        Rect.fromCircle(
          center: Offset(0, dotQuantityTemp * i),
          radius: radius,
        ),
      );
    }
    for (int i = 1; i <= quantityTemp; i++) {
      holePath.addOval(
        Rect.fromCircle(
          center: Offset(size.width, dotQuantityTemp * i),
          radius: radius,
        ),
      );
    }

    return Path.combine(
      PathOperation.difference,
      path,
      holePath,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class DolDurmaClipper extends CustomClipper<Path> {
  final double holeRadius;
  final double? position;
  bool verticalPath;

  DolDurmaClipper({
    required this.holeRadius,
    this.position,
    this.verticalPath = false,
  });

  @override
  Path getClip(Size size) {
    return Path.combine(
      PathOperation.difference,
      verticalPath ? getClipVertical(size) : getClipHorizontal(size),
      getClipAll(size),
    );
  }

  @override
  bool shouldReclip(DolDurmaClipper oldClipper) => true;

  Path getClipAll(Size size) {
    double radius = 15;
    Path pathAll = Path()
      ..addOval(
        Rect.fromCircle(
          center: const Offset(0, 0),
          radius: radius,
        ),
      )
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width, 0),
          radius: radius,
        ),
      )
      ..addOval(
        Rect.fromCircle(
          center: Offset(0, size.height),
          radius: radius,
        ),
      )
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width, size.height),
          radius: radius,
        ),
      );
    return pathAll;
  }

  Path getClipVertical(Size size) {
    var right = position ?? size.width / 2;
    final pathVertical = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - right - holeRadius, 0.0)
      ..arcToPoint(
        Offset(size.width - right, 0),
        clockwise: false,
        radius: const Radius.circular(1),
      )
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - right, size.height)
      ..arcToPoint(
        Offset(size.width - right - holeRadius, size.height),
        clockwise: false,
        radius: const Radius.circular(1),
      );
    pathVertical.lineTo(0.0, size.height);
    pathVertical.close();
    return pathVertical;
  }

  Path getClipHorizontal(Size size) {
    var bottom = position ?? size.height / 2;
    final pathHorizontal = Path()
      ..moveTo(0, 0)
      ..lineTo(0.0, size.height - bottom - holeRadius)
      ..arcToPoint(
        Offset(0, size.height - bottom),
        radius: const Radius.circular(1),
      )
      ..lineTo(0.0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height - bottom)
      ..arcToPoint(
        Offset(size.width, size.height - bottom - holeRadius),
        radius: const Radius.circular(1),
      );
    pathHorizontal.lineTo(size.width, 0.0);
    pathHorizontal.close();
    return pathHorizontal;
  }
}
