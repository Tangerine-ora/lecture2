// 独立研究1：const 与 final 差异实验
//
// 【实验设计】分别尝试用 final 与 const 接收 DateTime.now()（运行时值）。
//
// 【实验记录】
// final now = DateTime.now();  // OK：final 只要求"赋值一次"，运行时确定即可
// const now = DateTime.now();  // 编译错误，dart analyze 实测报错：
//   error - Const variables must be initialized with a constant value.
//           Try changing the initializer to be a constant expression.
//           - const_initialized_with_non_constant_value
//   error - The constructor being called isn't a const constructor.
//           Try removing 'const' from the constructor invocation.
//           - const_with_non_const
//
// 【结论】
// const 是编译期常量：初始值必须在编译期就能确定（字面量、const 构造、
// 常量表达式），DateTime.now() 取当前时间属于运行时行为，故双重报错——
// 既非"常量表达式"，DateTime 也没有 const 构造函数。
// final 只约束"只能赋值一次"，允许接收运行时才确定的值。
// 选型口诀：编译期已知的用 const；运行时才确定但不再变的用 final。

void main() {
  final now = DateTime.now(); // 运行时确定一次，合法
  const pi = 3.14159; // 编译期常量，合法
  const list = [1, 2, 3]; // const 集合：编译期确定，深度不可变

  print('final now  = $now');
  print('const pi   = $pi');
  print('const list = $list');

  // 对比：final 引用可变对象时，对象内部仍可修改（仅引用不可变）
  final mutableList = [1, 2, 3];
  mutableList.add(4); // OK：final 管的是"不能换指向"，不是"内容不能改"
  print('final list 内容可改: $mutableList');
  // list.add(4); // 若取消注释：编译错误，const 集合内容也不可变
}
