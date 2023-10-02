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
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    required this.hitchCount,
    this.isCustom = false,
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
  bool isCustom = false;


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
  final List<GlobalKey<WorkoutVideoPlayerState>> keys = [];
  ScrollController listScroll = ScrollController();
  static double bottomItemHeight = 0;
  final explainText = [warmUpTxt.tr(), workoutTxt.tr(), rest.tr()];
  int txtCount = 0;

  late final CustomTimerController _controllerTimeUp = CustomTimerController(
      vsync: this,
      begin: const Duration(),
      end: const Duration(hours: 24),
      initialState: CustomTimerState.reset,
      interval: CustomTimerInterval.milliseconds
  );



  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    for(final item in widget.workoutCount){
      keys.add(GlobalKey());
    }
    if(widget.isCustom){
      txtCount = 1;
    }
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
    openAdManager.createInterstitialAd('ca-app-pub-5842953747532713/3924109896', (){

    });
    super.initState();
  }

  bool pass = false;

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
                      child: Text(
                        // explainText[txtCount],
                        workoutTxt.tr(),
                        style: TextStyle(color: Colors.grey, fontFamily: 'SairaCondensed',),)),
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
                                  style: TextStyle(fontSize: 48.0, color: Colors.white, fontFamily: 'SairaCondensed',)
                              );
                            }
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left: 10, top: 15),
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              doneTxt.tr(), style: TextStyle(color: Colors.grey, fontFamily: 'SairaCondensed',),
                            )
                          ),
                        ),

                        Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: (){
                                _controllerTimeUp.pause();
                                final i =keys[position].currentState;
                               i?.pauseStartTimer(true, position);
                                _isPaused = true;
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
                      WorkOutModel workoutModel = currentWork.workOutModel < 0 ? WorkOutModel(name: "", difficulty: 3, muscleGroups: [], id: 1) : widget.workoutModel.firstWhere((element) => element.id == currentWork.workOutModel);
                      final width = MediaQuery.of(context).size.width;
                      // }
                      return Column(
                        children: [
                      widget.workoutCount[index].workOutModel == -1 ?
                          TopItemWidget(width, width, widget.workoutCount[index].count, index)
                      : widget.workoutCount[index].workOutModel == -2 ?
                      BottomItemWidget(width, bottomItemHeight, widget.workoutCount[index].count, index) :
                      WorkoutVideoPlayer(key: keys[index], workoutModel: workoutModel, currentWork: currentWork,nextExercise: (){
                        if(!widget.isCustom) {
                          if((widget.warmUpCount == index || widget.warmUpCount + widget.trainingCount + 1 == index ||
                              widget.warmUpCount + widget.trainingCount + widget.hitchCount + 5 == index))
                            position += 2;
                          // else if (widget.isCustom && currentWork.)
                          //   position += 2;
                          else {
                            ++position;
                            ++txtCount;
                          }
                        } else {
                          ++position;
                        }
                            if((widget.workoutCount.length - 2 <= index)
                                // || (widget.isCustom && widget.workoutCount.length <= index)
                            ){

                              _controllerTimeUp.pause();
                              user.caloriesBurned = colories.toInt();
                              setUser(user);

                              final map = {
                                planExerciseKcal: colories,
                                planExerciseName: widget.name,
                                planExerciseTime: totalTime,
                                planExerciseCount: widget.workoutCount.length,
                                planExerciseTotal: total,
                                challenge_item: widget.challengeItem,
                                planExerciseCalendarPass: widget.warmUpCount
                              };
                              changeScreen(planWorkoutEndScreen, context, argument: map);
                            } else {
                              final key = keys[position].currentContext!;
                              Scrollable.ensureVisible(
                                  key,
                                  duration: const Duration(milliseconds: 500));
                            }
                          }, sizeRestFunc: (height){
                            bottomItemHeight = height;
                          },),

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
                position = 0,
                  _isPaused = false,
                  _controllerTimeUp.reset(),
                  _controllerTimeUp.start(),
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                return WorkoutStartScreen(
                name: widget.name,
                workoutCount: widget.workoutCount,
                workoutModel: widget.workoutModel,
                restTime: widget.restTime,
                timeMinutes: widget.timeMinutes,
                warmUpCount: widget.warmUpCount,
                trainingCount: widget.trainingCount,
                hitchCount: widget.hitchCount,
                  isCustom: widget.isCustom
                );
                }), (r){
                return false;
                }),

                  // Scrollable.ensureVisible(keys[position].currentContext!, duration: const Duration(milliseconds: 500)),
                  // _controllerTimerTraining.start(),
                  // setState(() {})
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
                keys[position].currentState?.pauseStartTimer(false, null);
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
                        color: Colors.white,
                      fontFamily: 'SairaCondensed',),
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
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,
              fontFamily: 'SairaCondensed',),
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
              keys[position].currentState?.pauseStartTimer(false, null);
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
                        fontSize: 18,
                      fontFamily: 'SairaCondensed',),
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
                      fontWeight: FontWeight.w800,
                    fontFamily: 'SairaCondensed',),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  provideFeedback.tr(),
                  style: const TextStyle(color: Colors.white,
                    fontFamily: 'SairaCondensed',),
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
                child: Align(
                  alignment: Alignment.centerRight,
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
                              fontSize: 18,
                            fontFamily: 'SairaCondensed',),
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
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,
              fontFamily: 'SairaCondensed',),
          ),
        ),
      ),
    );
  }

  Widget TopItemWidget(double width, double height, int index, int key){

    late LinearGradient gradient;
    String text = "";
    String readyText = "";
    bool isSwipeAvailable = true;
    if(index == 0){
      gradient = gradientWarmUp;
      text = readyWarmUp.tr();
    } else if(index == 1){
      gradient = gradientTraining;
      text = readyWorkout.tr();
      readyText = widget.isCustom ? "" : finishedWarmUp.tr();
    } else if (index == 2){
      gradient = gradientHitch;
      text = readyRest.tr();
      readyText = finishedWorkout.tr();
    }

    return GestureDetector(
      key: keys[key],
      onVerticalDragUpdate: (details) {
        int sensitivity = 20;
        if(details.delta.dy < -sensitivity && isSwipeAvailable){
          isSwipeAvailable = false;
          ++position;

          Scrollable.ensureVisible(keys[position].currentContext!, duration: const Duration(milliseconds: 500));
          // listScroll.animateTo((keys[index].currentContext?.findRenderObject() as RenderBox).size.height
          //     * index + height * positionCount + bottomItemHeight * bottomItemCount, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
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
            SizedBox(height: 0,),
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(readyText,style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'SairaCondensed',)),
                SizedBox(width: 10,),
                index != 0 ?widget.isCustom ? SizedBox() :SvgPicture.asset("assets/images/checked.svg", height: 20,) : SizedBox()
              ],
            )),
            SizedBox(height: 20,),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(text,style: TextStyle(fontSize: 40, color: Colors.white,
                fontFamily: 'SairaCondensed',), textAlign: TextAlign.center,),
            )),
            Expanded(child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(swipeUp.tr(),
                style: TextStyle(fontSize: 20, color: Colors.white,
                  fontFamily: 'SairaCondensed',),))
            ),
            SizedBox(height: 10,),
            Icon(Icons.keyboard_arrow_up_outlined, color: Colors.white,)
          ],
        ),
      ),
    );
  }

  Widget BottomItemWidget(double width, double height, int index, int key){
    late LinearGradient gradient;
    String text = "";
    if(index == 0){
      gradient = gradientWarmUp;
      text = finishedWarmUp.tr();
    } else if(index == 1){
      gradient = gradientTraining;
      text = finishedWorkout.tr();
    } else if (index == 2){
      gradient = gradientHitch;
      text = finishRest.tr();
    }
    return Container(
      key: keys[key],
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
          Text(text,style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'SairaCondensed',)),
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
