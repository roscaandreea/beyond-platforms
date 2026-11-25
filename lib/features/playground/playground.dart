import 'package:material_ui/material_ui.dart';

enum PlatformPreview { web, ios, android }

extension on PlatformPreview {
  String get label => switch (this) {
    PlatformPreview.web => 'Web',
    PlatformPreview.ios => 'iOS',
    PlatformPreview.android => 'Android',
  };
}

class Playground extends StatefulWidget {
  const Playground({super.key});

  @override
  State<Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground>
    with SingleTickerProviderStateMixin {
  PlatformPreview _selected = PlatformPreview.web;
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );
  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) {
      _entrance.value = 1;
    } else if (_entrance.isDismissed) {
      _entrance.forward();
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? const [Color(0xFF10182F), Color(0xFF183A77), Color(0xFF5046A2)]
              : const [Color(0xFF173568), Color(0xFF235095), Color(0xFF5942A5)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: CustomPaint(
          painter: const _Traces(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 600;
              final wide = constraints.maxWidth >= 940;
              final copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'FLUTTER PLAYGROUND',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12,
                      color: Color(0xFF74EFF8),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'One UI, three platforms.',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: const Color(0xFFF4F7FC),
                      fontSize: wide ? 46 : 32,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Explore how the same Flutter interface adapts to a browser, iOS and Android.',
                    style: TextStyle(color: Color(0xFFDCE7FB), height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final platform in PlatformPreview.values)
                        ChoiceChip(
                          label: Text(platform.label),
                          selected: platform == _selected,
                          showCheckmark: false,
                          selectedColor: const Color(0xFF55B7FF),
                          backgroundColor: const Color(0xFF131C2C),
                          side: const BorderSide(color: Color(0xFF6682A2)),
                          labelStyle: TextStyle(
                            color: platform == _selected
                                ? const Color(0xFF0B101B)
                                : Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          onSelected: (_) =>
                              setState(() => _selected = platform),
                        ),
                    ],
                  ),
                ],
              );
              final preview = AnimatedBuilder(
                animation: _entrance,
                child: SizedBox(
                  height: compact ? 270 : 410,
                  child: compact
                      ? AnimatedSwitcher(
                          duration: Duration(
                            milliseconds: _reduceMotion ? 0 : 250,
                          ),
                          child: Center(
                            key: ValueKey(_selected),
                            child: _Device(platform: _selected, selected: true),
                          ),
                        )
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SizedBox(
                            width: 642,
                            height: 380,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                for (final platform in [
                                  ...PlatformPreview.values.where(
                                    (platform) => platform != _selected,
                                  ),
                                  _selected,
                                ])
                                  Positioned(
                                    key: ValueKey(platform),
                                    left: switch (platform) {
                                      PlatformPreview.web => 60,
                                      PlatformPreview.ios => 10,
                                      PlatformPreview.android => 500,
                                    },
                                    top: switch (platform) {
                                      PlatformPreview.web => 12,
                                      PlatformPreview.ios => 126,
                                      PlatformPreview.android => 86,
                                    },
                                    child: AnimatedScale(
                                      scale: platform == _selected ? 1.04 : 1,
                                      duration: Duration(
                                        milliseconds: _reduceMotion ? 0 : 250,
                                      ),
                                      child: AnimatedOpacity(
                                        opacity: platform == _selected ? 1 : .7,
                                        duration: Duration(
                                          milliseconds: _reduceMotion ? 0 : 250,
                                        ),
                                        child: _Device(
                                          platform: platform,
                                          selected: platform == _selected,
                                          browserWidth: 494,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                ),
                builder: (context, child) {
                  final t = Curves.easeOutCubic.transform(_entrance.value);
                  return Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, 16 * (1 - t)),
                      child: child,
                    ),
                  );
                },
              );
              return Padding(
                padding: EdgeInsets.all(compact ? 18 : 36),
                child: wide
                    ? Row(
                        children: [
                          SizedBox(width: 320, child: copy),
                          const SizedBox(width: 28),
                          Expanded(child: preview),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [copy, const SizedBox(height: 16), preview],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Device extends StatelessWidget {
  const _Device({
    required this.platform,
    required this.selected,
    this.browserWidth = 310,
  });
  final PlatformPreview platform;
  final bool selected;
  final double browserWidth;

  @override
  Widget build(BuildContext context) {
    final web = platform == PlatformPreview.web;
    final accent = platform == PlatformPreview.android
        ? const Color(0xFFB5A2FF)
        : const Color(0xFF55B7FF);
    return Semantics(
      image: true,
      label: '${platform.label} Flutter Playground preview',
      child: ExcludeSemantics(
        child: Container(
          width: web ? browserWidth : 132,
          height: web ? 228 : 244,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFF131C2C),
            borderRadius: BorderRadius.circular(web ? 16 : 24),
            border: Border.all(
              color: selected ? accent : const Color(0xFF40536F),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x65050A15),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (web)
                Container(
                  height: 32,
                  color: const Color(0xFF1B2739),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    '● ● ●    playground / overview',
                    style: TextStyle(
                      color: Color(0xFF9CAFC5),
                      fontFamily: 'JetBrains Mono',
                      fontSize: 9,
                    ),
                  ),
                )
              else
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 6,
                    width: platform == PlatformPreview.ios ? 36 : 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF415370),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(web ? 16 : 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        web ? 'Flutter Playground' : platform.label,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: web ? 'Space Grotesk' : 'JetBrains Mono',
                          fontSize: web ? 20 : 11,
                          color: web ? Colors.white : accent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        web ? 'Color and layout preview' : 'Playground',
                        maxLines: 1,
                        style: const TextStyle(
                          color: Color(0xFFB8C9DC),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 13),
                      Row(
                        children: [
                          for (final color in const [
                            Color(0xFF55B7FF),
                            Color(0xFFB5A2FF),
                            Color(0xFF35D7E8),
                          ])
                            Container(
                              width: web ? 28 : 21,
                              height: 24,
                              margin: const EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      if (web)
                        SizedBox(
                          height: 52,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              for (final (index, height) in const [
                                19.0,
                                28.0,
                                23.0,
                                38.0,
                                33.0,
                                45.0,
                                40.0,
                                50.0,
                              ].indexed)
                                Expanded(
                                  child: Container(
                                    height: height,
                                    margin: const EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                      color: index % 3 == 0
                                          ? const Color(0xFFB5A2FF)
                                          : accent,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      else ...[
                        Container(
                          height: 23,
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: 36,
                            height: 3,
                            color: const Color(0xFF9CAFC5),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Traces extends CustomPainter {
  const _Traces();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x1FFFFFFF);
    for (var x = 120.0; x < size.width + size.height; x += 85) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height * .46, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_Traces oldDelegate) => false;
}
