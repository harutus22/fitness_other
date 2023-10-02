import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/paymtent_item.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/colors.dart';
import '../main_menu_screen.dart';

const Set<String> _productIds = <String>{'monthly, yearly'};
const date = 'DATE';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({Key? key}) : super(key: key);

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  int chosenPayment = 0;
  final paymentsType = [
    PaymentItem(
        perYear: true, totalPrice: 34.99, weekPrice: 0.76, subsName: "yearly"),
    PaymentItem(
        perYear: false, totalPrice: 2.99, weekPrice: 2.50, subsName: "monthly"),
  ];
  final whatYouGain = [];

  // late StreamSubscription<dynamic> _subscription;
  // List<ProductDetails> _products = [];
  // InAppPurchase inAppPurchase = InAppPurchase.instance;
  bool isPro = false;

  @override
  void dispose() {
    // _subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final prefs = SharedPreferences.getInstance();
    prefs.then(
      (value) {
        final res = value.getString(date);
        if (res != null) {
          final a = DateTime.now().compareTo(DateTime.parse(res));
          isPro = a < 0;
        }
      },
    );
    getOfferings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff334F56), Color(0xff1E3439).withOpacity(0.84)],
                ), borderRadius: BorderRadius.circular(25)),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: const EdgeInsets.only(right: 10, top: 0),
                              padding: const EdgeInsets.all(5),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(builder: (BuildContext context) {
                                          return MainMenuScreen();
                                        }), (r) {
                                          return false;
                                        });
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: const EdgeInsets.only(right: 20, top: 20),
                              padding: const EdgeInsets.all(5),
                              child: InkWell(
                                onTap: () {
                                  _restorePurchase(argument);
                                },
                                child: Text(
                                  restoreText.tr(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'SairaCondensed',
                                  decoration: TextDecoration.underline),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: MediaQuery.of(context).size.width / 3 *2,
                              clipBehavior: Clip.none,
                              child: Image.asset(
                                "assets/images/paywall.png",
                              )),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "BE",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            foreground: Paint()..shader = textLinearGradient,
                                          fontFamily: 'SairaCondensed',),
                                      ),
                                      WidgetSpan(child: SizedBox(width: 10,)),
                                      WidgetSpan(child: Image.asset("assets/images/premium.png",height: 22,)),
                                      WidgetSpan(child: SizedBox(width: 10,)),
                                      TextSpan(
                                        text: "\n" + premium.tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            foreground: Paint()..shader = textLinearGradient,
                                          fontFamily: 'SairaCondensed',),
                                      ),
                                    ]
                                )),
                                SizedBox(height: 20,),
                                Text(
                                  getUnlimitedAccess.tr(),
                                  style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    fontFamily: 'SairaCondensed',),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        consItem("Video\ncoach", "assets/images/video.png"),
                        consItem("300+\nworkouts", "assets/images/muscle.png"),
                        consItem("Personalized\nplan", "assets/images/protein.png"),
                        consItem("Create your\nown plan", "assets/images/note.png"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        purchasePlanItem(paymentsType[0], 0, () => {}),
                        const SizedBox(
                          height: 20,
                        ),
                        purchasePlanItem(paymentsType[1], 1, () => {})
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        // user.isSubscribed = true;
                        // setUser(user);
                        // if (argument != null && argument == canPop) {
                          //TODO subscription init
                          pay(argument);
                          // Navigator.of(context).pop();
                        // } else {
                        //   Navigator.pushAndRemoveUntil(context,
                        //       MaterialPageRoute(builder: (BuildContext context) {
                        //         return MainMenuScreen();
                        //       }), (r) {
                        //         return false;
                        //       });
                        // }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: const BoxDecoration(
                            gradient: linearGradient,
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Text(
                          subscribe_txt.tr(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold,
                            fontFamily: 'SairaCondensed',
                          fontSize: 26),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xff9E9E9E),
                        fontFamily: 'SairaCondensed',),
                      children: [
                        TextSpan(text: "${byContinuingAccept.tr()} "),
                        TextSpan(
                          text: "${privacy.tr()}\n",
                          recognizer: TapGestureRecognizer()..onTap = () async {
                            final uri = Uri.parse(privacyUrl);
                            if (!await launchUrl(uri)) {
                              throw Exception('Could not launch $uri');
                            }
                          },
                          style: const TextStyle(
                              decoration:
                              TextDecoration.underline,
                            fontFamily: 'SairaCondensed',), //<-- SEE HERE
                        ),
                        TextSpan(text: " ${and.tr()} "),
                        TextSpan(
                          text: termsCondition.tr(),
                          recognizer: TapGestureRecognizer()..onTap = () async {
                            final uri = Uri.parse(termsUrl);
                            if (!await launchUrl(uri)) {
                              throw Exception('Could not launch $uri');
                            }
                          },
                          style: const TextStyle(
                              decoration:
                              TextDecoration.underline,
                            fontFamily: 'SairaCondensed',), //<-- SEE HERE
                        ),
                      ])),
              const SizedBox(
                height: 10,
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget consItem(String title, String image) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width / 5,
      height: MediaQuery.of(context).size.height / 7,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),child: Image.asset(image)),
          const SizedBox(
            width: 5,
          ),
          Text(
          title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontFamily: 'SairaCondensed',
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          )
        ],
      ),
    );
  }

  Widget purchasePlanItem(
      PaymentItem payment, int itemNumber, Function() callback) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: () {
            chosenPayment = itemNumber;
            setState(() {});
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 12,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                gradient: itemNumber == chosenPayment ? linearGradient : null,
                color: itemNumber != chosenPayment
                    ? const Color(0xffD7D7D7)
                    : null),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  color: backgroundColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            gradient: itemNumber == chosenPayment
                                ? linearGradient
                                : null,
                            color: itemNumber == chosenPayment
                                ? null
                                : const Color(0xffD7D7D7)),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  color: backgroundColor)),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
    payment.perYear == true
    ? "${yearlyText.tr()} - \$${payment.totalPrice.toStringAsFixed(2)}"
        : "${monthlyText.tr()} - \$${payment.totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              fontFamily: 'SairaCondensed',),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          // Text(
                          //   freeTrialText.tr(),
                          //   style: const TextStyle(
                          //       fontSize: 12, color: Colors.white,
                          //     fontFamily: 'SairaCondensed',),
                          //   textAlign: TextAlign.start,
                          // )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: itemNumber == chosenPayment ?  [colorMainGradLeft, colorMainGradRight]
                          : [Colors.white, Colors.white],
                        ).createShader(
                            const Rect.fromLTWH(5.0, 40.0, 60.0, 60.0)),
                        child: Text(
                          "\$ ${payment.weekPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: itemNumber == chosenPayment
                                ? Colors.white
                                : Colors.white,
                            fontFamily: 'SairaCondensed',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        perWeekText.tr(),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white,
                              fontFamily: 'SairaCondensed',),
                        textAlign: TextAlign.start,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        itemNumber == 0
            ? Positioned(
                right: MediaQuery.of(context).size.width / 5,
                top: -10,
                child: itemNumber == chosenPayment
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            gradient: linearGradient),
                        child: Text(
                          "${save.tr().toString()} 70%",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12,
                            fontFamily: 'SairaCondensed',),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.grey, Colors.grey],
                            )),
                        child: Text(
                          "${save.tr().toString()} 70%",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12,
                            fontFamily: 'SairaCondensed',),
                        ),
                      ))
            : SizedBox()
      ],
    );
  }

  Future getOfferings() async {
    final offerings = await Purchases.getOfferings();
    if(offerings.current != null){
      final packages = offerings.current?.availablePackages;
      print(packages);
      for(int i = 0; i < packages!.length; i++) {
        final product = packages[i].storeProduct;
        if(product.identifier == "lw_premium_year") {
          paymentsType[0].totalPrice = product.price;
          paymentsType[0].weekPrice =
              product.price / 52;
        } else {
          paymentsType[1].totalPrice = product.price;
          paymentsType[1].weekPrice =
              product.price / 4.4;
        }
      }
    }
    setState(() {

    });
  }
  pay(Object? argument) async {
    final payment = paymentsType[chosenPayment];
    final payId = payment.perYear ? "lw_premium_year" : "lw_premium_month";
    try {
      final result = await Purchases.purchaseProduct(payId);
      print(result.allExpirationDates[0]);
      print(result.activeSubscriptions);
      if(result.activeSubscriptions.isNotEmpty) {
        user.isSubscribed = true;
        setUser(user);
      }
      if(argument != null && argument == canPop){
        //TODO subscription init
        Navigator.of(context).pop();
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
          return MainMenuScreen();
        }), (r){
          return false;
        });
      }
      // result.
    } catch(e){
      debugPrint("Failed to subscribe due to: $e");
    }
  }

  void _restorePurchase(Object? argument) async {
    try {
      print("active subscriptions: clicked");
      final result = await Purchases.restorePurchases();
      print("active subscriptions: ${result.activeSubscriptions}");
      if (result.activeSubscriptions.isNotEmpty) {
        user.isSubscribed = true;
        setUser(user);
        if(argument != null && argument == canPop){
          //TODO subscription init
          Navigator.of(context).pop();
        } else {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
            return MainMenuScreen();
          }), (r){
            return false;
          });
        }
      }
      print(result.allExpirationDates);
    } catch(e){}
  }

}
