
import 'package:flutter/material.dart';

class ResponsiveUtil{

  static bool isMobile(context) => MediaQuery.of(context).size.width <= 720;
  static bool isDesktop(context) => MediaQuery.of(context).size.width > 720;


  static T sizeBasedValue<T>({
    required BuildContext context, 
    required T desktopValue, required T mobileValue}){

    if(isMobile(context)) return mobileValue;

    return desktopValue;

  }



  static Widget sizeBasedWidget({required Widget mobileView, required Widget desktopView}){
    return LayoutBuilder(  
      builder: (context, _){
        if(isMobile(context)) return mobileView;

        return desktopView;
      },
    );
  }

  
}



class ResponsiveGrid extends StatelessWidget {

  final List<Widget>? _children;
  final int? _itemCount;
  final Widget Function(BuildContext context, int index)? _itemBuilder;

  final WrapAlignment _horizontalAlignment;
  final WrapAlignment _verticalAlignment;

  final double? mainAxisExtent;
  final double minItemWidth;
  final double spacing;

  const ResponsiveGrid({
    super.key,
    required List<Widget> this._children,
    this.mainAxisExtent,
    this.minItemWidth = 280,
    this.spacing = 24,
    this._horizontalAlignment = .center,
    this._verticalAlignment = .center
  }) : _itemCount = null,
      _itemBuilder = null;


  
  const ResponsiveGrid.builder({
    super.key,
    this.minItemWidth = 280,
    this.mainAxisExtent,
    this.spacing = 16,
    this._horizontalAlignment = .center,
    this._verticalAlignment = .center,
    required int this._itemCount, //object is accessed as itemCount
    required Widget Function(BuildContext context, int index) this._itemBuilder, //object is accessed as _itemBuilder
  }) : _children = null;



  @override
  Widget build(BuildContext context) {

    final children = _children ??
        List<Widget>.generate(
          _itemCount!,
          (index) => _itemBuilder!(context, index),
        );

    if (children.isEmpty) return const SizedBox.shrink();


    return LayoutBuilder(builder: (context, c) {
      final cols = ((c.maxWidth + spacing) / (minItemWidth + spacing))
          .floor()
          .clamp(1, children.length)
          .toInt();
      final w = (c.maxWidth - spacing * (cols - 1)) / cols;


      return Wrap(
        spacing: spacing,
        runSpacing: spacing,

        alignment: _horizontalAlignment,
        runAlignment: _verticalAlignment,
        children: [
          for (final ch in children) SizedBox(
            width: w, 
            height: mainAxisExtent, 
            child: ch
          )
        ],
      );
    });
  }
}