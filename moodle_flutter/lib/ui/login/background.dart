import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
      Container(
      padding: EdgeInsets.only(top: size.height * 0.17),
        width: double.infinity,
        child: Text('Chào mừng đến với Ong vang hoc tap', textAlign: TextAlign.center)
      ),
          Transform.translate(
            offset: Offset(0, size.height * 0.25),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, -size.height * 0.2),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/busy_bee.gif'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
