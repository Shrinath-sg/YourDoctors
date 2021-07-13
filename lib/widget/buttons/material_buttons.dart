import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:flutter/material.dart';

class MaterialButtons extends StatelessWidget{
  MaterialButtons({@required this.onPressed,@required this.iconData});
  final GestureTapCallback onPressed;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialButton(

      color: CustomizedColors.primaryColor,
      child:Container(
          width:80 ,
          height:80 ,
          child: Icon(iconData,color: CustomizedColors.iconColor,size: 40,)),
      onPressed: onPressed,
      shape: const CircleBorder(),
    );
  }
}
