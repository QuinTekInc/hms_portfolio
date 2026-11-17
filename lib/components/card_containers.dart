
import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/responsive_util.dart';
import 'text.dart';


//section container
class SectionContainer extends StatelessWidget {

  final Widget child;
  final Color? backgroundColor;

  final double? _maxWidth;
  final bool _useDefaultMaxWidth;
  final double? _minHeight;
  final double? _maxHeight;

  const new({
    super.key,
    required this.child, 
    this.backgroundColor, 
    this._maxWidth, 
    this._useDefaultMaxWidth = true,
    this._minHeight,
    this._maxHeight
  });

  @override
  Widget build(BuildContext context) {
    return Container( 
      width: double.infinity,
      color: backgroundColor, 
      alignment: Alignment.center,

      padding: EdgeInsets.symmetric( 
        horizontal: ResponsiveUtil.sizeBasedValue<double>( 
          context: context, 
          mobileValue: 16, 
          desktopValue: 36,
        ),
        vertical: 24
      ),

      child: ConstrainedBox(  
        constraints: BoxConstraints( 
          maxWidth: _maxWidth ?? (_useDefaultMaxWidth ? 1100 : double.infinity), 
          minHeight: _minHeight ?? 0.0,
          maxHeight: _maxHeight ?? double.infinity
        ),

        child: child,
      ),
    );
  }

}



//card container for cards like the choose us.
class CardContainer extends StatelessWidget {

  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final String title; 
  final String detail;
  final Color? backgroundColor;
  final Color? titleTextColor;
  final Color? detailTextColor;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;

  const new({
    super.key,
    required this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    required this.title, 
    required this.detail,
    this.backgroundColor, 
    this.titleTextColor, 
    this.detailTextColor,
    this.mainAxisAlignment, 
    this.crossAxisAlignment
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(  
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white70,
          borderRadius: BorderRadius.circular(12), 
        ),
        child: Column(  
          mainAxisAlignment: mainAxisAlignment ?? .start,
          crossAxisAlignment: crossAxisAlignment ?? .start,
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
      
            Container(  
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(  
                borderRadius: BorderRadius.circular(12),
                color: iconBackgroundColor ?? Colors.blue.shade900,
                border: Border.all(color: Colors.white70)
              ),
              child: Icon(
                icon, 
                color: iconColor ?? Colors.white,
              ),
            ), 
      
            HeaderText(
              title, 
              textColor: titleTextColor ?? Colors.black87,
              fontSize: 18,
            ), 
      
      
            CustomText(  
              detail, 
              fontSize: 14,
              textColor: detailTextColor ?? Colors.black87,
            )
      
          ],
        )
      ),
    );
  }
}





class StatContainer extends StatelessWidget {

  final IconData icon;
  final String title;
  final String detail;

  const new({
    super.key, 
    required this.icon, 
    required this.title, 
    required this.detail
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [

          Icon(
            icon, 
            color: Colors.blue.shade900, 
            size: 32
          ),

          const SizedBox(height: 8),

          HeaderText(
            title,
            textColor: Colors.blue.shade900,
            fontSize: 30,
          ),


          CustomText(
            detail, 
          ),
        ],
      ),
    );
  }
}

