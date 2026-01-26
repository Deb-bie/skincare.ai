import 'package:flutter/material.dart';

class AnimatedEmptyState extends StatefulWidget {
  const AnimatedEmptyState({Key? key}) : super(key: key);

  @override
  State<AnimatedEmptyState> createState() => _AnimatedEmptyStateState();
}

class _AnimatedEmptyStateState extends State<AnimatedEmptyState>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _iconController;
  late Animation<double> _outerCircleAnimation;
  late Animation<double> _middleCircleAnimation;
  late Animation<double> _innerCircleAnimation;
  late Animation<double> _iconBounceAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for circles
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Icon bounce animation
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Staggered scaling for circles
    _outerCircleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _middleCircleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.1, 0.7, curve: Curves.easeInOut),
      ),
    );

    _innerCircleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );

    // Icon bounce with rotation
    _iconBounceAnimation = Tween<double>(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _iconController]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer circle
            Transform.scale(
              scale: _outerCircleAnimation.value,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00D9D9).withOpacity(0.1),
                ),
              ),
            ),

            // Middle circle
            Transform.scale(
              scale: _middleCircleAnimation.value,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00D9D9).withOpacity(0.2),
                ),
              ),
            ),

            // Inner circle with icon
            Transform.scale(
              scale: _innerCircleAnimation.value,
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF00D9D9),
                ),
                child: Transform.translate(
                  offset: Offset(0, _iconBounceAnimation.value),
                  child: Transform.rotate(
                    angle: _iconBounceAnimation.value * 0.01,
                    child: const Icon(
                      Icons.alarm,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}