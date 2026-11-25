import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../playground/playground.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key, required this.onToggleTheme});
  final VoidCallback onToggleTheme;

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _about = GlobalKey();
  final _work = GlobalKey();
  final _playground = GlobalKey();
  final _contact = GlobalKey();

  void _go(GlobalKey section) {
    final context = section.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      alignment: .025,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _open(Uri uri) async {
    final launched = await launchUrl(uri, webOnlyWindowName: '_blank');
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the contact link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final navigation = {
      'About': _about,
      'Work': _work,
      'Playground': _playground,
      'Contact': _contact,
    };

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final compact = width < 600;
              final margin = compact
                  ? 20.0
                  : width < 1050
                  ? 48.0
                  : 80.0;
              return Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: margin),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1280),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: compact ? 68 : 88,
                          child: Row(
                            children: [
                              const _Monogram(),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'Beyond Platforms.',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontSize: compact ? 17 : 24,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              if (!compact)
                                for (final entry in navigation.entries)
                                  TextButton(
                                    onPressed: () => _go(entry.value),
                                    child: Text(entry.key),
                                  )
                              else
                                PopupMenuButton<GlobalKey>(
                                  tooltip: 'Open navigation',
                                  onSelected: _go,
                                  itemBuilder: (context) => [
                                    for (final entry in navigation.entries)
                                      PopupMenuItem(
                                        value: entry.value,
                                        child: Text(entry.key),
                                      ),
                                  ],
                                  icon: const Icon(Icons.menu),
                                ),
                              IconButton(
                                tooltip: dark
                                    ? 'Switch to light mode'
                                    : 'Switch to dark mode',
                                onPressed: widget.onToggleTheme,
                                icon: Icon(
                                  dark
                                      ? Icons.light_mode_outlined
                                      : Icons.dark_mode_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: colors.outline),
                        SizedBox(height: compact ? 42 : 56),
                        _Technical(
                          'ANDREEA ROSCA / FLUTTER DEVELOPER',
                          color: colors.secondary,
                        ),
                        const SizedBox(height: 16),
                        Semantics(
                          header: true,
                          child: Text(
                            'One codebase.\nLimitless experiences.',
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: compact
                                  ? 43
                                  : width < 1050
                                  ? 60
                                  : 84,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 490),
                            child: _Body(
                              'Four years of Flutter development in banking and fintech, building for Web, iOS and Android.',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            FilledButton(
                              onPressed: () => _go(_work),
                              child: const Text('Explore my work'),
                            ),
                            OutlinedButton(
                              onPressed: () => _go(_contact),
                              child: const Text('Get in touch'),
                            ),
                          ],
                        ),
                        SizedBox(height: compact ? 28 : 44),
                        KeyedSubtree(
                          key: _playground,
                          child: const Playground(),
                        ),
                        const SizedBox(height: 24),
                        _Pair(
                          compact: compact,
                          children: [
                            _Panel(
                              key: _about,
                              label: 'ABOUT',
                              title: 'Hi, I’m Andreea.',
                              description: 'I’m a Flutter developer building interfaces for Web, iOS and Android.',
                            ),
                            _Panel(
                              key: _work,
                              label: 'PROFESSIONAL EXPERIENCE',
                              title: 'Flutter for banking and fintech',
                              description: 'My professional Flutter work has focused on banking applications across Web, iOS and Android.',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _Pair(
                          compact: compact,
                          children: [
                            const _Panel(
                              label: 'ENGINEERING EXPERTISE',
                              title: 'Flutter across platforms',
                              description:
                                  'Flutter and Dart · Web · iOS · Android',
                            ),
                            _Panel(
                              label: 'PERSONAL PROJECTS',
                              title: 'Projects in progress',
                              description: 'I’ll share personal projects here as they’re ready. In the meantime, explore the Flutter Playground.',
                              action: TextButton(
                                onPressed: () => _go(_playground),
                                child: const Text('Explore the Playground'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        _Technical('EDUCATION', color: colors.secondary),
                        const SizedBox(height: 6),
                        Text(
                          'Alexandru Ioan Cuza University of Iași',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 6),
                        const _Body(
                          'Faculty of Computer Science · Bachelor’s studies in software engineering.',
                        ),
                        const SizedBox(height: 32),
                        _Panel(
                          key: _contact,
                          label: 'CONTACT',
                          title: 'Let’s talk Flutter.',
                          description:
                              'Get in touch about Flutter opportunities.',
                          action: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              TextButton(
                                onPressed: () => _open(
                                  Uri.parse('mailto:andreea.rosca@gmail.com'),
                                ),
                                child: const Text('Email'),
                              ),
                              TextButton(
                                onPressed: () => _open(
                                  Uri.parse(
                                    'https://www.linkedin.com/in/andreea-maria-rosca-6bb501140/',
                                  ),
                                ),
                                child: const Text('LinkedIn'),
                              ),
                              TextButton(
                                onPressed: () => _open(
                                  Uri.parse('https://github.com/roscaandreea'),
                                ),
                                child: const Text('GitHub'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: compact
                              ? Alignment.center
                              : Alignment.centerLeft,
                          child: const _Body('© 2026 Andreea Rosca'),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Pair extends StatelessWidget {
  const _Pair({required this.compact, required this.children});
  final bool compact;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => compact
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [children.first, const SizedBox(height: 16), children.last],
        )
      : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: children.first),
            const SizedBox(width: 24),
            Expanded(child: children.last),
          ],
        );
}

class _Panel extends StatelessWidget {
  const _Panel({
    super.key,
    required this.label,
    required this.title,
    required this.description,
    this.action,
  });
  final String label;
  final String title;
  final String description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Technical(label, color: colors.tertiary),
            const SizedBox(height: 12),
            Semantics(
              header: true,
              child: Text(title, style: theme.textTheme.headlineMedium),
            ),
            const SizedBox(height: 10),
            _Body(description),
            if (action != null) ...[const SizedBox(height: 8), action!],
          ],
        ),
      ),
    );
  }
}

class _Technical extends StatelessWidget {
  const _Technical(this.value, {required this.color});
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
    value,
    style: TextStyle(
      fontFamily: 'JetBrains Mono',
      fontSize: 12,
      letterSpacing: .35,
      color: color,
    ),
  );
}

class _Body extends StatelessWidget {
  const _Body(this.value);
  final String value;

  @override
  Widget build(BuildContext context) => Text(
    value,
    style: TextStyle(
      fontSize: 16,
      height: 1.55,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}

class _Monogram extends StatelessWidget {
  const _Monogram();

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(36, 36),
    painter: _MarkPainter(Theme.of(context).colorScheme),
  );
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter(this.colors);
  final ColorScheme colors;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 40, size.height / 40);
    final paint = Paint();
    final top = Path()
      ..moveTo(14, 2)
      ..lineTo(29, 2)
      ..cubicTo(41, 2, 41, 18, 29, 18)
      ..lineTo(14, 18)
      ..close();
    final bottom = Path()
      ..moveTo(14, 22)
      ..lineTo(26, 22)
      ..cubicTo(37, 22, 37, 38, 26, 38)
      ..lineTo(14, 38)
      ..close();
    final spine = Path()
      ..moveTo(7, 2)
      ..lineTo(10, 2)
      ..lineTo(10, 38)
      ..lineTo(7, 38)
      ..quadraticBezierTo(2, 38, 2, 33)
      ..lineTo(2, 7)
      ..quadraticBezierTo(2, 2, 7, 2)
      ..close();
    canvas.drawPath(top, paint..color = colors.primary);
    canvas.drawPath(bottom, paint..color = colors.tertiary);
    canvas.drawPath(spine, paint..color = colors.secondary);
  }

  @override
  bool shouldRepaint(_MarkPainter oldDelegate) => colors != oldDelegate.colors;
}
