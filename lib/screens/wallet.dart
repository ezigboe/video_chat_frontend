import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_chat/screens/auth_screens/auth_helper_widgets.dart';
import 'package:video_chat/utils/meta_colors.dart';
import 'package:video_chat/utils/meta_styles.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
          appBar: AppBar(
              title: Text(
            "Wallet",
            style: MetaStyles.labelStyle,
          )),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(handler: () {}, label: "Add Coins"),
              )
            ],
          )),
    );
  }
}

class Card extends StatefulWidget {
  const Card({
    Key? key,
  }) : super(key: key);

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
        lowerBound: 0,
        upperBound: 1,
        vsync: this,
        duration: Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: CurvedAnimation(
              parent: _controller..forward(), curve: Curves.elasticInOut)
          .drive(Tween(begin: Offset(1, 0), end: Offset(0, 0))),
      child: Center(
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * .05),
          child: AnimatedBuilder(
              animation:
                  CurvedAnimation(parent: _controller, curve: Curves.easeIn),
              builder: (context, widget) {
                return Container(
                  decoration: BoxDecoration(
                      // color: Colors.purpleAccent,
                      boxShadow: [
                        BoxShadow(
                            color: MetaColors.primaryColor.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                            offset: Offset(5, 5))
                      ],
                      gradient: RadialGradient(
                          tileMode: TileMode.decal,
                          // startAngle: .2,
                          // endAngle: math.pi*1,
                          radius: .1,
                          focal: Alignment.topRight,
                          focalRadius: _controller.value,
                          colors: [
                            Colors.greenAccent,
                            Colors.redAccent,
                            Colors.amberAccent,
                            Colors.purpleAccent,
                          ]),
                      borderRadius: BorderRadius.circular(20)),
                  width: MediaQuery.of(context).size.width * .8,
                  height: MediaQuery.of(context).size.height * .25,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 5 * (_controller.value),
                          sigmaY: 5 * (_controller.value)),
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "EzigboE",
                                  style: TextStyle(
                                      fontSize: 20,
                                      // color:
                                      //     Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                //   Image(
                                // image: AssetImage(
                                //     MetaAssets
                                //         .appLogo),
                                // )
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.all(8.0).copyWith(bottom: 0),
                              child: Text(
                                "Available Coins",
                                style: TextStyle(
                                  fontSize: 13,
                                  // color: Colors.white,
                                ),
                              ),
                            ),
                            ClipRRect(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    width: double.maxFinite,
                                    color: Colors.white.withOpacity(0.3),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: BalanceWidget(
                                        amount: 1000,
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class BalanceWidget extends StatefulWidget {
  const BalanceWidget({
    Key? key,
    this.amount,
  }) : super(key: key);
  final double? amount;

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        lowerBound: 0,
        upperBound: widget.amount!,
        duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: CurvedAnimation(
            parent: _controller..forward(), curve: Curves.bounceIn),
        builder: (
          context,
          value,
        ) {
          return Text(
              "\u20b9 ${_controller.value.toStringAsFixed(2).toString()}",
              style: TextStyle(
                  // color: Colors
                  //     .white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500));
        });
  }
}
