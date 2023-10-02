import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';

import 'Routes.dart';

Widget next(BuildContext context, String screen, bool isActive, Function() pressed, {String? text, double wide = 300, Object? argument}) {
  final width = MediaQuery.of(context).size.width - 30;
  return Center(
      child: isActive ? Container(

        width: width,
    height: 60,
    decoration: ShapeDecoration(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
      ),
      gradient: linearGradient,
    ),
    child: MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      child: Text(
        screen == genderScreen ? imReady.tr() : text ?? nextS.tr(),
        style: const TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'SairaCondensed',),
      ),
      onPressed: () {
        pressed();
        changeScreen(screen, context, argument: argument);
      },
    ),
  ) : Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          color: Colors.grey,
        ),
        child: MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Text(
            screen == genderScreen ? imReady.tr() : nextS.tr(),
            style: const TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'SairaCondensed',),
          ),
          onPressed: () {

          },
        ),
      ));
}
