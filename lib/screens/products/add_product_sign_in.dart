import 'package:flutter/material.dart';

import '../../enums/signin_source.dart';
import '../auth/signin/sign_in.dart';

class AddProductSignInPage extends StatelessWidget {
  const AddProductSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
              const Color(0xFF1E3A3A),
              const Color(0xFF0F2A2A),
            ]
                : [
              const Color(0xFFE0F2FE),
              const Color(0xFFBAE6FD),
            ],
          ),
        ),

        child: SafeArea(
          child: Stack(
            children: [
              const SizedBox(height: 60,),

              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              color: theme.cardTheme.color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    isDark ? 0.5 : 0.1,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),

                            child: Center(
                              child: Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: isDark
                                        ? [
                                      const Color(0xFFD4A574)
                                          .withValues(alpha: 0.3),
                                      const Color(0xFFC89B63)
                                          .withValues(alpha: 0.3),
                                    ]
                                        : [
                                      const Color(0xFFFFD7BA),
                                      const Color(0xFFFFCBA4),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Stack(
                                  children: [

                                    // Serum Bottle
                                    Center(
                                      child: CustomPaint(
                                        size: const Size(50, 80),
                                        painter: SerumBottlePainter(
                                          isDark: isDark,
                                        ),
                                      ),
                                    ),


                                    // Wavy line decoration
                                    Positioned(
                                      bottom: 12,
                                      left: 12,
                                      right: 12,
                                      child: CustomPaint(
                                        size: const Size(136, 20),
                                        painter: WavyLinePainter(
                                          isDark: isDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),

                      // Title
                      Text(
                        'Want to add your\nown products?',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Description
                      Text(
                        'Sign in to keep track of your unique\nproducts and integrate them into your\nroutine.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 100),

                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => SignIn(),
                                settings: RouteSettings(
                                  name: '/signin',
                                  arguments: SignInSource.back,
                                ),
                              ),
                                  (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: Colors.black.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins",
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Close Button (Top Left)
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: isDark ? theme.cardTheme.color?.withOpacity(0.9): Colors.transparent,
                    padding: const EdgeInsets.all(8),
                    elevation: 2
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// Custom Painter for Serum Bottle
class SerumBottlePainter extends CustomPainter {
  final bool isDark;

  SerumBottlePainter({this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Bottle body
    paint.color = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFFFF8F0);
    final bottleRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.2,
        size.width * 0.6,
        size.height * 0.7,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(bottleRect, paint);

    // Bottle border
    paint.style = PaintingStyle.stroke;
    paint.color = isDark
        ? const Color(0xFF4A4A4A)
        : const Color(0xFFD1D5DB);
    paint.strokeWidth = 2;
    canvas.drawRRect(bottleRect, paint);

    // Dropper cap
    paint.style = PaintingStyle.fill;
    paint.color = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFE5E7EB);
    final capRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.3,
        size.height * 0.05,
        size.width * 0.4,
        size.height * 0.15,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(capRect, paint);

    // Dropper tube
    paint.color = isDark
        ? const Color(0xFF4A4A4A)
        : const Color(0xFFD1D5DB);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.48,
        size.height * 0.15,
        size.width * 0.04,
        size.height * 0.08,
      ),
      paint,
    );

    // Label on bottle
    paint.color = isDark
        ? Colors.white.withOpacity(0.1)
        : Colors.white.withOpacity(0.8);
    final labelRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.25,
        size.height * 0.4,
        size.width * 0.5,
        size.height * 0.3,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(labelRect, paint);

    // Label lines
    paint.color = isDark
        ? const Color(0xFF6B7280)
        : const Color(0xFF9CA3AF);
    paint.strokeWidth = 1.5;
    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.5),
      Offset(size.width * 0.65, size.height * 0.5),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.32, size.height * 0.56),
      Offset(size.width * 0.68, size.height * 0.56),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.38, size.height * 0.62),
      Offset(size.width * 0.62, size.height * 0.62),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for Wavy Line
class WavyLinePainter extends CustomPainter {
  final bool isDark;

  WavyLinePainter({this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark
          ? const Color(0xFF8B7355)
          : const Color(0xFFD4A574)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height / 2);

    for (double i = 0; i < size.width; i++) {
      path.lineTo(
        i,
        size.height / 2 + 3 * Math.sin((i / size.width) * 4 * Math.pi),
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Math {
  static double sin(double radians) => radians.sin();
  static const double pi = 3.141592653589793;
}

extension on double {
  double sin() {
    double x = this;
    while (x > Math.pi) x -= 2 * Math.pi;
    while (x < -Math.pi) x += 2 * Math.pi;

    double result = x;
    double term = x;
    for (int n = 1; n <= 10; n++) {
      term *= -x * x / ((2 * n) * (2 * n + 1));
      result += term;
    }
    return result;
  }
}

















// class AddProductSignInPage extends StatelessWidget {
//   const AddProductSignInPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFFE0F2FE),
//               Color(0xFFBAE6FD),
//             ],
//           ),
//         ),
//
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//
//                   // Product Image Circle with Plus Button
//                   Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//
//                       // White Circle Container
//                       Container(
//                         width: 220,
//                         height: 220,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 20,
//                               offset: const Offset(0, 10),
//                             ),
//                           ],
//                         ),
//
//                         child: Center(
//                           child: Container(
//                             width: 160,
//                             height: 160,
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                                 colors: [
//                                   Color(0xFFFFD7BA),
//                                   Color(0xFFFFCBA4),
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//
//                             child: Stack(
//                               children: [
//
//                                 // Serum Bottle
//                                 Center(
//                                   child: CustomPaint(
//                                     size: const Size(50, 80),
//                                     painter: SerumBottlePainter(),
//                                   ),
//                                 ),
//
//                                 // Wavy line decoration
//                                 Positioned(
//                                   bottom: 12,
//                                   left: 12,
//                                   right: 12,
//                                   child: CustomPaint(
//                                     size: const Size(136, 20),
//                                     painter: WavyLinePainter(),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//                     ],
//                   ),
//                   const SizedBox(height: 60),
//
//                   // Title
//                   const Text(
//                     'Want to add your\nown products?',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1F2937),
//                       fontFamily: "Poppins",
//                       height: 1.2,
//                     ),
//                   ),
//
//                   const SizedBox(height: 32),
//
//                   // Description
//                   const Text(
//                     'Sign in to keep track of your unique\nproducts and integrate them into your\nroutine.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 17,
//                       color: Color(0xFF6B7280),
//                       fontFamily: "Poppins",
//                       height: 1.5,
//                     ),
//                   ),
//
//                   const SizedBox(height: 180),
//
//
//                   // Sign In Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Handle sign in
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.teal,
//                         foregroundColor: Colors.black,
//                         elevation: 8,
//                         shadowColor: Colors.black.withOpacity(0.3),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(28),
//                         ),
//                       ),
//
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//
//                           Text(
//                             'Sign In',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//
//                           SizedBox(width: 8),
//
//                           Icon(Icons.arrow_forward, size: 20),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Custom Painter for Serum Bottle
// class SerumBottlePainter extends CustomPainter {
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..style = PaintingStyle.fill;
//
//     // Bottle body
//     paint.color = const Color(0xFFFFF8F0);
//     final bottleRect = RRect.fromRectAndRadius(
//       Rect.fromLTWH(size.width * 0.2, size.height * 0.2, size.width * 0.6, size.height * 0.7),
//       const Radius.circular(8),
//     );
//     canvas.drawRRect(bottleRect, paint);
//
//     // Bottle border
//     paint.style = PaintingStyle.stroke;
//     paint.color = const Color(0xFFD1D5DB);
//     paint.strokeWidth = 2;
//     canvas.drawRRect(bottleRect, paint);
//
//     // Dropper cap
//     paint.style = PaintingStyle.fill;
//     paint.color = const Color(0xFFE5E7EB);
//     final capRect = RRect.fromRectAndRadius(
//       Rect.fromLTWH(size.width * 0.3, size.height * 0.05, size.width * 0.4, size.height * 0.15),
//       const Radius.circular(6),
//     );
//     canvas.drawRRect(capRect, paint);
//
//     // Dropper tube
//     paint.color = const Color(0xFFD1D5DB);
//     canvas.drawRect(
//       Rect.fromLTWH(size.width * 0.48, size.height * 0.15, size.width * 0.04, size.height * 0.08),
//       paint,
//     );
//
//     // Label on bottle
//     paint.color = Colors.white.withOpacity(0.8);
//     final labelRect = RRect.fromRectAndRadius(
//       Rect.fromLTWH(size.width * 0.25, size.height * 0.4, size.width * 0.5, size.height * 0.3),
//       const Radius.circular(4),
//     );
//     canvas.drawRRect(labelRect, paint);
//
//     // Label lines
//     paint.color = const Color(0xFF9CA3AF);
//     paint.strokeWidth = 1.5;
//     canvas.drawLine(
//       Offset(size.width * 0.35, size.height * 0.5),
//       Offset(size.width * 0.65, size.height * 0.5),
//       paint,
//     );
//     canvas.drawLine(
//       Offset(size.width * 0.32, size.height * 0.56),
//       Offset(size.width * 0.68, size.height * 0.56),
//       paint,
//     );
//     canvas.drawLine(
//       Offset(size.width * 0.38, size.height * 0.62),
//       Offset(size.width * 0.62, size.height * 0.62),
//       paint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
//
// // Custom Painter for Wavy Line
// class WavyLinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFFD4A574)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;
//
//     final path = Path();
//     path.moveTo(0, size.height / 2);
//
//     for (double i = 0; i < size.width; i++) {
//       path.lineTo(
//         i,
//         size.height / 2 + 3 * Math.sin((i / size.width) * 4 * Math.pi),
//       );
//     }
//
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
//
// class Math {
//   static double sin(double radians) => radians.sin();
//   static const double pi = 3.141592653589793;
// }
//
// extension on double {
//   double sin() {
//     // Simple sine approximation using Taylor series
//     double x = this;
//     while (x > Math.pi) x -= 2 * Math.pi;
//     while (x < -Math.pi) x += 2 * Math.pi;
//
//     double result = x;
//     double term = x;
//     for (int n = 1; n <= 10; n++) {
//       term *= -x * x / ((2 * n) * (2 * n + 1));
//       result += term;
//     }
//     return result;
//   }
// }

