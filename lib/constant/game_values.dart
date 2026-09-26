const KSnakeStarting = [30, 50, 70, 90];
const KDefaultGameSpeed = 300;
const KEatScoreValue = 10;
const KComboResetSeconds = 4;
// Target-time (star par) tuning
const KTargetFoodDist = 12.5; // avg torus distance between meals (cells)
const KTargetBlockOverhead = 0.004; // extra path length added per obstacle cell
const KTargetSlack = 1.25; // good-player slack; lower = tighter par