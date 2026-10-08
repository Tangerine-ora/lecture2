// 课堂案例复现：函数声明、箭头函数、命名参数与默认值
// 对应《学生实践指南二》第三章 3.1 ~ 3.2 节

/// 普通函数声明
int add(int a, int b) {
  return a + b;
}

/// 箭头函数：单表达式简写
int add2(int a, int b) => a + b;

/// 命名参数函数：required 必填，其余给默认值或可空
/// 对应指南 3.2 节的 enroll 示例
void enroll({required String name, int age = 18, String? className}) {
  print(
    '报名：姓名=$name，年龄=$age，班级=${className ?? '未分班'}',
  );
}

/// 函数演示入口
void funcDemo() {
  print('--- 3.1 函数与箭头 ---');
  print('add(3, 5) = ${add(3, 5)}');
  print('add2(3, 5) = ${add2(3, 5)}');

  print('\n--- 3.2 命名参数与默认值 ---');
  // 指南示例调用：省略有默认值/可空的参数
  enroll(name: '李华', className: '2班');
  // 省略 className（可空，默认 null）
  enroll(name: '王五');
  // 全部给定
  enroll(name: '张三', age: 20, className: '1班');
}
