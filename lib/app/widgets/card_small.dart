import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/app/constants/theme.dart';

class CardSmall extends StatelessWidget {
  const CardSmall(
      {Key? key,
      this.title = 'Placeholder Title',
      this.cta = '',
      this.img = 'https://via.placeholder.com/200',
      this.tap = defaultFunc})
      : super(key: key);

  final String cta;
  final String img;
  final Function tap;
  final String title;

  static void defaultFunc() {}

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Container(
      height: 235,
      child: GestureDetector(
        onTap: () => tap,
        child: Card(
            elevation: 0.4,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 2,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6)),
                            image: DecorationImage(
                              image: NetworkImage(img),
                              fit: BoxFit.cover,
                            )))),
                Flexible(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: const TextStyle(
                                  color: ArgonColors.header, fontSize: 13)),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(cta,
                                style: const TextStyle(
                                    color: ArgonColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          )
                        ],
                      ),
                    ))
              ],
            )),
      ),
    ));
  }
}
