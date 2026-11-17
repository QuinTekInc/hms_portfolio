
import 'package:flutter/material.dart';
import 'package:hms_portfolio/models/models.dart';


const String aboutText = '''Laborum aute ad deserunt eu veniam labore officia sunt quis do fugiat non deserunt.
  Do culpa cupidatat amet cillum amet labore ipsum amet. Et est culpa adipisicing nulla sint.
  In reprehenderit sunt laboris adipisicing reprehenderit ipsum amet eu in duis cillum mollit.
  Dolor amet quis voluptate adipisicing ea. Anim magna mollit ipsum voluptate ullamco eu.\n
  Non sunt duis minim deserunt nulla mollit veniam ipsum fugiat eiusmod consequat incididunt.\n

  Aliquip amet eu Lorem enim. Pariatur dolore elit minim fugiat commodo eiusmod laborum.
  Adipisicing commodo sit minim excepteur sint officia nostrud enim.\n

  Eiusmod enim ex est labore Lorem reprehenderit aute est aliqua aliqua.
  Minim proident ullamco enim incididunt esse mollit elit do ad. Sunt et 
  culpa nostrud anim nulla Lorem anim ullamco exercitation. '
  Cillum veniam consequat et veniam amet consectetur.''' ;


final String motto = "Welcome to Methodist Hospital Aburaso";


final welcomeItems = [
  (
    //'Welcome to Methodist Hospital Aburaso.', 
    'Your trusted partner in health and wellness.',
    'Compassionate health care for you and your family.'
  ), 
  (
    'Everything your health needs in one place.',
    'General and specialized services delivered by a dedicated team.'
  ), 
  (
    'Quality Care you can trust', 
    'Professional, affordable and faith inspired compassionate healthcare'
  ), 

];



const accrediationLogs = [
  'assets/img/hefra_logo.png',
  'assets/img/nhis-logo.png',
  'assets/img/safecare-logo.png'
];



const List<String> generalServices = [
  'General Medical Care (Inpatient and Outpatient)', 
  'Pharmaceutical Services', 
  'Laboratory Services',
  'Diagnostic Imaging (Ultrasound/ECG)',
  'Antenatal and Postnatal Care', 
  'Reproductive and Child Health', 
  'Chronic Care', 
  'Fertility and Family Planning',
  'Home Care', 
  'Public Health', 
  'Medical Research and Training', 
  'Breast and Cervical Cancer Screening', 
  'Pastoral Care and Counselling'
];

const List<(String, String)> specialServicesList = [
  ('Obstetrics and Gynecology', 'assets/img/pediatrics.jpg'),
  ('General Surgery', 'assets/img/surgery.jpg'),
  ('Hypertension and Diabetes', 'assets/img/diabetes.jpg'),
  ('Dental Care', 'assets/img/dental-care.jpg'),
  ('Urology', 'assets/img/urology.jpg'),
  ('Pediatrics', 'assets/img/pediatrics.jpg'),
  ('Nutrition / Dietics', 'assets/img/nutrition.jpg'),
  ('Optometry / Eye care', 'assets/img/optometry.jpg'),
  ('Nose and Throad (ENT)', 'assets/img/nose-care.jpg'),
  ('Mental Health Care', 'assets/img/mental-health.jpg'),
  ('HIV/AIDS', 'assets/img/hivaids.jpg'),
];



/// Sample data. Replace with data from your API / Firestore.
final List<NewsArticle> sampleNews = [

  NewsArticle(
    title: 'New Cardiac Care Centre Opens Its Doors',
    excerpt:
        'Our state-of-the-art cardiac centre now offers advanced diagnostics, '
        'catheterisation and rehabilitation under one roof.',
    date: DateTime(2026, 10, 27),
    category: NewsCategory.announcement,
    readMinutes: 4,
  ),

  NewsArticle(
    title: '5 Simple Habits for a Healthier Heart',
    excerpt:
        'Our cardiologists share everyday changes that lower your risk of '
        'heart disease, from diet to sleep.',
    date: DateTime(2026, 10, 24),
    category: NewsCategory.healthTip,
    readMinutes: 5,
  ),
   
  NewsArticle(
    title: 'Hospital Wins Patient Safety Excellence Award',
    excerpt:
        'We were recognised for outstanding infection control and patient '
        'safety standards at this year\'s national healthcare awards.',
    date: DateTime(2026, 10, 20),
    category: NewsCategory.award,
    readMinutes: 3,
  ),

  NewsArticle(
    title: 'Study on Early Diabetes Detection Published',
    excerpt:
        'Our research team has published findings that could help clinics '
        'detect type 2 diabetes years earlier.',
    date: DateTime(2026, 10, 15),
    category: NewsCategory.research,
    readMinutes: 6,
  ),

  NewsArticle(
    title: 'Free Community Screening Reaches 1,200 Residents',
    excerpt:
        'Volunteers and staff provided free blood pressure, sugar and eye '
        'checks across three neighbouring communities.',
    date: DateTime(2026, 10, 9),
    category: NewsCategory.community,
    readMinutes: 3,
  ),

  NewsArticle(
    title: 'Updated Visiting Hours for Inpatient Wards',
    excerpt:
        'To support patient recovery, visiting hours have been updated. '
        'See the new schedule for each ward.',
    date: DateTime(2026, 10, 3),
    category: NewsCategory.announcement,
    readMinutes: 2,
  ),
  NewsArticle(
    title: 'Staying Hydrated: What Your Body Really Needs',
    excerpt:
        'How much water is enough? Our dietitians separate the myths from '
        'the facts.',
    date: DateTime(2026, 9, 28),
    category: NewsCategory.healthTip,
    readMinutes: 4,
  ),
];


