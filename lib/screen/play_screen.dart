import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../constant/enum_file.dart';
import '../helper/swipe.dart';
import '../model/color_app.dart';
import '../providers/stagePlay.dart';
import '../view_model/app_color.dart';
import '../view_model/game_size.dart';
import '../view_model/manager.dart';
import '../widget/game_menu.dart';
import '../widget/play_screen_widget/d_pad.dart';
import '../widget/play_screen_widget/game_effects.dart';
import '../widget/play_screen_widget/neon_grid.dart';
import '../widget/play_screen_widget/play_board.dart';
import '../widget/play_screen_widget/screen_shake.dart';
import '../widget/play_screen_widget/tap_to_play.dart';
import '../widget/play_screen_widget/top_section.dart';

double width = GameSize().width();
double height = GameSize().height();
double avaWidth = GameSize().avaWidth();

class PlayScreen extends StatelessWidget {
  static const routeName = '/PlayScreen';

  PlayScreen();

  @override
  Widget build(BuildContext context) {
    final stagePlay = context.watch<StagePlay>();
    final stage = stagePlay.stage;
    if (Manager.gameOver || Manager.requestLife) {
      stagePlay.setMenuState(refresh: false);
    }
    Manager.screenAdjust();
    AppColor colors = context.watch<AppColorController>().getColors();
    double cell = GameSize().cellSize().toDouble();
    return Scaffold(
      backgroundColor: colors.basicColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: GameSize().rowHeight(),
                  child: TopPart(
                      title: stage!.getStageTitle(),
                      stage: stagePlay.level,
                      level: stagePlay.controller),
                ),
                Expanded(
                  child: SwipeSteer(
                    stagePlay: stagePlay,
                    child: ScreenShake(
                      child: Container(
                        width: avaWidth,
                        decoration: BoxDecoration(
                          color: colors.blockColor.withOpacity(.3),
                          borderRadius:
                              BorderRadius.circular(cell * .45),
                          boxShadow: [
                            BoxShadow(
                              color: colors.glowColor.withOpacity(.4),
                              blurRadius: cell * 2,
                              spreadRadius: cell * .3,
                            ),
                          ],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: NeonGridPainter(
                                  colors.glowColor,
                                  GameSize().cellInRow(),
                                  GameSize().rowNum(),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: PlayBoard(stagePlay: stagePlay),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: GameSize().rowHeight(),
              left: GameSize().sideMargin() / 2,
              width: avaWidth,
              height: GameSize().getStageHeight().toDouble(),
              child: GameEffects(),
            ),
            if (Manager.dPadEnabled)
              Positioned(
                right: GameSize().sideMargin() / 2 + cell * .3,
                bottom: GameSize().sideMargin() / 2 + cell * .3,
                child: DPad(),
              ),
            GameMenu(
              visible: stagePlay.showMenu,
              isPause: Manager.isPause,
            ),
            TapToPlay(),
          ],
        ),
      ),
    );
  }
}

class SwipeSteer extends StatefulWidget {
  final StagePlay stagePlay;
  final Widget child;

  const SwipeSteer({super.key, required this.stagePlay, required this.child});

  @override
  _SwipeSteerState createState() => _SwipeSteerState();
}

class _Ghost {
  final Direct? dir;
  final int seq;

  const _Ghost(this.dir, this.seq);
}

class _SwipeSteerState extends State<SwipeSteer> {
  Offset? _start;
  final ValueNotifier<_Ghost> _ghost = ValueNotifier(const _Ghost(null, 0));
  int _steerSeq = 0;

  void _steer(Offset current) {
    final start = _start;
    if (start == null) return;
    final dir = resolveSwipe(
      dragStart: start,
      current: current,
      currentDir: widget.stagePlay.getDirect(),
      threshold: GameSize().width() * .015,
    );
    if (dir != null) {
      _start = current;
      _steerSeq++;
      _ghost.value = _Ghost(dir, _steerSeq);
      HapticFeedback.selectionClick();
      widget.stagePlay.changeDirect(dir);
    }
  }

  @override
  void dispose() {
    _ghost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: (d) => _start = d.globalPosition,
      onHorizontalDragStart: (d) => _start = d.globalPosition,
      onVerticalDragUpdate: (d) => _steer(d.globalPosition),
      onHorizontalDragUpdate: (d) => _steer(d.globalPosition),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: avaWidth, maxHeight: GameSize().getStageHeight().toDouble()),
            child: widget.child,
          ),
          ValueListenableBuilder<_Ghost>(
            valueListenable: _ghost,
            builder: (_, g, __) =>
                _SwipeGhost(steer: g.dir, seq: g.seq),
          ),
        ],
      ),
    );
  }
}

class _SwipeGhost extends StatelessWidget {
  final Direct? steer;
  final int seq;

  const _SwipeGhost({this.steer, required this.seq});

  @override
  Widget build(BuildContext context) {
    if (seq == 0 || steer == null) return const SizedBox.shrink();
    final iconData = switch (steer!) {
      Direct.Up => Icons.arrow_upward_rounded,
      Direct.Down => Icons.arrow_downward_rounded,
      Direct.Left => Icons.arrow_back_rounded,
      Direct.Right => Icons.arrow_forward_rounded,
    };
    return IgnorePointer(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(begin: .8, end: 1).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        ),
        child: TweenAnimationBuilder<double>(
          key: ValueKey(seq),
          tween: Tween(begin: 1, end: 0),
          duration: const Duration(milliseconds: 420),
          builder: (_, v, child) => Opacity(
            opacity: v.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, -12 * v),
              child: child,
            ),
          ),
          child: Icon(
            iconData,
            color: context
                .watch<AppColorController>()
                .getColors()
                .glowColor
                .withOpacity(.8),
            size: GameSize().cellSize() * 1.4,
          ),
        ),
      ),
    );
  }
}