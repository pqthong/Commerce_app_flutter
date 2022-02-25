import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/product_page.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, this.onPressed, this.imageUrl, this.price, this.productId, this.title}) : super(key: key);
  final VoidCallback? onPressed;
  final String? imageUrl;
  final String? title;
  final String? price;
  final String? productId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12)
        ),
        height: 250,
        margin: EdgeInsets.symmetric(horizontal: 24,vertical: 12),
        child: Stack(
          children: [
            Container(
              child: ClipRRect(
                child: Image.network(
                  imageUrl!,fit: BoxFit.cover,
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
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              height: 250,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(title!,style: Constants.regularDarkText,),
                    Text("\$$price",style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600
                    ),),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
            )

          ],

        ),
      ),
    );;
  }
}
