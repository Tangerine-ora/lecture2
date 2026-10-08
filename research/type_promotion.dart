// 独立研究2：类型提升（Type Promotion）验证
//
// 【问题】可空变量在 if 判空后能否直接当非空用？
//
// 【结论】分两种情况：
// 1) 局部变量：能。判空（!= null）后 Dart 将其"提升"为非空类型，
//    分支内可直接调用非空成员，无需 ! 或 ?.；
// 2) 顶层变量 / 实例字段（非 private final）：不能提升。
//    因为它们可能被其他代码并发修改，编译器不保证判空后仍然非空，
//    仍需 ! 或先拷贝到局部变量。
//
// 以下代码均可运行验证。

/// 顶层可空变量：不享受类型提升
String? topLevel = 'top';

void main() {
  // --- 实验1：局部变量判空后提升 ---
  String? local = 'dart';
  if (local != null) {
    // 此处 local 已由 String? 提升为 String，直接用 .length 编译通过
    print('实验1 局部提升: length = ${local.length}');
  }

  // --- 实验2：赋值 null 后提升被撤销，需重新判空 ---
  local = null;
  print('实验2 置空后: ${local ?? '已变回 null'}');
  // print(local.length); // 若取消注释：编译错误（可空未判空）

  // --- 实验3：顶层变量不提升 ---
  if (topLevel != null) {
    // print(topLevel.length); // 若取消注释：编译错误
    //  Error: The property 'length' can't be unconditionally accessed
    //  because the receiver can be 'null'.
    // 正确做法1：空断言（确定非空时）
    print('实验3 顶层用 !: length = ${topLevel!.length}');
    // 正确做法2：拷贝到局部变量，拷贝后可提升
    final copy = topLevel;
    if (copy != null) {
      print('实验3 局部拷贝提升: length = ${copy.length}');
    }
  }

  // --- 实验4：switch 模式匹配同样触发提升（Dart 3） ---
  String? maybe = 'pattern';
  switch (maybe) {
    case String s: // 非空匹配，s 直接是 String
      print('实验4 模式匹配: $s (length=${s.length})');
    case null:
      print('实验4 模式匹配: null');
  }
}
