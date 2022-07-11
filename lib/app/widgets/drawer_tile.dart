import 'package:flutter/material.dart';

import 'package:mobile_blitzbudget/app/constants/theme.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onTap,
      this.isSelected = false,
      this.iconColor = ArgonColors.text})
      : super(key: key);

  final String title;
  final IconData icon;
  final Function onTap;
  final bool isSelected;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap,
      child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: isSelected ? ArgonColors.primary : ArgonColors.white,
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Row(
            children: [
              Icon(icon,
                  size: 20, color: isSelected ? ArgonColors.white : iconColor),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(title,
                    style: TextStyle(
                        letterSpacing: .3,
                        fontSize: 15,
                        color: isSelected
                            ? ArgonColors.white
                            : const Color.fromRGBO(0, 0, 0, 0.7))),
              )
            ],
          )),
    );
  }
}
