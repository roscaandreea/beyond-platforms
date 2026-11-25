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
                          label: 'One codebase. Limitless experiences.',
                          excludeSemantics: true,
                          child: DefaultTextStyle(
                            style: theme.textTheme.displayLarge!.copyWith(
                              fontSize: compact
                                  ? 43
                                  : width < 1050
                                  ? 60
                                  : 84,
                              height: 1,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('One codebase.'),
                                ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: dark
                                        ? const [
                                            Color(0xFF7FDEF7),
                                            Color(0xFFB5A2FF),
                                          ]
                                        : const [
                                            Color(0xFF1264AC),
                                            Color(0xFF7154BB),
                                          ],
                                  ).createShader(bounds),
                                  child: const Text('Limitless experiences.'),
                                ),
                              ],
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
                        _PortfolioDetails(
                          useBento: width >= 820,
                          aboutKey: _about,
                          workKey: _work,
                          onExplorePlayground: () => _go(_playground),
                        ),
                        const SizedBox(height: 32),
                        Divider(height: 1, color: colors.outline),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: _EducationRow(compact: compact),
                        ),
                        Divider(height: 1, color: colors.outline),
                        Padding(
                          key: _contact,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: _ContactRow(compact: compact, onOpen: _open),
                        ),
                        Divider(height: 1, color: colors.outline),
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

class _PortfolioDetails extends StatelessWidget {
  const _PortfolioDetails({
    required this.useBento,
    required this.aboutKey,
    required this.workKey,
    required this.onExplorePlayground,
  });

  final bool useBento;
  final GlobalKey aboutKey;
  final GlobalKey workKey;
  final VoidCallback onExplorePlayground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final about = _PortfolioCard(
      key: aboutKey,
      title: 'About',
      accent: colors.primary,
      trailing: const ExcludeSemantics(child: _Monogram()),
      child: Text.rich(
        TextSpan(
          text: 'I’m Andreea, a ',
          children: [
            TextSpan(
              text: 'Flutter developer',
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const TextSpan(
              text: ' building interfaces for Web, iOS and Android.',
            ),
          ],
        ),
        style: TextStyle(
          color: colors.onSurfaceVariant,
          fontSize: 18,
          height: 1.5,
        ),
      ),
    );

    Widget expertiseItems(List<(IconData, String)> items, Color foreground) =>
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (icon, label) in items)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Color.alphaBlend(
                    foreground.withValues(alpha: .08),
                    colors.surface,
                  ),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: colors.outline),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExcludeSemantics(
                        child: Icon(icon, size: 15, color: foreground),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );

    final expertise = _PortfolioCard(
      title: 'Engineering expertise',
      accent: colors.tertiary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          expertiseItems(const [
            (Icons.layers_outlined, 'Flutter'),
            (Icons.code, 'Dart'),
          ], colors.primary),
          const SizedBox(height: 12),
          Divider(height: 1, color: colors.outline),
          const SizedBox(height: 12),
          expertiseItems(const [
            (Icons.desktop_windows_outlined, 'Web'),
            (Icons.apple, 'iOS'),
            (Icons.android, 'Android'),
          ], colors.tertiary),
        ],
      ),
    );
    final projectCopy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Projects in progress', style: theme.textTheme.titleLarge),
        const SizedBox(height: 6),
        const _Body('I’ll share personal projects here as they’re ready.'),
        const SizedBox(height: 4),
        TextButton.icon(
          onPressed: onExplorePlayground,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          iconAlignment: IconAlignment.end,
          icon: const Icon(Icons.arrow_forward, size: 18),
          label: const Text('Explore the Playground'),
        ),
      ],
    );
    final projects = _PortfolioCard(
      title: 'Personal projects',
      accent: colors.tertiary,
      child: useBento
          ? Row(
              children: [
                SizedBox(
                  width: 106,
                  height: 90,
                  child: Stack(
                    children: [
                      for (var index = 0; index < 3; index++)
                        Positioned(
                          left: index * 14,
                          bottom: index * 12,
                          width: 76,
                          height: 54,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color.lerp(
                                  colors.outline,
                                  colors.primary,
                                  .10 + index * .16,
                                )!,
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colors.primary.withValues(alpha: .10),
                                  colors.surface,
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: projectCopy),
              ],
            )
          : projectCopy,
    );
    final showBesideCopy = useBento;
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Flutter for ',
            children: [
              TextSpan(
                text: 'banking',
                style: TextStyle(color: colors.primary),
              ),
              const TextSpan(text: ' and '),
              TextSpan(
                text: 'fintech',
                style: TextStyle(color: colors.tertiary),
              ),
            ],
          ),
          style: showBesideCopy
              ? theme.textTheme.headlineLarge
              : theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        const _Body(
          'My professional Flutter work has focused on banking and fintech applications across Web, iOS and Android.',
        ),
      ],
    );
    final panes = CustomPaint(
      painter: _ExperiencePanes(colors.primary, colors.tertiary),
      child: SizedBox(height: showBesideCopy ? 144 : 90),
    );
    final experience = _PortfolioCard(
      key: workKey,
      title: 'Professional experience',
      accent: colors.primary,
      child: showBesideCopy
          ? Row(
              children: [
                Expanded(flex: 6, child: copy),
                const SizedBox(width: 16),
                Expanded(flex: 4, child: panes),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                copy,
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(width: 180, child: panes),
                ),
              ],
            ),
    );

    Widget pair(Widget first, Widget second, int firstFlex) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: firstFlex, child: first),
          const SizedBox(width: 20),
          Expanded(flex: 100 - firstFlex, child: second),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: useBento
          ? [
              pair(experience, about, 65),
              const SizedBox(height: 20),
              pair(expertise, projects, 43),
            ]
          : [
              experience,
              const SizedBox(height: 16),
              about,
              const SizedBox(height: 16),
              expertise,
              const SizedBox(height: 16),
              projects,
            ],
    );
  }
}

