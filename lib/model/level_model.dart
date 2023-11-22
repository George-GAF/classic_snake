import '../constant/level_indexs.dart';
import '../viewmodel/game_size.dart';

class LevelModel {
  final int rank;
  final int targetScore;
  late int? highScore;
  final List<int>? buildWell;
  bool enable;

  LevelModel(
      { this.highScore,
      required this.rank,
      required this.targetScore,
      required this.enable,
       this.buildWell});

  @override
  String toString() {
    return 'level number : $rank complete : $enable target : $targetScore high level $highScore well have $buildWell';
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
];

LevelModel _free = LevelModel(
  rank: 0,
  targetScore: 0,
  enable: true,
  buildWell: GameSize.blockIndex = [],
);
LevelModel _levelOne = LevelModel(
  rank: 1,
  targetScore: 300,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelOne,
);

LevelModel _levelTwo = LevelModel(
  rank: 2,
  targetScore: 300,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelTwo,
);
LevelModel _levelThree = LevelModel(
  rank: 3,
  targetScore: 300,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelThree,
);
LevelModel _levelFour = LevelModel(
  rank: 4,
  targetScore: 300,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelFour,
);
LevelModel _levelFive = LevelModel(
  rank: 5,
  targetScore: 300,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelFive,
);
LevelModel _levelSix = LevelModel(
  rank: 6,
  targetScore: 400,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelSix,
);
LevelModel _levelSeven = LevelModel(
  rank: 7,
  targetScore: 400,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelSeven,
);
LevelModel _levelEight = LevelModel(
  rank: 8,
  targetScore: 400,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelEight,
);
LevelModel _levelNine = LevelModel(
  rank: 9,
  targetScore: 400,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelNine,
);
LevelModel _levelTen = LevelModel(
  rank: 10,
  targetScore: 400,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelTen,
);
LevelModel _levelEleven = LevelModel(
  rank: 11,
  targetScore: 500,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelEleven,
);
LevelModel _levelTwelve = LevelModel(
  rank: 12,
  targetScore: 500,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelTwelve,
);
LevelModel _levelThirteen = LevelModel(
  rank: 13,
  targetScore: 500,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelThirteen,
);
LevelModel _levelFourteen = LevelModel(
  rank: 14,
  targetScore: 500,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelFourteen,
);
LevelModel _levelFifteen = LevelModel(
  rank: 15,
  targetScore: 500,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelFifteen,
);
LevelModel _levelSixteen = LevelModel(
  rank: 16,
  targetScore: 600,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelSixteen,
);
LevelModel _levelSeventeen = LevelModel(
  rank: 17,
  targetScore: 600,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelSeventeen,
);
LevelModel _levelEighteen = LevelModel(
  rank: 18,
  targetScore: 600,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelEighteen,
);
LevelModel _levelNineteen = LevelModel(
  rank: 19,
  targetScore: 600,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelNineteen,
);
LevelModel _levelTwenty = LevelModel(
  rank: 20,
  targetScore: 600,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelTwenty,
);
LevelModel _levelTwentyOne = LevelModel(
  rank: 21,
  targetScore: 700,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelTwentyOne,
);
LevelModel _levelTwentyTwo = LevelModel(
  rank: 22,
  targetScore: 700,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelTwentyTwo,
);
LevelModel _levelTwentyThree = LevelModel(
  rank: 23,
  targetScore: 700,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelTwentyThree,
);
LevelModel _levelTwentyFour = LevelModel(
  rank: 24,
  targetScore: 700,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelTwentyFour,
);
LevelModel _levelTwentyFive = LevelModel(
  rank: 25,
  targetScore: 700,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelTwentyFive,
);
LevelModel _levelTwentySix = LevelModel(
  rank: 26,
  targetScore: 800,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelTwentySix,
);
LevelModel _levelTwentySeven = LevelModel(
  rank: 27,
  targetScore: 800,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelTwentySeven,
);
LevelModel _levelTwentyEight = LevelModel(
  rank: 28,
  targetScore: 800,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelTwentyEight,
);
LevelModel _levelTwentyNine = LevelModel(
  rank: 29,
  targetScore: 800,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelTwentyNine,
);
LevelModel _levelThirty = LevelModel(
  rank: 30,
  targetScore: 800,
  enable: false,
  buildWell: GameSize.blockIndex = IndexLevelThirteen,
);

/*

List<LevelModel> levelList = [
  LevelModel(
    rank: 0,
    targetScore: 0,
    enable: true,
    buildWell: () {
      GameSize.getWellIndex(block: []);
    },
  ),
  LevelModel(
    rank: 1,
    targetScore: 300,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelOne);
    },
  ),
  LevelModel(
    rank: 2,
    targetScore: 300,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelTwo);
    },
  ),
  LevelModel(
    rank: 3,
    targetScore: 300,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelThree);
    },
  ),
  LevelModel(
    rank: 4,
    targetScore: 300,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelFour);
    },
  ),
  LevelModel(
    rank: 5,
    targetScore: 300,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelFive);
    },
  ),
  LevelModel(
    rank: 6,
    targetScore: 400,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelSix);
    },
  ),
  LevelModel(
    rank: 7,
    targetScore: 400,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelSeven);
    },
  ),
  LevelModel(
    rank: 8,
    targetScore: 400,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelEight);
    },
  ),
  LevelModel(
    rank: 9,
    targetScore: 400,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelNine);
    },
  ),
  LevelModel(
    rank: 10,
    targetScore: 400,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelTen);
    },
  ),
  LevelModel(
    rank: 11,
    targetScore: 500,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelEleven);
    },
  ),
  LevelModel(
    rank: 12,
    targetScore: 500,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelTwelve);
    },
  ),
  LevelModel(
    rank: 13,
    targetScore: 500,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelThirteen);
    },
  ),
  LevelModel(
    rank: 14,
    targetScore: 500,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelFourteen);
    },
  ),
  LevelModel(
    rank: 15,
    targetScore: 500,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelFifteen);
    },
  ),
  LevelModel(
    rank: 16,
    targetScore: 600,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelSixteen);
    },
  ),
  LevelModel(
    rank: 17,
    targetScore: 600,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelSeventeen);
    },
  ),
  LevelModel(
    rank: 18,
    targetScore: 600,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelEighteen);
    },
  ),
  LevelModel(
    rank: 19,
    targetScore: 600,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelNineteen);
    },
  ),
  LevelModel(
    rank: 20,
    targetScore: 600,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelTwenty);
    },
  ),
  LevelModel(
    rank: 21,
    targetScore: 700,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelTwentyOne);
    },
  ),
  LevelModel(
    rank: 22,
    targetScore: 700,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelTwentyTwo);
    },
  ),
  LevelModel(
    rank: 23,
    targetScore: 700,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelTwentyThree);
    },
  ),
  LevelModel(
    rank: 24,
    targetScore: 700,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelTwentyFour);
    },
  ),
  LevelModel(
    rank: 25,
    targetScore: 700,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelTwentyFive);
    },
  ),
  LevelModel(
    rank: 26,
    targetScore: 800,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelTwentySix);
    },
  ),
  LevelModel(
    rank: 27,
    targetScore: 800,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelTwentySeven);
    },
  ),
  LevelModel(
    rank: 28,
    targetScore: 800,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelTwentyEight);
    },
  ),
  LevelModel(
    rank: 29,
    targetScore: 800,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelTwentyNine);
    },
  ),
  LevelModel(
    rank: 30,
    targetScore: 800,
    enable: false,
    buildWell: () {
      GameSize.getWellIndex(block: IndexLevelThirteen);
    },
  ),
];

 */
