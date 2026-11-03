
import 'package:flutter/material.dart';


//all animations comes here. 
class FadeSlideIn extends StatelessWidget {
  
  const FadeSlideIn({super.key, 
    required this.index, 
    required this.child
  });

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 450 + index * 70),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - t)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}


/// Smoothly interpolates between [min] (at 360px wide) and [max] (at 1200px).
double fluidInterpolation(BuildContext context, double min, double max) {
  final w = MediaQuery.sizeOf(context).width;
  final t = ((w - 360) / (1200 - 360)).clamp(0.0, 1.0);
  return min + (max - min) * t;
}



/// Fades and slides [child] in the first time it scrolls into view.
Widget revealAnimationWidget({required Widget child, Duration delay = Duration.zero}) {
  return _Reveal(
    delay: delay,
    builder: (context, visible) => AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, 0.06),
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOutCubic,
        child: child,
      ),
    ),
  );
}

class _Reveal extends StatefulWidget {
  const _Reveal({required this.builder, this.delay = Duration.zero});

  final Widget Function(BuildContext context, bool visible) builder;
  final Duration delay;

  @override
  State<_Reveal> createState() => _RevealState();
}

class _RevealState extends State<_Reveal> {
  
  bool _visible = false;
  bool _triggered = false;
  ScrollPosition? _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final pos = Scrollable.maybeOf(context)?.position;
    if (pos != _position) {
      _position?.removeListener(_check);
      _position = pos;
      _position?.addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_triggered || !mounted) return;
    final box = context.findRenderObject();

    if (box is! RenderBox || !box.attached || !box.hasSize) return;

    final top = box.localToGlobal(Offset.zero).dy;
    final viewportHeight = MediaQuery.sizeOf(context).height;

    if (top < viewportHeight * 0.92) {
      _triggered = true;
      _position?.removeListener(_check);
      Future.delayed(widget.delay, () {
        if (mounted) setState(() => _visible = true);
      });
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _visible);
}