import 'package:flutter/material.dart';

const Color colorMainGradLeft = Color(0xff00EA9D);
const Color colorMainGradRight = Color(0xff5573E2);
const Color colorGreyBoarder = Color(0xffCDCDCF);
const Color colorGreyTextField = Color(0xffF6F6F8);
const Color colorGreyText = Color(0xff8C8C8C);

const Color barColorFirst = Color(0xff87C5BA);
const Color barColorSecond = Color(0xff4C6C93);
const Color barColorThird = Color(0xff73DD77);
const Color barColorFour = Color(0xffCEDA5C);
const Color barColorFive = Color(0xffFFB443);
const Color barColorSix = Color(0xffEA444E);

const Color bottomItemColor = Color(0xff919BA9);
const Color backgroundColor = Color(0xff1B2224);

// const Color bottomNavigationBar1 = Color(0xffB80505);
// const Color bottomNavigationBar2 = Color(0xff1A961F);
// const Color bottomNavigationBar3 = Color(0xff1F25BB);
// const Color bottomNavigationBar4 = Color(0xffC0B912);

final Shader linearShaderGradient = const LinearGradient(
  colors: <Color>[colorMainGradLeft, colorMainGradRight],
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

final Shader textLinearGradient = const LinearGradient(
  colors: <Color>[colorMainGradLeft, colorMainGradRight],
).createShader(const Rect.fromLTWH(90.0, 50.0, 200.0, 70.0));

final Shader smallTextLinearGradient = const LinearGradient(
  colors: <Color>[colorMainGradLeft, colorMainGradRight],
).createShader(const Rect.fromLTWH(0.0, 0.0, 100.0, 100.0));

final Shader bottomItemTextGradient = const LinearGradient(
  colors: <Color>[colorMainGradLeft, colorMainGradRight],
).createShader(const Rect.fromLTWH(0.0, 0.0, 25.0, 100.0));

const LinearGradient linearGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [colorMainGradLeft, colorMainGradRight],
);

LinearGradient linearGradientOpacity = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [colorMainGradLeft.withOpacity(0.30), colorMainGradRight.withOpacity(.30)],
);

const LinearGradient gradientWarmUp = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xff00EA9D), Color(0xff5573E2)],
);

const LinearGradient gradientTraining = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xffE85C1F), Color(0xffEBA22F)],
);

const LinearGradient gradientHitch = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xff544CEF), Color(0xff6D76FF)],
);
