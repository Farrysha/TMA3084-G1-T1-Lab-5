import 'package:material_ui/material_ui.dart';

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  static const Color _primary = Color(0xFF1E5BE0);
  static const Color _navy = Color(0xFF17254E);
  static const Color _muted = Color(0xFF6B7A99);
  static const Color _tint = Color(0xFFE8F0FF);
  static const String _logo = 'assets/images/logo.png';

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFF6F8FC),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AppHeader(),
            SizedBox(height: 20),
            _SectionCard(
              icon: Icons.apps_rounded,
              title: 'About StudentHub',
              child: Text(
                'StudentHub is a student management application designed to '
                'make accessing student information easier and more '
                'convenient. Users can browse student profiles, view academic '
                'records, and explore different academic programmes.',
                style: TextStyle(fontSize: 14, height: 1.45, color: _navy),
              ),
            ),
            SizedBox(height: 12),
            _SectionCard(
              icon: Icons.auto_awesome_rounded,
              title: 'Key Features',
              child: Column(
                children: [
                  _FeatureTile(
                    icon: Icons.people_alt_rounded,
                    title: 'Student profiles',
                    description:
                        'Browse names, matric numbers, and programmes.',
                  ),
                  _FeatureTile(
                    icon: Icons.table_chart_rounded,
                    title: 'Academic records',
                    description: 'View student records and sort the table.',
                  ),
                  _FeatureTile(
                    icon: Icons.school_rounded,
                    title: 'Academic programmes',
                    description: 'Explore students by academic programme.',
                  ),
                  _FeatureTile(
                    icon: Icons.swap_horiz_rounded,
                    title: 'Quick navigation',
                    description:
                        'Move between Home, students, records, and About.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            _SectionCard(
              icon: Icons.code_rounded,
              title: 'Development Information',
              child: Column(
                children: [
                  _InfoRow(label: 'Developed By', value: 'TMA3084 Group G1-T1'),
                  _InfoRow(
                    label: 'Course',
                    value: 'Software Engineering Laboratory',
                  ),
                  _InfoRow(
                    label: 'University',
                    value: 'Universiti Malaysia Sarawak (UNIMAS)',
                  ),
                  _InfoRow(label: 'Framework', value: 'Flutter'),
                  _InfoRow(label: 'Language', value: 'Dart'),
                ],
              ),
            ),
            SizedBox(height: 24),
            _Footer(),
          ],
        ),
      ),
    );
  }
}

///Logo, app name, tagline, and version layered on the banner.
class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 248,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 248,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Screen4._primary, Screen4._navy],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          Positioned(
            right: -18,
            top: -28,
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x22FFFFFF),
              ),
            ),
          ),
          Positioned(
            left: -24,
            bottom: 36,
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x14FFFFFF),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: 22,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Screen4._tint,
                    child: ClipOval(
                      child: Image.asset(
                        Screen4._logo,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.school_rounded,
                              size: 32,
                              color: Screen4._primary,
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'StudentHub',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your Student Information, Simplified.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.5, color: Color(0xE6FFFFFF)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Version: 1.0.0',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      shadowColor: const Color(0x331E5BE0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Screen4._tint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: Screen4._primary),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Screen4._navy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Screen4._primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Screen4._navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: Screen4._muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Screen4._muted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Screen4._navy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'App Version 1.0.0',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Screen4._navy,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '© 2026 StudentHub',
          style: TextStyle(fontSize: 13, color: Screen4._muted),
        ),
        SizedBox(height: 4),
        Text(
          'Made with ❤️ using Flutter',
          style: TextStyle(fontSize: 13, color: Screen4._muted),
        ),
      ],
    );
  }
}
