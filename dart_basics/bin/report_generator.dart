// 自主实践任务2：命名参数设计——实验报告生成器
// 为"实验报告生成器"设计函数签名并给出三种调用。

/// 生成一份实验报告。
///
/// 命名参数设计说明：
/// - 必填信息用 required：实验标题 [title]、实验者姓名 [studentName]；
/// - 有合理默认值的给默认值：实验日期 [date] 默认今天（运行时取），
///   实验编号 [expNo] 默认 1，是否含结论 [withConclusion] 默认 true；
/// - 可缺省信息用可空类型：指导教师 [teacher]、备注 [remark]。
///
/// 设计理由：Flutter 组件构造函数统一采用命名参数风格，可读性高，
/// 调用方无需记忆参数顺序；required 保证关键字段不被遗漏（编译期检查），
/// 默认值减少样板代码，可空类型表达"可选"语义。
String generateLabReport({
  required String title,
  required String studentName,
  int expNo = 1,
  DateTime? date,
  String? teacher,
  bool withConclusion = true,
  String? remark,
}) {
  final dateStr = (date ?? DateTime.now()).toString().split(' ').first;
  final buffer = StringBuffer()
    ..writeln('====== 实验报告 ======')
    ..writeln('实验编号：$expNo')
    ..writeln('实验标题：$title')
    ..writeln('实验者：$studentName')
    ..writeln('实验日期：$dateStr')
    ..writeln('指导教师：${teacher ?? '无'}');
  if (withConclusion) {
    buffer.writeln('结论：实验达到预期目标。');
  }
  if (remark != null) {
    buffer.writeln('备注：$remark');
  }
  return buffer.toString();
}

/// 三种调用方式演示
void reportGeneratorDemo() {
  print('--- 实践2 命名参数：实验报告生成器 ---');

  // 调用一：只传必填项，其余全部使用默认值
  print(generateLabReport(
    title: 'LED 点亮实验',
    studentName: '李华',
  ));

  // 调用二：部分指定——覆盖默认编号与日期，省略可空项
  print(generateLabReport(
    title: '按键中断实验',
    studentName: '王五',
    expNo: 3,
    date: DateTime(2026, 10, 8),
  ));

  // 调用三：全量指定——所有参数显式给出
  print(generateLabReport(
    title: '串口通信实验',
    studentName: '张三',
    expNo: 5,
    date: DateTime(2026, 10, 1),
    teacher: '陈老师',
    withConclusion: false,
    remark: '数据有少量丢包，需复测',
  ));
}
