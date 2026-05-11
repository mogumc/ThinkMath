# 数学模型库参考文档

## 1. 优化类模型

### 1.1 线性规划 (Linear Programming)
**适用场景**：目标函数和约束条件都是线性函数
**典型应用**：资源分配、生产计划、运输问题
**Python库**：scipy.optimize.linprog

### 1.2 非线性规划 (Nonlinear Programming)
**适用场景**：目标函数或约束条件包含非线性项
**典型应用**：工程设计、经济模型
**Python库**：scipy.optimize.minimize

### 1.3 整数规划 (Integer Programming)
**适用场景**：决策变量需要取整数值
**典型应用**：调度问题、选址问题
**Python库**：pulp, scipy.optimize.milp

### 1.4 动态规划 (Dynamic Programming)
**适用场景**：多阶段决策过程，具有最优子结构
**典型应用**：最短路径、资源分配、库存管理
**Python库**：自定义实现

### 1.5 遗传算法 (Genetic Algorithm)
**适用场景**：复杂优化问题，传统方法难以求解
**典型应用**：组合优化、参数优化
**Python库**：deap, genetic-algorithm

## 2. 评价类模型

### 2.1 层次分析法 (AHP, Analytic Hierarchy Process)
**适用场景**：多准则决策问题，需要确定权重
**典型应用**：方案选择、绩效评估
**Python库**：ahpy, pyDecision

### 2.2 熵权法 (Entropy Weight Method)
**适用场景**：客观确定指标权重
**典型应用**：综合评价、排序问题
**Python库**：自定义实现

### 2.3 TOPSIS法 (Technique for Order Preference by Similarity to Ideal Solution)
**适用场景**：多属性决策，基于理想解排序
**典型应用**：方案评价、供应商选择
**Python库**：pyDecision, topsis

### 2.4 模糊综合评价 (Fuzzy Comprehensive Evaluation)
**适用场景**：评价指标具有模糊性
**典型应用**：环境评价、质量评估
**Python库**：scikit-fuzzy

## 3. 预测类模型

### 3.1 时间序列分析 (Time Series Analysis)
**适用场景**：基于历史数据预测未来趋势
**典型应用**：销售预测、股票预测
**Python库**：statsmodels, prophet

### 3.2 回归分析 (Regression Analysis)
**适用场景**：变量之间存在因果关系
**典型应用**：房价预测、销量预测
**Python库**：scikit-learn, statsmodels

### 3.3 神经网络预测 (Neural Network Prediction)
**适用场景**：复杂非线性关系预测
**典型应用**：图像识别、自然语言处理
**Python库**：tensorflow, pytorch, keras

### 3.4 马尔可夫链 (Markov Chain)
**适用场景**：状态转移概率已知的预测问题
**典型应用**：天气预测、市场份额预测
**Python库**：pomegranate, hmmlearn

## 4. 统计类模型

### 4.1 假设检验 (Hypothesis Testing)
**适用场景**：验证统计假设是否成立
**典型应用**：实验效果评估、质量检测
**Python库**：scipy.stats

### 4.2 方差分析 (ANOVA)
**适用场景**：比较多个组的均值差异
**典型应用**：实验设计、因素分析
**Python库**：scipy.stats, statsmodels

### 4.3 相关性分析 (Correlation Analysis)
**适用场景**：分析变量之间的相关关系
**典型应用**：特征选择、数据探索
**Python库**：pandas, scipy.stats

### 4.4 主成分分析 (PCA, Principal Component Analysis)
**适用场景**：降维、特征提取
**典型应用**：数据压缩、可视化
**Python库**：scikit-learn, numpy

## 5. 模型选择指南

### 问题类型匹配表
| 问题类型 | 推荐模型 | 复杂度 | 数据要求 |
|---------|----------|--------|----------|
| 资源分配 | 线性规划、整数规划 | 低 | 约束条件明确 |
| 方案选择 | AHP、TOPSIS | 中 | 评价指标体系 |
| 趋势预测 | 时间序列、回归分析 | 中 | 历史数据 |
| 模式识别 | 神经网络、SVM | 高 | 大量训练数据 |
| 状态转移 | 马尔可夫链 | 中 | 转移概率矩阵 |

### 模型复杂度考虑因素
1. **数据量**：数据量少时选择简单模型，数据量大时可使用复杂模型
2. **计算资源**：考虑计算时间和内存限制
3. **可解释性**：需要解释结果时选择简单模型
4. **精度要求**：精度要求高时可使用复杂模型

### 模型验证方法
1. **交叉验证**：将数据分为训练集和测试集
2. **留出法**：保留部分数据用于验证
3. **K折交叉验证**：多次划分训练集和测试集
4. **性能指标**：准确率、精确率、召回率、F1分数等