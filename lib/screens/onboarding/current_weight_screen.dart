import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';

import '../../utils/back_button.dart';
import '../../utils/const.dart';
import '../../utils/input_formater/weight_input_formatter.dart';
import '../../utils/next_button.dart';
import '../../utils/routes.dart';

class CurrentWeightScreen extends StatefulWidget {
  const CurrentWeightScreen({Key? key}) : super(key: key);

  @override
  State<CurrentWeightScreen> createState() => _CurrentWeightScreenState();
}

class _CurrentWeightScreenState extends State<CurrentWeightScreen> {

  bool isNextActive = false;
  double weight = 0;
  bool isKgChecked = false;
  bool lowerMinimum = false;
  double chooseHeight = 0;
  double chooseWidth = 0;
  final _userController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    chooseWidth = MediaQuery.of(context).size.width * 0.25;
    chooseHeight = MediaQuery.of(context).size.height * 0.04;
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: whatCurrentWeight.tr(),
                      ),
                      TextSpan(
                          text: current.tr(),
                          style: TextStyle(
                              foreground: Paint()..shader = textLinearGradient,
                            fontFamily: 'SairaCondensed',
                          )
                      ),
                      TextSpan(
                          text: weightText.tr(),
                      ),
                    ],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: onboardingTextSize,
                        fontFamily: 'SairaCondensed',
                      )),

                ),
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
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              isKgChecked = false;
                              _userController.clear();
                              setState(() {});
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: chooseHeight,
                              decoration: isKgChecked
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
                                lb.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isKgChecked ? colorGreyText : Colors.white,
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
                              isKgChecked = true;
                              _userController.clear();
                              setState(() {});
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: chooseHeight,
                              decoration: isKgChecked
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
                                kg.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: !isKgChecked ? colorGreyText : Colors.white,fontFamily: 'SairaCondensed',
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
                    child: Column(
                      children: [
                        Container(
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
                            inputFormatters: [WeightInputFormatter(isKg: isKgChecked)],
                            onChanged: (text) {
                              if (text.isNotEmpty) {
                                weight = double.parse(text);
                                if (isKgChecked) {
                                  if (weight < 40) {
                                    setState(() {
                                      lowerMinimum = true;
                                      isNextActive = false;
                                    });
                                  }
                                  else if (weight >= 40) {
                                    setState(() {
                                      lowerMinimum = false;
                                      isNextActive = true;
                                    });
                                  }
                                } else {
                                  if (weight < 88.8) {
                                    setState(() {
                                      lowerMinimum = true;
                                      isNextActive = false;
                                    });
                                  } else if (weight >= 88.8) {
                                    setState(() {
                                      lowerMinimum = false;
                                      isNextActive = true;
                                    });
                                  }
                                }
                              }
                              setState(() {});
                            },
                            decoration: InputDecoration(
                                hintText: enterCurrentWeight.tr(),
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  fontFamily: 'SairaCondensed',
                                ),
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        lowerMinimum
                            ? Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              isKgChecked
                                  ? "Minimum weight 40 kg"
                                  : "Minimum weight 88.18 lb",
                              style: TextStyle(color: Color(0xffFC0C0C)),
                            ))
                            : SizedBox()
                      ],
                    ),
                  ),
                ],
              ),
              next(context, userTargetWeightScreen, isNextActive, () {
                if(!isKgChecked){
                  weight = weight * 0.45;
                }
                user.weight = weight;
              }),
              const SizedBox()
            ],
          )),
    );
  }

  Timer? future;

  void futureJob(Function callback){
    if(future != null){
      if(future!.isActive){
        future!.cancel();
        future = Timer(Duration(milliseconds: 500), () {
          callback();
        });
      } else {
        future = Timer(Duration(milliseconds: 500), () {
          callback();
        });
      }
    } else {
      future = Timer(Duration(milliseconds: 500), () {
        callback();
      });
    }
  }
}
