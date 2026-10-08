# TraeCode 对拍练习记录（第一轮）

范围指定：空安全、命名参数、整除。共 5 题"预测输出"。
流程：TraeCode 出题 → 本人手写答案 → TraeCode 生成参考答案与讲解 → 逐题复核。

---

## 第 1 题（空安全·安全调用与空默认）

```dart
void main() {
  String? a;
  String? b = 'abc';
  print(a?.length);
  print(b?.length);
  print(a ?? b ?? 'empty');
}
```

**本人手写答案**：`null` / `3` / `abc`
**AI 参考答案**：`null` / `3` / `abc`
**讲解**：`?.` 遇 null 短路返回 null；`??` 左结合，`a` 为 null 取 `b`，`b` 非 null 即为 `'abc'`。
**复核**：一致，无分歧。

---

## 第 2 题（整除·负数方向）

```dart
void main() {
  print(7 ~/ 2);
  print(-7 ~/ 2);
  print(7 / 2);
}
```

**本人手写答案**：`3` / `-4` / `3.5`
**AI 参考答案**：`3` / `-3` / `3.5`
**讲解**：`~/` 是**向零取整**（截断），不是向下取整。`-7 ~/ 2 = -3`（不是数学下取整的 -4）；`/` 结果恒为 double。
**复核**：**有分歧**。本人按数学 floor 语义误答 -4。已在仓库 `research` 探针实测验证：`dart run` 输出确为 `-3`。教训：`~/` 等价于 `(a / b).truncate()`。

---

## 第 3 题（命名参数·required 与默认值）

```dart
void show({required String name, int age = 18, String? tag}) {
  print('$name-$age-${tag ?? 'none'}');
}
void main() {
  show(age: 20, name: 'Li');
  show(name: 'Hu');
}
```

**本人手写答案**：`Li-20-none` / `Hu-18-none`
**AI 参考答案**：`Li-20-none` / `Hu-18-none`
**讲解**：命名参数传参顺序无关；`required` 只要求必传，不影响默认值机制；可空参数缺省为 null，配合 `??` 兜底。
**复核**：一致，无分歧。

---

## 第 4 题（空安全·late 延迟初始化）

```dart
void main() {
  late String token;
  if (DateTime.now().year == 0) token = 'x'; // 实际不执行
  try {
    print(token.length);
  } catch (e) {
    print(e.runtimeType);
  }
}
```

**本人手写答案**：输出 `LateInitializationError`
**AI 参考答案**：输出 `LateError`
**讲解**：late 变量使用前未赋值抛 late 错误；其**运行时类型的 toString/打印名在 Dart 3 中为 `LateError`**（`LateInitializationError` 是早期叫法/常见表述，实测 `e.runtimeType` 打印为 `LateError`）。另注意：若编译器能静态断定"明确未赋值"（如无干扰的直白代码），直接在**编译期**报错 `Late variable without initializer is definitely unassigned`，根本运行不到 catch。
**复核**：**有分歧**。本人按指南表述答 `LateInitializationError`，实测输出 `LateError`。已用探针程序验证两种情形（编译期报错 vs 运行期 LateError），指南说法需在 Dart 3.13 下修正。

---

## 第 5 题（整除与类型推断综合）

```dart
void main() {
  var a = 10;
  var b = 3;
  var c = a ~/ b;
  var d = a / b;
  print(c.runtimeType);
  print(d.runtimeType);
  print('${c + 0.5}');
}
```

**本人手写答案**：`int` / `double` / `3.5`
**AI 参考答案**：`int` / `double` / `3.5`
**讲解**：`~/` 返回 int，`/` 返回 double；`var` 推断遵循表达式类型；字符串插值中 `c + 0.5` 是 int + double = double。
**复核**：一致，无分歧。

---

## 对拍小结

| 题号 | 知识点 | 是否一致 | 备注 |
|------|--------|----------|------|
| 1 | 空安全 ?. / ?? | 一致 | |
| 2 | 整除负数方向 | **分歧** | `~/` 向零取整，非 floor |
| 3 | 命名参数 | 一致 | |
| 4 | late 错误类型 | **分歧** | Dart 3 实测为 `LateError` |
| 5 | 类型推断 | 一致 | |

5 题中 2 题有分歧，均已通过探针程序实测复核确认，分歧点与修正结论已记入进度报告。
