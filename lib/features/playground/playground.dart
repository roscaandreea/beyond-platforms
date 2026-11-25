import 'dart:ui' show ImageFilter;

import 'package:material_ui/material_ui.dart';

enum PlatformPreview { web, ios, android }

extension on PlatformPreview {
  String get label => switch (this) {
    PlatformPreview.web => 'Web',
    PlatformPreview.ios => 'iOS',
    PlatformPreview.android => 'Android',
  };

  IconData get icon => switch (this) {
    PlatformPreview.web => Icons.desktop_windows_outlined,
    PlatformPreview.ios => Icons.apple,
    PlatformPreview.android => Icons.android,
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
          painter: const _PlaygroundLighting(),
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
                  _GlassPlatformSelector(
                    selected: _selected,
                    reduceMotion: _reduceMotion,
                    onSelected: (platform) =>
                        setState(() => _selected = platform),
                  ),
                ],
              );
              final preview = AnimatedBuilder(
                animation: _entrance,
                child: SizedBox(
                  height: compact
                      ? 318
                      : wide
                      ? 464
                      : 388,
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
                          fit: BoxFit.contain,
                          child: SizedBox(
                            width: 666,
                            height: 414,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                for (final platform
                                    in _selected == PlatformPreview.android
                                        ? const [
                                            PlatformPreview.web,
                                            PlatformPreview.ios,
                                            PlatformPreview.android,
                                          ]
                                        : const [
                                            PlatformPreview.web,
                                            PlatformPreview.android,
                                            PlatformPreview.ios,
                                          ])
                                  Positioned(
                                    key: ValueKey(platform),
                                    left: switch (platform) {
                                      PlatformPreview.web => 24,
                                      PlatformPreview.ios => 360,
                                      PlatformPreview.android => 516,
                                    },
                                    top: switch (platform) {
                                      PlatformPreview.web => 50,
                                      PlatformPreview.ios => 148,
                                      PlatformPreview.android => 102,
                                    },
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: _devicePerspective(platform),
                                      child: AnimatedScale(
                                        scale: platform == _selected ? 1.04 : 1,
                                        duration: Duration(
                                          milliseconds: _reduceMotion ? 0 : 250,
                                        ),
                                        child: _Device(
                                          platform: platform,
                                          selected: platform == _selected,
                                          browserWidth: 514,
                                          oblique: true,
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

class _GlassPlatformSelector extends StatelessWidget {
  const _GlassPlatformSelector({
    required this.selected,
    required this.reduceMotion,
    required this.onSelected,
  });

  final PlatformPreview selected;
  final bool reduceMotion;
  final ValueChanged<PlatformPreview> onSelected;

  @override
  Widget build(BuildContext context) {
    final highContrast = MediaQuery.highContrastOf(context);
    final radius = BorderRadius.circular(26);
    Color foreground(PlatformPreview platform) =>
        highContrast && platform == selected
        ? const Color(0xFF0B101B)
        : Colors.white;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          enabled: !highContrast,
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: highContrast ? Colors.white : const Color(0x42DCF1FF),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: highContrast
                    ? const [Color(0xFF111827), Color(0xFF111827)]
                    : const [Color(0x39758FAC), Color(0x8C0A1324)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedAlign(
                        duration: Duration(
                          milliseconds: reduceMotion ? 0 : 280,
                        ),
                        curve: Curves.easeOutCubic,
                        alignment: Alignment(selected.index - 1.0, 0),
                        child: FractionallySizedBox(
                          widthFactor: 1 / PlatformPreview.values.length,
                          heightFactor: 1,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: radius,
                              border: Border.all(
                                color: highContrast
                                    ? Colors.white
                                    : const Color(0x62EAF8FF),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: highContrast
                                    ? const [Colors.white, Colors.white]
                                    : const [
                                        Color(0x7BA2D4FA),
                                        Color(0x4C6C9EC9),
                                      ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    type: MaterialType.transparency,
                    child: Row(
                      children: [
                        for (final platform in PlatformPreview.values)
                          Expanded(
                            child: Semantics(
                              button: true,
                              selected: platform == selected,
                              child: InkWell(
                                customBorder: const StadiumBorder(),
                                overlayColor: const WidgetStatePropertyAll(
                                  Color(0x22FFFFFF),
                                ),
                                onTap: () => onSelected(platform),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 44,
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 8,
                                      ),
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        spacing: 5,
                                        runSpacing: 3,
                                        children: [
                                          ExcludeSemantics(
                                            child: Icon(
                                              platform.icon,
                                              size: 16,
                                              color: foreground(platform),
                                            ),
                                          ),
                                          Text(
                                            platform.label,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: foreground(platform),
                                              fontSize: 14,
                                              fontWeight: platform == selected
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Matrix4 _devicePerspective(PlatformPreview platform) {
  final (pitch, yaw, roll) = switch (platform) {
    PlatformPreview.web => (-.16, .25, -.19),
    PlatformPreview.ios => (-.11, .37, .09),
    PlatformPreview.android => (-.08, .28, .16),
  };
  return Matrix4.identity()
    ..setEntry(3, 2, .0011)
    ..rotateX(pitch)
    ..rotateY(yaw)
    ..rotateZ(roll);
}

class _Device extends StatelessWidget {
  const _Device({
    required this.platform,
    required this.selected,
    this.browserWidth = 310,
    this.oblique = false,
  });
  final PlatformPreview platform;
  final bool selected;
  final double browserWidth;
  final bool oblique;

  @override
  Widget build(BuildContext context) {
    final web = platform == PlatformPreview.web;
    final accent = platform == PlatformPreview.android
        ? const Color(0xFFB5A2FF)
        : const Color(0xFF55B7FF);
    final radius = BorderRadius.circular(web ? 18 : 26);
    final display = Container(
      width: web ? browserWidth : 132,
      height: web ? 256 : 238,
      padding: EdgeInsets.all(web ? 2 : 4),
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, .26, .65, 1],
          colors: [
            const Color(0xFFD8ECFF),
            accent,
            const Color(0xFF202C4A),
            const Color(0xFF607397),
          ],
        ),
        boxShadow: [
          const BoxShadow(
            color: Color(0xB0050A15),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
          if (selected)
            BoxShadow(
              color: accent.withValues(alpha: .34),
              blurRadius: 26,
              spreadRadius: 1,
            ),
          if (oblique)
            const BoxShadow(color: Color(0xFF293959), offset: Offset(6, 3)),
          if (oblique)
            const BoxShadow(color: Color(0xFF8297C1), offset: Offset(3, 1)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(web ? 16 : 22),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF172543), Color(0xFF0B1428)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (web)
                Container(
                  color: const Color(0xFF223356),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  child: Row(
                    children: [
                      for (final color in const [
                        Color(0xFFEF8D91),
                        Color(0xFFE5C47E),
                        Color(0xFF8CCBB1),
                      ])
                        Container(
                          width: 5,
                          height: 5,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      const SizedBox(width: 9),
                      const Expanded(
                        child: Text(
                          'playground / overview',
                          maxLines: 1,
                          style: TextStyle(
                            color: Color(0xFFB0C5E9),
                            fontFamily: 'JetBrains Mono',
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 7,
                    width: platform == PlatformPreview.ios ? 33 : 7,
                    decoration: BoxDecoration(
                      color: const Color(0xFF050A15),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(web ? 12 : 8),
                  child: Row(
                    children: [
                      if (web) ...[
                        const SizedBox(
                          width: 28,
                          child: CustomPaint(
                            painter: _PreviewSidebar(),
                            child: SizedBox.expand(),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              web ? 'Flutter Playground' : platform.label,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: web
                                    ? 'Space Grotesk'
                                    : 'JetBrains Mono',
                                fontSize: web ? 18 : 10,
                                color: web ? Colors.white : accent,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Expanded(
                              child: SizedBox.expand(
                                child: CustomPaint(
                                  painter: _PreviewDashboard(accent),
                                ),
                              ),
                            ),
                            if (!web)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 6),
                                  child: SizedBox(
                                    width: 29,
                                    height: 2,
                                    child: ColoredBox(color: Color(0xFF9CAFC5)),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return Semantics(
      image: true,
      label: '${platform.label} Flutter Playground preview',
      child: ExcludeSemantics(
        child: web
            ? SizedBox(
                width: browserWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: display,
                    ),
                    const CustomPaint(
                      painter: _LaptopBase(),
                      child: SizedBox(height: 22),
                    ),
                  ],
                ),
              )
            : display,
      ),
    );
  }
}

class _LaptopBase extends CustomPainter {
  const _LaptopBase();

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final bounds = Offset.zero & size;
    final deck = Path()
      ..moveTo(14, 0)
      ..lineTo(width - 14, 0)
      ..lineTo(width - 1, 12)
      ..quadraticBezierTo(width, 13, width - 2, 14)
      ..lineTo(2, 14)
      ..quadraticBezierTo(0, 13, 1, 12)
      ..close();
    final lip = Path()
      ..moveTo(2, 14)
      ..lineTo(width - 2, 14)
      ..quadraticBezierTo(width - 8, 21, width - 29, 21)
      ..lineTo(29, 21)
      ..quadraticBezierTo(8, 21, 2, 14)
      ..close();
    final paint = Paint();
    canvas.drawPath(
      lip,
      paint
        ..shader = const LinearGradient(
          colors: [Color(0xFF273D63), Color(0xFF5C6B9C), Color(0xFF252943)],
        ).createShader(bounds),
    );
    canvas.drawPath(
      deck,
      paint
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF162744), Color(0xFF51668E)],
        ).createShader(const Rect.fromLTWH(0, 0, 1, 14)),
    );
    paint.shader = null;
    canvas.drawLine(
      const Offset(3, 14),
      Offset(width - 3, 14),
      paint..color = const Color(0xFF91B5E3),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(width / 2, 9),
          width: width * .18,
          height: 5,
        ),
        const Radius.circular(2),
      ),
      paint..color = const Color(0xFF273855),
    );
  }

  @override
  bool shouldRepaint(_LaptopBase oldDelegate) => false;
}

class _PreviewSidebar extends CustomPainter {
  const _PreviewSidebar();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var index = 0; index < 6; index++) {
      final row = Rect.fromLTWH(0, 8 + index * 19.0, index == 1 ? 26 : 17, 6);
      canvas.drawRRect(
        RRect.fromRectAndRadius(row, const Radius.circular(3)),
        paint
          ..color = index == 1
              ? const Color(0xFF55B7FF)
              : const Color(0xFF395178),
      );
    }
  }

  @override
  bool shouldRepaint(_PreviewSidebar oldDelegate) => false;
}

class _PreviewDashboard extends CustomPainter {
  const _PreviewDashboard(this.accent);
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final banner = Rect.fromLTWH(0, 0, size.width, size.height * .39);
    canvas.drawRRect(
      RRect.fromRectAndRadius(banner, const Radius.circular(9)),
      paint
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent.withValues(alpha: .74), const Color(0xFF2E285D)],
        ).createShader(banner),
    );
    paint.shader = null;
    void line(double left, double top, double width, Color color) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, width, 4),
          const Radius.circular(2),
        ),
        paint..color = color,
      );
    }

    line(8, banner.height * .47, size.width * .38, const Color(0xD7D6ECFF));
    line(8, banner.height * .64, size.width * .25, const Color(0x9483BAF4));
    final gutter = size.width > 200 ? 8.0 : 5.0;
    final cardWidth = (size.width - gutter) / 2;
    final cardTop = size.height * .46;
    final cardHeight = size.height * .42;
    for (final index in [0, 1]) {
      final left = index * (cardWidth + gutter);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, cardTop, cardWidth, cardHeight),
          const Radius.circular(7),
        ),
        paint..color = const Color(0xFF1C2E51),
      );
      line(left + 5, cardTop + 7, cardWidth * .45, const Color(0xFF56709F));
      final barWidth = (cardWidth - 13) / 5;
      for (final (bar, fraction) in const [.35, .54, .43, .69, .58].indexed) {
        final height = (cardHeight - 16) * fraction;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              left + 5 + bar * barWidth,
              cardTop + cardHeight - 5 - height,
              barWidth - 2,
              height,
            ),
            const Radius.circular(2),
          ),
          paint..color = index == 0 ? accent : const Color(0xFF8F8BCD),
        );
      }
    }
    line(0, size.height * .94, size.width * .34, const Color(0xFF2F4873));
    line(
      size.width * .52,
      size.height * .94,
      size.width * .27,
      const Color(0xFF2F4873),
    );
  }

  @override
  bool shouldRepaint(_PreviewDashboard oldDelegate) =>
      accent != oldDelegate.accent;
}

class _PlaygroundLighting extends CustomPainter {
  const _PlaygroundLighting();

  @override
  void paint(Canvas canvas, Size size) {
    final wide = size.width >= 940;
    void glow(
      Offset center,
      double width,
      double height,
      Color color, {
      double angle = 0,
    }) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      canvas.scale(width, height);
      canvas.drawCircle(
        Offset.zero,
        1,
        Paint()
          ..shader = RadialGradient(
            stops: const [0, .4, 1],
            colors: [
              color,
              color.withValues(alpha: color.a * .36),
              color.withValues(alpha: 0),
            ],
          ).createShader(const Rect.fromLTWH(-1, -1, 2, 2)),
      );
      canvas.restore();
    }

    final width = size.width;
    final height = size.height;
    final floor = height * (wide ? .82 : .87);

    // Aim the spotlight across the artwork, below the copy on smaller screens.
    glow(
      Offset(width * (wide ? .88 : .87), height * (wide ? .12 : .64)),
      width * (wide ? .29 : .42),
      height * .29,
      const Color(0xA2AC8BFF),
      angle: -.62,
    );
    glow(
      Offset(width * (wide ? .95 : .96), height * (wide ? .035 : .57)),
      width * .18,
      height * .10,
      const Color(0xAEEAD6FF),
      angle: -.62,
    );
    glow(
      Offset(width * (wide ? .63 : .45), height * (wide ? .58 : .74)),
      width * .40,
      height * .43,
      const Color(0x705578FF),
    );

    // A low, wide pool of colored light gives the devices a surface to sit on.
    glow(
      Offset(width * (wide ? .62 : .42), floor),
      width * .34,
      height * .13,
      const Color(0xAA55B7FF),
    );
    glow(
      Offset(width * (wide ? .86 : .75), floor + height * .06),
      width * .24,
      height * .14,
      const Color(0x99AF82FF),
    );

    final traces = Paint()
      ..shader = const LinearGradient(
        stops: [0, .30, .62, 1],
        colors: [
          Color(0x00A9C6FF),
          Color(0x13A9C6FF),
          Color(0x37A9C6FF),
          Color(0x12E0C8FF),
        ],
      ).createShader(Offset.zero & size);
    for (var x = width * .32; x < width + height; x += 100) {
      canvas.drawLine(Offset(x, 0), Offset(x - height * .52, height), traces);
    }
  }

  @override
  bool shouldRepaint(_PlaygroundLighting oldDelegate) => false;
}
