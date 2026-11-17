import 'package:material_ui/material_ui.dart';

// Brand colours and assets, at file scope rather than as private statics on
// Screen4. The helper widgets below each used to reach into another class's
// private members (_primary), which only compiled because they share
// this file.
const Color _primary = Color(0xFF1E5BE0);
const Color _navy = Color(0xFF17254E);
const Color _muted = Color(0xFF6B7A99);
const Color _tint = Color(0xFFE8F0FF);
const String _logo = 'assets/images/logo.png';

/// Single source for the version shown on this page. It used to appear as two
/// separate literals ('Version: 1.0.0' and 'App Version 1.0.0') that could
/// drift apart.
const String _appVersion = '1.0.0';

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

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

  /// The banner and its backdrop share this height, so they are declared once.
  static const double _bannerHeight = 248;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _bannerHeight,
      child: Stack(
        // The decorative circles are positioned to overhang the banner, so
        // clipping stays off.
        clipBehavior: Clip.none,
        children: [
          Container(
            height: _bannerHeight,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_primary, _navy],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          const Positioned(
            right: -18,
            top: -28,
            child: _Bubble(size: 120, color: Color(0x22FFFFFF)),
          ),
          const Positioned(
            left: -24,
            bottom: 36,
            child: _Bubble(size: 72, color: Color(0x14FFFFFF)),
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
                    backgroundColor: _tint,
                    child: ClipOval(
                      child: Image.asset(
                        _logo,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.school_rounded,
                              size: 32,
                              color: _primary,
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
                  'Version: $_appVersion',
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

/// A decorative translucent circle on the banner. The two circles above were
/// the same ten-line Container twice.
class _Bubble extends StatelessWidget {
  const _Bubble({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
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
                    color: _tint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: _primary),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _navy,
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
          Icon(icon, size: 22, color: _primary),
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
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: _muted,
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
              style: const TextStyle(fontSize: 14, color: _muted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _navy,
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
          'App Version $_appVersion',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _navy,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '© 2026 StudentHub',
          style: TextStyle(fontSize: 13, color: _muted),
        ),
        SizedBox(height: 4),
        Text(
          'Made with ❤️ using Flutter',
          style: TextStyle(fontSize: 13, color: _muted),
        ),
      ],
    );
  }
}
