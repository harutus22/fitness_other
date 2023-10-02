import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/plan_model_static.dart';
import 'package:fitness/utils/calculations.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WorkOutPlanItem extends StatelessWidget {
  final PlanModelStatic workOutPlanItemModel;
  final Function(PlanModelStatic, bool) workoutFunction;
  final String image;
  final bool isFree;

  const WorkOutPlanItem(
      {Key? key, required this.workOutPlanItemModel, required this.workoutFunction,
        required this.image, required this.isFree})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(fontWeight: FontWeight.w900,
      fontFamily: 'SairaCondensed',
        color: Colors.white, );
    final Size size = calculateTextSize(context, text: premium.tr(), style: style);
    final width = MediaQuery.of(context).size.height * 0.24;
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: (){
          workoutFunction(workOutPlanItemModel, isFree);
        },
        child: Stack(
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image,
                  width: width,
                  height: width,
                  scale: 1,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
              width: size.width + 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: const BoxDecoration(
              gradient: linearGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ), child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if(!isFree)
                  SvgPicture.asset("assets/images/crown.svg", height: 10,),
                Text(
                  isFree ? free.tr() : premium.tr(),
                  style: style,
                  textAlign: TextAlign.center,
                ),
              ],
            ),),
            Positioned(
              bottom: 20,
              left: 20,
              child: Text(
                workOutPlanItemModel.name!,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.white
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
