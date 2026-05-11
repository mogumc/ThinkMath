# 工具保障层

## 层级概述
本层级负责保障工具调用可靠性，并在工具调用失败时提供重试和降级机制，确保任务链的连续性和稳定性。

## 1. 核心准则
- **可靠优先**：工具调用失败不应导致整个任务链断裂，必须提供重试或降级路径
- **响应必校**：每次工具调用返回后必须校验响应有效性，不合格则重试而非直接接受
- **拒绝空响应**：当工具返回空内容或不合格结果时，必须重新思考并重试，禁止将空/无效结果原样返回给用户
- **退避有界**：所有重试必须有硬性次数上限和总耗时上限，防止无限循环

## 2. 工具调用全流程

### 2.1 执行前准备

在发起任何工具调用之前，必须完成以下步骤：

- [ ] 明确本次调用的**目的与预期输出格式**——你需要从这次工具调用中获得什么信息？
- [ ] 构造完整的**请求参数**，确保参数完整且语义正确
- [ ] 判断当前工具的**幂等性分类**：
  - 自然幂等（读取/查询类）：无条件可重试
  - 条件幂等（写入类）：必须携带幂等标识
  - 非幂等（创建类）：重试前需先查询确认未重复执行
- [ ] 确定该工具的**备选降级方案**（如果有其他 Agent 可完成相同任务）

### 2.2 发起调用与响应校验

```text
步骤 1：向目标 Agent 工具发起调用，附带明确的参数和预期格式要求
    ↓
步骤 2：等待工具返回响应
    ↓
步骤 3：执行响应校验（必须执行）
    ├── 校验 A — 结构完整性：返回值是否存在？结构是否符合预期？
    ├── 校验 B — 内容有效性：数据是否有意义？是否包含实际内容？
    └── 校验 C — 语义正确性：返回结果是否回答了你的问题？
    ↓
步骤 4：根据校验结果决策
```

### 2.3 响应校验标准

| 校验项 | 合格标准 | 不合格判定 |
|:---|:---|:---|
| 结构完整性 | 返回非 null / 非 undefined / 非 Error 对象 | 返回 `null`、`undefined`、错误对象、异常 |
| 内容有效性 | 包含实质性的数据或文本，非空字符串、非空数组 | 返回空字符串 `""`、空数组 `[]`、占位符文本 |
| 语义正确性 | 结果与调用意图匹配，能用于后续推理 | 返回"无结果"、"未找到"、与请求无关的内容 |
| 格式一致性 | 数据格式与工具文档声明的 schema 一致 | 字段缺失、类型错乱、编码异常 |

**任何一项校验不通过 → 视为响应不合格 → 进入重试/降级流程**

## 3. 失败分类与处理策略

### 3.1 错误类型定义

| 错误码 | 场景示例 | 处理策略 |
|:---|:---|:---|
| `TIMEOUT` | 工具调用超时未响应 | 退避重试 |
| `RATE_LIMITED` | Agent 被限流，返回 429 或类似提示 | 延长间隔后重试 |
| `SERVICE_UNAVAILABLE` | 目标 Agent 不可用 / 服务异常 | **Agent 降级**：切换到备选 Agent 执行相同任务 |
| `NETWORK_ERROR` | 网络连接中断、DNS 解析失败 | 退避重试 |
| `INVALID_PARAMS` | 参数格式错误、缺少必要字段 | **快速终止**：修正参数后重新调用（不消耗重试次数） |
| `PERMISSION_DENIED` | 权限不足、访问被拒绝 | **快速终止**：报告用户，请求授权 |
| `EMPTY_RESPONSE` | 工具返回了空内容或无效响应 | 退避重试（最多 2 次），仍为空则切换策略 |
| `UNKNOWN` | 无法归类的未知错误 | 保守策略：退避重试 |

### 3.2 三种核心处理策略

#### 策略一：退避重试（Backoff Retry）

**适用场景**：瞬时错误（TIMEOUT / RATE_LIMITED / NETWORK_ERROR / EMPTY_RESPONSE / UNKNOWN）

