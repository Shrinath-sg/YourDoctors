import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final bool isRound;
  final double radius;
  final double height;
  final double width;

  final BoxFit fit;

  final String noImageAvailable =
      "https://www.esm.rochester.edu/uploads/NoPhotoAvailable.jpg";

  CachedImage(
    this.imageUrl, {
    this.isRound = false,
    this.radius = 0,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(isRound ? 50 : radius))),
        height: isRound ? radius : height,
        width: isRound ? radius : width,
        padding: EdgeInsets.all(3),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(isRound ? 50 : radius),
            child: (this.imageUrl == "" ||
                    this.imageUrl == null ||
                    this.imageUrl == "assets/images/defaultprofilepic.png")
                ? Image.asset("assets/images/defaultprofilepic.png",fit: BoxFit.cover,width: 40,height: 40,)
                : CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: fit,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Image.network(noImageAvailable, fit: BoxFit.cover),
                  )),
      );
    } catch (e) {
      print(e);
      return Image.network(noImageAvailable, fit: BoxFit.cover,width: 40,height: 40,);
    }
  }
}
