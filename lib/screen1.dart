import 'package:material_ui/material_ui.dart';

// ---- Tab indices -----------------------------------------------------------
// Named so the cards below do not pass bare numbers to onNavigate. These match
// the order of the items in main.dart's BottomNavigationBar.
const int _studentsTab = 1;
const int _recordsTab = 2;
const int _aboutTab = 3;

// ---- Brand colours ---------------------------------------------------------
// At file scope rather than as private statics on Screen1, so the helper
// widgets below do not have to reach into another class's private members.
const Color _primary = Color(0xFF1E5BE0);
const Color _navy = Color(0xFF17254E);
const Color _muted = Color(0xFF6B7A99);
const Color _tint = Color(0xFFE8F0FF);
const Color _chevron = Color(0xFF9AA8C2);
const Color _cardShadow = Color(0x331E5BE0);

// ---- Image assets ----------------------------------------------------------
const String _logo = 'assets/images/logo.png';
const String _hero = 'assets/images/students.png';

/// Home page of the StudentHub app (TMA3084 Lab 5.1).
/// Kept as a StatelessWidget named `Screen1`. It deliberately does NOT create
/// its own Scaffold, so the parent's AppBar, Drawer and BottomNavigationBar
/// keep working when this page is shown as the Home tab.
class Screen1 extends StatelessWidget {
  const Screen1({required this.onNavigate, super.key});

  /// Called with the tab index the user wants to open. main.dart passes a
  /// function that updates _currentIndex, so the BottomNavigationBar stays
  /// on screen instead of being covered by a pushed route.
  ///
  /// Now required and non-nullable: the old nullable field forced a `!`
  /// force-unwrap plus a SnackBar fallback branch that could never run,
  /// because main.dart is the only caller and always supplies it.
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
              // These sections used to be _buildHeader() / _buildHero() /
              // _buildSectionLabel() methods. A method's result can never be
              // const, so every one of them was rebuilt whenever this page
              // rebuilt; as widget classes they can be, and Flutter skips them.
              const _Header(),
              const SizedBox(height: 20),
              const _Hero(),
              const SizedBox(height: 28),
              const _SectionLabel('Quick Access'),
              const SizedBox(height: 12),
              _MenuCard(
                icon: Icons.people_alt_rounded,
                title: 'View Students',
                subtitle: 'Browse the full student list',
                onTap: () => onNavigate(_studentsTab),
              ),
              const SizedBox(height: 12),
              _MenuCard(
                icon: Icons.table_chart_rounded,
                title: 'Student Records',
                subtitle: 'Sortable table of names and CGPA',
                onTap: () => onNavigate(_recordsTab),
              ),
              const SizedBox(height: 12),
              _MenuCard(
                icon: Icons.info_rounded,
                title: 'About',
                subtitle: 'App information and credits',
                onTap: () => onNavigate(_aboutTab),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---- Sections --------------------------------------------------------------

/// Logo, app name and tagline.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _AssetImage(
          path: _logo,
          size: 64,
          fallback: Icons.school_rounded,
        ),
        SizedBox(height: 12),
        Text(
          'StudentHub',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: _navy,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Your Student Portal',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: _muted, height: 1.3),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    // The hero photo is square (1200x1211), so AspectRatio 1.0 shows the whole
    // frame with no cropping at all. If you swap in a wider photo later, change
    // the ratio to match it (e.g. 16 / 9) rather than fighting it with
    // alignment.
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: const AspectRatio(
        aspectRatio: 1.0,
        child: _AssetImage(
          path: _hero,
          fit: BoxFit.cover,
          fallback: Icons.groups_rounded,
          fallbackSize: 72,
          fallbackBackground: _tint,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
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
}

// ---- Helpers ---------------------------------------------------------------

/// Loads a PNG, and falls back to a Material icon if the file is missing,
/// so the app never crashes with a grey asset error during the demo.
///
/// Was a static `_assetImage()` method; as a widget it can be const.
class _AssetImage extends StatelessWidget {
  const _AssetImage({
    required this.path,
    required this.fallback,
    this.size,
    this.fit = BoxFit.contain,
    this.fallbackSize,
    this.fallbackBackground,
  });

  final String path;
  final IconData fallback;
  final double? size;
  final BoxFit fit;
  final double? fallbackSize;

  /// Optional colour behind the fallback icon, for the places where the image
  /// fills a shaped box.
  final Color? fallbackBackground;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size,
      height: size,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        final icon = Icon(
          fallback,
          size: fallbackSize ?? size ?? 72,
          color: _primary,
        );
        final background = fallbackBackground;
        if (background == null) {
          return icon;
        }
        return ColoredBox(color: background, child: Center(child: icon));
      },
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
      shadowColor: _cardShadow,
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
                  color: _tint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 26, color: _primary),
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
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: _muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: _chevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
