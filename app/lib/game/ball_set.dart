enum BallSet { blueRed, blueYellow, redYellow, numbered }

class BallKind {
  static const cue = 'cue';
  static const black = 'black';
  static const a = 'a';
  static const b = 'b';
}

class BallSkin {
  const BallSkin({
    required this.id,
    required this.labelA,
    required this.labelB,
    required this.assetA,
    required this.assetB,
    required this.assetBlack,
    required this.assetCue,
    this.numbered = false,
  });

  final BallSet id;
  final String labelA;
  final String labelB;
  final String assetA;
  final String assetB;
  final String assetBlack;
  final String assetCue;
  final bool numbered;

  static const cuePath = 'assets/game/balls/ball_00.png';
  static const blackPath = 'assets/game/balls/ball_black.png';

  static BallSkin of(BallSet set) {
    switch (set) {
      case BallSet.blueRed:
        return const BallSkin(
          id: BallSet.blueRed,
          labelA: 'BLUE',
          labelB: 'RED',
          assetA: 'assets/game/balls/ball_blue.png',
          assetB: 'assets/game/balls/ball_red.png',
          assetBlack: blackPath,
          assetCue: cuePath,
        );
      case BallSet.blueYellow:
        return const BallSkin(
          id: BallSet.blueYellow,
          labelA: 'BLUE',
          labelB: 'YELLOW',
          assetA: 'assets/game/balls/ball_blue.png',
          assetB: 'assets/game/balls/ball_yellow.png',
          assetBlack: blackPath,
          assetCue: cuePath,
        );
      case BallSet.redYellow:
        return const BallSkin(
          id: BallSet.redYellow,
          labelA: 'RED',
          labelB: 'YELLOW',
          assetA: 'assets/game/balls/ball_red.png',
          assetB: 'assets/game/balls/ball_yellow.png',
          assetBlack: blackPath,
          assetCue: cuePath,
        );
      case BallSet.numbered:
        return const BallSkin(
          id: BallSet.numbered,
          labelA: 'SOLIDS',
          labelB: 'STRIPES',
          assetA: 'assets/game/balls/ball_01.png',
          assetB: 'assets/game/balls/ball_09.png',
          assetBlack: 'assets/game/balls/ball_08.png',
          assetCue: cuePath,
          numbered: true,
        );
    }
  }

  String numberedAsset(int n) {
    final s = n.toString().padLeft(2, '0');
    return 'assets/game/balls/ball_$s.png';
  }
}