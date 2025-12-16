import 'package:dakna/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dakna/features/auth/presentation/bloc/auth_event.dart';
import 'package:dakna/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// =======================
/// Logout Button
/// =======================
class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () {
          context.read<AuthBloc>().add(LogoutPressed());
        },
      ),
    );
  }
}

/// =======================
/// Profile Page
/// =======================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProfileHeader(context, state),
      
                  const SizedBox(height: 30),
      
                  /// Quick actions تظهر فقط لو المستخدم مسجل
                  if (state is Authenticated) ...[
                    _buildQuickActions(context),
                    const SizedBox(height: 20),
                    const Divider(thickness: 8, color: Color(0xFFF0F0F0)),
                    const SizedBox(height: 10),
                  ],
      
                  _buildSettingsList(context),
      
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// =======================
  /// Profile Header
  /// =======================
  Widget _buildProfileHeader(BuildContext context, AuthState state) {
    final primaryColor = Theme.of(context).primaryColor;

    final bool isAuthenticated = state is Authenticated;
    final String userName =
        isAuthenticated && state.user.name.isNotEmpty
            ? state.user.name
            : 'مرحبًا 👋';

    final String? userEmail =
        isAuthenticated ? state.user.email : null;

    final String? picture =
        isAuthenticated ? state.user.picture : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: primaryColor.withOpacity(0.1),
            backgroundImage:
                picture != null ? NetworkImage(picture) : null,
            child: picture == null
                ? const Icon(Icons.person_outline, size: 30)
                : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                if (userEmail != null)
                  Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),

          if (isAuthenticated) const LogoutButton(),
        ],
      ),
    );
  }

  /// =======================
  /// Quick Actions
  /// =======================
  Widget _buildQuickActions(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickActionButton(
            context,
            icon: Icons.history,
            title: 'طلباتي',
            onTap: () {},
          ),
          _buildQuickActionButton(
            context,
            icon: Icons.location_on_outlined,
            title: 'عناويني',
            onTap: () {},
          ),
          _buildQuickActionButton(
            context,
            icon: Icons.account_balance_wallet_outlined,
            title: 'القسائم',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final primaryColor = Theme.of(context).primaryColor;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: primaryColor, size: 28),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  /// =======================
  /// Settings List
  /// =======================
  Widget _buildSettingsList(BuildContext context) {
    return Column(
      children: [
        _buildProfileOption(
          context: context,
          title: 'الإشعارات',
          icon: Icons.notifications_none,
          onTap: () {},
        ),
        _buildProfileOption(
          context: context,
          title: 'اللغة',
          icon: Icons.language,
          onTap: () {},
        ),
        _buildProfileOption(
          context: context,
          title: 'المساعدة والدعم',
          icon: Icons.help_outline,
          onTap: () {},
        ),
        _buildProfileOption(
          context: context,
          title: 'الشروط والأحكام',
          icon: Icons.description_outlined,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildProfileOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(icon, color: Theme.of(context).primaryColor),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        const Divider(height: 1, thickness: 1, indent: 20, endIndent: 20),
      ],
    );
  }
}
