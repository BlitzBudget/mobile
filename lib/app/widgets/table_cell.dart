import 'package:flutter/material.dart';

import 'package:mobile_blitzbudget/app/constants/theme.dart';

class TableCellSettings extends StatelessWidget {
  const TableCellSettings({Key? key, required this.title, required this.onTap})
      : super(key: key);

  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: ArgonColors.text)),
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.arrow_forward_ios,
                  color: ArgonColors.text, size: 14),
            )
          ],
        ),
      ),
    );
  }
}
