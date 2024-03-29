import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector_pro/matrix_gesture_detector_pro.dart';

typedef PointMoveCallback = void Function(Offset offset, Key? key);

class OverlayedWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback onDragStart;
  final PointMoveCallback onDragEnd;
  final PointMoveCallback onDragUpdate;

  const OverlayedWidget({
    super.key,
    required this.child,
    required this.onDragStart,
    required this.onDragEnd,
    required this.onDragUpdate,
  });
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
    Offset offset = const Offset(0, 0);
    return Listener(
      onPointerMove: (event) {
        offset = event.position;
        onDragUpdate(event.position, key);
      },
      child: MatrixGestureDetector(
        onScaleStart: () {
          onDragStart();
        },
        onScaleEnd: () {
          onDragEnd(offset, key);
        },
        onMatrixUpdate: (m, tm, sm, rm) {
          notifier.value = m;
        },
        child: AnimatedBuilder(
          animation: notifier,
          builder: (ctx, childWidget) {
            return Transform(
              transform: notifier.value,
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.contain,
                child: SizedBox(
                  child: child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
