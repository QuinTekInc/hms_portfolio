
import 'package:flutter/material.dart';

enum EventCategory { 
  healthTalk, screening, training, community, other;

  static EventCategory fromTypeString(String typeString){
    for(final category in EventCategory.values){
      if(category.label == typeString) return category;
    }

    return other;
  }
  
 }

extension EventCategoryX on EventCategory {

   String get typeString => switch (this) {
        EventCategory.healthTalk => 'health_talk',
        EventCategory.screening => 'screening',
        EventCategory.training => 'training',
        EventCategory.community => 'community',
        EventCategory.other => 'other'
      };

  String get label => switch (this) {
        EventCategory.healthTalk => 'Health Talk',
        EventCategory.screening => 'Screening',
        EventCategory.training => 'Training',
        EventCategory.community => 'Community',
        EventCategory.other => 'Other'
      };

  Color get color => switch (this) {
        EventCategory.healthTalk => const Color(0xFF0E7C86),
        EventCategory.screening => const Color(0xFFD9534F),
        EventCategory.training => const Color(0xFF6C5CE7),
        EventCategory.community => const Color(0xFFEF8F2D),
        EventCategory.other => Colors.blue.shade600
      };

  IconData get icon => switch (this) {
        EventCategory.healthTalk => Icons.record_voice_over_rounded,
        EventCategory.screening => Icons.monitor_heart_rounded,
        EventCategory.training => Icons.school_rounded,
        EventCategory.community => Icons.groups_rounded,
        EventCategory.other => Icons.event_available_rounded
      };
}


enum EventStatus{pending, ongoing, past, cancelled, unknown}

extension EventStatusX on EventStatus{
  String get label => switch(this){
    EventStatus.pending => 'pending',
    EventStatus.ongoing => 'ongoing', 
    EventStatus.past => 'past',
    EventStatus.cancelled => 'cancelled', 
    EventStatus.unknown => 'unknown'
  };

  Color get color => switch(this){
    EventStatus.pending => Colors.blue.shade900,
    EventStatus.ongoing => Colors.green.shade900, 
    EventStatus.past => Colors.amber,
    EventStatus.cancelled => Colors.red.shade700, 
    EventStatus.unknown => Colors.orange.shade700
  };
}


class HospitalEvent {
  final String id;
  final String name;
  final EventCategory category;
  final String? theme;
  final String description;
  final String? coverImage;
  final DateTime startDate;
  final DateTime? endDate;
  final String startTime;
  final String? endTime;
  final String location;
  final bool isFlagshipEvent;
  final bool requiresRegistration;
  final EventStatus status;

  const HospitalEvent({
    required this.id,
    required this.name,
    this.theme,
    required this.description,
    this.coverImage,
    required this.startDate,
    this.endDate,
    required this.startTime,
    this.endTime,
    required this.location,
    required this.category,
    this.isFlagshipEvent = false, 
    this.requiresRegistration = false,
    this.status = EventStatus.pending
  });


  //TODO: Create a function to parse 
  factory HospitalEvent.fromJson(Map<String, dynamic> jsonMap){

    final now = DateTime.now();

    return HospitalEvent( 
      id: jsonMap['id'], 
      name: jsonMap['event_name'],
      theme: jsonMap['theme'] ?? ' ',
      description: jsonMap['description'], 
      coverImage: jsonMap['cover_image'],
      startDate: DateTime.parse(jsonMap['start_date']), 
      endDate: jsonMap.containsKey('end_date') ? DateTime.parse(jsonMap['end_date']) : null,
      startTime: '${now.hour % 12}:${now.minute} ${now.hour < 12 ? 'am':'pm'}', 
      endTime: jsonMap['end_time'],
      location: jsonMap['location'], 
      category: EventCategory.fromTypeString(jsonMap['category']),
    );
  }
}


enum RegistrationFieldType{
  text, number, email, phone, select, date, checkbox, unknown;

  static RegistrationFieldType fromString(String typeString){

    for(final rtype in RegistrationFieldType.values){
      if(rtype.typeString == typeString) return rtype;
    }

    return unknown;

  }
}


extension RegistrationFieldTypeX on RegistrationFieldType{
  String get typeString => switch(this){
    RegistrationFieldType.text => 'text',
    RegistrationFieldType.phone => 'phone',
    RegistrationFieldType.number => 'number',
    RegistrationFieldType.email => 'email', 
    RegistrationFieldType.date => 'date',
    RegistrationFieldType.checkbox => 'checkbox', 
    RegistrationFieldType.select => 'select',
    RegistrationFieldType.unknown => 'unknown'
  };
}

class RegistrationField{

  final int id;
  final String eventId;
  final String fieldKey;
  final String label;
  final bool isRequired;
  final List<String>? options;
  final int order;
  final RegistrationFieldType fieldType;

  RegistrationField({
    required this.id, 
    required this.eventId, 
    required this.fieldKey, 
    required this.label,
    this.isRequired = true, 
    this.options, 
    required this.order, 
    required this.fieldType
  });


  factory RegistrationField.fromJson(Map<String, dynamic> jsonMap){

    return RegistrationField( 
      id: jsonMap['id'],
      eventId: jsonMap['event_id'],
      fieldKey: jsonMap['key'],
      label: jsonMap['label'], 
      isRequired: jsonMap['required'] ?? true, 
      options: List<String>.from(jsonMap['options']), 
      fieldType: RegistrationFieldType.fromString(jsonMap['field_type']), 
      order: jsonMap['order']
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




enum ServiceType{
  general, specialized, unknown;

  static ServiceType fromString(String serviceString){

    for(final ServiceType serviceType in ServiceType.values){
      if(serviceType.label == serviceString) return serviceType;
    }

    return unknown;
  }
}

extension ServiceTypeX on ServiceType{

  String get label => switch(this){
    ServiceType.general => 'general',
    ServiceType.specialized => 'specialized',
    ServiceType.unknown => 'unkown'
  };

}

class HospitalService{
  
  final String serviceId;
  final String serviceName;
  final String? coverImage;
  final String serviceDetail;
  final ServiceType serviceType;


  HospitalService({
    required this.serviceId,
    required this.serviceName, 
    required this.coverImage, 
    required this.serviceDetail,
    required this.serviceType
  });


  factory HospitalService.fromJson(Map<String, dynamic> jsonMap){
    return HospitalService(
      serviceId: jsonMap['id'],
      serviceName: jsonMap['service_name'],
      coverImage: jsonMap['cover_image'],
      serviceDetail: jsonMap['detail'], 
      serviceType: ServiceType.fromString(jsonMap['category'])
    );
  }
}





class GalleryItem{
  String id;
  String description;
  String imageUrl;

  GalleryItem({
    required this.id, 
    required this.imageUrl, 
    required this.description
  });


  factory GalleryItem.fromJson(Map<String, dynamic> jsonMap){

    return GalleryItem(  
      id: jsonMap['id'],
      description: jsonMap['description'],
      imageUrl: jsonMap['image']
    );
  }
}