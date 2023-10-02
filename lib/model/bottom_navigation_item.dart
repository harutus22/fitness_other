import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/colors.dart';
import '../utils/custom_icons/create_final_custom_icons.dart';

class BottomNavigationItem{
  showItem(bool pageActive, String text, double sizeIcon, String icon){
    return BottomNavigationBarItem(icon: ShaderMask(
      shaderCallback: (Rect bounds) {
        return  pageActive ? bottomItemTextGradient : LinearGradient(colors: [Colors.grey, Colors.grey]).createShader(bounds);
      },
      child: SvgPicture.asset(
        icon,
        height: sizeIcon,
        color: pageActive ? Colors.white : Colors.grey,
      ),
    ),
    label: text);
  }
}