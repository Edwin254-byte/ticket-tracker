import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../theme/bloc/theme_bloc.dart';
import '../../theme/bloc/theme_event.dart';
import '../../theme/bloc/theme_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = authState.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primaryContainer,
                        colorScheme.primaryContainer.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email
                      Text(
                        user.email,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // User badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_user,
                              size: 16,
                              color: colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Verified User',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Settings Section
                Text(
                  'Settings',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Theme selector
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, themeState) {
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.brightness_6_outlined,
                              color: colorScheme.primary,
                            ),
                            title: const Text('Theme'),
                            subtitle: Text(
                              _getThemeModeLabel(themeState.themeMode),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: SegmentedButton<ThemeMode>(
                              segments: const [
                                ButtonSegment<ThemeMode>(
                                  value: ThemeMode.light,
                                  icon: Icon(Icons.light_mode, size: 20),
                                  label: Text('Light'),
                                ),
                                ButtonSegment<ThemeMode>(
                                  value: ThemeMode.dark,
                                  icon: Icon(Icons.dark_mode, size: 20),
                                  label: Text('Dark'),
                                ),
                                ButtonSegment<ThemeMode>(
                                  value: ThemeMode.system,
                                  icon: Icon(Icons.auto_mode, size: 20),
                                  label: Text('System'),
                                ),
                              ],
                              selected: {themeState.themeMode},
                              onSelectionChanged:
                                  (Set<ThemeMode> newSelection) {
                                    context.read<ThemeBloc>().add(
                                      ThemeChanged(newSelection.first),
                                    );
                                  },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Info Card
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                    ),
                    title: const Text('About'),
                    subtitle: const Text('Ticket Resolution App v1.0.0'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Ticket Resolution',
                        applicationVersion: '1.0.0',
                        applicationIcon: Icon(
                          Icons.confirmation_number_outlined,
                          size: 48,
                          color: colorScheme.primary,
                        ),
                        children: [
                          const Text(
                            'A Flutter application for managing and resolving tickets.',
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text(
                            'Are you sure you want to logout?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(
                                  const AuthLogoutRequested(),
                                );
                                Navigator.of(dialogContext).pop();
                                context.go('/login');
                              },
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.errorContainer,
                      foregroundColor: colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      case ThemeMode.system:
        return 'System Default';
    }
  }
}
