import 'package:flutter/material.dart';
import 'package:moodle_flutter/ui/components/text_field.dart';
import 'package:moodle_flutter/utils/ui_data.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: "Mật khẩu",
          icon: Icon(
            Icons.lock,
            color: Colors.black,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}