// 课堂案例复现：dart_basics 统一入口
// 步骤二：main 统一调用 types / func / flow 三组示例
// 步骤五：追加自主实践（空安全改写、报告生成器、扩展分级器）

import 'types_demo.dart';
import 'func_demo.dart';
import 'flow_demo.dart';
import 'null_safety_rewrite.dart';
import 'report_generator.dart';
import 'extended_grader.dart';

void main(List<String> arguments) {
  print('========== 课堂案例复现 dart_basics ==========');
  variableDemo();
  stringDemo();
  nullSafetyDemo();
  print('');
  funcDemo();
  print('');
  flowDemo();

  print('\n========== 自主实践 ==========');
  // 实践1：全 null 数据 + 正常数据各演示一遍
  nullSafetyRewriteDemo(null, null, null);
  print('');
  nullSafetyRewriteDemo('hu', 85, 'hu@example.com');
  print('');
  reportGeneratorDemo();
  print('');
  extendedGraderDemo();
}
