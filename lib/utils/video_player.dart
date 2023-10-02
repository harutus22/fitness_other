import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../model/workout_model.dart';
import '../model/workout_model_count.dart';
import 'colors.dart';

class WorkoutVideoPlayer extends StatefulWidget {
  const WorkoutVideoPlayer({Key? key, required this.currentWork, required this.workoutModel,
  required this.nextExercise, required this.sizeRestFunc}) : super(key: key);

  final Function nextExercise;
  final Function(double) sizeRestFunc;
  final WorkoutModelCount currentWork;
  final WorkOutModel workoutModel;
  static bool sizeRestGiven = false;
  @override
  State<WorkoutVideoPlayer> createState() => WorkoutVideoPlayerState();
}

class WorkoutVideoPlayerState extends State<WorkoutVideoPlayer> {

  VideoPlayerController? _controller;
  final CountdownController _controllerTimerTraining =
  CountdownController(autoStart: false);
  final CountdownController _controllerTimerCountdown =
  CountdownController(autoStart: true);
  double? width;
  bool preCount = false;
  bool _videoReady = false;
  bool isDarken = true;
  bool isSwipeAvailable = false;
  bool isClosed = false;
  bool isPaused = false;

  void pauseStartTimer(bool isPaused, int? index){
    if(isPaused) {
      if(_controllerTimerCountdown.isCompleted!)
        _controllerTimerTraining.pause();
      else
      _controllerTimerCountdown.pause();
    }
    else {
      if(_controllerTimerCountdown.isCompleted!)
        _controllerTimerTraining.resume();
      else
      _controllerTimerCountdown.resume();
    }
  }


  void getUrl() async{
    _controller =
    VideoPlayerController.asset("assets/videos/training/${widget.workoutModel.id}.mp4")
      ..initialize().then((_) => {

        _videoReady = true,
        setState(() {})
      });
    // getApplicationDocumentsDirectory().then((value){
    //   final url = "${value.path}/training_video/${widget.workoutModel.id}.mp4";
    //
    // });
  }
  @override
  void initState() {
    getUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width ??= MediaQuery.of(context).size.width;
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        int sensitivity = 20;
        if(details.delta.dy < -sensitivity && isSwipeAvailable && !preCount){
          isSwipeAvailable = false;
          isClosed = true;
          widget.nextExercise();
        }
      },
      child: VisibilityDetector(
        key: Key(widget.key!.toString() + widget.currentWork.workOutModel.toString()),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          if(visiblePercentage == 100){
            preCount = true;
            _controller!.play();
            isSwipeAvailable = true;
          _controller!.setLooping(true);
          isDarken = false;
            setState(() {

            });
          } else {
            if(!WorkoutVideoPlayer.sizeRestGiven){
              WorkoutVideoPlayer.sizeRestGiven = true;
              widget.sizeRestFunc(visibilityInfo.size.height * (visibilityInfo.visibleFraction));
            }
          }
          debugPrint(
              'Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
        },
        child: Stack(
          children: [
            Container(
              width: width,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    _controller != null ? VideoPlayer(_controller!) : SizedBox(),
                    isDarken == true ? Container(
                      width: width,
                      color: Colors.black.withOpacity(0.7),
                      child: Center()
                    ): SizedBox(),
                    preCount == true ? Container(
                      width: width,
                      color: Colors.black.withOpacity(0.7),
                      child: Center(
                          child: Countdown(
                            key: null,
                            controller: _controllerTimerCountdown,
                            seconds: 5,
                            interval: Duration(seconds: 1),
                            build: (context, item){
                              return Text(item == 0 ? "Start" : item.toInt().toString(), style: TextStyle(
                                  fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'SairaCondensed',
                              ),);
                            },
                            onFinished: (){
                              preCount = false;
                              _controllerTimerTraining.resume();
                              if(!isClosed)
                              setState(() {});
                            },
                          )
                      ),
                    ) : SizedBox(),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  widget.workoutModel.name,
                  style: TextStyle(
                      fontSize:  widget.workoutModel.name == shadowBoxingWhileTunningInPlace.tr() ? 22 : 30,
                    color: Colors.black, fontWeight: FontWeight.w800, fontFamily: 'SairaCondensed',),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            widget.currentWork.count > 1000
                ? Positioned(
              left: 20,
              bottom: 0,
              child: countDown(widget.currentWork.count, () {
                if(!isClosed) {
                  widget.nextExercise();
                }
              }, 60, widget.workoutModel),
            )
                : Positioned(
              left: 20,
              bottom: 0,
              child: Text(
                "x${widget.currentWork.count.toString()}",
                style: TextStyle(
                    fontSize: 60,
                    // foreground: Paint()..shader = textLinearGradient,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'SairaCondensed'),
              ),
            ),
          ],
        ),
      ),
    );;
  }

  Widget countDown(int time, Function() callback, double fontSize, WorkOutModel? item) {
    // startCount();
    return _videoReady ? Countdown(
      key: item == null ? null : Key(item.name + item.id.toString()),
      seconds: time ~/ 1000,
      controller: _controllerTimerTraining,
      build: (BuildContext context, double timeer) => Text(
        getTimeText(timeer.toInt()),
        style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'SairaCondensed',
            foreground: Paint()..shader = textLinearGradient,
            fontWeight: FontWeight.w800),
      ),
      interval: const Duration(seconds: 1),
      onFinished: () {
        print('Timer is done!');
        callback();
      },
    ) : SizedBox();
  }

  String getTimeText(int time) {
    int minute = time ~/ 60;
    int seconds = time % 60;

    return "${minute.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controllerTimerTraining.pause();
    super.dispose();
  }
}
