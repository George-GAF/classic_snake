import '../constant/level_indexs.dart';
import '../view_model/game_size.dart';

class LevelModel {
  final int? rank;
  final int? targetScore;
  late int? highScore;
  List<int>? blocks = [];
  bool enable;

  LevelModel(
      {this.highScore,
      required this.rank,
      required this.targetScore,
      required this.enable,
      this.blocks});

  @override
  String toString() {
    return 'level number : $rank complete : $enable target : $targetScore high Score $highScore blocks $blocks';
  }
}

//blockIndex
List<LevelModel> levelList = [
  _free,
  _levelOne,
  _levelTwo,
  _levelThree,
  _levelFour,
  _levelFive,
  _levelSix,
  _levelSeven,
  _levelEight,
  _levelNine,
  _levelTen,
  _levelEleven,
  _levelTwelve,
  _levelThirteen,
  _levelFourteen,
  _levelFifteen,
  _levelSixteen,
  _levelSeventeen,
  _levelEighteen,
  _levelNineteen,
  _levelTwenty,
  _levelTwentyOne,
  _levelTwentyTwo,
  _levelTwentyThree,
  _levelTwentyFour,
  _levelTwentyFive,
  _levelTwentySix,
  _levelTwentySeven,
  _levelTwentyEight,
  _levelTwentyNine,
  _levelThirty,
  customize
];

LevelModel customize = LevelModel(
  rank: 999,
  targetScore: 0,
  enable: true,
  blocks: GameSize.blockIndex = [],
);

LevelModel _free = LevelModel(
  rank: 0,
  targetScore: 0,
  enable: true,
  blocks: GameSize.blockIndex = [],
);
LevelModel _levelOne = LevelModel(
  rank: 1,
  targetScore: 300,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelOne,
);

LevelModel _levelTwo = LevelModel(
  rank: 2,
  targetScore: 300,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelTwo,
);
LevelModel _levelThree = LevelModel(
  rank: 3,
  targetScore: 300,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelThree,
);
LevelModel _levelFour = LevelModel(
  rank: 4,
  targetScore: 300,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelFour,
);
LevelModel _levelFive = LevelModel(
  rank: 5,
  targetScore: 300,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelFive,
);
LevelModel _levelSix = LevelModel(
  rank: 6,
  targetScore: 400,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelSix,
);
LevelModel _levelSeven = LevelModel(
  rank: 7,
  targetScore: 400,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelSeven,
);
LevelModel _levelEight = LevelModel(
  rank: 8,
  targetScore: 400,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelEight,
);
LevelModel _levelNine = LevelModel(
  rank: 9,
  targetScore: 400,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelNine,
);
LevelModel _levelTen = LevelModel(
  rank: 10,
  targetScore: 400,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelTen,
);
LevelModel _levelEleven = LevelModel(
  rank: 11,
  targetScore: 500,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelEleven,
);
LevelModel _levelTwelve = LevelModel(
  rank: 12,
  targetScore: 500,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelTwelve,
);
LevelModel _levelThirteen = LevelModel(
  rank: 13,
  targetScore: 500,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelThirteen,
);
LevelModel _levelFourteen = LevelModel(
  rank: 14,
  targetScore: 500,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelFourteen,
);
LevelModel _levelFifteen = LevelModel(
  rank: 15,
  targetScore: 500,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelFifteen,
);
LevelModel _levelSixteen = LevelModel(
  rank: 16,
  targetScore: 600,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelSixteen,
);
LevelModel _levelSeventeen = LevelModel(
  rank: 17,
  targetScore: 600,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelSeventeen,
);
LevelModel _levelEighteen = LevelModel(
  rank: 18,
  targetScore: 600,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelEighteen,
);
LevelModel _levelNineteen = LevelModel(
  rank: 19,
  targetScore: 600,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelNineteen,
);
LevelModel _levelTwenty = LevelModel(
  rank: 20,
  targetScore: 600,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelTwenty,
);
LevelModel _levelTwentyOne = LevelModel(
  rank: 21,
  targetScore: 700,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelTwentyOne,
);
LevelModel _levelTwentyTwo = LevelModel(
  rank: 22,
  targetScore: 700,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelTwentyTwo,
);
LevelModel _levelTwentyThree = LevelModel(
  rank: 23,
  targetScore: 700,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelTwentyThree,
);
LevelModel _levelTwentyFour = LevelModel(
  rank: 24,
  targetScore: 700,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelTwentyFour,
);
LevelModel _levelTwentyFive = LevelModel(
  rank: 25,
  targetScore: 700,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelTwentyFive,
);
LevelModel _levelTwentySix = LevelModel(
  rank: 26,
  targetScore: 800,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelTwentySix,
);
LevelModel _levelTwentySeven = LevelModel(
  rank: 27,
  targetScore: 800,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelTwentySeven,
);
LevelModel _levelTwentyEight = LevelModel(
  rank: 28,
  targetScore: 800,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelTwentyEight,
);
LevelModel _levelTwentyNine = LevelModel(
  rank: 29,
  targetScore: 800,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelTwentyNine,
);
LevelModel _levelThirty = LevelModel(
  rank: 30,
  targetScore: 800,
  enable: false,
  blocks: GameSize.blockIndex = IndexLevelThirty,
);
