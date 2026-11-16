import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.availableWeekdays,
  });

  final String id;
  final String name;
  final String specialty;

  /// Uses DateTime.monday (1) ... DateTime.sunday (7).
  final Set<int> availableWeekdays;

  bool isAvailableOn(DateTime date) => availableWeekdays.contains(date.weekday);
}

class AppointmentRequest {
  const AppointmentRequest({
    required this.patientName,
    required this.phone,
    required this.email,
    required this.date,
    required this.doctor,
    required this.notes,
  });

  final String patientName;
  final String phone;
  final String email;
  final DateTime date;
  final Doctor doctor;
  final String notes;
}

// Replace with data from your backend.
const demoDoctors = [
  Doctor(
    id: 'd1',
    name: 'Dr. Ama Mensah',
    specialty: 'Obstetrics and Gynecology',
    availableWeekdays: {DateTime.monday, DateTime.wednesday, DateTime.friday},
  ),
  Doctor(
    id: 'd2',
    name: 'Dr. Kwame Boateng',
    specialty: 'General Surgery',
    availableWeekdays: {DateTime.tuesday, DateTime.thursday},
  ),
  Doctor(
    id: 'd3',
    name: 'Dr. Efua Owusu',
    specialty: 'Pediatrics',
    availableWeekdays: {DateTime.monday, DateTime.tuesday, DateTime.thursday},
  ),
  Doctor(
    id: 'd4',
    name: 'Dr. Yaw Asante',
    specialty: 'Dental Care',
    availableWeekdays: {DateTime.wednesday, DateTime.friday, DateTime.saturday},
  ),
];

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class AppointmentFormPage extends StatefulWidget {
  const AppointmentFormPage({
    super.key,
    this.doctors = demoDoctors,
    this.onSubmit,
  });

  final List<Doctor> doctors;

  /// Send the request to your backend here. Throw to show an error.
  final Future<void> Function(AppointmentRequest request)? onSubmit;

  @override
  State<AppointmentFormPage> createState() => _AppointmentFormPageState();
}

class _AppointmentFormPageState extends State<AppointmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  DateTime? _selectedDate;
  Doctor? _selectedDoctor;
  String? _dateError;
  String? _doctorError;
  bool _submitting = false;

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String _formatDate(DateTime d) =>
      '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';

  bool _anyDoctorOn(DateTime d) => widget.doctors.any((doc) => doc.isAvailableOn(d));

  List<Doctor> get _availableDoctors {
    final date = _selectedDate;
    if (date == null) return const [];
    return widget.doctors.where((d) => d.isAvailableOn(date)).toList();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final first = _today;
    final last = first.add(const Duration(days: 90));

    // initialDate must satisfy selectableDayPredicate, so find the first valid day.
    DateTime? initial;
    for (var d = first; !d.isAfter(last); d = d.add(const Duration(days: 1))) {
      if (_anyDoctorOn(d)) {
        initial = d;
        break;
      }
    }

    if (initial == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No doctors are available for booking right now.')),
      );
      return;
    }

    final selected = _selectedDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: (selected != null && _anyDoctorOn(selected)) ? selected : initial,
      firstDate: first,
      lastDate: last,
      helpText: 'Select your available date',
      selectableDayPredicate: _anyDoctorOn,
    );

    if (picked == null) return;

    setState(() {
      _selectedDate = picked;
      _dateError = null;
      // Clear the doctor if they don't work on the newly selected day.
      if (_selectedDoctor != null && !_selectedDoctor!.isAvailableOn(picked)) {
        _selectedDoctor = null;
      }
    });
  }

  Future<void> _submit() async {
    final formValid = _formKey.currentState!.validate();

    setState(() {
      _dateError = _selectedDate == null ? 'Please choose a date' : null;
      _doctorError = (_selectedDate != null && _selectedDoctor == null)
          ? 'Please choose a doctor'
          : null;
    });

    if (!formValid || _selectedDate == null || _selectedDoctor == null) return;

    final request = AppointmentRequest(
      patientName: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      date: _selectedDate!,
      doctor: _selectedDoctor!,
      notes: _notesCtrl.text.trim(),
    );

    setState(() => _submitting = true);
    try {
      if (widget.onSubmit != null) {
        await widget.onSubmit!(request);
      } else {
        await Future<void>.delayed(const Duration(seconds: 1)); // demo only
      }
      if (!mounted) return;
      await _showSuccess(request);
      _resetForm();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _showSuccess(AppointmentRequest r) {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(Icons.check_circle, color: Colors.green.shade600, size: 48),
        title: const Text('Request sent'),
        content: Text(
          '${r.doctor.name}\n${_formatDate(r.date)}\n\n'
          'We will contact you on ${r.phone} to confirm your appointment.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameCtrl.clear();
    _phoneCtrl.clear();
    _emailCtrl.clear();
    _notesCtrl.clear();
    setState(() {
      _selectedDate = null;
      _selectedDoctor = null;
      _dateError = null;
      _doctorError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book an Appointment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().length < 2) ? 'Enter your full name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                      prefixIcon: Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final digits = (v ?? '').replaceAll(RegExp(r'[^0-9]'), '');
                      return digits.length < 9 ? 'Enter a valid phone number' : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email (optional)',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final value = (v ?? '').trim();
                      if (value.isEmpty) return null; // optional
                      return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)
                          ? null
                          : 'Enter a valid email';
                    },
                  ),
                  const SizedBox(height: 24),

                  // Date
                  Text('When are you available?',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(4),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Preferred date',
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                        border: const OutlineInputBorder(),
                        errorText: _dateError,
                      ),
                      child: Text(
                        _selectedDate == null
                            ? 'Tap to choose a date'
                            : _formatDate(_selectedDate!),
                        style: TextStyle(
                          color: _selectedDate == null
                              ? Theme.of(context).hintColor
                              : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Doctors
                  Text('Available doctors',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  _buildDoctorList(),
                  const SizedBox(height: 24),

                  // Notes
                  TextFormField(
                    controller: _notesCtrl,
                    maxLines: 4,
                    maxLength: 300,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: "What's bothering you? (optional)",
                      hintText: 'Briefly describe your symptoms or reason for the visit',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.5),
                            )
                          : const Text('Request Appointment'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorList() {
    if (_selectedDate == null) {
      return Text(
        'Choose a date to see which doctors are available.',
        style: TextStyle(color: Theme.of(context).hintColor),
      );
    }

    final doctors = _availableDoctors;
    if (doctors.isEmpty) {
      return const Text('No doctors are available on this day. Please pick another date.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final doc in doctors)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: _selectedDoctor?.id == doc.id
                    ? Colors.blue.shade700
                    : Colors.grey.shade300,
                width: _selectedDoctor?.id == doc.id ? 2 : 1,
              ),
            ),
            child: ListTile(
              selected: _selectedDoctor?.id == doc.id,
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: Icon(Icons.medical_services_outlined, color: Colors.blue.shade700),
              ),
              title: Text(doc.name),
              subtitle: Text(doc.specialty),
              trailing: _selectedDoctor?.id == doc.id
                  ? Icon(Icons.check_circle, color: Colors.blue.shade700)
                  : const Icon(Icons.radio_button_unchecked),
              onTap: () => setState(() {
                _selectedDoctor = doc;
                _doctorError = null;
              }),
            ),
          ),
        if (_doctorError != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              _doctorError!,
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}