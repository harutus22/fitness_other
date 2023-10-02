import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/custom_plan_model.dart';
import 'package:fitness/utils/back_button.dart';
import 'package:flutter/material.dart';

import '../../custom_class/divider_circle_painter.dart';
import '../../model/workout_model.dart';
import '../../model/workout_model_count.dart';
import '../../utils/colors.dart';
import '../../utils/const.dart';
import '../../utils/routes.dart';
import '../../utils/words.dart';
import '../plan/work_out_start_screen.dart';

class CreatedDetailedPreStartScreen extends StatefulWidget {
  const CreatedDetailedPreStartScreen({Key? key}) : super(key: key);

  @override
  State<CreatedDetailedPreStartScreen> createState() =>
      _CreatedDetailedPreStartScreenState();
}

class _CreatedDetailedPreStartScreenState
    extends State<CreatedDetailedPreStartScreen> {
  List<WorkOutModel> _workouts = [];
  List<WorkOutModel> passingWorkouts = [];
  bool isPassed = false;

  @override
  void initState() {
    super.initState();
  }

  void initWorkoutModel(PlanModel planModel) async {
    databaseHelper.getWorkoutModels().then((value) => {
          for (var item in planModel.countModelList){
              _workouts.add(value.where((element) => element.id == item.workOutModel).single)
            },
      passingWorkouts.addAll(value),
          setState(() {})
        });
  }

  @override
  Widget build(BuildContext context) {
    final planWorkout = ModalRoute.of(context)?.settings.arguments as PlanModel;
    if (!isPassed) {
      initWorkoutModel(planWorkout);
      isPassed = true;
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: backButton(context, isColor: true)),
                Expanded(
                  flex: 2,
                  child: Text(
                    // DateFormat('EEEE, MMM dd').format(DateTime.now()),
                    "",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black,
                      fontFamily: 'SairaCondensed',),
                  ),
                ),
                InkWell(
                  onTap: (){
                    final map = {
                      'name_count': planWorkout.name,
                      'workout_list': planWorkout
                    };
                    changeScreen(createExerciseFinalScreen, context, argument: map);
                  },
                  child: Text(
                    edit.tr(),
                    style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                      fontFamily: 'SairaCondensed',),
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
                  Center(
                    child: Text(
                    planWorkout.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        color: Colors.black,
                      fontFamily: 'SairaCondensed',),
                  ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, position) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
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
                                  "assets/images/training/${_workouts[position].id}.jpg",
                                  height: 80,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, bottom: 10, left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        _workouts[position].name,
                                        style: TextStyle(fontSize:
                                        _workouts[position].name == shadowBoxingWhileTunningInPlace.tr()
                                            ? 16
                                            : 20,fontFamily: 'SairaCondensed',),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        getListMuscles(
                                            _workouts[position].muscleGroups),
                                        style:
                                            TextStyle(color: Color(0xff696969),
                                              fontFamily: 'SairaCondensed',),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: getTime(
                                                    planWorkout
                                                        .countModelList[
                                                            position]
                                                        .isTime,
                                                    planWorkout
                                                        .countModelList[
                                                            position]
                                                        .count)
                                                .replaceAll("\n", " "),
                                            style: TextStyle(
                                                foreground: Paint()
                                                  ..shader =
                                                      textLinearGradient,
                                              fontFamily: 'SairaCondensed',))
                                      ])),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      position != _workouts.length - 1
                          ? Padding(
                              padding: const EdgeInsets.only(left: 11),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                          : SizedBox()
                    ],
                  );
                },
                itemCount: _workouts.length,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: const ShapeDecoration(
                  shape: StadiumBorder(),
                  gradient: linearGradient,
                ),
                child: MaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: const StadiumBorder(),
                  child: Text(
                    startText.tr(),
                    style: const TextStyle(fontSize: 20, color: Colors.white,
                      fontFamily: 'SairaCondensed',),
                  ),
                  onPressed: () {
                    planWorkout.countModelList.insert(0, WorkoutModelCount(workOutModel: -1, count: 1, isTime: false));
                    planWorkout.countModelList.insert(planWorkout.countModelList.length,
                        WorkoutModelCount(workOutModel: -2, count: 1, isTime: false));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkoutStartScreen(
                            name: planWorkout.name,
                            workoutCount: planWorkout.countModelList,
                            workoutModel: passingWorkouts,
                            restTime: 30000,
                            timeMinutes: 0,
                            warmUpCount: 0,
                              trainingCount: 0,
                              hitchCount: 0,
                            isCustom: true,
                          )),
                    );
                  },
                ),
              )
            )
          ]),
        ),
      ),
    );
  }
}
