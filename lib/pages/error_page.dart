import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hms_portfolio/components/page_header.dart';
import 'package:hms_portfolio/components/responsive_util.dart';
import 'package:hms_portfolio/components/text.dart';

/// Simple 404 page: blue.shade900 background with amber accents.
///
/// Use it as `onUnknownRoute` or as a fallback route:
///   onUnknownRoute: (_) => MaterialPageRoute(builder: (_) => const Error404Page()),
class Error404Page extends StatefulWidget {

  final VoidCallback? onGoHome;

  const Error404Page({super.key, this.onGoHome});

  @override
  State<Error404Page> createState() => _Error404PageState();
}

class _Error404PageState extends State<Error404Page> with SingleTickerProviderStateMixin {
      
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  late final Animation<double> _offset = Tween<double>(begin: -8, end: 8)
      .animate(CurvedAnimation(parent: _float, curve: Curves.easeInOut));

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  void _goHome() {
    if (widget.onGoHome != null) {
      widget.onGoHome!();
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.blue.shade500,
      appBar: PreferredSize(  
        preferredSize: Size.fromHeight(120),
        child: PageHeader(),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: .center,
            mainAxisAlignment: .center,
            children: [
              // Floating icon
              AnimatedBuilder(
                animation: _offset,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _offset.value),
                  child: child,
                ),
                
                child: Column(
                  mainAxisSize: .min,
                  children: [
            
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber.withAlpha(30),
                        border: Border.all(color: Colors.amber, width: 2),
                      ),
                      child: const Icon(
                        Icons.local_hospital_rounded,
                        size: 56,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),
              
              HeaderText(
                '404',
                textColor: Colors.amber,
                fontSize: ResponsiveUtil.sizeBasedValue<double>(  
                  context: context, 
                  mobileValue: 88, 
                  desktopValue: 120
                ),   
              ),

              const SizedBox(height: 12),
            
            
              const CustomText(
                'Page not found',
                textColor: Colors.white,
                fontSize: 26,
              ),
            
              const SizedBox(height: 10),
            
            
              CustomText(
                "Sorry, the page you're looking for doesn't exist or has been moved.",
                textAlignment: TextAlign.center,
                fontSize: 16,
                textColor: Colors.white.withAlpha(200),
              ),
            
              
              const SizedBox(height: 32),
            
            
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton.icon(
                    onPressed: _goHome,
                    icon: const Icon(Icons.home_rounded),
                    label: const CustomText(
                      'Back to Home', 
                      fontWeight: FontWeight.w600,
                      textColor: Colors.white,
                      fontSize: 16,
                    ),

                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24, 
                        vertical: 16
                      ),
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const CustomText(
                      'Go Back',
                      textColor: Colors.amber, 
                      fontSize: 16, 
                      fontWeight: FontWeight.w600,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.amber,
                      side: const BorderSide(color: Colors.amber, width: 1.5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24, 
                        vertical: 16
                      ),
                     
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}