final sampleEvents = [

  HospitalEvent(
    id: '1',
    name: 'Diabetes Awareness Talk',
    description:
        'Learn how to recognise early signs, manage blood sugar and eat well with our endocrinology team.',
    startDate: DateTime(2026, 12, 7),
    startTime: '10:00 AM',
    location: 'Main Auditorium',
    category: EventCategory.healthTalk,
    coverImage: 'https://www.nationalbreastcancer.org/wp-content/uploads/2026/07/bcam-graphic-5-high-res-scaled.png',
    isFlagshipEvent: true, 
    requiresRegistration: true
  ),

  HospitalEvent(
    id: '2',
    name: 'Free Blood Pressure Screening',
    description:
        'Walk in for a quick, free check-up with our nurses. No appointment needed.',
    startDate: DateTime(2026, 11, 12),
    startTime: '8:00 AM',
    location: 'Outpatient Lobby',
    category: EventCategory.screening,
  ),

  HospitalEvent(
    id: '3',
    name: 'First Aid & CPR Workshop',
    description:
        'Hands-on training in life-saving skills for schools, workplaces and families.',
    startDate: DateTime(2026, 11, 19),
    startTime: '2:00 PM',
    location: 'Training Room B',
    category: EventCategory.training,
  ),

  HospitalEvent(
    id: '4',
    name: 'Community Health Walk',
    description:
        'Join staff and neighbours for a friendly 5 km walk promoting an active lifestyle.',
    startDate: DateTime(2026, 11, 28),
    startTime: '6:30 AM',
    location: 'Hospital Gate',
    category: EventCategory.community,
  ),

  HospitalEvent(
    id: '5',
    name: "Maternal & Child Health Day",
    description:
        'Talks on antenatal care, nutrition and immunisation, with free baby weighing.',
    startDate: DateTime(2026, 12, 3),
    startTime: '9:00 AM',
    location: 'Maternity Wing',
    category: EventCategory.healthTalk,
  ),

  HospitalEvent(
    id: '6',
    name: 'Free Eye & Vision Screening',
    description:
        'Get your eyes checked by our ophthalmology team and learn how to protect your sight.',
    startDate: DateTime(2026, 12, 10),
    startTime: '9:00 AM',
    location: 'Eye Clinic',
    category: EventCategory.screening,
  ),
];

const List<String> months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String formatDate(DateTime d) => '${d.day} ${months[d.month - 1]} ${d.year}';



final sampleFields = <RegistrationField>[
  RegistrationField(
    id: 1,
    eventId: '1',
    fieldKey: 'full_name',
    label: 'Full name',
    order: 1,
    fieldType: RegistrationFieldType.text,
  ),
  RegistrationField(
    id: 2,
    eventId: '1',
    fieldKey: 'email',
    label: 'Email address',
    order: 2,
    fieldType: RegistrationFieldType.email,
  ),
  RegistrationField(
    id: 3,
    eventId: '1',
    fieldKey: 'phone',
    label: 'Phone number',
    order: 3,
    fieldType: RegistrationFieldType.phone,
  ),
  RegistrationField(
    id: 4,
    eventId: '1',
    fieldKey: 'date_of_birth',
    label: 'Date of birth',
    order: 4,
    fieldType: RegistrationFieldType.date,
  ),
  RegistrationField(
    id: 5,
    eventId: '1',
    fieldKey: 'party_size',
    label: 'Number of people attending',
    order: 5,
    fieldType: RegistrationFieldType.number,
  ),
  RegistrationField(
    id: 6,
    eventId: '1',
    fieldKey: 'screening_type',
    label: 'Screening you are interested in',
    order: 6,
    fieldType: RegistrationFieldType.select,
    options: ['Blood pressure', 'Blood sugar', 'Eye test', 'General check-up'],
  ),
  RegistrationField(
    id: 7,
    eventId: '1',
    fieldKey: 'first_time',
    label: 'This is my first time attending',
    isRequired: false,
    order: 7,
    fieldType: RegistrationFieldType.checkbox,
  ),
  RegistrationField(
    id: 8,
    eventId: '1',
    fieldKey: 'consent',
    label: 'I agree to be contacted about this event',
    order: 8,
    fieldType: RegistrationFieldType.checkbox,
  ),
];


class Constants{
  static Color navy = Colors.blue.shade900;
  static const Color muted = Color(0xFF5B7480);
  static const Color ink = Color(0xFF0D2A4A);
  static const Color surface = Color(0xFFF4F8FB);
  static const Color greyBorder = Color(0xFFE3ECEF);
}