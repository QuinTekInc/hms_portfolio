
import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/responsive_util.dart';
import 'text.dart';
import 'package:hms_portfolio/models/models.dart';


//section container
class SectionContainer extends StatelessWidget {

  final Widget child;
  final Color? backgroundColor;

  const new({
    super.key,
    required this.child, 
    this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Container( 
      width: double.infinity,
      color: backgroundColor, 
      padding: EdgeInsets.symmetric( 
        horizontal: ResponsiveUtil.sizeBasedValue<double>( 
          context: context, 
          mobileValue: 16, 
          desktopValue: 36,
        ),
        vertical: 24
      ),
      child: child,
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




const _months = [
  'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
  'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
];


class EventCard extends StatefulWidget {

  final HospitalEvent event;

  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    final color = e.category.color;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hover ? color.withAlpha(120) : const Color(0xFFE3ECEF),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(_hover ? 30 : 12),
              blurRadius: _hover ? 24 : 12,
              offset: Offset(0, _hover ? 12 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date badge
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: color.withAlpha(28),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${e.date.day}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: color,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _months[e.date.month - 1],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Category tag
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withAlpha(28),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(e.category.icon, size: 14, color: color),
                      const SizedBox(width: 6),
                      Text(
                        e.category.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              e.title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                height: 1.25,
                color: Color(0xFF12303A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              e.description,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.5,
                color: Color(0xFF5B7480),
              ),
            ),
            const SizedBox(height: 16),
            _InfoRow(icon: Icons.schedule_rounded, text: e.time),
            const SizedBox(height: 6),
            _InfoRow(icon: Icons.place_rounded, text: e.location),
            const SizedBox(height: 18),

            Spacer(),
            
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: navigateToRegistrationPage,
                child: const Text('Register interest'),
              ),
            ),
          ],
        ),
      ),
    );
  }


  //mainly to open a new tab to the next website
  void navigateToRegistrationPage() async {
    // TODO: navigate to a registration form or booking page.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration for "${widget.event.title}" coming soon')),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF7D93A0)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF365564),
            ),
          ),
        ),
      ],
    );
  }
}





