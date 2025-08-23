import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _routeController;
  late AnimationController _pulseController;
  late AnimationController _dotController;
  late AnimationController _textController;
  late AnimationController _progressController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _routeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _dotAnimation;
  late Animation<double> _textFade;
  late Animation<double> _textSlide;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Route drawing animation
    _routeController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    // Pulse animation for the route lines
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    
    // Red dot movement animation
    _dotController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    // Text animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Progress animation
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 6000),
      vsync: this,
    );

    // Setup animations
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    ));

    _routeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _routeController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _dotAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dotController,
      curve: Curves.easeInOut,
    ));

    _textFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _textSlide = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.elasticOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
    _navigateToLogin();
  }

  void _startAnimations() async {
    // Start logo animation
    _logoController.forward();
    
    // Start text animation after logo
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    
    // Start route animation
    await Future.delayed(const Duration(milliseconds: 400));
    _routeController.forward();
    _pulseController.repeat(reverse: true);
    
    // Start progress
    _progressController.forward();
    
    // Start dot animation after route is partially drawn
    await Future.delayed(const Duration(milliseconds: 800));
    _dotController.repeat();
  }

  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 7));
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _routeController.dispose();
    _pulseController.dispose();
    _dotController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
              const Color(0xFF0f3460),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            ...List.generate(20, (index) => _buildBackgroundParticle(index)),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with enhanced animation
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScale.value,
                        child: Opacity(
                          opacity: _logoOpacity.value,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD4A574).withOpacity(0.5),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color(0xFFD4A574),
                                      const Color(0xFFB8956A),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.location_city,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // App title with enhanced animation
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _textSlide.value),
                        child: Opacity(
                          opacity: _textFade.value,
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                const Color(0xFFD4A574),
                                const Color(0xFFFFD700),
                                const Color(0xFFD4A574),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Text(
                              'ManilaServe',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Subtitle
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textFade.value,
                        child: const Text(
                          'Your Smart Guide Through Manila City Hall',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Route animation container
                  Container(
                    width: 280,
                    height: 200,
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _routeAnimation,
                        _pulseAnimation,
                        _dotAnimation,
                      ]),
                      builder: (context, child) {
                        return CustomPaint(
                          painter: EnhancedRouteFinderPainter(
                            routeProgress: _routeAnimation.value,
                            pulseOpacity: _pulseAnimation.value,
                            dotProgress: _dotAnimation.value,
                          ),
                          size: const Size(280, 200),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Loading text
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textFade.value,
                        child: const Text(
                          'Mapping your journey...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Enhanced progress bar
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return Container(
                        width: 200,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: 200 * _progressAnimation.value,
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFD4A574),
                                    Color(0xFFFFD700),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFD4A574).withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundParticle(int index) {
    final random = math.Random(index);
    final size = MediaQuery.of(context).size;
    
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Positioned(
          left: random.nextDouble() * size.width,
          top: random.nextDouble() * size.height,
          child: Opacity(
            opacity: (0.1 + random.nextDouble() * 0.3) * _pulseAnimation.value,
            child: Container(
              width: 2 + random.nextDouble() * 4,
              height: 2 + random.nextDouble() * 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD4A574),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4A574).withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class EnhancedRouteFinderPainter extends CustomPainter {
  final double routeProgress;
  final double pulseOpacity;
  final double dotProgress;

  EnhancedRouteFinderPainter({
    required this.routeProgress,
    required this.pulseOpacity,
    required this.dotProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Define route points (simulating Manila City Hall layout)
    final routePoints = [
      Offset(center.dx - 100, center.dy - 60), // Entrance
      Offset(center.dx - 60, center.dy - 80),  // Security
      Offset(center.dx - 20, center.dy - 70),  // Information desk
      Offset(center.dx + 20, center.dy - 40),  // Registry
      Offset(center.dx + 80, center.dy - 20),  // Treasury
      Offset(center.dx + 60, center.dy + 20),  // Business office
      Offset(center.dx + 20, center.dy + 50),  // Mayor's office
      Offset(center.dx - 20, center.dy + 60),  // Social services
      Offset(center.dx - 60, center.dy + 40),  // Legal office
      Offset(center.dx - 80, center.dy + 10),  // Exit
    ];

    // Draw enhanced background grid
    _drawEnhancedGrid(canvas, size);
    
    // Draw building outlines
    _drawBuildingOutlines(canvas, size);
    
    // Draw route with enhanced effects
    _drawEnhancedRoute(canvas, routePoints);
    
    // Draw office markers
    _drawOfficeMarkers(canvas, routePoints);
    
    // Draw moving dot with trail
    _drawEnhancedMovingDot(canvas, routePoints);
  }

  void _drawEnhancedGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFD4A574).withOpacity(0.15)
      ..strokeWidth = 0.5;

    // Draw grid with perspective effect
    for (double x = 0; x < size.width; x += 25) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    for (double y = 0; y < size.height; y += 25) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
  }

  void _drawBuildingOutlines(Canvas canvas, Size size) {
    final buildingPaint = Paint()
      ..color = const Color(0xFFD4A574).withOpacity(0.2)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw simplified building layouts
    final buildings = [
      Rect.fromCenter(center: Offset(center.dx - 60, center.dy - 50), width: 40, height: 30),
      Rect.fromCenter(center: Offset(center.dx + 60, center.dy - 30), width: 35, height: 25),
      Rect.fromCenter(center: Offset(center.dx + 40, center.dy + 40), width: 45, height: 35),
      Rect.fromCenter(center: Offset(center.dx - 40, center.dy + 50), width: 40, height: 30),
    ];

    for (final building in buildings) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(building, const Radius.circular(4)),
        buildingPaint,
      );
    }
  }

  void _drawEnhancedRoute(Canvas canvas, List<Offset> points) {
    final routePaint = Paint()
      ..color = const Color(0xFFD4A574).withOpacity(pulseOpacity * 0.9)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = const Color(0xFFD4A574).withOpacity(pulseOpacity * 0.4)
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()
      ..color = const Color(0xFFD4A574).withOpacity(pulseOpacity * 0.2)
      ..strokeWidth = 12.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      final segmentProgress = ((routeProgress * points.length) - i).clamp(0.0, 1.0);
      
      if (segmentProgress > 0) {
        final start = points[i];
        final end = points[i + 1];
        final currentEnd = Offset(
          start.dx + (end.dx - start.dx) * segmentProgress,
          start.dy + (end.dy - start.dy) * segmentProgress,
        );

        // Draw shadow
        canvas.drawLine(start, currentEnd, shadowPaint);
        // Draw glow
        canvas.drawLine(start, currentEnd, glowPaint);
        // Draw main line
        canvas.drawLine(start, currentEnd, routePaint);
      }
    }
  }

  void _drawOfficeMarkers(Canvas canvas, List<Offset> points) {
    final markerPaint = Paint()
      ..color = const Color(0xFFD4A574).withOpacity(pulseOpacity)
      ..style = PaintingStyle.fill;

    final markerOutlinePaint = Paint()
      ..color = Colors.white.withOpacity(pulseOpacity * 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < points.length; i++) {
      final pointProgress = ((routeProgress * points.length) - i).clamp(0.0, 1.0);
      if (pointProgress > 0) {
        // Draw marker shadow
        canvas.drawCircle(
          points[i].translate(1, 1),
          6.0,
          Paint()..color = Colors.black.withOpacity(0.2),
        );
        
        // Draw marker
        canvas.drawCircle(points[i], 5.0, markerPaint);
        canvas.drawCircle(points[i], 5.0, markerOutlinePaint);
        
        // Draw inner dot
        canvas.drawCircle(
          points[i],
          2.0,
          Paint()..color = Colors.white.withOpacity(pulseOpacity),
        );
      }
    }
  }

  void _drawEnhancedMovingDot(Canvas canvas, List<Offset> points) {
    if (routeProgress < 0.3) return;

    final dotPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final trailPaint = Paint()
      ..color = Colors.red.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Calculate position along the route
    final totalSegments = points.length - 1;
    final adjustedProgress = (dotProgress % 1.0);
    final currentSegment = (adjustedProgress * totalSegments).floor();
    final segmentProgress = (adjustedProgress * totalSegments) - currentSegment;

    if (currentSegment < totalSegments) {
      final start = points[currentSegment];
      final end = points[currentSegment + 1];
      
      final currentPosition = Offset(
        start.dx + (end.dx - start.dx) * segmentProgress,
        start.dy + (end.dy - start.dy) * segmentProgress,
      );

      // Draw trail dots
      for (int i = 1; i <= 5; i++) {
        final trailOffset = Offset(
          start.dx + (end.dx - start.dx) * (segmentProgress - i * 0.1).clamp(0.0, 1.0),
          start.dy + (end.dy - start.dy) * (segmentProgress - i * 0.1).clamp(0.0, 1.0),
        );
        
        if ((segmentProgress - i * 0.1) > 0) {
          canvas.drawCircle(
            trailOffset,
            (6 - i).toDouble(),
            Paint()..color = Colors.red.withOpacity(0.3 / i),
          );
        }
      }

      // Draw outer glow
      canvas.drawCircle(currentPosition, 12.0, glowPaint);
      
      // Draw main dot shadow
      canvas.drawCircle(
        currentPosition.translate(1, 1),
        6.0,
        Paint()..color = Colors.black.withOpacity(0.3),
      );
      
      // Draw main dot
      canvas.drawCircle(currentPosition, 6.0, dotPaint);
      
      // Draw inner highlight
      canvas.drawCircle(
        currentPosition.translate(-1, -1),
        2.0,
        Paint()..color = Colors.white.withOpacity(0.8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}