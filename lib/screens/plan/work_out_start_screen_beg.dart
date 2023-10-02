import 'dart:io';
import 'dart:math';

import 'package:custom_timer/custom_timer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/workout_model.dart';
import 'package:fitness/model/workout_model_count.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/video_player.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/challane_model.dart';
import '../../utils/Routes.dart';
import '../../utils/const.dart';
import '../challenges/challenge_screen.dart';
import '../main_menu_screen.dart';

class WorkoutStartScreen extends StatefulWidget {
  WorkoutStartScreen({
    Key? key,
    required this.name,
    required this.workoutCount,
    required this.workoutModel,
    required this.restTime,
    required this.timeMinutes,
    this.challengeItem,
    required this.warmUpCount,
    required this.trainingCount,
    required this.hitchCount
  }) : super(key: key);

  final List<WorkoutModelCount> workoutCount;
  final List<WorkOutModel> workoutModel;
  final String name;
  final int restTime;
  final int timeMinutes;
  final int warmUpCount;
  final int trainingCount;
  final int hitchCount;
  ChallengeModel? challengeItem;


  @override
  State<WorkoutStartScreen> createState() => _WorkoutStartScreenState();
}

class _WorkoutStartScreenState extends State<WorkoutStartScreen> with SingleTickerProviderStateMixin {
  bool _isPaused = false;
  bool _wantQuit = false;
  int restingTime = 0;
  double? width;
  double colories = 0;
  String totalTime = "00:00";
  int total = 0;
  bool preCount = true;
  late Directory dir;
  int position = 0;
  final List<GlobalKey> keys = [];
  ScrollController listScroll = ScrollController();
  int positionCount = 0;
  double bottomItemHeight = 0;
  int bottomItemCount = 0;
  double pos= 0;

  late final CustomTimerController _controllerTimeUp = CustomTimerController(
      vsync: this,
      begin: const Duration(),
      end: const Duration(hours: 24),
      initialState: CustomTimerState.reset,
      interval: CustomTimerInterval.milliseconds
  );

  void getPath() async {
    dir = await getApplicationDocumentsDirectory();
  }

