import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

class Sfx {
  static final _hit = AudioPlayer();
  static final _rail = AudioPlayer();
  static final _pocket = AudioPlayer();
  static final _cue = AudioPlayer();
  static bool _ready = false;

  static Future<void> init() async {
    if (_ready) return;
    await _hit.setSourceBytes(_tone(220, 40));
    await _rail.setSourceBytes(_tone(140, 30));
    await _pocket.setSourceBytes(_tone(90, 80));
    await _cue.setSourceBytes(_tone(180, 50));
    _ready = true;
  }

  static void hit() => _play(_hit);
  static void rail() => _play(_rail);
  static void pocket() => _play(_pocket);
  static void cue() => _play(_cue);

  static void _play(AudioPlayer p) {
    if (!_ready) return;
    p.seek(Duration.zero);
    p.resume();
  }

  static Uint8List _tone(int hz, int ms) {
    const rate = 8000;
    final n = (rate * ms / 1000).round();
    final bytes = BytesBuilder();
    void u32(int v) {
      bytes.add([v & 255, (v >> 8) & 255, (v >> 16) & 255, (v >> 24) & 255]);
    }

    void u16(int v) {
      bytes.add([v & 255, (v >> 8) & 255]);
    }

    bytes.add('RIFF'.codeUnits);
    u32(36 + n);
    bytes.add('WAVEfmt '.codeUnits);
    u32(16);
    u16(1);
    u16(1);
    u32(rate);
    u32(rate);
    u16(1);
    u16(8);
    bytes.add('data'.codeUnits);
    u32(n);
    for (var i = 0; i < n; i++) {
      final t = i / rate;
      final s = (127 + 80 * _sin(2 * 3.14159 * hz * t) * (1 - i / n)).round();
      bytes.addByte(s.clamp(0, 255));
    }
    return bytes.takeBytes();
  }

  static double _sin(double x) {
    x = x % (2 * 3.14159);
    var t = x;
    var s = x;
    t *= -x * x / (2 * 3);
    s += t;
    t *= -x * x / (4 * 5);
    s += t;
    t *= -x * x / (6 * 7);
    s += t;
    return s;
  }
}