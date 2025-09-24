import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_widgets.dart';
import '../../../../routes/app_pages.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppPages.home),
        ),
      ),
      body: ListView(
        children: [
          // Profile Section
          CustomCard(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'John Doe',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'john.doe@example.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Edit Profile',
                  onPressed: () {
                    // Edit profile
                  },
                  isOutlined: true,
                ),
              ],
            ),
          ),

          // Appearance Section
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Switch between light and dark themes'),
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                ),
                ListTile(
                  title: const Text('Background'),
                  subtitle: const Text('Change app background'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Change background
                  },
                ),
              ],
            ),
          ),

          // Notifications Section
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Enable Notifications'),
                  subtitle: const Text('Receive reminders and updates'),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                ListTile(
                  title: const Text('Habit Reminders'),
                  subtitle: const Text('Daily habit reminders'),
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Task Reminders'),
                  subtitle: const Text('Task due date reminders'),
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // General Section
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'General',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Language'),
                  subtitle: Text(_selectedLanguage),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showLanguageDialog();
                  },
                ),
                ListTile(
                  title: const Text('Data & Privacy'),
                  subtitle: const Text('Manage your data and privacy settings'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Data & privacy
                  },
                ),
                ListTile(
                  title: const Text('Backup & Sync'),
                  subtitle: const Text('Manage your data backup'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Backup & sync
                  },
                ),
              ],
            ),
          ),

          // Support Section
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Support',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Help & FAQ'),
                  subtitle: const Text('Get help and find answers'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Help & FAQ
                  },
                ),
                ListTile(
                  title: const Text('Contact Us'),
                  subtitle: const Text('Get in touch with our support team'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Contact us
                  },
                ),
                ListTile(
                  title: const Text('Rate App'),
                  subtitle: const Text('Rate us on the app store'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Rate app
                  },
                ),
              ],
            ),
          ),

          // Logout Section
          CustomCard(
            child: Column(
              children: [
                CustomButton(
                  text: AppStrings.logout,
                  onPressed: () {
                    _showLogoutDialog();
                  },
                  backgroundColor: Theme.of(context).colorScheme.error,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Spanish'),
              value: 'Spanish',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('French'),
              value: 'French',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
