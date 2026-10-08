// 课堂案例复现：变量、内置类型与空安全四件套演示
// 对应《学生实践指南二》第二章 2.1 ~ 2.3 节

/// 变量声明与内置类型演示
void variableDemo() {
  print('--- 2.1 变量声明 ---');

  // var 类型推断：编译器推断为 String / int / double
  var title = '第一次作业';
  int year = 2026;
  double score = 92.5;

  // final：运行时确定一次；const：编译期常量
  final now = DateTime.now();
  const pi = 3.14159;

  print('title = $title (String)');
  print('year = $year (int)');
  print('score = $score (double)');
  print('now = $now (DateTime, final 运行时确定)');
  print('pi = $pi (const 编译期常量)');
}

/// 字符串插值演示
void stringDemo() {
  print('\n--- 2.2 字符串插值 ---');
  var name = '李华';
  var score = 90;
  // 变量直接 $，表达式加花括号
  print('你好，$name，成绩${score + 5}');
}

/// 模拟来源不可控的可空数据（如网络/表单返回），
/// 编译器无法静态确定其取值，判空与安全调用均为必要操作。
String? fetchNullableName({String? give}) => give;

/// 空安全四件套演示：?.、??、!、late
void nullSafetyDemo() {
  print('\n--- 2.3 空安全四件套 ---');
  String? nickname = fetchNullableName();

  // 1. 安全调用 ?.：为 null 则短路返回 null
  print('nickname?.length = ${nickname?.length}');

  // 2. 空默认值 ??：为 null 时用右侧兜底
  print('nickname ?? "未填写" = ${nickname ?? '未填写'}');

  nickname = 'hu';
  // 赋值非空后发生类型提升，可当作非空 String 直接使用
  print('nickname.length = ${nickname.length}');

  // 3. 空断言 !：仅用于"确定非空但编译器无法证明"的场景；
  //    若实际为 null，运行时抛出 "Null check operator used on a null value"
  final fixed = fetchNullableName(give: 'hu');
  print('fixed!.length = ${fixed!.length}');

  // 4. late：延迟初始化，承诺使用前必赋值
  late String token;
  token = 'abc123';
  print('late token = $token');
}
