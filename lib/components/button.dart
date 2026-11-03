

import 'package:flutter/material.dart';
import 'text.dart';

class CustomButton extends StatelessWidget {

  final Widget? child;
  final EdgeInsets padding;
  final Function() onPressed;
  final Color? backgroundColor;
  final double height;
  final double? width;
  final bool disable;

  const CustomButton({
    super.key,
    required this.onPressed,
    this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.backgroundColor,
    this.height = 50,
    this.width,
    this.disable = false
  });

  //button with only text in it.
  factory CustomButton.withText(String text, {
    required Function() onPressed, 
    double? width, bool disable = false,
    EdgeInsets? padding,
  }){

    return CustomButton(
      onPressed: onPressed,
      padding: padding ?? EdgeInsets.zero,
      width: width,
      disable: disable,
      child: CustomText(text, fontSize: 16, textColor: Colors.white,),
    );
  }


  //button with text and an Icon
  factory CustomButton.withIcon(String text, {
    required Function() onPressed, 
    required IconData icon, 
    Color iconColor = Colors.white,
    double width = 135,
    bool disable = false
  }){

    return CustomButton(
      onPressed: onPressed,
      width: 70, 
      disable: disable,
      child: SizedBox(
        width: width,
        child: Row( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            CustomText(text, fontSize: 16, textColor: Colors.white, padding: EdgeInsets.zero,),
            const SizedBox(width: 5,),
            Icon(icon, color: iconColor,)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: padding,

      child: IgnorePointer(
        ignoring: disable,

        child: MaterialButton(
          onPressed: onPressed,
          height: height,
          minWidth: width,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          color: backgroundColor ?? Colors.green.shade400,
          child: child,
        ),

      ),
    );
  }
}





class LinkButton extends StatefulWidget{

  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final Color hoverTextColor;
  final FontWeight? fontWeight;

  const LinkButton({
    super.key, 
    required this.onPressed, 
    required this.text, 
    this.textColor = Colors.white,
    this.hoverTextColor = Colors.amber, 
    this.fontWeight
  });

  @override
  State<LinkButton> createState () => _LinkButtonState();
}



class _LinkButtonState extends State<LinkButton>{


  late Color _currentTextColor;


  @override 
  void initState(){
    super.initState();
    _currentTextColor = widget.textColor;
  }

  @override
  Widget build(BuildContext context){

    return GestureDetector(  
      onTap: widget.onPressed,
      child: MouseRegion(
        onHover: (event) => setState(() => _currentTextColor = widget.hoverTextColor),
        onExit: (event) => setState(() => _currentTextColor = widget.textColor),
        cursor: SystemMouseCursors.click,
        child: CustomText(   
          widget.text, 
          textColor: _currentTextColor,
          fontSize: 14,
          fontWeight: widget.fontWeight ?? FontWeight.normal,
        ),
      ),
    );
  }
}





//todo: custom checkBoxes.
class CustomCheckBox extends StatelessWidget {

  final bool value;
  final String text;
  final Function(bool? newValue)? onChanged;
  final MainAxisAlignment alignment;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.text,
    this.onChanged,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(  
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [

        Checkbox(
          value: value, 
          onChanged: onChanged,
          activeColor: Colors.green,
        ),

        CustomText(
          text, fontSize: 14,
          fontWeight: FontWeight.w500,
          softwrap: true
        )
      ],
    );
  }
}




class TransparentButton extends StatefulWidget {

  final VoidCallback onPressed;
  final String text;

  final double? width;
  final double? height;


  const TransparentButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.height,
    this.width,
  });

  @override
  State<TransparentButton> createState() => _TransparentButtonState();
}

class _TransparentButtonState extends State<TransparentButton> {

  Color backgroundColor = Colors.transparent;
  Color textColor = Colors.white;


  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (mouseEvent)=> setState((){
        backgroundColor = Colors.white;
        textColor = Colors.black87;
      }),
      onExit: (mouseEvent) => setState((){
        backgroundColor = Colors.transparent;
        textColor = Colors.white;
      }),

      child: GestureDetector(
        onTap: widget.onPressed,

        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),

          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,

          decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: Colors.white, width: 1.5)
          ),

          child: CustomText(
            'Continue',
            fontSize: 16,
            textColor: textColor,
          )
        ),
      ),
    );
  }
}






class CustomDropdownButton<T> extends StatefulWidget {

  final List<T> items;
  final DropdownController controller;
  final Function(T? newValue)? onChanged;
  final String? hint;
  final IconData? icon;
  final Color? backgroundColor;

  const CustomDropdownButton({
    super.key,
    required this.controller,
    this.hint,
    this.icon,
    required this.items,
    required this.onChanged,
    this.backgroundColor
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState<T>();
}

class _CustomDropdownButtonState<T> extends State<CustomDropdownButton<T>> {

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 8),

      decoration: BoxDecoration(

          color: widget.backgroundColor ?? Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),

          border: Border.all(
              color: Colors.black26,
              width: 1.5
          )
      ),

      child: DropdownButton<T>(

          value: widget.controller.value,
          icon: Icon(
            widget.icon ?? Icons.arrow_drop_down,
            color: Colors.green.shade400,
            size: widget.icon == null ? 28 : null,
          ),
          isExpanded: true,
          isDense: true,

          underline: SizedBox(),

          hint: widget.hint != null ? CustomText(
            widget.hint!,
            fontWeight: FontWeight.w600,
            textColor: Colors.black38,
          ) : null,

          items: List<DropdownMenuItem<T>>.generate(
              widget.items.length,
                  (index) => DropdownMenuItem<T>(
                value: widget.items[index],
                child: CustomText(
                    widget.items[index].toString()
                ),
              )
          ),


          borderRadius: BorderRadius.circular(12),
          //Colors.grey.shade200
          dropdownColor: Colors.grey.shade200,
          focusColor: Colors.green.shade100,

          onChanged: (newValue) {

            setState(() => widget.controller.value = newValue);


            if(widget.onChanged != null){
              widget.onChanged!.call(newValue);
            }

          }
      ),
    );
  }
}


class DropdownController<T>{

  T? value;


  DropdownController({this.value});

  void reset() => value = null;

}




class CustomChip extends StatefulWidget {
  final String text; 
  final IconData? icon;
  final Color? iconColor;
  final bool isSelected;
  final Color? textColor;
  final Color? hoverTextColor;
  final Color? backgroundColor;
  final Color? hoverBackgroundColor;
  final Color? selectedBackgroundColor;
  final void Function()? onPressed;

  const new({
    super.key, 
    required this.text, 
    this.icon,
    this.iconColor,
    this.isSelected = false,
    this.textColor, 
    this.hoverTextColor, 
    this.backgroundColor, 
    this.selectedBackgroundColor,
    this.hoverBackgroundColor, 
    this.onPressed
  });

  @override
  State<CustomChip> createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {

  bool isHovered = false;

  Color get textColor{
    if(widget.isSelected || isHovered){
      return widget.hoverTextColor ?? Colors.white;
    }

    return widget.textColor ?? Colors.black87;
  }


  Color get iconColor{
    if(widget.isSelected) return Colors.amber;

    return widget.iconColor ?? textColor;
  }

  Color get backgroundColor{

    if(widget.isSelected){
      return widget.selectedBackgroundColor ?? Colors.blue.shade900;
    }

    if(isHovered && !widget.isSelected){
      return widget.hoverBackgroundColor ?? Colors.blue.shade800;
    }

    return widget.backgroundColor ?? Colors.white;
  }



  @override
  Widget build(BuildContext context) {
    return MouseRegion(

      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,

      child: GestureDetector(
        onTap: widget.onPressed,

        child: AnimatedContainer(  
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 200),

          
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.center,

          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(999), 
            border: Border.all(width: 1.5, color: Colors.grey.shade300)
          ),
      
          child: Row(
            crossAxisAlignment: .center,
            mainAxisSize: .min,
            spacing: 8,
            children: [

              if(widget.icon != null) Icon(
                widget.icon, 
                color: iconColor,
                size: 18,
              ),

              CustomText(  
                widget.text, 
                fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                textColor: textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

