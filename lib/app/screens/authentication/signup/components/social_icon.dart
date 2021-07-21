import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/constants.dart';

class SocalIcon extends StatelessWidget {
  const SocalIcon({
    Key? key,
    this.iconSrc,
    this.press,
  }) : super(key: key);

  final String? iconSrc;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => press,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: primaryLightColor,
          ),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          iconSrc!,
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}