  @override
  void initState() {
    for(final item in widget.workoutCount){
      keys.add(GlobalKey());
    }
    getPath();
    restingTime = widget.restTime;
    final preColories =
        widget.workoutCount.map((e) => e.count > 1000 ? e.count / 1000 : 0);
    total = 0;
    preColories.forEach((element) {
      if (element != 0) {
        colories += 6 + 3 * Random().nextDouble();
        total += element.toInt();
      }
    });
    final minute = (total ~/ 60).toString().padLeft(2, "0");
    final seconds = (total % 60).toString().padLeft(2, "0");
    totalTime = "$minute:$seconds";
    _controllerTimeUp.start();
    _controllerTimeUp.state.addListener(() {
      final res = _controllerTimeUp.remaining.value.duration;
      total = res.inSeconds;
      var minutesForCalories = res.inMinutes;
      while(minutesForCalories != 0){
        colories += 6 + 3 * Random().nextDouble();
        minutesForCalories--;
      }
      final minute = (total ~/ 60).toString().padLeft(2, "0");
      final seconds = (total % 60).toString().padLeft(2, "0");
      totalTime = "$minute:$seconds";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width ??= MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
                      child: Text("Разминка", style: TextStyle(color: Colors.grey),)),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTimer(
                            controller: _controllerTimeUp,
                            builder: (state, time) {
                              return Text(
                                  "${time.minutes}:${time.seconds}",
                                  style: TextStyle(fontSize: 48.0, color: Colors.white)
                              );
                            }
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left: 10, top: 15),
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "готово", style: TextStyle(color: Colors.grey),
                            )
                          ),
                        ),

                        Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: (){
                                _controllerTimeUp.pause();
                                // keys[position].currentState?.pauseStartTimer(true, position);
                                _isPaused = true;
                                pos = listScroll.position.pixels;
                                setState(() {});
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                  child: SvgPicture.asset("assets/images/pause.svg", height: 40,),),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(itemBuilder: (context, index){
                      WorkoutModelCount currentWork = widget.workoutCount[index];
                      WorkOutModel workoutModel = widget.workoutModel.firstWhere((element) => element.id == currentWork.workOutModel);
                      final width = MediaQuery.of(context).size.width;
                      // }
                      return Column(
                        children: [
                          if((index == 0 && positionCount == 0) ||
                              (index == widget.warmUpCount && positionCount == 1) ||
                              (index == widget.warmUpCount + widget.trainingCount && positionCount == 2))
                            TopItemWidget(width, width, index),
                          WorkoutVideoPlayer(key :keys[index], workoutModel: workoutModel, currentWork: currentWork,nextExercise: (){
                            position++;
                            if(index == widget.warmUpCount -1 || index == widget.trainingCount-1 + widget.warmUpCount ||
                                index == widget.trainingCount + widget.warmUpCount +widget.hitchCount -1){
                              ++bottomItemCount;
                            }
                            if(widget.workoutCount.length <= index){
                              _controllerTimeUp.pause();
                              final map = {
                                planExerciseKcal: colories,
                                planExerciseName: widget.name,
                                planExerciseTime: totalTime,
                                planExerciseCount: widget.workoutCount.length,
                                planExerciseTotal: total,
                                challenge_item: widget.challengeItem
                              };
                              changeScreen(planWorkoutEndScreen, context, argument: map);
                            } else
                            listScroll.animateTo((keys[index].currentContext?.findRenderObject() as RenderBox).size.height
                                * position + width * positionCount + bottomItemHeight * bottomItemCount, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                            // ctr.scrollTo(index: position, duration: Duration(milliseconds: 500));
                          }, sizeRestFunc: (height){
                            bottomItemHeight = height;
                          },),
                          if((index == widget.warmUpCount -1 && positionCount == 1) ||
                      (index == widget.warmUpCount + widget.trainingCount-1 && positionCount == 2) ||
                              (index == widget.warmUpCount + widget.trainingCount + widget.hitchCount-1 && positionCount == 3)
                          )
                            BottomItemWidget(width, bottomItemHeight, index)
                        ],
                      );
                    }, itemCount: widget.workoutCount.length,
                      physics: NeverScrollableScrollPhysics(),
                      controller: listScroll,
                    shrinkWrap: true,),
                  )
                ],
              ),
            ),
            _isPaused ? getPause(width!) : const SizedBox(),
            _wantQuit ? getQuit(width!) : const SizedBox(),
          ],
        ),
      ),
    );
  }

  String getTimeText(int time) {
    int minute = time ~/ 60;
    int seconds = time % 60;

    return "${minute.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  Widget getPause(double width) {
    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      child: Align(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          width: width,
          child: Text(
            paused.tr(),
            style: TextStyle(
                fontSize: 30,
                foreground: Paint()..shader = textLinearGradient,
                fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            pausedMenuItem(restartExercise.tr(),
                () => {
              // _currentPosition = 0,
                  _isPaused = false,
                  _controllerTimeUp.reset(),
                  _controllerTimeUp.start(),
                  // _controllerTimerTraining.start(),
                  setState(() {})
                }, width),
            const SizedBox(
              height: 20,
            ),
            pausedMenuItem(
                quitWorkout.tr(),
                () => {
                  _isPaused = false,
                  _wantQuit = true,
                  setState((){}),
                    },
                width),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _controllerTimeUp.start();
                _isPaused = false;
                // keys[position].currentState?.pauseStartTimer(false, null);
                setState(() {});
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                width: width,
                decoration: BoxDecoration(
                    gradient: linearGradient,
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20),
                  child: Text(
                    resume.tr(),
                    // textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    ),
      ),
    );
  }

  Widget pausedMenuItem(String title, Function() callback, double width) {
    return InkWell(
      onTap: () {
        callback();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        width: width,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            title,
            // textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  int _quitValue = -1;

  Widget getQuit(double width) {
    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      child: Align(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              _wantQuit = false;
              _controllerTimeUp.start();
              // _controllerTimerTraining.resume();
              // keys[position].currentState?.pauseStartTimer(false, null);
              setState(() {});
            },
            child: Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    resume.tr(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
          children: [
              Container(
                width: width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  whyGiveUp.tr(),
                  style: TextStyle(
                      fontSize: 30,
                      foreground: Paint()..shader = textLinearGradient,
                      fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  provideFeedback.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
            )),
        Expanded(
          flex: 2,
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
              const SizedBox(
                height: 40,
              ),
              quitMenuItem(tooEasy.tr(), 0, width),
              const SizedBox(
                height: 20,
              ),
              quitMenuItem(tooHard.tr(), 1, width),
              const SizedBox(
                height: 20,
              ),
              quitMenuItem(anotherReason.tr(), 2, width),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return MainMenuScreen();
                  }), (r) {
                    return false;
                  });
                },
                child: Expanded(
                  child: Container(
                    width: width,
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(top: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          quit.tr(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
            )),
      ],
    ),
      ),
    );
  }

  Widget quitMenuItem(String title, int index, double width) {
    return GestureDetector(
      onTap: () {
        _quitValue = index;
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        width: width,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: _quitValue == index ? Colors.white : Colors.transparent,
                width: _quitValue == index ? 2.0 : 0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            title,
            // textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget TopItemWidget(double width, double height, int index){

    late LinearGradient gradient;
    String text = "";
    String readyText = "";
    final three = widget.trainingCount + widget.warmUpCount;
    bool isSwipeAvailable = true;
    if(index == 0){
      gradient = gradientWarmUp;
      text = "Готовы к разминке?";
    } else if(index == widget.warmUpCount){
      gradient = gradientTraining;
      text = "Готовы к тренировке?";
      readyText = "РАЗМИНКУ ЗАВЕРШЕНО";
    } else if (index == three){
      gradient = gradientHitch;
      text = "Готовы к передышке??";
      readyText = "РАЗМИНКУ ЗАВЕРШЕНО";
    }

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        int sensitivity = 30;
        if(details.delta.dy < -sensitivity && isSwipeAvailable){
          isSwipeAvailable = false;
          ++positionCount;
          listScroll.animateTo((keys[index].currentContext?.findRenderObject() as RenderBox).size.height
              * index + height * positionCount + bottomItemHeight * bottomItemCount, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10)
        ),
        width: width,
        height: height,
        child: Column(
          children: [
            SizedBox(height: 20,),
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(readyText,style: TextStyle(fontSize: 20, color: Colors.white)),
                SizedBox(width: 10,),
                index != 0 ?SvgPicture.asset("assets/images/checked.svg", height: 20,) : SizedBox()
              ],
            )),
            SizedBox(height: 50,),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(text,style: TextStyle(fontSize: 40, color: Colors.white), textAlign: TextAlign.center,),
            )),
            Expanded(child: Align(
                alignment: Alignment.bottomCenter,
                child: Text("СМАХНИТЕ ВВЕРХ, ЧТОБЫ НАЧАТЬ",
                style: TextStyle(fontSize: 20, color: Colors.white),))
            ),
            SizedBox(height: 10,),
            Icon(Icons.keyboard_arrow_up_outlined, color: Colors.white,)
          ],
        ),
      ),
    );
  }

  Widget BottomItemWidget(double width, double height, int index){
    late LinearGradient gradient;
    String text = "";
    final two = widget.trainingCount + widget.warmUpCount-1;
    final three = widget.trainingCount + widget.warmUpCount +widget.hitchCount-1;
    if(index == widget.warmUpCount-1){
      gradient = gradientWarmUp;
      text = "ЗАКОНЧЕНО РАЗМИНКУ";
    } else if(index == two){
      gradient = gradientTraining;
      text = "ЗАКОНЧЕНО ТРЕНИРОВКУ";
    } else if (index == three){
      gradient = gradientHitch;
      text = "ЗАКОНЧЕНО ПЕРЕДЫШКУ";
    }
    return Container(
        decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(10)
    ),
    width: width,
    height: height,
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text,style: TextStyle(fontSize: 20, color: Colors.white)),
          SizedBox(width: 10,),
          SvgPicture.asset("assets/images/checked.svg", height: 20,)
        ],
      ),
    )
    );
  }


  @override
  void dispose() {
    super.dispose();
  }
}
