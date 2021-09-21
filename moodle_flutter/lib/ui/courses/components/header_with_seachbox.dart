import 'package:flutter/material.dart';

import 'package:moodle_flutter/utils/ui_data.dart';

class HeaderWithSearchBox extends StatelessWidget {
  const HeaderWithSearchBox({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: UIData.kDefaultPadding ),
      // It will cover 20% of our total height
      height: size.height * 0.2,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: UIData.kDefaultPadding,
              right: UIData.kDefaultPadding,
              bottom: UIData.kDefaultPadding,
            ),
            height: size.height * 0.2 - 27,

            child: Row(
              children: <Widget>[
                Text(
                  'Khoá học',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                // Image.asset("assets/icons/icon-id-true.png")
                // Icon(Icons.account_box_rounded),
                IconButton(
                  icon: Icon(Icons.account_box_rounded),
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: UIData.kDefaultPadding),
              padding: EdgeInsets.symmetric(horizontal: UIData.kDefaultPadding),
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: Colors.black87.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm khoá học",
                        hintStyle: TextStyle(
                          color: Colors.black87.withOpacity(0.2),
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  // Image.asset("assets/icons/icon-id-true.png"),
                  Icon(Icons.search)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
