import 'package:flutter/material.dart';

class FlowStackDelegate extends FlowDelegate {
  Animation<double> animation;
  double screnWidth;
  bool expand;

  FlowStackDelegate(
      {required this.animation, required this.screnWidth, required this.expand})
      : super(repaint: animation);
  @override
  void paintChildren(FlowPaintingContext context) {
    int childCount = context.childCount;
    double gap = context.getChildSize(0)!.height + 15;
    double childHeight = context.getChildSize(0)!.height;
    double height = context.size.height - 20;
    double firstPos = (height / 2 - (childHeight / 2)) - gap;
    double x, y;

    for (int i = childCount - 1; i >= 0; i--) {
      //default y
      double defY = (height / 2 - (childHeight / 2)) + (10 * i).toDouble();
      y = defY + (firstPos + (i * gap) - defY) * animation.value;
      x = expand ? (screnWidth * 0.05) : (screnWidth * 0.05) + (i * 5);
      context.paintChild(i, transform: Matrix4.translationValues(x, y, 0));
    }
  }

  @override
  Size getSize(BoxConstraints constraints) {
    //slightly widder than the children for the shadow to appear
    return Size(screnWidth * 0.9, double.infinity);
  }

  @override
  bool shouldRepaint(FlowStackDelegate oldDelegate) {
    return animation != oldDelegate.animation;
  }
}