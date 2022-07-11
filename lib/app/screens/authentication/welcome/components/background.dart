import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/onboard-background.png'),
                  fit: BoxFit.cover))),
      Padding(
          padding:
              const EdgeInsets.only(top: 73, left: 32, right: 32, bottom: 16),
          child: child)
    ]));
  }
}
