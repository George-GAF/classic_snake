import 'dart:async';
import 'dart:math';

void main() {
  print('START');
  int s = Random().nextInt(20) + 30;
  print('seconds $s');
  Duration duration = Duration(seconds: s);
  Timer.periodic(duration, (timer) {
    print('${Random().nextInt(600)}');
    Future.delayed(Duration(seconds: 15), () {
      print(601);
    });
  });
}
