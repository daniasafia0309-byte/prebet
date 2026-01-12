import 'package:flutter/material.dart';
import 'package:prebet/common/app_colors.dart';
import 'package:prebet/common/widgets/user_avatar.dart';
import 'package:prebet/common/widgets/header.dart';
import 'package:prebet/data/user_model.dart';
import 'package:prebet/controller/user_profile_controller.dart';

class EditProfilePage extends StatefulWidget {
  final AppUser user;

  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = UserProfileController();

  late final TextEditingController _nameCtrl =
      TextEditingController(text: widget.user.name);
  late final TextEditingController _studentIdCtrl =
      TextEditingController(text: widget.user.studentId);
  late final TextEditingController _emailCtrl =
      TextEditingController(text: widget.user.email);
  late final TextEditingController _phoneCtrl =
      TextEditingController(text: widget.user.phone);
  late final TextEditingController _emergencyNameCtrl =
      TextEditingController(text: widget.user.emergencyName);
  late final TextEditingController _emergencyPhoneCtrl =
      TextEditingController(text: widget.user.emergencyPhone);

  late String _relationship =
      widget.user.emergencyRelationship.isNotEmpty
          ? widget.user.emergencyRelationship
          : 'Parent';

  late bool _canEditStudentId = widget.user.studentId.isEmpty;

  static const double fieldGap = 14;
  static const double sectionGap = 22;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _studentIdCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _emergencyNameCtrl.dispose();
    _emergencyPhoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      appBar: const PrebetHeader(
        title: 'Edit Profile',
        showBack: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _avatar(),
              const SizedBox(height: sectionGap),

              _sectionTitle('Student Information'),
              _field(
                label: 'Full Name',
                icon: Icons.person_outline,
                controller: _nameCtrl,
              ),
              _field(
                label: 'Student ID',
                icon: Icons.badge_outlined,
                controller: _studentIdCtrl,
                readOnly: !_canEditStudentId,
                helper:
                    _canEditStudentId ? null : 'Student ID cannot be changed',
              ),
              _field(
                label: 'Email',
                icon: Icons.email_outlined,
                controller: _emailCtrl,
              ),
              _field(
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                controller: _phoneCtrl,
              ),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 24),
                height: 1,
                color: Colors.grey.shade300,
              ),

              _sectionTitle('Emergency Contact', color: Colors.red),
              _field(
                label: 'Emergency Contact Name',
                controller: _emergencyNameCtrl,
              ),
              _relationshipDropdown(),
              _field(
                label: 'Emergency Phone Number',
                controller: _emergencyPhoneCtrl,
              ),

              const SizedBox(height: 14),
              _warningBox(),

              const SizedBox(height: sectionGap),
              _saveButton(),
              const SizedBox(height: 10),
              _cancelButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar() {
    return Center(
      child: Column(
        children: [
          UserAvatar(user: widget.user, size: 84),
          const SizedBox(height: 8),
          const Text(
            'Profile picture is auto-generated',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: color ?? Colors.black,
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    IconData? icon,
    required TextEditingController controller,
    bool readOnly = false,
    String? helper,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: fieldGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Required field' : null,
            decoration: InputDecoration(
              helperText: helper,
              prefixIcon:
                  icon != null ? Icon(icon, size: 20) : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.4,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _relationshipDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: fieldGap),
      child: DropdownButtonFormField<String>(
        value: _relationship,
        items: const [
          DropdownMenuItem(value: 'Parent', child: Text('Parent')),
          DropdownMenuItem(value: 'Sibling', child: Text('Sibling')),
          DropdownMenuItem(value: 'Guardian', child: Text('Guardian')),
          DropdownMenuItem(value: 'Friend', child: Text('Friend')),
        ],
        onChanged: (v) => setState(() => _relationship = v!),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _warningBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded,
              color: Colors.orange, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'This contact will be contacted in the event of an emergency during travel',
              style: TextStyle(fontSize: 12, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) return;

          if (_canEditStudentId && _studentIdCtrl.text.isNotEmpty) {
            await _controller.updateStudentId(
              _studentIdCtrl.text.trim(),
            );
          }

          final updatedUser = widget.user.copyWith(
            name: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            emergencyName: _emergencyNameCtrl.text.trim(),
            emergencyPhone: _emergencyPhoneCtrl.text.trim(),
            emergencyRelationship: _relationship,
          );

          await _controller.updateProfile(updatedUser);

          if (!mounted) return;
          Navigator.pop(context);
        },
        child: const Text(
          'Save Changes',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _cancelButton() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    );
  }
}
