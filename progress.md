# 进度报告2（第4周·Dart语言基础一）

## 一、任务理解

本次作业要完成两件事：

1. **课堂案例复现**：用 `dart create` 搭建纯 Dart 工程 dart_basics，按指南填充变量/类型/空安全、函数/命名参数、运算符/控制流三组示例，`dart run` 全部输出正确且无编译告警，并按步骤做规范 Git 提交。
2. **自主实践五项**：空安全改写（含隐患代码→安全版本+逐处解释）、为"实验报告生成器"设计命名参数函数并给出三种调用、成绩分级器扩展（边界 100/0 与非法输入）、与 TraeCode 完成一轮"出题-作答-批改-复核"对拍（5 题，范围：空安全/命名参数/整除）、全程标注 AI 使用。选做：const/final 差异实验、类型提升验证、dart format diff。

**验收标准**：`dart run` 输出正确、`dart analyze` 无告警、空安全改写逐处有解释、Git 至少 3 次规范提交、对拍分歧记入报告、报告十节完整。

## 二、环境与工具

- OS：Windows 11（x64）
- Dart SDK：3.13.3 (stable)
- 编辑器/AI IDE：TraeCode（内置 AI 助手）
- 版本控制：git 2.55.0，远程仓库 github.com/Tangerine-ora/lecture2
- 运行目标：命令行（纯 Dart 虚拟机，本课无 Web/模拟器/真机）
- AI 工具：TraeCode AI（模型 Kimi-K3），用于出题、批改、答疑

## 三、过程记录

1. `git clone` 空仓库 lecture2，`dart create dart_basics` 建工程（首次 `dart pub get` 因沙箱限制失败，放开后成功，48 个依赖）。
2. 提交一：`feat: dart create dart_basics`。
3. 在 bin/ 下新建 types_demo.dart / func_demo.dart / flow_demo.dart，改写入口 dart_basics.dart 统一调用；追加自主实践三文件 null_safety_rewrite.dart / report_generator.dart / extended_grader.dart。
4. `dart run` 首轮通过，但 `dart analyze` 报 4 个告警（死代码、不必要的 `!`）——定位后修复（详见第六节），修复后 analyze 全绿。
5. 提交二：`feat: types/func/flow demos all pass`。
6. 完成三个选做研究并实测：const 接 `DateTime.now()` 捕获真实编译错误；类型提升四组实验；故意写乱文件后 `dart format` 生成 diff。对应提交：`test: research experiments` + `style: dart format practice diff applied`。
7. 与 TraeCode 对拍 5 题，先手写答案再对答案，2 题分歧写探针程序实测复核，记录入 quiz_records.md，提交 `docs: ai quiz round 1 records`。
8. 填写本报告。

## 四、关键代码

### 1. 空安全四件套（types_demo.dart，AI 辅助生成，人工验证）

```dart
String? nickname = fetchNullableName();
print('nickname?.length = ${nickname?.length}');      // 安全调用：null 短路
print('nickname ?? "未填写" = ${nickname ?? '未填写'}'); // 空默认兜底
nickname = 'hu';
print('nickname.length = ${nickname.length}');         // 赋值后类型提升，直接用
final fixed = fetchNullableName(give: 'hu');
print('fixed!.length = ${fixed!.length}');             // 空断言：编译器无法证明时用
late String token;
token = 'abc123';                                      // late：先用后声明的契约
print('late token = $token');
```

逐行解释：`?.` 左侧为 null 整链短路返回 null；`??` 左侧为 null 取右侧；类型提升后可直接访问非空成员；`!` 断言非 null（为 null 则运行时抛错，慎用）；`late` 承诺使用前必赋值。**验证方式**：`dart run` 输出与预期逐行比对一致。

> 说明：最初版本用局部 `String? nickname;` 直接演示，被分析器判出 dead_code 告警（编译器能静态断定其恒为 null）。改为经函数返回值模拟"来源不可控"的数据后，告警消除且语义更真实。

### 2. 空安全改写前后对照（null_safety_rewrite.dart）

```dart
// 改写前（隐患）：可空变量直接断言/运算
// print('姓名：${userName!.toUpperCase()}');  // userName 为 null 必崩
// print('加分后：${score! + 10}');            // 可空 int 不能直接 +
// late String teacher; print(teacher);        // LateError
// print(email.length);                        // 可空对象直接访问

// 改写后（安全）：
if (userName != null) {
  print('姓名：${userName.toUpperCase()}'); // 判空后类型提升
} else {
  print('姓名：未填写');
}
final safeScore = score ?? 0;               // ?? 转非空再运算
print('加分后：${safeScore + 10}');
late String teacher;
teacher = '张老师';                          // late 使用前必赋值
print('教师：$teacher');
print('邮箱长度：${email?.length ?? 0}');    // ?. + ?? 组合兜底
```

解释：`!` 只在"确定非空但编译器无法证明"时使用；无法确定时必须判空或给默认值。**验证方式**：传全 null 与正常数据各跑一遍，输出分别为"未填写/10/张老师/0"与"HU/95/张老师/14"，符合预期。

### 3. 命名参数设计：实验报告生成器（report_generator.dart）

```dart
String generateLabReport({
  required String title,       // 必填：实验标题
  required String studentName, // 必填：实验者
  int expNo = 1,               // 默认值：编号
  DateTime? date,              // 可空：缺省取今天
  String? teacher,             // 可空：可缺省信息
  bool withConclusion = true,  // 默认值：是否含结论
  String? remark,              // 可空：备注
}) { /* ... */ }

// 三种调用：
generateLabReport(title: 'LED 点亮实验', studentName: '李华');           // 仅必填
generateLabReport(title: '按键中断实验', studentName: '王五',
    expNo: 3, date: DateTime(2026, 10, 8));                              // 部分指定
generateLabReport(title: '串口通信实验', studentName: '张三', expNo: 5,
    date: DateTime(2026, 10, 1), teacher: '陈老师',
    withConclusion: false, remark: '数据有少量丢包，需复测');              // 全量指定
```

