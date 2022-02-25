import 'package:flutter/material.dart';

class ProductSize extends StatefulWidget {
   const ProductSize({Key? key, required this.productSize, this.onSelected}) : super(key: key);
  final List productSize;
  final Function(String)? onSelected;
  @override
  _ProductSizeState createState() => _ProductSizeState();
}

class _ProductSizeState extends State<ProductSize> {

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Row(
        children: [
          for ( int i =0 ; i< widget.productSize.length; i++)
            GestureDetector(
              onTap: (){
                widget.onSelected!(widget.productSize[i]);
                setState(() {
                  _selected = i ;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _selected == i ? Theme.of(context).accentColor : Colors.grey,
                  borderRadius: BorderRadius.circular(10)
                ),
                alignment: Alignment.center,
                child: Text (widget.productSize[i],style: TextStyle(
                  fontWeight: FontWeight.w600, color: _selected == i ? Colors.white : Colors.black, fontSize: 16
                ),),
              ),
            )

        ],
      ),
    );
  }
}
