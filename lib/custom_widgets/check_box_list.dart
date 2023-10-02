import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/custom_check_box_model.dart';
import 'package:fitness/model/user_info_enums.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class MenuListView extends StatefulWidget {
  const MenuListView({Key? key, required this.passChosen}) : super(key: key);

  final Function(List<CheckBoxState>) passChosen;
  @override
  _MenuListViewState createState() => _MenuListViewState();
}

class _MenuListViewState extends State<MenuListView> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      children: List.generate(list.length, (index) => image(list[index])),
    );
  }

  Widget image(CheckBoxState item) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Container(
            alignment: Alignment.center,
            width: 120,
            height: 40,
            padding: EdgeInsets.all(5),
            decoration: !item.value
                ? BoxDecoration(
                color: Colors.transparent,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.grey))
                : const ShapeDecoration(
              shape: StadiumBorder(),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorMainGradLeft, colorMainGradRight],
              ),
            ),
            child: Text(item.title,
              textAlign: TextAlign.center,
              style: TextStyle(color: !item.value ? Colors.black: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'SairaCondensed',),),
          ),
        ),
        onTap: () {
          item.value = !item.value;
          widget.passChosen(list);
          setState(() {});
        },
      ),
    );
  }

  final list = [
    CheckBoxState(title: arm.tr(), focusArea: FocusArea.arm),
    CheckBoxState(title: chest.tr(), focusArea: FocusArea.chest),
    CheckBoxState(title: abs.tr(), focusArea: FocusArea.abs),
    CheckBoxState(title: leg.tr(), focusArea: FocusArea.leg),
    CheckBoxState(title: fullBody.tr(), focusArea: FocusArea.fullBody),
  ];
}
