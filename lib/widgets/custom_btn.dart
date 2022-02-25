import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  const CustomBtn({Key? key, this.text, this.onPressed, this.outlineBtn, this.isLoading})
      : super(key: key);
  final String? text;
  final VoidCallback? onPressed;
  final bool? outlineBtn;
  final bool? isLoading;


  @override
  Widget build(BuildContext context) {

    bool _outlineBtn = outlineBtn ?? false ;
    bool _isLoading = isLoading ?? false ;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _outlineBtn ? Colors.transparent : Colors.black,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 2)),
        height: 65,
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Stack(
          children: [
            Visibility(
              visible: !_isLoading  ,
              child: Center(
                child: Text(
                  text ?? "Text",
                  style: TextStyle(
                      fontSize: 16,
                      color: _outlineBtn ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
