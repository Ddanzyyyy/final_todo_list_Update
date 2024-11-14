// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:async';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:to_do_list_app/main.dart';
// import 'dart:math' as math;

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late AnimationController _pulseController;
//   late AnimationController _rotationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _pulseAnimation;

//   final List<ParticleModel> particles = List.generate(
//     20,
//     (index) => ParticleModel(
//       position: Offset(
//         math.Random().nextDouble() * 400,
//         math.Random().nextDouble() * 800,
//       ),
//       speed: Offset(
//         (math.Random().nextDouble() - 0.5) * 2,
//         (math.Random().nextDouble() - 0.5) * 2,
//       ),
//       size: math.Random().nextDouble() * 8 + 4,
//     ),
//   );

//   @override
//   void initState() {
//     super.initState();
    
//     // Mengurangi durasi animasi utama
//     _controller = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     );

//     _pulseController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     )..repeat(reverse: true);

//     _rotationController = AnimationController(
//       duration: const Duration(seconds: 10),
//       vsync: this,
//     )..repeat();

//     // Menyederhanakan animasi fade
//     _fadeAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeIn,
//     );

//     // Memperbaiki scale animation dengan single tween
//     _scaleAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.elasticOut,
//       ),
//     );

//     _pulseAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.1,
//     ).animate(_pulseController);

//     _controller.forward();
//     _updateParticles();
//     _navigateToHome();
//   }

//   void _updateParticles() {
//     Timer.periodic(const Duration(milliseconds: 16), (timer) {
//       if (!mounted) {
//         timer.cancel();
//         return;
//       }
//       setState(() {
//         for (var particle in particles) {
//           particle.position += particle.speed;
          
//           if (particle.position.dx < 0 || particle.position.dx > 400) {
//             particle.speed = Offset(-particle.speed.dx, particle.speed.dy);
//           }
//           if (particle.position.dy < 0 || particle.position.dy > 800) {
//             particle.speed = Offset(particle.speed.dx, -particle.speed.dy);
//           }
//         }
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _pulseController.dispose();
//     _rotationController.dispose();
//     super.dispose();
//   }

//   _navigateToHome() async {
//     await Future.delayed(const Duration(seconds: 5)); // Mengurangi waktu delay
//     if (mounted) {
//       Navigator.pushReplacement(
//         context,
//         PageRouteBuilder(
//           pageBuilder: (context, animation, secondaryAnimation) => const ToDoListScreen(),
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             return FadeTransition(
//               opacity: animation,
//               child: SlideTransition(
//                 position: Tween<Offset>(
//                   begin: const Offset(0, 0.5),
//                   end: Offset.zero,
//                 ).animate(animation),
//                 child: child,
//               ),
//             );
//           },
//           transitionDuration: const Duration(milliseconds: 800),
//         ),
//       );
//     }
//   }

//   Widget _buildNetworkImage(String url, double height, double width) {
//     return Image.network(
//       url,
//       height: height,
//       width: width,
//       fit: BoxFit.contain,
//       loadingBuilder: (context, child, loadingProgress) {
//         if (loadingProgress == null) return child;
//         return SizedBox(
//           height: height,
//           width: width,
//           child: Center(
//             child: CircularProgressIndicator(
//               value: loadingProgress.expectedTotalBytes != null
//                   ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//                   : null,
//               color: const Color(0xFF636E72),
//             ),
//           ),
//         );
//       },
//       errorBuilder: (context, error, stackTrace) {
//         return SizedBox(
//           height: height,
//           width: width,
//           child: const Icon(
//             Icons.error_outline,
//             color: Colors.red,
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           ...particles.map((particle) => Positioned(
//             left: particle.position.dx,
//             top: particle.position.dy,
//             child: Container(
//               width: particle.size,
//               height: particle.size,
//               decoration: BoxDecoration(
//                 color: Colors.blue.withOpacity(0.2),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           )),
          
//           SafeArea(
//             child: AnimatedBuilder(
//               animation: _controller,
//               builder: (context, child) {
//                 return FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Spacer(),
//                         ScaleTransition(
//                           scale: _scaleAnimation,
//                           child: AnimatedBuilder(
//                             animation: _pulseAnimation,
//                             builder: (context, child) {
//                               return Transform.scale(
//                                 scale: _pulseAnimation.value,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.blue.withOpacity(0.3),
//                                         spreadRadius: 5,
//                                         blurRadius: 20,
//                                         offset: const Offset(0, 3),
//                                       ),
//                                     ],
//                                   ),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(20),
//                                     child: _buildNetworkImage(
//                                       'https://img.freepik.com/free-vector/online-wishes-list-concept-illustration_114360-3055.jpg',
//                                       200,
//                                       200,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 40),
//                         DefaultTextStyle(
//                           style: GoogleFonts.poppins(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: const Color(0xFF2D3436),
//                           ),
//                           child: AnimatedTextKit(
//                             animatedTexts: [
//                               TypewriterAnimatedText(
//                                 'To Do List App',
//                                 speed: const Duration(milliseconds: 150),
//                               ),
//                             ],
//                             isRepeatingAnimation: false,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         ShaderMask(
//                           shaderCallback: (Rect bounds) {
//                             return const LinearGradient(
//                               colors: [Colors.blue, Colors.purple],
//                             ).createShader(bounds);
//                           },
//                           child: Text(
//                             'Kelompok 3',
//                             style: GoogleFonts.poppins(
//                               fontSize: 18,
//                               color: Colors.white,
//                               letterSpacing: 1.5,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                         const Spacer(),
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             children: [
//                               // RotationTransition(
//                               //   turns: _rotationController,
//                               //   child: _buildNetworkImage(
//                               //     'https://1.bp.blogspot.com/-j4TSpuiugjA/X4lyFe4lrEI/AAAAAAAAJoM/KJuAMh9i7yApLp0yeTdPqZjMUVNBvGrFQCLcBGAsYHQ/w1200-h630-p-k-no-nu/Unpak.png',
//                               //     50,
//                               //     50,
//                               //   ),
//                               // ),
//                               const SizedBox(height: 12),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 16,
//                                   vertical: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Colors.blue.withOpacity(0.3),
//                                       Colors.purple.withOpacity(0.3),
//                                     ],
//                                   ),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Text(
//                                   'Version 1.1 Beta',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 14,
//                                     color: const Color(0xFF636E72),
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ParticleModel {
//   Offset position;
//   Offset speed;
//   final double size;

//   ParticleModel({
//     required this.position,
//     required this.speed,
//     required this.size,
//   });
// }