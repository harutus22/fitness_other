import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/user_info_enums.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../utils/back_button.dart';
import '../../utils/custom_radio_button.dart';
import '../../utils/next_button.dart';
import '../../utils/routes.dart';

class BodyMassIndexScreen extends StatefulWidget {
  const BodyMassIndexScreen({Key? key}) : super(key: key);

  @override
  State<BodyMassIndexScreen> createState() => _BodyMassIndexScreenState();
}

class _BodyMassIndexScreenState extends State<BodyMassIndexScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 2, child: backButton(context)),
                  Expanded(
                      flex: 5,
                      child: Text(
                        bodyMassIndex.tr(),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontFamily: 'SairaCondensed',
                            fontSize: onboardingTextSize,
                            color: Colors.black,
                            fontWeight: FontWeight.w900
                        ),
                      )
                  )
                ],
              ),


              const SizedBox(height: 20,),
              Expanded(child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    bodyMassIndexText.tr(),
                    style: const TextStyle(
                        fontFamily: 'SairaCondensed',
                        fontSize: 16,
                        color: Colors.black
                    ),
                  ),
                ),
              ))
            ],
          )),
    );
  }

}
