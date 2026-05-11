# cumcmthesis LaTeX模板使用说明

## 概述
cumcmthesis是专为全国大学生数学建模竞赛设计的LaTeX文档类，提供了标准的论文格式和排版规范。

## 基本使用方法

### 1. 文档结构
使用cumcmthesis模板时，文档应包含以下基本结构：
- 文档类声明：`\documentclass{cumcmthesis}`
- 导言区：包含必要的宏包和设置
- 文档内容：摘要、正文、参考文献、附录等

### 2. 必要的宏包
推荐在导言区添加以下宏包：
- 参考文献格式：`\usepackage{gbt7714}`
- 算法环境：`\usepackage{algorithm}` 和 `\usepackage{algorithmic}`
- 数学符号：根据需要添加`amsmath`、`amssymb`等

### 3. 文档类选项
cumcmthesis支持以下常用选项：
- 中文支持：自动处理中文排版
- 页边距设置：符合竞赛要求的页面布局
- 字体设置：中文字体和英文字体配置

### 4. 章节结构
数学建模论文的标准章节结构：
1. **摘要**：问题概述、方法、结果、结论
2. **问题重述**：重新组织语言介绍题目
3. **问题分析**：对每个问题的分析思路
4. **模型假设**：关键简化假设
5. **符号说明**：数学符号解释
6. **模型建立**：详细数学模型推导
7. **模型求解**：算法描述和求解过程
8. **结果分析**：数据分析和图表解释
9. **模型评价**：优缺点分析和改进方向
10. **参考文献**：BibTeX格式引用
11. **附录**：补充材料、代码等

### 5. 数学公式排版
- 行内公式：使用`$...$`或`\(...\)`
- 行间公式：使用`\[...\]`或`equation`环境
- 编号公式：使用`equation`环境
- 多行公式：使用`align`、`gather`等环境

### 6. 图表处理
- 图片插入：使用`\includegraphics`命令
- 表格环境：推荐使用`tabular`、`booktabs`等
- 图表标题：使用`\caption`命令
- 交叉引用：使用`\label`和`\ref`命令

### 7. 参考文献管理
- BibTeX格式：使用`reference.bib`文件
- 引用命令：使用`\cite{key}`格式
- 编译流程：XeLaTeX → Biber → XeLaTeX → XeLaTeX

### 8. 编译要求
推荐使用XeLaTeX编译器：
- 支持中文和Unicode字符
- 良好的字体处理能力
- 兼容BibTeX参考文献处理

### 9. 页面设置
模板已预设符合竞赛要求的页面设置：
- 纸张大小：A4
- 页边距：上下2.5cm，左右3cm
- 行距：1.5倍行距
- 字号：正文小四号字

### 10. 特殊环境
- 算法环境：使用`algorithm`和`algorithmic`环境
- 定理环境：可根据需要添加
- 列表环境：使用`enumerate`、`itemize`等

## 注意事项
1. 确保使用UTF-8编码保存所有文件
2. 图片格式推荐使用PNG或JPG，分辨率≥300DPI
3. 参考文献数量建议10-20篇
4. 论文总页数控制在20页以内
5. 避免使用过多的列表项，保持段落连贯性

## 常见问题解决
1. **中文显示问题**：确保使用XeLaTeX编译器，并正确配置中文字体
2. **参考文献不显示**：检查BibTeX编译流程是否完整
3. **图表位置问题**：使用`[!ht]`等位置限定符
4. **公式编号错误**：检查公式环境是否正确嵌套

## 示例代码结构
```
\documentclass{cumcmthesis}
\usepackage{gbt7714}
\usepackage{algorithm}
\usepackage{algorithmic}

\begin{document}
\title{论文标题}
\maketitle

\begin{abstract}
摘要内容...
\end{abstract}

\section{问题重述}
...

\bibliography{reference.bib}

\begin{appendices}
\section{附录内容}
...
\end{appendices}

\end{document}
```

## 扩展功能
1. **自定义封面**：可修改标题、作者、日期等信息
2. **目录生成**：使用`\tableofcontents`命令
3. **页眉页脚**：模板已预设，可根据需要调整
4. **交叉引用**：支持图表、公式、章节的交叉引用

通过遵循以上说明，可以快速创建符合数学建模竞赛要求的规范论文。