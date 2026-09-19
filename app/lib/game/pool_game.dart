import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'ball_set.dart';
import 'sfx.dart';

enum GameEnd { none, aWins, bWins }

class PoolBall {
  PoolBall({
    required this.id,
    required this.kind,
    required this.number,
    required this.pos,
    required this.color,
    this.sprite,
  });

  final int id;
  final String kind;
  final int number;
  Vector2 pos;
  Vector2 vel = Vector2.zero();
  double omega = 0;
  final Color color;
  ui.Image? sprite;
  bool pocketed = false;
}

class PoolGame extends FlameGame with DragCallbacks, TapCallbacks {
  PoolGame({
    this.ballSet = BallSet.blueRed,
    this.onWin,
    this.onPocket,
  });

  BallSet ballSet;
  late BallSkin skin;
  final void Function(bool youWin)? onWin;
  final void Function(String kind)? onPocket;

  static const tableAsset = 'assets/game/table_full.png';
  static const cueAsset = 'assets/game/cue.png';

  ui.Image? tableImg;
  ui.Image? cueImg;

  final List<PoolBall> balls = [];
  final math.Random _rng = math.Random(7);

  late Rect felt;
  late List<Offset> pockets;

  Vector2? aimFrom;
  Vector2? aimTo;
  double power = 0.45;
  bool dragging = false;
  bool locked = false;

  String? assignedA;
  bool playerIsA = true;
  GameEnd end = GameEnd.none;
  String status = 'Break';
  final List<String> returnRail = [];

  int get remainingA =>
      balls.where((b) => !b.pocketed && b.kind == BallKind.a).length;
  int get remainingB =>
      balls.where((b) => !b.pocketed && b.kind == BallKind.b).length;

  void setPower(double v) {
    power = v.clamp(0.08, 1.0);
  }

  @override
  Color backgroundColor() => const Color(0xFF0E1A12);

  @override
  Future<void> onLoad() async {
    await Sfx.init();
    skin = BallSkin.of(ballSet);
    tableImg = await _tryImage(tableAsset);
    cueImg = await _tryImage(cueAsset);
    _layout();
    await _rack();
  }

  void applySet(BallSet set) {
    if (locked) return;
    ballSet = set;
    skin = BallSkin.of(set);
    _rack();
  }

  Future<ui.Image?> _tryImage(String path) async {
    try {
      return await images.load(path);
    } catch (_) {
      return null;
    }
  }

  void _layout() {
    final w = size.x;
    final h = size.y;
    const pad = 28.0;
    felt = Rect.fromLTWH(pad, pad * 1.6, w - pad * 2, h - pad * 2.4);
    pockets = [
      felt.topLeft,
      Offset(felt.center.dx, felt.top),
      felt.topRight,
      felt.bottomLeft,
      Offset(felt.center.dx, felt.bottom),
      felt.bottomRight,
    ];
  }

  Future<void> _rack() async {
    balls.clear();
    returnRail.clear();
    assignedA = null;
    end = GameEnd.none;
    status = 'Break';

    final cueSpr = await _tryImage(skin.assetCue);
    final blackSpr = await _tryImage(skin.assetBlack);
    final aSpr = await _tryImage(skin.assetA);
    final bSpr = await _tryImage(skin.assetB);

    final r = felt.width * 0.018;
    balls.add(PoolBall(
      id: 0,
      kind: BallKind.cue,
      number: 0,
      pos: Vector2(felt.left + felt.width * 0.28, felt.center.dy),
      color: Colors.white,
      sprite: cueSpr,
    ));

    final apex = Vector2(felt.left + felt.width * 0.68, felt.center.dy);
    final slots = <Vector2>[];
    for (var row = 0; row < 5; row++) {
      final count = row + 1;
      for (var i = 0; i < count; i++) {
        slots.add(Vector2(
          apex.x + row * r * 1.78,
          apex.y + (i - (count - 1) / 2) * r * 2.05,
        ));
      }
    }

    final colors = <String>[
      ...List.filled(7, BallKind.a),
      ...List.filled(7, BallKind.b),
    ]..shuffle(_rng);
    colors.insert(4, BallKind.black);

    for (var i = 0; i < 15; i++) {
      final kind = colors[i];
      final num = skin.numbered
          ? (kind == BallKind.black
              ? 8
              : kind == BallKind.a
                  ? (i % 7) + 1
                  : 9 + (i % 7))
          : 0;
      ui.Image? spr = kind == BallKind.black
          ? blackSpr
          : kind == BallKind.a
              ? aSpr
              : bSpr;
      if (skin.numbered && kind != BallKind.black) {
        spr = await _tryImage(skin.numberedAsset(num));
      }
      balls.add(PoolBall(
        id: i + 1,
        kind: kind,
        number: num,
        pos: slots[i],
        color: kind == BallKind.black
            ? Colors.black
            : kind == BallKind.a
                ? const Color(0xFF1E5BFF)
                : const Color(0xFFE10600),
        sprite: spr,
      ));
    }
  }

  double get _radius => felt.width * 0.018;

  @override
  void update(double dt) {
    super.update(dt);
    if (end != GameEnd.none) return;
    var moving = false;
    for (final b in balls) {
      if (b.pocketed) continue;
      if (b.vel.length2 > 4) moving = true;
      _step(b, dt);
    }
    for (var i = 0; i < balls.length; i++) {
      for (var j = i + 1; j < balls.length; j++) {
        _collide(balls[i], balls[j]);
      }
    }
    locked = moving;
  }

