import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/screens/create/create_exercise_final.dart';
import 'package:fitness/utils/Routes.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/next_button.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../utils/back_button.dart';
import '../main_menu_screen.dart';

class NameWorkoutScreen extends StatefulWidget {
  const NameWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<NameWorkoutScreen> createState() => _NameWorkoutScreenState();
}

class _NameWorkoutScreenState extends State<NameWorkoutScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
    databaseHelper.getPlanModels().then((value) => {
          if (name == "")
            {
              name = "${workoutNumber.tr()}${value.length + 1}",
              _controller.text = name,
              if (name.isNotEmpty) {isNextActive = true},
              setState(() {})
            }
        });
  }

  bool isNextActive = false;
  String name = "";
  late TextEditingController _controller;
  bool _isPassed = false;
  Object? route;

  @override
  Widget build(BuildContext context) {
    if (!_isPassed) {
      route = ModalRoute.of(context)?.settings.arguments;
      name = route == null ? name : route as String;
      _controller.text = name;
      _isPassed = true;
      if (name.isNotEmpty) {
        isNextActive = true;
      }
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Align(alignment: Alignment.bottomLeft, child: backButton(context, isColor: true)),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    nameWorkout.tr(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black,fontFamily: 'SairaCondensed',
                    fontSize: 24),
                  ),
                )
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: _controller,
                        onChanged: (text) {
                          if (text.isNotEmpty) {
                            isNextActive = true;
                          } else {
                            isNextActive = false;
                          }
                          name = text;
                          setState(() {});
                        },
                      ),
                      Positioned(
                        bottom: 1,
                        child: Container(
                          height: 3,
                          width: MediaQuery.of(context).size.width - 20,
                          decoration: BoxDecoration(
                            gradient: linearGradient,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: next(
                        context,
                        route == null ? chooseWorkoutScreen : "",
                        isNextActive,
                        () => {
                              if (route != null) {Navigator.pop(context, name)}
                            },
                        argument: name))),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
