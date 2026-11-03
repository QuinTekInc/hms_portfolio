
import 'package:flutter/material.dart';

enum EventCategory { healthTalk, screening, training, community }

extension EventCategoryX on EventCategory {
  String get label => switch (this) {
        EventCategory.healthTalk => 'Health Talk',
        EventCategory.screening => 'Free Screening',
        EventCategory.training => 'Training',
        EventCategory.community => 'Community',
      };

  Color get color => switch (this) {
        EventCategory.healthTalk => const Color(0xFF0E7C86),
        EventCategory.screening => const Color(0xFFD9534F),
        EventCategory.training => const Color(0xFF6C5CE7),
        EventCategory.community => const Color(0xFFEF8F2D),
      };

  IconData get icon => switch (this) {
        EventCategory.healthTalk => Icons.record_voice_over_rounded,
        EventCategory.screening => Icons.monitor_heart_rounded,
        EventCategory.training => Icons.school_rounded,
        EventCategory.community => Icons.groups_rounded,
      };
}

class HospitalEvent {
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final String location;

  final EventCategory category;

  const HospitalEvent({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
  });



  factory HospitalEvent.fromJson(Map<String, dynamic> jsonMap){

    final now = DateTime.now();

    return HospitalEvent(  
      title: 'Hospial Event',
      description: 'Description of event', 
      date: now, 
      time: '${now.hour % 12}:${now.minute} ${now.hour < 12 ? 'am':'pm'}', 
      location: 'Hospital premises', 
      category: EventCategory.screening
    );
  }
}




enum NewsCategory { announcement, healthTip, research, award, community }

//so the extension in more like adding extra functionality to the enum.
extension NewsCategoryX on NewsCategory {
  String get label => switch (this) {
        NewsCategory.announcement => 'Announcements',
        NewsCategory.healthTip => 'Health Tips',
        NewsCategory.research => 'Research',
        NewsCategory.award => 'Awards',
        NewsCategory.community => 'Community',
      };

  IconData get icon => switch (this) {
        NewsCategory.announcement => Icons.campaign_rounded,
        NewsCategory.healthTip => Icons.favorite_rounded,
        NewsCategory.research => Icons.science_rounded,
        NewsCategory.award => Icons.emoji_events_rounded,
        NewsCategory.community => Icons.groups_rounded,
      };

  Color get color => switch (this) {
        NewsCategory.announcement => Colors.blue.shade900,
        NewsCategory.healthTip => Colors.teal.shade700,
        NewsCategory.research => Colors.indigo.shade600,
        NewsCategory.award => Colors.amber.shade800,
        NewsCategory.community => Colors.deepOrange.shade400,
      };
}


class NewsArticle {
  final String title;
  final String excerpt;
  final bool isFeatured;
  final DateTime date;
  final NewsCategory category;
  final int readMinutes;

  /// Optional. If null (or it fails to load) a themed placeholder is shown.
  final String? imageUrl;

  const NewsArticle({
    required this.title,
    required this.excerpt,
    required this.date,
    required this.category,
    this.isFeatured = false,
    this.readMinutes = 3,
    this.imageUrl,
  });


  factory NewsArticle.fromJson(Map<String, dynamic> jsonMap){

    return NewsArticle(
      title: jsonMap['title'],
      excerpt: jsonMap['details'],
      date: DateTime.parse(jsonMap['created_at']), 
      category: NewsCategory.announcement,
      isFeatured: jsonMap['is_featured'], 
      imageUrl: jsonMap['cover_image']
    );
  }
}


