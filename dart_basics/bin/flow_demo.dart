// 课堂案例复现：运算符、分支与循环
// 对应《学生实践指南二》第四章

/// 成绩分级器：if/else 分支演示
String gradeOf(int score) {
  if (score >= 90) return '优';
  if (score >= 80) return '良';
  if (score >= 60) return '中';
  return '不及格';
}

/// 运算符演示：/ 与 ~/ 的区别
void operatorDemo() {
  print('--- 4 运算符：/ 与 ~/ ---');
  print('7 / 2 = ${7 / 2} (double)');
  print('7 ~/ 2 = ${7 ~/ 2} (int，整除)');
}

/// 循环演示：for-in 遍历集合
void loopDemo() {
  print('\n--- 4 for-in 循环 ---');
  for (final i in [1, 2, 3]) {
    print('第$i题');
  }
}

/// 控制流演示入口
void flowDemo() {
  operatorDemo();
  print('\n--- gradeOf 分级器 ---');
  for (final s in [95, 85, 70, 55]) {
    print('score=$s => ${gradeOf(s)}');
  }
  loopDemo();
}
