import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/colors.dart';
import '../../utils/const.dart';
import '../../utils/routes.dart';

class LoaderScreen extends StatelessWidget {
  LoaderScreen({Key? key}) : super(key: key);

  // final Reference ref = FirebaseStorage.instance.ref();

  @override
  Widget build(BuildContext context) {
    start(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(child: Center(
        child: Lottie.asset('assets/loader/onboard_calculation.json'),
      )),
    );
  }

  void start(BuildContext context) async {
    await databaseHelper.init();
    databaseHelper.getWorkoutModels().then((value) async {
      // final dir = await getApplicationDocumentsDirectory();
      // for(var item in value){
      //   var video = ref.child("audio_files").child("${item.id}.mp4");
      //   final file = File("${dir.path}/training_video/${video.name}");
      //   final a = await video.writeToFile(file);
      //   print(a);
      // }
      Future.delayed(const Duration(milliseconds: 4000), () {
        changeScreen(payWallScreen, context);
      });
    });
    ;
  }
}
