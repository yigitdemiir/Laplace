import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../auth/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildSection(
            title: 'Account',
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Edit Profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to edit profile page
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to change password page
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Preferences',
            children: [
              SwitchListTile(
                secondary: Icon(
                  _notificationsEnabled
                      ? Icons.notifications_active_outlined
                      : Icons.notifications_off_outlined,
                  color: _notificationsEnabled ? AppColors.primary : AppColors.textSecondary,
                ),
                title: const Text('Push Notifications'),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              SwitchListTile(
                secondary: Icon(
                  _darkModeEnabled ? Icons.dark_mode : Icons.light_mode,
                  color: _darkModeEnabled ? AppColors.primary : AppColors.textSecondary,
                ),
                title: const Text('Dark Mode'),
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                  // TODO: Implement dark mode
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: 'English',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'Turkish',
                      child: Text('Turkish'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                      // TODO: Implement language change
                    }
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            title: 'Privacy & Security',
            children: [
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to privacy policy page
                },
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to terms of service page
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Support',
            children: [
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help Center'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to help center page
                },
              ),
              ListTile(
                leading: const Icon(Icons.contact_support_outlined),
                title: const Text('Contact Us'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to contact us page
                },
              ),
            ],
          ),
          _buildSection(
            title: 'App Info',
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                trailing: const Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () {
                  // TODO: Show about dialog
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await Provider.of<AuthProvider>(context, listen: false).signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Logout'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
} 