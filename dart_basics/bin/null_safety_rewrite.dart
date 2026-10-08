// 自主实践任务1：空安全改写
// 给定含隐患的可空代码（改写前，注释形式保留），改写为安全版本并逐处解释。

/*
 * ========== 改写前：含隐患版本 ==========
 * 这段代码有多处空安全隐患，直接运行会抛运行时错误。
 *
 * String? userName;
 * int? score;
 * String? email;
 *
 * void printReport() {
 *   // 隐患1：对可能为 null 的变量直接用 ! 断言，userName 未赋值必崩
 *   print('姓名：${userName!.toUpperCase()}');
 *
 *   // 隐患2：对可空 int 直接参与算术运算，score 为 null 时编译即报错
 *   // 若绕开编译（如用 !），score! 为 null 则运行时抛错
 *   print('加分后：${score! + 10}');
 *
 *   // 隐患3：late 变量使用前未赋值，触发 LateInitializationError
 *   late String teacher;
 *   print('教师：$teacher');
 *
 *   // 隐患4：链式访问未做安全调用，email 为 null 时崩
 *   print('邮箱长度：${email.length}');
 * }
 */

/// 空安全改写演示：对照上方隐患版本逐处给出安全写法。
/// 三个可空参数模拟来源不可控的数据（如网络/表单返回），
/// 编译器无法在调用点静态确定其取值，判空与安全调用均为必要操作。
void nullSafetyRewriteDemo(String? userName, int? score, String? email) {
  print('--- 实践1 空安全改写（安全版本） ---');

  // 隐患1 改写：先判空再使用；为 null 时给兜底文案。
  // 解释：空断言 ! 在值为 null 时抛 "Null check operator used on a null value"，
  //       只有能确定非空时才允许使用。这里无法确定，故改为条件判断。
  //       判空后局部变量发生类型提升，可直接当非空 String 使用。
  if (userName != null) {
    print('姓名：${userName.toUpperCase()}');
  } else {
    print('姓名：未填写');
  }

  // 隐患2 改写：用 ?? 提供默认值 0 再运算。
  // 解释：可空 int 不能直接 +，需先转为非空。?? 在左侧为 null 时取右侧，
  //       保证参与运算的一定是非空 int，彻底消除隐患。
  final safeScore = score ?? 0;
  print('加分后：${safeScore + 10}');

  // 隐患3 改写：late 变量使用前必须先赋值；或在声明处直接给初始值。
  // 解释：late 是"承诺使用前必赋值"的契约，违约抛 LateInitializationError。
  //       最稳妥的写法是声明时就初始化；若确需延迟，则保证所有路径都赋值。
  late String teacher;
  teacher = '张老师'; // 使用前完成赋值
  print('教师：$teacher');

  // 隐患4 改写：链式访问改用安全调用 ?.，长度未知时用 ?? 兜底。
  // 解释：?. 在左侧为 null 时整条链路短路返回 null，不会抛错；
  //       配合 ?? 把 null 结果转为可展示的 0。
  print('邮箱长度：${email?.length ?? 0}');
}
