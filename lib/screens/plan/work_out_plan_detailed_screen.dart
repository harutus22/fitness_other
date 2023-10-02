import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/muscle_groups.dart';
import 'package:fitness/model/plan_model_static.dart';
import 'package:fitness/screens/plan/work_out_start_screen.dart';
import 'package:fitness/utils/back_button.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/const.dart';
import 'package:flutter/material.dart';

import '../../custom_class/divider_circle_painter.dart';
import '../../model/workout_model.dart';
import '../../model/workout_model_count.dart';
import '../../utils/words.dart';

class PlanDetailedScreen extends StatefulWidget {
  const PlanDetailedScreen({Key? key}) : super(key: key);

  @override
  State<PlanDetailedScreen> createState() => _PlanDetailedScreenState();
}

class _PlanDetailedScreenState extends State<PlanDetailedScreen> {
  List<WorkOutModel> list = [];
  List<WorkoutModelCount> listCount = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void fillList(List<int> a, List<int> b) {
    for (int i = 0; i < a.length; i++) {
      listCount.add(WorkoutModelCount(
          workOutModel: a[i], count: b[i], isTime: b[i] > 1000));
    }
  }

  String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final workout =
        ModalRoute.of(context)?.settings.arguments as PlanModelStatic;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: backButton(context)),
                Expanded(
                  flex: 2,
                  child: Text(
                      capitalizeAllWord(DateFormat('EEEE, MMM dd').format(DateTime.now())),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      workout.image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      workout.name!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                          color: Colors.white,
                        fontFamily: 'SairaCondensed',),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: databaseHelper.getWorkoutModels(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    list.addAll(snapshot.data!);
                    final warmUp = workout.warmUp!;
                    final warmUpTime = workout.warmUpTime!;
                    final training = workout.training!;
                    final trainingTime = workout.trainingTime!;
                    final hitch = workout.hitch!;
                    final hitchTime = workout.hitchTime!;
                    fillList(warmUp, warmUpTime);
                    fillList(training, trainingTime);

                    fillList(hitch, hitchTime);

                  }
                  return RawScrollbar(
                    thumbColor: const Color(0xffA96BEA),
                    radius: const Radius.circular(20),
                    thickness: 1,
                    child: ListView.builder(
                      itemBuilder: (context, position) {
                        final workoutModel = list.isNotEmpty ?
                        list.firstWhere((element) => element.id == listCount[position].workOutModel) :
                        WorkOutModel(name: "", difficulty: 1, muscleGroups: [MuscleGroups.absGroup], id: -1);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 2,
                                          color: const Color(0xffDADADA),
                                          height: 100,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ClipRRect(
                                      child: Image.asset(
                                        "assets/images/training/${workoutModel.id}.jpg",
                                        height: 80,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15,
                                          bottom: 10,
                                          left: 10,
                                          right: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(
                                                  workoutModel.name,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    fontFamily: 'SairaCondensed',),
                                                  overflow: TextOverflow.ellipsis,
                                                )),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(
                                                  getListMuscles(
                                                      workoutModel.muscleGroups),
                                                  style: const TextStyle(
                                                      color: Color(0xff696969),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    fontFamily: 'SairaCondensed',),
                                                  overflow: TextOverflow.ellipsis,
                                                )),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: RichText(
                                                text: TextSpan(children: [
                                              TextSpan(
                                                  text: listCount[position].isTime
                                                      ? "${(listCount[position].count.toInt() ~/ 1000).toInt().toString()} ${secText.tr()}"
                                                      : "x${listCount[position].count}",
                                                  style: TextStyle(
                                                      foreground: Paint()
                                                        ..shader =
                                                            textLinearGradient,
                                                    fontFamily: 'SairaCondensed',),)
                                            ])),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            position != list.length - 1
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 11),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CustomPaint(
                                          painter: DividerCirclePainter(),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        const Text(
                                          "Rest",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                            fontFamily: 'SairaCondensed',),
                                        )
                                      ],
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        );
                      },
                      itemCount: listCount.length,
                      shrinkWrap: true,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: (){
                  listCount.insert(0, WorkoutModelCount(workOutModel: -1, count: 0, isTime: false));
                  listCount.insert(workout.warmUp!.length + 1, WorkoutModelCount(workOutModel: -2, count: 0, isTime: false));
                  listCount.insert(workout.warmUp!.length + 2, WorkoutModelCount(workOutModel: -1, count: 1, isTime: false));
                  listCount.insert(workout.warmUp!.length + 2 + workout.training!.length,WorkoutModelCount(workOutModel: -2, count: 1, isTime: false));
                  listCount.insert(workout.warmUp!.length + 3 + workout.training!.length, WorkoutModelCount(workOutModel: -1, count: 2, isTime: false));
                  listCount.insert(workout.warmUp!.length + 5 + workout.training!.length + workout.hitch!.length, WorkoutModelCount(workOutModel: -2, count: 2, isTime: false));
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => WorkoutStartScreen(
                  name: workout.name!,
                  workoutCount: listCount,
                  workoutModel: list,
                  restTime: workout.restBetweenExercises == null ? 0 : workout.restBetweenExercises!,
                  timeMinutes: workout.trainingInMinutes == null ? 0 : workout.trainingInMinutes!,
                  warmUpCount: workout.warmUp == null ? 0 : workout.warmUp!.length,
                  trainingCount: workout.training == null ? 0 : workout.training!.length,
                  hitchCount: workout.hitch == null ? 0 : workout.hitch!.length,
                  )),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: linearGradient
                  ),
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      startText.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30, color: Colors.white,
                        fontFamily: 'SairaCondensed',),
                    ),
                  ),
                ),
              )
            )
          ]),
        ),
      ),
    );
  }
}
