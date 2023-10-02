import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/input_formater/height_input_formatter.dart';
import 'package:fitness/utils/routes.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';

import '../../utils/back_button.dart';
import '../../utils/const.dart';
import '../../utils/next_button.dart';

class UserHeightScreen extends StatefulWidget {
  const UserHeightScreen({Key? key}) : super(key: key);

  @override
  State<UserHeightScreen> createState() => _UserHeightScreenState();
}

class _UserHeightScreenState extends State<UserHeightScreen> {
  bool isNextActive = false;
  double height = 0;
  bool isCmChecked = false;
  double chooseHeight = 0;
  double chooseWidth = 0;
  final _userController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    chooseWidth = size.width * 0.25;
    chooseHeight = size.height * 0.04;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 1, child: backButton(context, isColor: false)),
              Expanded(
                  flex: 14,
                  child: Image.asset(
                    "assets/images/onboard_3.png",
                    alignment: Alignment.center,
                  ))
            ],
          ),
          RichText(
            text: TextSpan(
                text: whatHeight.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: onboardingTextSize,
                  fontFamily: 'SairaCondensed',
                )),
          ),
          // MenuGridView(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: chooseWidth,
                height: chooseHeight,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                    // border: Border.all(color: Colors.grey.shade200)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          isCmChecked = false;
                          _userController.clear();
                          setState(() {});
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: chooseHeight,
                          decoration: isCmChecked
                              ? BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                )
                              : BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      colorMainGradLeft,
                                      colorMainGradRight
                                    ],
                                  ),
                                ),
                          child: Text(
                            ft.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isCmChecked ? colorGreyText : Colors.white,
                              fontFamily: 'SairaCondensed',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          isCmChecked = true;
                          _userController.clear();
                          setState(() {});
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: chooseHeight,
                          decoration: isCmChecked
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      colorMainGradLeft,
                                      colorMainGradRight
                                    ],
                                  ),
                                )
                              : BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                          child: Text(
                            cm.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !isCmChecked ? colorGreyText : Colors.white,
                              fontFamily: 'SairaCondensed',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: colorGreyTextField,
                      border: Border.all(
                          width: 1,
                          color: colorGreyBoarder,
                          style: BorderStyle.solid)),
                  child: TextFormField(
                    controller: _userController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [HeightInputFormatter(isCm: isCmChecked)],
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        isNextActive = true;
                        height = double.parse(text);
                      } else {
                        isNextActive = false;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        hintText: enterHeight.tr(),
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          fontFamily: 'SairaCondensed',
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        border: InputBorder.none),
                  ),
                ),
              ),
            ],
          ),
          next(context, userCurrentWeightScreen, isNextActive, () {
            if(!isCmChecked){
              height = height * 0.3 * 100;
            }
            user.height = height;
          }),
          const SizedBox()
        ],
      )),
    );
  }
}