**规则**：
- 最大重试次数：**3 次**
- 退避公式：`delay = min(1000ms × 2^attempt, 10000ms)`
- 每次重试前必须**调整请求方式**（如换一种参数表达、简化请求、补充上下文），不能完全重复相同调用
- 重试期间记录日志：尝试编号、错误码、耗时、调整措施

```
第 1 次重试：等待 1 秒，微调参数或补充上下文后重试
第 2 次重试：等待 2 秒，换一种提问方式或拆分请求后重试
第 3 次重试：等待 4 秒，使用最简化的请求形式最后尝试一次
超过 3 次 → 转入 Agent 降级或终止报错
```

#### 策略二：Agent 降级（Agent Fallback）

**适用场景**：SERVICE_UNAVAILABLE / 重试耗尽后的兜底

**规则**：
- 维护每类任务的 **Agent 优先级列表**（按能力匹配度排序）
- 当前 Agent 失败时，按优先级列表顺序切换到下一个 Agent
- 降级是**路径切换**，不是重复尝试——不计入重试计数
- 降级成功后记录可用性数据，后续同类型任务可优先使用成功的 Agent
- 所有备选 Agent 均失败 → 终止并报告详细原因

```
示例：代码搜索任务
  优选 Agent: code-explorer → 失败？
    ↓ 降级
  备选 Agent: 直接 search_content + read_file 组合 → 失败？
    ↓ 降级
  兜底: list_files + 手动遍历 → 全部失败？
    ↓ 终止
  报告用户：所有搜索路径均不可用，附具体错误链
```

#### 策略三：快速终止（Fast Fail）

**适用场景**：INVALID_PARAMS / PERMISSION_DENIED / 确认不可恢复的错误

**规则**：
- 不消耗重试配额
- 立即停止当前工具调用
- 向用户明确报告错误原因和修复建议
- 如果是参数问题，修正参数后可重新发起全新调用

## 4. 响应不合格时的行为规范

这是 ToolGuard 最关键的约束——**绝对禁止静默接受不合格响应**。

### 4.1 空响应处理

当工具返回空内容时：

```
❌ 禁止做法：
   - 将空字符串原样返回给用户
   - 输出"没有找到相关内容"后结束
   - 用猜测或编造的内容填充空位
   - 跳过当前步骤继续后续流程

✅ 正确做法：
   - 记录空响应事件（工具名、参数、时间戳）
   - 分析空响应的可能原因（参数不对？路径不存在？权限不足？）
   - 调整策略后重试（换参数、换路径、换工具）
   - 连续 2 次空响应后考虑降级到其他工具
   - 所有手段耗尽后，明确告知用户遇到了什么问题以及你做了哪些尝试
```

### 4.2 内容不合格处理

当工具返回的内容不符合预期时：

```
❌ 禁止做法：
   - 将不合格结果包装后输出给用户
   - 用"可能是因为..."之类的模糊表述掩盖问题
   - 自行编造合理的数据填充缺口

✅ 正确做法：
   - 明确指出哪里不合格（缺字段？类型错？内容无关？）
   - 基于已返回的部分信息判断是否可以再次请求补全
   - 用更精确的参数或更窄的范围重新发起调用
   - 若多次仍不合格，切换到备选工具或 Agent
   - 最终无法获取有效数据时，如实告知用户限制所在
```

### 4.3 重新思考机制（Rethink）

当检测到以下任一信号时，触发**重新思考**：

| 触发信号 | 行动 |
|:---|:---|
| 连续 2 次同一工具返回空/无效响应 | 暂停，分析原因，更换调用策略 |
| 返回内容与请求意图完全不相关 | 检查参数传递是否被误解，重新构造请求 |
| 工具抛出未预期的错误格式 | 查阅工具文档确认正确用法后再尝试 |
| 降级到新 Agent 后首次调用失败 | 回顾之前的失败模式，避免在新 Agent 上重复 |

**重新思考不是简单重试——它要求 AI 检视已有失败记录，调整策略后再行动。**

## 5. 执行伪代码（AI 必须模拟执行的流程）