  void _step(PoolBall b, double dt) {
    b.pos += b.vel * dt;
    final speed = b.vel.length;
    if (speed > 0) {
      b.omega = speed / _radius;
      final drag = 1.6 + speed * 0.002;
      final ns = math.max(0.0, speed - drag * dt * 60);
      if (ns == 0) {
        b.vel.setZero();
        b.omega = 0;
      } else {
        b.vel.scale(ns / speed);
      }
    }
    final r = _radius;
    if (b.pos.x < felt.left + r) {
      b.pos.x = felt.left + r;
      b.vel.x = -b.vel.x * 0.72;
      Sfx.rail();
    }
    if (b.pos.x > felt.right - r) {
      b.pos.x = felt.right - r;
      b.vel.x = -b.vel.x * 0.72;
      Sfx.rail();
    }
    if (b.pos.y < felt.top + r) {
      b.pos.y = felt.top + r;
      b.vel.y = -b.vel.y * 0.72;
      Sfx.rail();
    }
    if (b.pos.y > felt.bottom - r) {
      b.pos.y = felt.bottom - r;
      b.vel.y = -b.vel.y * 0.72;
      Sfx.rail();
    }
    for (final p in pockets) {
      if ((Offset(b.pos.x, b.pos.y) - p).distance < r * 1.55) {
        _pocket(b);
        break;
      }
    }
  }

  void _pocket(PoolBall b) {
    if (b.pocketed) return;
    b.pocketed = true;
    b.vel.setZero();
    Sfx.pocket();
    if (b.kind == BallKind.cue) {
      b.pocketed = false;
      b.pos = Vector2(felt.left + felt.width * 0.28, felt.center.dy);
      status = 'Scratch';
      return;
    }
    returnRail.add(b.kind);
    onPocket?.call(b.kind);
    if (b.kind == BallKind.black) {
      final shooterA = playerIsA;
      final mineLeft = shooterA ? remainingA : remainingB;
      final youWin = mineLeft == 0
          ? shooterA
          : !shooterA;
      end = youWin ? GameEnd.aWins : GameEnd.bWins;
      status = mineLeft > 0 ? 'Black early — loss' : 'Black potted — win';
      onWin?.call(end == GameEnd.aWins);
      return;
    }
    assignedA ??= b.kind;
    status = '${b.kind == assignedA ? skin.labelA : skin.labelB} potted';
  }

  void _collide(PoolBall a, PoolBall b) {
    if (a.pocketed || b.pocketed) return;
    final d = b.pos - a.pos;
    final dist = d.length;
    final min = _radius * 2;
    if (dist == 0 || dist >= min) return;
    final n = d / dist;
    final overlap = min - dist;
    a.pos -= n * overlap / 2;
    b.pos += n * overlap / 2;
    final rel = b.vel - a.vel;
    final vn = rel.dot(n);
    if (vn > 0) return;
    const e = 0.92;
    final j = -(1 + e) * vn / 2;
    a.vel -= n * j;
    b.vel += n * j;
    Sfx.hit();
  }

  void shoot([double? strength]) {
    if (locked || end != GameEnd.none) return;
    final cue = balls.first;
    final dir = (aimTo ?? Vector2(felt.center.dx + 80, felt.center.dy)) - cue.pos;
    if (dir.length2 < 1) return;
    final p = (strength ?? power).clamp(0.08, 1.0);
    cue.vel = dir.normalized() * (980 * p);
    Sfx.cue();
    aimFrom = null;
    aimTo = null;
    dragging = false;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (locked) return;
    dragging = true;
    aimFrom = event.localPosition;
    aimTo = event.localPosition;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!dragging) return;
    aimTo = event.localEndPosition;
    final cue = balls.first.pos;
    power = ((aimTo! - cue).length / (felt.width * 0.35)).clamp(0.08, 1.0);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!dragging) return;
    dragging = false;
    shoot(power);
  }

  @override
  void render(Canvas canvas) {
    if (tableImg != null) {
      paintImage(
        canvas: canvas,
        rect: size.toRect(),
        image: tableImg!,
        fit: BoxFit.cover,
      );
    } else {
      canvas.drawRect(size.toRect(), Paint()..color = const Color(0xFF0E1A12));
      canvas.drawRRect(
        RRect.fromRectAndRadius(felt, const Radius.circular(18)),
        Paint()..color = const Color(0xFF1B7A3A),
      );
    }

    final r = _radius;
    for (final b in balls) {
      if (b.pocketed) continue;
      final rect = Rect.fromCircle(center: Offset(b.pos.x, b.pos.y), radius: r);
      if (b.sprite != null) {
        paintImage(canvas: canvas, rect: rect, image: b.sprite!, fit: BoxFit.cover);
      } else {
        canvas.drawCircle(Offset(b.pos.x, b.pos.y), r, Paint()..color = b.color);
      }
    }

    final cue = balls.first;
    if (!cue.pocketed && !locked && end == GameEnd.none) {
      final target = aimTo ?? Vector2(felt.right - 40, felt.center.dy);
      final dir = target - cue.pos;
      if (dir.length2 > 4) {
        final n = dir.normalized();
        final tip = Offset(cue.pos.x - n.x * (r + 4), cue.pos.y - n.y * (r + 4));
        if (cueImg != null) {
          canvas.save();
          canvas.translate(tip.dx, tip.dy);
          canvas.rotate(math.atan2(n.y, n.x) + math.pi);
          paintImage(
            canvas: canvas,
            rect: Rect.fromLTWH(0, -6, 160 + power * 40, 12),
            image: cueImg!,
            fit: BoxFit.fill,
          );
          canvas.restore();
        } else {
          canvas.drawLine(
            tip,
            Offset(cue.pos.x - n.x * (70 + power * 80),
                cue.pos.y - n.y * (70 + power * 80)),
            Paint()
              ..color = const Color(0xFFD4AF37)
              ..strokeWidth = 4
              ..strokeCap = StrokeCap.round,
          );
        }
      }
    }
  }
}