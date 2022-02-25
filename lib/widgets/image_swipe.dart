import 'package:flutter/material.dart';

class ImageSwipe extends StatefulWidget {
  const ImageSwipe({Key? key, required this.imageList}) : super(key: key);
  final List imageList;
  @override
  _ImageSwipeState createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {
  int _selectedPage = 0 ;

  @override
  Widget build(BuildContext context) {


    return Container(
      child: Stack(
        children: [
          PageView(
            onPageChanged: (numPage){
              setState(() {
                _selectedPage = numPage;
                print (_selectedPage);
              });
            },
            children: [
              for(var i =0 ; i <widget.imageList.length;i++ )
                Container(
                  child: Image.network("${widget.imageList[i]}",
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    fit: BoxFit.cover,),
                )
            ],
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i =0 ; i< widget.imageList.length; i++ )
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: i == _selectedPage ? 25 :12,
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.5)
                    ),
                  )
              ],
            ),
          )
        ],
      ),
      height: 250,
    );
  }
}
