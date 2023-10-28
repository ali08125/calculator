import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomToggle extends StatefulWidget {
  @required
  final bool value;
  final double width;

  @required
  final Function(bool)? onChanged;
  final Image? iconOff;
  final Color iconOffColor;
  final Image? iconOn;
  final Color iconOnColor;
  final Color colorOn;
  final Color colorOff;
  final double textSize;
  final Duration animationDuration;
  final Function onTap;
  final Function onSwipe;
  final Color? circleSwitchColor;

  const CustomToggle({super.key,
    this.circleSwitchColor = Colors.white,
    this.value = false,
    this.width = 130,
    this.iconOff,
    this.iconOn,
    this.textSize = 14.0,
    this.colorOn = Colors.green,
    this.colorOff = Colors.red,
    this.animationDuration = const Duration(milliseconds: 600),
    this.iconOffColor = Colors.white,
    this.iconOnColor = Colors.black,
    required this.onTap,
    required this.onSwipe,
    this.onChanged,
  });

  @override
  _RollingSwitchState createState() => _RollingSwitchState();
}

class _RollingSwitchState extends State<CustomToggle>
    with SingleTickerProviderStateMixin {
  /// Late declarations
  late AnimationController animationController;
  late Animation<double> animation;
  late bool turnState;

  double value = 0.0;

  @override
  void dispose() {
    //Ensure to dispose animation controller
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: widget.animationDuration);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animationController.addListener(() {
      setState(() {
        value = animation.value;
      });
    });
    turnState = widget.value;

    // Executes a function only one time after the layout is completed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (turnState) {
          animationController.forward();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Color transition animation
    Color? transitionColor = Color.lerp(widget.colorOff, widget.colorOn, value);

    return GestureDetector(
      onTap: () {
        _action();
        widget.onTap();
      },
      onPanEnd: (details) {
        _action();
        widget.onSwipe();
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        width: widget.width,
        decoration: BoxDecoration(
            color: transitionColor, borderRadius: BorderRadius.circular(50)),
        child: Stack(
          children: <Widget>[
            Transform.translate(
              offset: isRTL(context)
                  ? Offset(-10 * value, 0)
                  : Offset(10 * value, 0), //original
              child: Opacity(
                opacity: (1 - value).clamp(0.0, 1.0),
                child: Container(
                  padding: isRTL(context)
                      ? const EdgeInsets.only(left: 5)
                      : const EdgeInsets.only(right: 5),
                  alignment: isRTL(context)
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  height: 40,
                  child: widget.iconOff,
                ),
              ),
            ),
            Transform.translate(
              offset: isRTL(context)
                  ? Offset(-10 * (1 - value), 0)
                  : Offset(10 * (1 - value), 0), //original
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Container(
                    padding: isRTL(context)
                        ? const EdgeInsets.only(right: 5)
                        : const EdgeInsets.only(left: 5),
                    alignment: isRTL(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    height: 40,
                    child: widget.iconOn
                ),
              ),
            ),
            Transform.translate(
              offset: isRTL(context)
                  ? Offset((-widget.width + 50) * value, 0)
                  : Offset((widget.width - 50) * value, 0),
              child: Transform.rotate(
                angle: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: widget.circleSwitchColor),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Opacity(
                          opacity: (1 - value).clamp(0.0, 1.0),
                        ),
                      ),
                      Center(
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _action() {
    _determine(changeState: true);
  }

  _determine({bool changeState = false}) {
    setState(() {
      if (changeState) turnState = !turnState;
      (turnState)
          ? animationController.forward()
          : animationController.reverse();

    });
  }
}

bool isRTL(BuildContext context) {
  return Bidi.isRtlLanguage(Localizations
      .localeOf(context)
      .languageCode);
}