设计思路：必填用 required（编译期防漏传）、有合理默认值的给默认值、可缺省信息用可空类型——即 Flutter 组件构造函数的统一风格。**验证方式**：三种调用输出报告字段与传参一一对应。

## 五、检查点结果

- `dart run`：全部输出正确（变量/插值/空安全四件套、函数与命名参数、`/`vs`~/`、分级器、for-in、三项自主实践），实测输出已逐行核对。
- `dart analyze`：**No issues found!**（修复首轮 4 个告警后全绿）。
- 空安全改写练习：通过，两处输入组合（全 null / 正常值）均输出正确。
- 口头解释 `??` 与 `!` 的区别：`??` 是**空值合并**——左侧为 null 时取右侧兜底，永不抛错；`!` 是**空断言**——向编译器承诺非 null，若违约运行时才抛 "Null check operator used on a null value"。前者防御、后者断言，能防御就不用断言。

证据：见第八节截图（dart run 完整输出、dart analyze 全绿、git log）。

## 六、问题与调试

**问题1（真实记录）**：`dart analyze` 报 4 个告警——`unnecessary_null_comparison`、`dead_code`、`unnecessary_non_null_assertion`。

- 定位：告警集中在空安全演示段。原因是局部变量 `String? nickname;` 声明后编译器能静态断定其恒为 null，判空和 `??` 的右分支成了"死代码"；赋值 `'hu'` 后又能断定非空，`!` 成了多余。
- 解决：把"可空数据来源"改为函数返回值/参数（模拟网络、表单等编译器看不透的来源），判空与安全调用恢复必要语义，告警全消。
- 收获：这条路径反而加深了对**类型提升适用边界**的理解——编译器只在"无法静态确定"时才需要运行时判空。

**问题2**：探究 late 未赋值行为时，直白写法 `late String t; print(t);` 直接编译报错 `definitely unassigned`，根本到不了运行时。

- 解决：加恒假条件绕过编译期赋值分析后，实测运行时错误类型打印为 `LateError`（指南表述的 `LateInitializationError` 在 Dart 3.13 下需修正），该分歧已记入对拍记录第 4 题。

## 七、AI 使用记录

| 用途 | 指令摘要 | AI 输出 | 本人验证方式 |
|------|----------|---------|--------------|
| 生成示例骨架 | "按指南二章写 types/func/flow 三组 demo" | 三组 dart 文件初稿 | `dart run` + `dart analyze` 逐行核对输出 |
| 出题（对拍） | "出 5 道预测输出题，范围：空安全、命名参数、整除" | 5 道题目 | 先手写答案再比对 |
| 批改与讲解 | "给出参考答案与逐题讲解" | 参考答案+讲解 | 分歧题写探针程序实测（第 2、4 题） |
| 答疑 | "为什么局部可空变量判空告警 dead_code" | 解释静态确定与类型提升边界 | 改代码复验告警消除 |
| 空安全改写参考 | "给出含隐患代码的安全改写并解释" | 改写版本+逐处解释 | 两组输入实测输出正确 |

**分歧复核结论**：第 2 题 `~/` 为向零取整（`-7 ~/ 2 = -3`，非 floor 的 -4）；第 4 题 late 未赋值运行时错误类型实测为 `LateError`。两题均以探针实测为准修正。

## 八、证据截图

1. `dart run` 完整输出截图——三组示例 + 三项实践全部正确打印。
2. `dart analyze` 输出 "No issues found!" 截图——无编译告警检查点达成。
3. `git log --oneline` 截图——5 次规范提交（feat×2 / test / style / docs）。
4. const 实验编译错误截图——`const_initialized_with_non_constant_value` 实测报错。
5. `git diff`（dart format 前后）截图——格式化从 8 行乱码到规范缩进的对比。

## 九、自评

| 项目 | 要求 | 完成情况 |
|------|------|----------|
| 案例复现 | dart_basics 完整复现 | ✅ 三组示例+统一入口，输出正确 |
| 检查点 | run 正确 / analyze 无告警 / 空安全改写通过 / 能解释 ?? 与 ! | ✅ 全部达成 |
| Git 规范 | 3 次以上规范提交 | ✅ 5 次（feat/test/style/docs 前缀） |
| 空安全改写 | 安全版本+逐处解释 | ✅ 4 处隐患逐处改写并注释解释 |
| 命名参数设计 | 报告生成器签名+三种调用 | ✅ required/默认值/可空三类全覆盖 |
| 控制流小程序 | 边界 100/0 与非法输入 | ✅ 14 组用例含 NaN/null/越界 |
| 对拍记录 | 5 题+分歧复核 | ✅ 2 题分歧均实测复核 |
| AI 使用标注 | 用途/指令/输出/验证 | ✅ 见第七节表格 |
| 选做研究 | const/final、类型提升、dart format | ✅ 三项均完成并实测 |

## 十、一句话收获与下一步计划

**收获**：Dart 空安全不是"多写几个符号"，而是编译器与你签的契约——`??` 防御、`!` 断言、`late` 承诺，违约的代价从编译期一路排到运行时。

**遗留问题**：类型提升对"被闭包捕获的可空局部变量"的具体规则还没完全摸清；switch 模式匹配只试了最简形式。

**下次预习**：第 3 课集合（List/Map/Set）与回调函数，重点预习 `where`/`map` 链式操作与函数作为参数传递的写法。
