import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/plan_model_static.dart';
import 'package:fitness/model/work_out_plan_item_model.dart';
import 'package:fitness/screens/challenges/challenge_screen.dart';
import 'package:fitness/screens/plan/work_out_start_screen.dart';
import 'package:fitness/utils/back_button.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/next_button.dart';
import 'package:fitness/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../../custom_class/divider_circle_painter.dart';
import '../../model/challane_model.dart';
import '../../model/workout_model.dart';
import '../../model/workout_model_count.dart';
import '../../utils/words.dart';

class ChallengeDetailedScreen extends StatefulWidget {
  const ChallengeDetailedScreen({Key? key, required this.map}) : super(key: key);

  final Map<String, Object> map;

  @override
  State<ChallengeDetailedScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeDetailedScreen> {

  late List<PlanModelStatic> planModelStatic;
  late ChallengeModel challengeItem;
  List<WorkOutModel> listCount = [];
  List<WorkoutModelCount> list = [];
  int _currentDay = 0;

  @override
  void initState() {
    planModelStatic = widget.map[challenge_plans] as List<PlanModelStatic>;
    challengeItem = widget.map[challenge_model] as ChallengeModel;
    databaseHelper.getWorkoutModels().then((value) {
      if (value.isNotEmpty) {
        listCount.addAll(value);
      }
    });
    super.initState();
  }

  void fillList(List<int> a, List<int> b) {
    for (int i = 0; i < a.length; i++) {
      list.add(WorkoutModelCount(
          workOutModel: a[i], count: b[i], isTime: b[i] > 1000));
    }
  }

  @override
  Widget build(BuildContext context) {
    for(var item = 0; item < challengeItem.isPassed!.length; item++){
      if(challengeItem.isPassed![item] == false){
        _currentDay = item;
        break;
      }
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 11 * 3,
                    decoration: BoxDecoration(
                      color: Color(0xff3f3c5b),
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter:
                        ColorFilter.mode(Colors.black.withOpacity(0.32),
                            BlendMode.dstATop),
                        image:  AssetImage(
                            challengeItem.image!,
                        ),
                      ),
                    ),
                  )

                ),
                Positioned.fill(
                  child: Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Text(
                        challengeItem.name!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.white, fontSize: 26,
                          fontFamily: 'SairaCondensed',),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                      child: backButton(context, isColor: false)),
                ))
              ],

            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Отличный комплексный челлендж. Приготовтесь к невероятному приображению всего тела!",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Color(0xff919BA9),
                fontSize: 17,
                fontFamily: 'SairaCondensed',
              ),),
            ),
            Expanded(
              child: Stack(
                children: [
                  LayoutGrid(
                    // set some flexible track sizes based on the crossAxisCount
                    columnSizes: [auto, auto, auto, auto, auto],
                    // set all the row sizes to auto (self-sizing height)
                    rowSizes: const [auto, auto, auto, auto, auto, auto],
                    rowGap: -10, // equivalent to mainAxisSpacing
                    columnGap: 0, // equivalent to crossAxisSpacing
                    // note: there's no childAspectRatio
                    children: List.generate(planModelStatic.length,
                            (index) =>
                            challengeItemWidget(
                                challengeItem.isPassed![index],index,  () {
                              // print(index);
                              // PlanModelStatic item = planModelStatic[index];
                              // final warmUp = item.warmUp!;
                              // final warmUpTime = item.warmUpTime!;
                              // final training = item.training!;
                              // final trainingTime = item.trainingTime!;
                              // final hitch = item.hitch!;
                              // final hitchTime = item.hitchTime!;
                              // fillList(warmUp, warmUpTime);
                              // fillList(training, trainingTime);
                              // fillList(hitch, hitchTime);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => WorkoutStartScreen(
                              //         name: item.name!,
                              //         workoutCount: list,
                              //         workoutModel: listCount,
                              //         restTime: item.restBetweenExercises == null ? 0 : item.restBetweenExercises!,
                              //         timeMinutes: item.trainingInMinutes == null ? 0 : item.trainingInMinutes!,
                              //         challengeItem: challengeItem,
                              //       )),
                              // );
                            })),
                  ),
                  // GridView.count(crossAxisCount: 5,
                  // children: List.generate(planModelStatic.length,
                  //         (index) =>
                  //     challengeItemWidget(
                  //         challengeItem.isPassed![index],index,  () {
                  //     print(index);
                  //       PlanModelStatic item = planModelStatic[index];
                  //     final warmUp = item.warmUp!;
                  //     final warmUpTime = item.warmUpTime!;
                  //     final training = item.training!;
                  //     final trainingTime = item.trainingTime!;
                  //     final hitch = item.hitch!;
                  //     final hitchTime = item.hitchTime!;
                  //     fillList(warmUp, warmUpTime);
                  //     fillList(training, trainingTime);
                  //     fillList(hitch, hitchTime);
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => WorkoutStartScreen(
                  //               name: item.name!,
                  //               workoutCount: list,
                  //               workoutModel: listCount,
                  //               restTime: item.restBetweenExercises == null ? 0 : item.restBetweenExercises!,
                  //               timeMinutes: item.trainingInMinutes == null ? 0 : item.trainingInMinutes!,
                  //               challengeItem: challengeItem,
                  //             )),
                  //       );
                  // })),),
                  !user.isSubscribed ?
                  Positioned(
                    bottom: -15,
                    right: -10,
                    child: lockedScreen(),
                  ) : SizedBox(),
                ],
              )
            ),
            InkWell(
              onTap: () async {
                if(!user.isSubscribed){
                  if(_currentDay > 9) {
                    await changeScreen(payWallScreen, context, argument: canPop);
                    setState(() {});
                  } else {
                    startExercise();
                  }
                } else {
                  startExercise();
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  gradient: linearGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Start Day " + (_currentDay + 1).toString(),
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontFamily: 'SairaCondensed',
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  void startExercise(){
    PlanModelStatic item = planModelStatic[_currentDay];
    final warmUp = item.warmUp!;
    final warmUpTime = item.warmUpTime!;
    final training = item.training!;
    final trainingTime = item.trainingTime!;
    final hitch = item.hitch!;
    final hitchTime = item.hitchTime!;
    fillList(warmUp, warmUpTime);
    fillList(training, trainingTime);
    fillList(hitch, hitchTime);
    list.insert(0, WorkoutModelCount(workOutModel: -1, count: 0, isTime: false));
    list.insert(warmUp.length, WorkoutModelCount(workOutModel: -2, count: 0, isTime: false));
    list.insert(warmUp.length + 1, WorkoutModelCount(workOutModel: -1, count: 1, isTime: false));
    list.insert(warmUp.length + 1 + training.length,WorkoutModelCount(workOutModel: -2, count: 1, isTime: false));
    list.insert(warmUp.length + 2 + training.length, WorkoutModelCount(workOutModel: -1, count: 2, isTime: false));
    list.insert(warmUp.length + 5 + training.length + hitch.length, WorkoutModelCount(workOutModel: -2, count: 2, isTime: false));
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              WorkoutStartScreen(
                name: item.name!,
                workoutCount: list,
                workoutModel: listCount,
                restTime: item.restBetweenExercises == null
                    ? 0
                    : item.restBetweenExercises!,
                timeMinutes: item.trainingInMinutes == null
                    ? 0
                    : item.trainingInMinutes!,
                challengeItem: challengeItem,
                warmUpCount: item.warmUp!.length,
                trainingCount: item.training!.length,
                hitchCount: item.hitch!.length,
              )),
    );
  }

  Widget challengeItemWidget(bool isChecked,  int index, Function() clicked){
    return GestureDetector(
      onTap: () {
        if(!isChecked)
        clicked();
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            decoration: isChecked ? BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorMainGradLeft, colorMainGradRight],
                )
            ):_currentDay == index ? BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorMainGradLeft, colorMainGradRight],
                )
            ): BoxDecoration(),
            child: !isChecked ? Padding(
              padding: const EdgeInsets.all(2),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xffE8E9EE), Color(0xffE8E9EE)],
                      )),

                ),
              ),
            ) : null,
          ),
          isChecked ? Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ) : Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget lockedScreen(){
    return GestureDetector(
      onTap:() async {
        if(user.isSubscribed == false){
          await changeScreen(payWallScreen, context, argument: canPop);
          setState(() {});
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
        width: MediaQuery.of(context).size.width ,
        height: MediaQuery.of(context).size.height / 9 * 3,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/back_challenge.png"),
        //     fit: BoxFit.cover
        //   )
        // ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/premium.png", height: 30,),
                SizedBox(width: 10,),
                Text(bePremiumText.tr(), style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, foreground: Paint()..shader = textLinearGradient,fontFamily: 'SairaCondensed',), )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
