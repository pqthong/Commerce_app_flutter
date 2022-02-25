import 'package:flutter/material.dart';
import 'package:the_commerce/constants.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({Key? key, this.hintText, this.onChanged, this.onSubmitted, this.focusNode, this.textInputAction, this.isPasswordField}) : super(key: key);
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool? isPasswordField;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8,horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFFF2F2F2),
      ),
      child: TextField(
        obscureText: isPasswordField ?? false ,
        textInputAction: textInputAction,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 24,vertical: 18),
          border: InputBorder.none,
          hintText: hintText ?? "Hint text"
        ),
        style: Constants.regularDarkText ,
      ),
    );
  }
}
