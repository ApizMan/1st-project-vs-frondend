import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:project/widget/flow_stack_delegate.dart';

class CardsStack extends StatefulWidget {
  const CardsStack({super.key});

  @override
  State<CardsStack> createState() => _CardsStackState();
}

class _CardsStackState extends State<CardsStack> with TickerProviderStateMixin {
  late AnimationController controller = AnimationController(vsync: this);
  bool expand = false;
  double cardHeight = 100;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double cardWidth = width * 0.8;

    // Wrap the Flow widget in a SizedBox with a fixed height
    return GestureDetector(
      onTap: onCardTap,
      child: SizedBox(
        height: expand ? cardHeight * 3 : cardHeight, // Set a bounded height
        child: Flow(
          delegate: FlowStackDelegate(
            animation: controller,
            screnWidth: width,
            expand: expand,
          ),
          children: List.generate(3, (index) {
            return Container(
              height: cardHeight,
              width: expand ? cardWidth : cardWidth - (index * 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color.fromARGB(255, 83, 80, 80),
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 5),
                    color: Color.fromARGB(255, 209, 203, 203),
                    spreadRadius: 1,
                    blurRadius: 8,
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void onCardTap() {
    if (expand) {
      setState(() {
        expand = false;
      });
      final SpringSimulation springSimulation = SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 90, damping: 8.0),
        1.0,
        0.0,
        0.0,
      );
      controller.animateWith(springSimulation);
    } else {
      setState(() {
        expand = true;
      });
      final SpringSimulation springSimulation = SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 90, damping: 8.0),
        0.0,
        1.0,
        0.0,
      );
      controller.animateWith(springSimulation);
    }
  }
}
