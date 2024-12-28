import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AdvancedLoader extends StatelessWidget {
  final LoaderType type;
  final Color? color;
  final double size;

  const AdvancedLoader({
    Key? key,
    this.type = LoaderType.gradient,
    this.color,
    this.size = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case LoaderType.lottie:
        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Lottie.asset('assets/animations/loading.json'),
          ),
        );

      case LoaderType.gradient:
        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  color?.withOpacity(0.5) ?? Colors.blue,
                  color ?? Colors.blue,
                  color?.withOpacity(0.5) ?? Colors.purple,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        );

      case LoaderType.shimmer:
        return Center(
          child: Shimmer.fromColors(
            baseColor: color?.withOpacity(0.3) ?? Colors.grey[300]!,
            highlightColor: color ?? Colors.white,
            child: Container(
              width: size * 4,
              height: size * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size * 0.2),
              ),
            ),
          ),
        );

      case LoaderType.dots:
        return Center(
          child: SpinKitChasingDots(
            color: color ?? Colors.blue,
            size: size,
          ),
        );

      case LoaderType.wave:
        return Center(
          child: SpinKitWave(
            color: color ?? Colors.blue,
            size: size,
            itemCount: 5,
          ),
        );
    }
  }
}

// Custom animated 3D progress bar
class ProgressBar3D extends StatefulWidget {
  final Color? color;
  final double size;

  const ProgressBar3D({
    Key? key,
    this.color,
    this.size = 50.0,
  }) : super(key: key);

  @override
  _ProgressBar3DState createState() => _ProgressBar3DState();
}

class _ProgressBar3DState extends State<ProgressBar3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size * 4,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: _ProgressBar3DPainter(
                progress: _animation.value,
                color: widget.color ?? Colors.blue,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProgressBar3DPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ProgressBar3DPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.3)
      ..lineTo(size.width * progress, size.height * 0.3)
      ..lineTo(size.width * progress - (size.height * 0.2), size.height * 0.7)
      ..lineTo(0, size.height * 0.7)
      ..close();

    // Add 3D effect
    final shadowPath = Path()
      ..moveTo(size.width * progress, size.height * 0.3)
      ..lineTo(size.width * progress - (size.height * 0.2), size.height * 0.7)
      ..lineTo(size.width * progress, size.height * 0.7)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = color.withOpacity(0.3)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_ProgressBar3DPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

enum LoaderType {
  lottie,
  gradient,
  shimmer,
  dots,
  wave,
}
