---
name: thinkmath
description: 数学建模全链路自动化执行skill，支持从问题输入到最终论文输出的完整闭环。当用户需要解决数学建模问题、生成Python求解代码、创建可视化图表或生成标准数学建模论文时使用此skill。
version: "2.1"
---

# ThinkMath Skill 执行规范

## 一、触发条件

当用户输入满足以下任一条件时激活本 Skill：
- 用户明确要求"数学建模"、"建模论文"、"数学建模竞赛"
- 用户提供了一个数学优化/评价/预测/统计类问题，并期望完整解答
- 用户要求使用 cumcmthesis 模板生成论文
- 用户要求生成数学模型的 Python 求解代码

## 二、环境依赖

执行前确认以下环境就绪：
- **Python 3.x**：用于求解代码运行和数据处理
- **XeLaTeX**：用于论文编译（推荐 TLaTeX 发行版）
- **必要 Python 库**：numpy, pandas, scipy, matplotlib 等（按需安装）

如环境缺失，在题目解析层输出提示，由用户确认后继续。

## 三、工作目录结构

```
{用户指定的项目目录}/
├── problem_data.json            # 题目数据记忆（题目解析层生成）
├── analysis_report.md           # 解析报告（题目解析层生成）
├── original_problem.txt         # 原始问题文本
├── question1/                   # 问题1解答目录
│   ├── solution1.py            # 求解代码
│   ├── result1.json            # 求解结果
│   ├── data1.csv               # 问题数据（如有）
│   └── log1.txt                # 运行日志
├── question2/                   # 问题2解答目录
│   └── ...
├── validation_report.md         # 数据验证报告（数据分析层生成）
├── figures/                     # 可视化图表目录（数据可视化层生成）
├── figure_scripts/              # 图表生成脚本
├── paper/                       # 论文工作目录（论文编写层生成）
│   ├── paper.tex
│   ├── reference.bib
│   ├── cumcmthesis.cls
│   └── figures/
└── check_report.md              # 论文检查报告（论文检查层生成）
```

## 四、层级执行流程

> **核心原则**：按层级顺序严格依次执行，每完成一层输出状态标记。

### 工具保障层（贯穿全程）
> 额外层级，不参与主流程，在工具调用失败时介入保障任务链连续性。
- **触发条件**：使用 Agent 工具（task、web_fetch、search_content 等）时自动介入
- **必须读取**：`tools/tool_guard.md`
- **执行内容**：执行前准备 → 响应校验 → 失败分类 → 重试/降级
- **状态输出**：`【工具保障层介入】`

### 第 1 层：题目解析层
- **必须读取**：`references/problem_parsing.md`
- **输入**：用户提供的数学建模问题文本
- **输出**：`problem_data.json` + `analysis_report.md` + `original_problem.txt`
- **核心任务**：问题重述 → 约束条件提取 → 决策变量识别 → 目标函数确定 → 代码建模需求评估 → 问题分类 → 创建题目数据记忆 → 验证解析结果
- **代码评估**：在本层即判断 `code_complexity_level`（none/simple/complex），为论文附录是否插入代码提供依据
- **状态输出**：`【当前执行层级：题目解析层】`

### 第 2 层：题目解答层
- **必须读取**：`references/problem_solving.md` + `tools/model_library.md`
- **输入**：`problem_data.json`
- **输出**：`question{N}/solution{N}.py` + `result{N}.json` + `log{N}.txt`
- **核心任务**：按题目顺序逐题解答，每题创建独立工作目录，独立运行求解，保存结果
- **状态输出**：`【当前执行层级：题目解答层】`

### 第 3 层：数据分析层
- **必须读取**：`references/data_analysis.md`
- **输入**：所有 `result{N}.json`
- **输出**：`validation_report.md` + `consistency_check.json` + `anomaly_detection.json`
- **核心任务**：跨问题一致性检查 → 合理性分析 → 异常识别 → 通过或打回
- **打回机制**：数据异常 → 生成重做指令 → 返回第 2 层重新解答对应问题
- **状态输出**：`【当前执行层级：数据分析层】`

### 第 4 层：数据可视化层
- **必须读取**：`references/data_visualization.md`
- **输入**：验证后的数据文件
- **输出**：`figures/` 目录下的图表文件 + `figure_scripts/` 目录下的独立脚本
- **核心任务**：确定可视化需求 → 选择图表类型 → 生成独立代码 → 验证图表质量
- **关键约束**：生图代码与数据处理解耦，图表宽度 ≤16cm，分辨率 ≥300DPI
- **状态输出**：`【当前执行层级：数据可视化层】`

### 第 5 层：论文编写层
- **必须读取**：`references/paper_writing.md` + `tools/cumcmthesis_usage.md`
- **输入**：解答结果 + 数据分析报告 + 可视化图表 + `problem_data.json`（读取 `code_complexity_level`）
- **输出**：`paper/paper.tex` + `paper/reference.bib` + `paper/cumcmthesis.cls`
- **核心任务**：按标准章节结构编写论文（摘要→问题重述→问题分析→模型假设→符号说明→模型建立→模型求解→结果分析→模型评价→参考文献→附录）
- **附录条件**：根据 `code_complexity_level` 决定是否插入代码附录（none/simple→不插入，complex→必须插入关键代码）
- **编译流程**：`xelatex` → `biber` → `xelatex` → `xelatex`（共三次编译）
- **状态输出**：`【当前执行层级：论文编写层】`

### 第 6 层：论文检查层
- **必须读取**：`references/paper_checking.md`
- **输入**：`paper/paper.tex` + 编译日志
- **输出**：`check_report.md`
- **核心任务**：排版检查 → 内容检查 → 编译日志分析 → 生成检查报告 → 提供编译指导
- **用户交互**：用户提供编译后的 PDF 和日志，由本层检查并反馈
- **状态输出**：`【当前执行层级：论文检查层】`

## 五、数据流转协议

```
用户输入问题
    │
    ▼
【第1层】题目解析层 ──→ problem_data.json
    │
    ▼
【第2层】题目解答层 ──→ result{N}.json
    │
    ▼
【第3层】数据分析层 ──→ validation_report.md
    │                      │
    │                      ├── 通过 → 继续
    │                      └── 异常 → 打回第2层重做
    │
    ▼
【第4层】数据可视化层 ──→ figures/ + figure_scripts/
    │
    ▼
【第5层】论文编写层 ──→ paper/paper.tex
    │
    ▼
【第6层】论文检查层 ──→ check_report.md → 用户确认
```

## 六、异常恢复机制

| 异常场景 | 处理策略 |
|:---|:---|
| 题目解析信息不完整 | 提示用户补充缺失信息，暂停解析层 |
| 解答代码执行失败 | 记录错误日志，尝试修复代码，最多重试 3 次 |
| 数据分析发现异常 | 生成修正指令，返回第 2 层重新解答对应问题 |
| 图表生成失败 | 记录错误，尝试调整参数重新生成 |
| LaTeX 编译错误 | 分析日志，提供具体修复建议，由用户手动编译 |
| 参考文献缺失 | 标记缺失项，不杜撰，论文中删除对应引用 |

## 七、核心设计原则

1. **独立性原则**：每个问题独立解答，代码和目录互不干扰，禁止串题
2. **层级隔离原则**：每个层级只读取对应规范文件，禁止跨层读取执行
3. **质量控制原则**：数据异常必须打回重做，论文检查必须用户确认
4. **可追溯原则**：所有中间结果、日志、决策记录必须持久化保存
5. **用户确认原则**：关键节点（题目解析确认、数据分析通过、论文检查通过）需用户明确确认后方可进入下一阶段
