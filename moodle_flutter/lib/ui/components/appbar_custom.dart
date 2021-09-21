import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final String image, title;
  final double heightAppbar;
  final Size size;

  const AppBarCustom(
      {Key key,
      this.child,
      this.title,
      this.image,
      this.heightAppbar,
      this.size})
      : super(key: key);

  @override
  Size get preferredSize => (heightAppbar == null || heightAppbar == 0)
      ? size * 0.1
      : size * heightAppbar;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        centerTitle: true,
        title: AutoSizeText(
          title,
          maxLines: 2,
          style: TextStyle(fontSize: 23),
        ),
        flexibleSpace: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.fitWidth,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.darken),
              ),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
      ),
    );
  }
}
