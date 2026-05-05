import 'package:boost_fundr/export.dart';

class CustomStepper extends StatelessWidget {
  final List<({bool isEnable, dynamic content})> steps;
  final int currentIndex;

  const CustomStepper({super.key, required this.steps, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    Logger.printer(title: 'Current Index: $currentIndex');
    return Stepper(
      currentStep: currentIndex,
      type: StepperType.horizontal,
      stepIconMargin: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      stepIconHeight: 24,
      physics: const ClampingScrollPhysics(),
      steps: List.generate(steps.length, (index) {
        return Step(
          title: const SizedBox.shrink(),
          content: steps[index].content,
          stepStyle: StepStyle(
              color: Colors.transparent,
              connectorColor: currentIndex > index
                  ? ColorConst.kGreen
                  : currentIndex == index
                      ? ColorConst.kPrimaryColor
                      : ColorConst.kGray300),
          state: currentIndex < index
              ? StepState.complete
              : (currentIndex == index)
                  ? StepState.editing
                  : StepState.indexed,
          isActive: steps[index].isEnable,
        );
      }),
      elevation: 0.0,
      clipBehavior: Clip.antiAlias,
      stepIconBuilder: (index, stepI) {
        return Icon(
          Icons.adjust_rounded,
          color: currentIndex > index
              ? ColorConst.kGreen
              : currentIndex == index
                  ? ColorConst.kPrimaryColor
                  : ColorConst.kGray300,
          size: s26,
        );
      },
      controlsBuilder: (BuildContext context, ControlsDetails control) {
        return const SizedBox.shrink();
      },
    );
  }
}

class CustomStep extends Step {
  final Color? connectorColor;

  CustomStep(
    this.connectorColor, {
    required super.content,
    required bool isEnable,
  }) : super(
          title: const SizedBox.shrink(),
          stepStyle: StepStyle(color: Colors.transparent, connectorColor: connectorColor),
          state: isEnable ? StepState.complete : StepState.editing,
          isActive: isEnable,
        );
}

// Stepper(
// currentStep: currentIndex.value,
// type: StepperType.horizontal,
// stepIconMargin: p0,
// steps: steps,
// stepIconBuilder: (index, stepI) {
// return const Icon(
// Icons.adjust_rounded,
// );
// },
// controlsBuilder: (BuildContext context, ControlsDetails control) {
// return const SizedBox.shrink();
// },
// ),

// import 'package:flutter/material.dart';
//
// class CustomStepper extends StatefulWidget {
//   final List<CustomStep> steps;
//
//   CustomStepper({required this.steps});
//
//   @override
//   _CustomStepperState createState() => _CustomStepperState();
// }
//
// class _CustomStepperState extends State<CustomStepper> {
//   int _currentStep = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stepper(
//       currentStep: _currentStep,
//       type: StepperType.horizontal,
//       steps: _buildSteps(),
//       onStepTapped: (int step) {
//         setState(() {
//           _currentStep = step;
//         });
//       },
//       onStepContinue: _nextStep,
//       onStepCancel: _previousStep,
//       controlsBuilder: _buildControls,
//     );
//   }
//
//   List<Step> _buildSteps() {
//     return widget.steps.map((customStep) {
//       return Step(
//         title: const SizedBox.shrink(),
//         content: customStep.content,
//         isActive: customStep.isActive,
//         state: StepState.indexed,
//       );
//     }).toList();
//   }
//
//   void _nextStep() {
//     if (_currentStep < widget.steps.length - 1) {
//       setState(() {
//         _currentStep += 1;
//       });
//     }
//   }
//
//   void _previousStep() {
//     if (_currentStep > 0) {
//       setState(() {
//         _currentStep -= 1;
//       });
//     }
//   }
//
//   Widget _buildControls(BuildContext context, ControlsDetails controls) {
//     return Row(
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         Flexible(
//           child: ElevatedButton(
//             onPressed: controls.onStepCancel,
//             child: Text('Previous'),
//           ),
//         ),
//         SizedBox(width: 10),
//         Flexible(
//           child: ElevatedButton(
//             onPressed: controls.onStepContinue,
//             child: Text('Next'),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class CustomStep {
//   final Widget content;
//   final bool isActive;
//
//   CustomStep({required this.content, required this.isActive});
// }
