import 'package:calculator/config/theme.dart';
import 'package:calculator/features/calculate/provider/result_provider.dart';
import 'package:calculator/features/calculate/widgets/custom_toggle.dart';
import 'package:calculator/features/calculate/provider/operation_provider.dart';
import 'package:calculator/features/constants/KeyLabels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator/common/utils/image_path.dart';

class CalculateScreen extends StatelessWidget {
  const CalculateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeData = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              // toggle dark and light
              Center(
                child: CustomToggle(
                  width: width * 0.27,
                  colorOn: themeData.colorScheme.secondary,
                  colorOff: themeData.colorScheme.secondary,
                  iconOff: Image.asset(ImagePath.moonPath),
                  iconOn: Image.asset(ImagePath.sunPath),
                  circleSwitchColor: themeData.colorScheme.surface,
                  onTap: themeProvider.changeTheme,
                  onSwipe: themeProvider.changeTheme,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              // display calculation
              Flexible(
                flex: 2,
                child: Consumer<OperationProvider>(
                  builder: (context, value, child) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          value.text.join(),
                          style: themeData.textTheme.titleLarge,
                          maxLines: 1,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              // display result
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Consumer<ResultProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                      return Visibility(
                          visible: double.parse(value.result) != 0 &&
                              context.read<OperationProvider>().showResult(),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              value.result,
                              style: themeData.textTheme.titleSmall,
                              maxLines: 1,
                            ),
                          ));
                    },
                  ),
                ),
              ),

               const Expanded(child: SizedBox()),

              // Keys
              const Flexible(
                flex: 9,
                child: Keys(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Keys extends StatelessWidget {
  const Keys({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return GridView.builder(
      itemCount: 20,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        if (index < 3) {
          return Key(
            color: themeData.colorScheme.surface,
            label: KeyLabels.labels[index],
          );
        } else if ((index + 1) % 4 == 0) {
          return Key(
            color: themeData.colorScheme.primary,
            labelColor: Colors.white,
            label: KeyLabels.labels[index],
          );
        } else {
          return Key(
            color: themeData.colorScheme.secondary,
            label: KeyLabels.labels[index],
          );
        }
      },
    );
  }
}

class Key extends StatelessWidget {
  final Color color;
  final Color? labelColor;
  final String label;

  const Key(
      {super.key, required this.color, required this.label, this.labelColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        height: 500,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(24)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashFactory: InkRipple.splashFactory,
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              if (isLabel(label)) {
                // calculate and update the result
                context.read<OperationProvider>().checkLabel(label, context);
              } else {
                context.read<OperationProvider>().addToText(label, context);
              }
            },
            onLongPress: label == '⌫'
                ? () {
                    context.read<OperationProvider>().reset(context);
                  }
                : null,
            child: Center(
              child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: labelColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool isLabel(String label) {
  if (label == '=' || label == '⌫' || label == 'C' || label == '±') {
    return true;
  }
  return false;
}