```text
FUNCTION executeToolWithGuard(toolName, params, expectedFormat):
    context = RetryContext(attempt=0, triedAgents=[], errors=[])

    WHILE true:
        // 步骤 1：选择执行 Agent
        agent = selectAgent(toolName, context.triedAgents)
        IF agent == NULL:
            RETURN 终止报告(ALL_AGENTS_EXHAUSTED, context.errors)

        // 步骤 2：发起调用
        result = agent.call(toolName, params)

        // 步骤 3：响应校验
        IF result.success AND validateResponse(result.data, expectedFormat):
            RETURN result  // 成功且合格 → 返回

        // 步骤 4：错误分类
        error = classifyError(result)

        IF error.code IN [INVALID_PARAMS, PERMISSION_DENIED]:
            RETURN 快速终止(error)  // 不可恢复错误

        IF error.code == SERVICE_UNAVAILABLE:
            context.triedAgents.append(agent.name)
            context.errors.append(error)
            CONTINUE  // Agent 降级，重置重试计数
        END IF

        IF error.code IN [TIMEOUT, RATE_LIMITED, NETWORK_ERROR, EMPTY_RESPONSE, UNKNOWN]:
            IF context.attempt < 3:
                context.attempt += 1
                delay = min(1000 * 2^context.attempt, 10000)
                params = adjustStrategy(params, context.attempt, error)  // 关键：调整策略！
                sleep(delay)
                CONTINUE  // 退避重试
            ELSE:
                // 重试耗尽 → 尝试 Agent 降级
                context.triedAgents.append(agent.name)
                context.attempt = 0  // 降级到新 Agent 时重置
                CONTINUE
            END IF
        END IF

        // 安全兜底：不应到达此处
        RETURN 终止报告(UNEXPECTED_STATE, context.errors)
    END WHILE
END FUNCTION
```

## 6. 日志与诊断要求

每次工具调用（含重试和降级）必须隐式维护以下信息：

| 记录项 | 说明 |
|:---|:---|
| 工具名称 | 被调用的工具标识 |
| 目标 Agent | 执行该工具的 Agent 名称 |
| 请求摘要 | 参数的关键信息（脱敏） |
| 响应状态 | 成功 / 失败（含错误码） |
| 尝试序号 | 第几次尝试（初始=0） |
| 总耗时 | 从首次调用到最终结果的累计耗时 |
| 策略调整 | 重试时做了什么调整（如"换用了相对路径""补充了 fileTypes 参数"） |

当最终向用户报告结果时，如果经历了重试或降级，应在响应末尾附加简要说明：

```
【ToolGuard 日志】工具 read_file 经历 2 次重试后成功（首超时，次路径调整）
```

## 7. 与路由系统的集成关系

ToolGuard 是**透明中间层**，位于路由决策之后、层文件执行过程之中：

```
用户请求
  → 路由决策（SKILL.md 四、确定加载哪个层文件）
  → 加载对应层规范（architecture / implementation / review / iteration）
  → 按 Layer 规范执行任务
     → 过程中需要调用工具（rw / fetch / task / search ...）
        → 【ToolGuard 介入】→ 重试 / 降级 / 校验 → 返回有效结果
     → 继续执行层规范要求的后续步骤
  → 向用户输出最终结果
```

**关键原则：ToolGuard 不改变路由决策逻辑，不替代四层规范，仅在工具调用环节提供可靠性保障。**

## 8. 特殊工具类型的降级映射表

| 主工具 | 降级备选 1 | 降级备选 2 | 降级条件 |
|:---|:---|:---|:---|
| `task(code-explorer)` | 直接用 `search_content` + `read_file` 组合 | `list_files` + 手动筛选 | code-explorer 无响应或超时 |
| `web_fetch` | 使用 `search_content` 搜索本地缓存 | 报告用户手动提供内容 | URL 不可达或返回异常 |
| `execute_command` | 改用 `write_to_file` + 手工指导 | 提供命令让用户自行执行 | 命令执行环境不可用 |
| `search_file` | `list_files` + 逐目录扫描 | `task(code-explorer)` 广度搜索 | 搜索模式过于复杂导致超时 |
| `read_file` | 尝试用 `search_content` 定位关键行 | 请求用户提供文件片段 | 文件过大或编码异常 |

---