class _ExperiencePanes extends CustomPainter {
  const _ExperiencePanes(this.blue, this.violet);

  final Color blue;
  final Color violet;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = (size.width / 200).clamp(0.0, size.height / 120).toDouble();
    canvas.translate(
      (size.width - 200 * scale) / 2,
      (size.height - 120 * scale) / 2,
    );
    canvas.scale(scale);
    for (final (index, tone) in [
      violet,
      Color.lerp(blue, violet, .45)!,
      blue,
    ].indexed) {
      final top = 66.0 - index * 25;
      final pane = Path()
        ..moveTo(12, top + 21)
        ..lineTo(121, top)
        ..quadraticBezierTo(129, top - 2, 137, top + 1)
        ..lineTo(190, top + 18)
        ..quadraticBezierTo(198, top + 21, 189, top + 24)
        ..lineTo(79, top + 47)
        ..quadraticBezierTo(71, top + 49, 63, top + 46)
        ..lineTo(12, top + 28)
        ..quadraticBezierTo(3, top + 24, 12, top + 21)
        ..close();
      final bounds = pane.getBounds();
      final rim = Color.lerp(tone, Colors.white, .47)!;
      final thickness = pane.shift(const Offset(0, 2.8));
      canvas.drawPath(
        pane.shift(const Offset(2, 6)),
        Paint()
          ..color = tone.withValues(alpha: .24)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
      canvas.drawPath(
        thickness,
        Paint()
          ..shader = LinearGradient(
            colors: [
              tone.withValues(alpha: .82),
              tone.withValues(alpha: .16),
              rim.withValues(alpha: .46),
            ],
          ).createShader(bounds),
      );
      canvas.drawPath(
        pane,
        Paint()
          ..shader = LinearGradient(
            begin: const Alignment(-1, .75),
            end: const Alignment(1, -.8),
            stops: const [0, .22, .64, 1],
            colors: [
              tone.withValues(alpha: .80),
              tone.withValues(alpha: .43),
              tone.withValues(alpha: .13),
              tone.withValues(alpha: .31),
            ],
          ).createShader(bounds),
      );
      canvas.drawPath(
        pane,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: const [0, .26, .61, 1],
            colors: [
              rim.withValues(alpha: .9),
              tone.withValues(alpha: .95),
              rim.withValues(alpha: .28),
              tone.withValues(alpha: .48),
            ],
          ).createShader(bounds)
          ..style = PaintingStyle.stroke
          ..strokeWidth = .85,
      );
    }
  }

  @override
  bool shouldRepaint(_ExperiencePanes oldDelegate) =>
      blue != oldDelegate.blue || violet != oldDelegate.violet;
}

class _PortfolioCard extends StatelessWidget {
  const _PortfolioCard({
    super.key,
    required this.title,
    required this.child,
    this.accent,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Color? accent;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final tint = accent;
    final heading = Semantics(
      header: true,
      child: Text(title, style: theme.textTheme.headlineMedium),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outline),
        gradient: tint == null
            ? null
            : LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.center,
                colors: [
                  Color.alphaBlend(tint.withValues(alpha: .10), colors.surface),
                  colors.surface,
                ],
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (trailing case final ornament?)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: heading),
                  const SizedBox(width: 12),
                  ornament,
                ],
              )
            else
              heading,
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _EducationRow extends StatelessWidget {
  const _EducationRow({required this.compact});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = Semantics(
      header: true,
      child: Text('Education', style: theme.textTheme.titleLarge),
    );
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alexandru Ioan Cuza University of Iași',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        const _Body(
          'Faculty of Computer Science · Bachelor’s studies in software engineering.',
        ),
      ],
    );
    return compact
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [title, const SizedBox(height: 8), details],
          )
        : Row(
            children: [
              SizedBox(width: 142, child: title),
              Container(width: 1, height: 32, color: theme.colorScheme.outline),
              const SizedBox(width: 28),
              Expanded(child: details),
            ],
          );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.compact, required this.onOpen});

  final bool compact;
  final ValueChanged<Uri> onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = Semantics(
      header: true,
      child: Text('Contact', style: theme.textTheme.headlineLarge),
    );
    const message = _Body('Get in touch about Flutter opportunities.');
    final email = FilledButton.icon(
      onPressed: () => onOpen(Uri.parse('mailto:andreea.rosca@gmail.com')),
      icon: const Icon(Icons.mail_outline, size: 18),
      label: const Text('Get in touch'),
    );
    final socials = Wrap(
      spacing: 8,
      children: [
        TextButton(
          onPressed: () => onOpen(
            Uri.parse(
              'https://www.linkedin.com/in/andreea-maria-rosca-6bb501140/',
            ),
          ),
          child: const Text('LinkedIn'),
        ),
        TextButton(
          onPressed: () => onOpen(Uri.parse('https://github.com/roscaandreea')),
          child: const Text('GitHub'),
        ),
      ],
    );
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [title, const SizedBox(height: 8), message],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (compact)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [copy, const SizedBox(height: 12), email],
          )
        else
          Row(
            children: [
              Expanded(child: copy),
              const SizedBox(width: 16),
              email,
            ],
          ),
        const SizedBox(height: 8),
        Align(
          alignment: compact ? Alignment.centerLeft : Alignment.centerRight,
          child: socials,
        ),
      ],
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
