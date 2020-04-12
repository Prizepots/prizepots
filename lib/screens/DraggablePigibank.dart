
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/physics.dart';


class DraggablePigibank extends StatefulWidget {
  final Widget child;
  DraggablePigibank({this.child});

  @override
  _DraggablePigibankState createState() => _DraggablePigibankState();
}

class _DraggablePigibankState extends State<DraggablePigibank>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  /// The alignment of the card as it is dragged or being animated.
  ///
  /// While the card is being dragged, this value is set to the values computed
  /// in the GestureDetector onPanUpdate callback. If the animation is running,
  /// this value is set to the value of the [_animation].
  var _dragAlignment = Alignment.center;

  Animation<Alignment> _animation;

  final _spring = const SpringDescription(
    mass: 30,
    stiffness: 1000,
    damping: 0.3,
  );

  /// Calculate the velocity relative to the unit interval, [0,1],
  /// used by the animation controller.
  double _normalizeVelocity(Offset velocity, Size size) {
    final normalizedVelocity = Offset(
      velocity.dx / size.width,
      velocity.dy / size.height,
    );
    // Returning negative implies dragging away from center
    return -normalizedVelocity.distance;
  }

  /// Calculates and runs a [SpringSimulation]
  void _runAnimation(Offset velocity, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );

    final simulation =
    SpringSimulation(_spring, 0, 1, _normalizeVelocity(velocity, size));

    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)
      ..addListener(() => setState(() => _dragAlignment = _animation.value));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanStart: (details) => _controller.stop(canceled: true),
      onPanUpdate: (details) => setState(
            () => _dragAlignment += Alignment(
          details.delta.dx / (size.width / 3),
          details.delta.dy / (size.height / 50),
        ),
      ),
      onPanEnd: (details) =>
          _runAnimation(details.velocity.pixelsPerSecond, size),
      child: Align(
        alignment: _dragAlignment,
        child: Card(
          child: widget.child,
        ),
      ),
    );
  }
}