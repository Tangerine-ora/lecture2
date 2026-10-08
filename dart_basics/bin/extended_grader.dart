// 自主实践任务3：控制流小程序——成绩分级器扩展
// 处理边界 100/0 与非法输入（负数、超过 100、非数值）。

import 'dart:io';

/// 扩展版成绩分级器。
///
/// 相对课堂版 gradeOf 的改进：
/// - 入参为可空 double?，非法输入（null、NaN、<0、>100）返回提示而非误判；
/// - 明确覆盖边界 100 与 0；
/// - 用 switch 表达式（Dart 3）展示另一种分支写法。
String gradeOfExtended(double? score) {
  if (score == null || score.isNaN) {
    return '输入非法：成绩必须是数字';
  }
  if (score < 0 || score > 100) {
    return '输入非法：成绩需在 0~100 之间（当前：$score）';
  }
  // switch 表达式：Dart 3 模式匹配写法（了解即可）
  return switch (score) {
    100 => '满分',
    >= 90 => '优',
    >= 80 => '良',
    >= 60 => '中',
    0 => '零分',
    _ => '不及格',
  };
}

/// 演示：正常值、边界值、非法值全覆盖
void extendedGraderDemo() {
  print('--- 实践3 成绩分级器扩展 ---');
  final cases = <double?>[
    100, // 边界：满分
    95, 90, // 优
    85, 80, // 良
    70, 60, // 中
    59.5, 30, // 不及格
    0, // 边界：零分
    -1, // 非法：负数
    101, // 非法：超过 100
    double.nan, // 非法：NaN
    null, // 非法：null
  ];
  for (final s in cases) {
    print('score=$s => ${gradeOfExtended(s)}');
  }
}

/// 交互式入口（可选）：从标准输入读取成绩，验证非法输入处理。
/// 单独运行：dart run bin/extended_grader.dart --interactive
void interactiveGrader() {
  stdout.write('请输入成绩（0~100）：');
  final line = stdin.readLineSync();
  final score = double.tryParse(line ?? '');
  print(gradeOfExtended(score));
}
