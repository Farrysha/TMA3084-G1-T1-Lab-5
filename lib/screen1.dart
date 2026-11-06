import 'package:flutter/material.dart';

/// Home page of the StudentHub app (TMA3084 Lab 5.1).
///
/// Kept as a StatelessWidget named `Screen1`. It deliberately does NOT create
/// its own Scaffold, so the parent's AppBar, Drawer and BottomNavigationBar
/// keep working when this page is shown as the Home tab.
class Screen1 extends StatelessWidget {
  const Screen1({super.key, this.onNavigate});

  /// Called with the tab index the user wants to open. main.dart passes a
  /// function that updates _currentIndex, so the BottomNavigationBar stays
  /// on screen instead of being covered by a pushed route.
  final ValueChanged<int>? onNavigate;

  // ---- Brand colours -------------------------------------------------------
  static const Color _primary = Color(0xFF1E5BE0);
  static const Color _navy = Color(0xFF17254E);
  static const Color _muted = Color(0xFF6B7A99);
  static const Color _tint = Color(0xFFE8F0FF);

  // ---- Image assets --------------------------------------------------------
  static const String _logo = 'assets/images/logo.png';
  static const String _hero = 'assets/images/students.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_tint, Colors.white],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildHero(context),
              const SizedBox(height: 28),
              _buildSectionLabel('Quick Access'),
              const SizedBox(height: 12),
              _MenuCard(
                icon: Icons.people_alt_rounded,
                title: 'View Students',
                subtitle: 'Browse the full student list',
                onTap: () => _go(context, 1, 'View Students'),
              ),
              const SizedBox(height: 12),
              _MenuCard(
                icon: Icons.table_chart_rounded,
                title: 'Student Records',
                subtitle: 'Sortable table of names and CGPA',
                onTap: () => _go(context, 2, 'Student Records'),
              ),
              const SizedBox(height: 12),
              _MenuCard(
                icon: Icons.info_rounded,
                title: 'About',
                subtitle: 'App information and credits',
                onTap: () => _go(context, 3, 'About'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Navigation ----------------------------------------------------------

  /// Switches the host's bottom-navigation tab. Because this only changes the
  /// index inside main.dart, the AppBar and BottomNavigationBar stay visible.
  void _go(BuildContext context, int tabIndex, String label) {
    if (onNavigate != null) {
      onNavigate!(tabIndex);
    } else {
      // Safety net if the callback was not supplied.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Open the ' + label + ' tab below')),
      );
    }
  }

  // ---- Sections ------------------------------------------------------------

  Widget _buildHeader() {
    return Column(
      children: [
        _assetImage(_logo, size: 64, fallback: Icons.school_rounded),
        const SizedBox(height: 12),
        const Text(
          'StudentHub',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: _navy,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Your Student Portal',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: _muted, height: 1.3),
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    // The hero photo is square (1200x1211), so AspectRatio 1.0 shows the whole
    // frame with no cropping at all. If you swap in a wider photo later, change
    // the ratio to match it (e.g. 16 / 9) rather than fighting it with
    // alignment.
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Image.asset(
          _hero,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: _tint,
            alignment: Alignment.center,
            child: const Icon(Icons.groups_rounded, size: 72, color: _primary),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: _muted,
        letterSpacing: 0.8,
      ),
    );
  }

  // ---- Helpers -------------------------------------------------------------

  /// Loads a PNG, and falls back to a Material icon if the file is missing,
  /// so the app never crashes with a grey asset error during the demo.
  static Widget _assetImage(
      String path, {
        double? size,
        required IconData fallback,
      }) {
    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          Icon(fallback, size: size ?? 72, color: _primary),
    );
  }
}

/// A single tappable row on the home page.
class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      shadowColor: const Color(0x331E5BE0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 26, color: const Color(0xFF1E5BE0)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF17254E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF6B7A99),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF9AA8C2)),
            ],
          ),
        ),
      ),
    );
  }
}