import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/app/constants/theme.dart';

class CardCategory extends StatelessWidget {
  const CardCategory(
      {Key? key,
      this.title = 'Placeholder Title',
      this.img = 'https://via.placeholder.com/250',
      this.tap = defaultFunc})
      : super(key: key);

  final String img;
  final Function tap;
  final String title;

  static void defaultFunc() {}

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 252,
        child: GestureDetector(
          onTap: () => tap,
          child: Card(
              elevation: 0.4,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Stack(children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        image: DecorationImage(
                          image: NetworkImage(img),
                          fit: BoxFit.cover,
                        ))),
                Container(
                    decoration: const BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
                Center(
                  child: Text(title,
                      style: const TextStyle(
                          color: ArgonColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
                )
              ])),
        ));
  }
}
