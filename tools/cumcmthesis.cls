
% 在 cumcmthesis 的基础上修改
% cumcmthesis 来自：https://github.com/latexstudio/CUMCMThesis

% 指定所需的 LaTeX 格式和版本
\NeedsTeXFormat{LaTeX2e}[1995/12/01]

%% 初始代码

% 定义关键字的令牌
\newcommand\mcm@tokens@keywords{}

%% 执行选项
% 默认执行彩色打印选项
\ExecuteOptions{colorprint}
% 处理所有选项并忽略多余的空格
\ProcessOptions\relax

%% 加载文档类
% 加载 article 类，设置纸张大小为 A4，字号为 12pt
\LoadClass[a4paper,12pt]{article}

%% 加载宏包
% 检查是否使用 XeTeX 引擎
\RequirePackage{ifxetex}
% 要求使用 XeTeX 引擎
\RequireXeTeX
% 如果未使用 XeTeX 引擎，抛出错误提示
\ifxetex\else
\ClassError{mcmthesis}{You must use the `xelatex' driver\MessageBreak Please choose `xelatex'}{%
Just choose `xelatex', no `pdflatex' or `latex' and so on.}
\fi

% 支持中文的 ctex 宏包
\RequirePackage{ctex}
% 用于页面布局设置
\RequirePackage{geometry}
% 数学相关宏包，提供数学公式排版功能
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{amssymb}
% 提供粗体数学符号
\RequirePackage{bm}
% 用于定制目录样式
\RequirePackage{titletoc}
% 设置颜色的宏包
\RequirePackage{xcolor}
% 插入图片的宏包
\RequirePackage{graphicx}
% 支持子图排版的宏包
\RequirePackage{subcaption} 
% 用于表格排版的宏包
\RequirePackage{array}
% 支持长表格排版的宏包
\RequirePackage{longtable}
% 提供 \toprule 等命令，用于美化表格
\RequirePackage{booktabs}
% 支持在表格中跨行排版
\RequirePackage{multirow}
% 调整表格间隔，使表格更美观
\RequirePackage{bigstrut}
% 在跨行表格中输入定界符
\RequirePackage{bigdelim}
% 保护脆弱命令，避免意外解析
\RequirePackage{cprotect}
% 设置代码环境的宏包
\RequirePackage{listings}
% 再次加载 xcolor 用于代码环境的颜色设置
\RequirePackage{xcolor}
% 设置行距的宏包
\RequirePackage{setspace} 
% 用于定制目录、图表目录等样式
\RequirePackage[titles]{tocloft}
% 重新定义目录中的点为特定符号
\renewcommand{\cftdot}{$\cdot$}
% 设置目录中节标题与页码之间的点的间隔
\renewcommand{\cftsecdotsep}{1.5} 
% 设置目录中节标题前的垂直间距
\setlength{\cftbeforesecskip}{7pt}
% 设置目录中子节标题前的垂直间距
\setlength{\cftbeforesubsecskip}{3pt}
% 设置目录中节标题的字体为四号黑体加粗
\renewcommand{\cftsecfont}{\bfseries\zihao{-4}\heiti}
% 设置目录中节标题与页码之间的填充方式
\renewcommand{\cftsecleader}{\cftdotfill{\cftsecdotsep}}
% 设置目录中节标题编号后的水平间距
\renewcommand{\cftsecaftersnumb}{\hskip.4em}

% 定义几种颜色，用于代码环境设置
\definecolor{dkgreen}{rgb}{0,0.6,0}
\definecolor{gray}{rgb}{0.5,0.5,0.5}
\definecolor{mauve}{rgb}{0.58,0,0.82}

% 设置代码环境的样式
\lstset{
  frame=tb, % 代码框上下有边框
  aboveskip=3mm, % 代码框上方的垂直间距
  belowskip=3mm, % 代码框下方的垂直间距
  showstringspaces=false, % 不显示字符串中的空格
  columns=flexible, % 代码列的宽度可灵活调整
  framerule=1pt, % 边框线的宽度
  rulecolor=\color{gray!35}, % 边框线的颜色
  backgroundcolor=\color{gray!5}, % 代码框的背景颜色
  basicstyle={\small\ttfamily}, % 代码的基本字体样式
  numbers=none, % 不显示行号
  numberstyle=\tiny\color{gray}, % 行号的字体样式
  keywordstyle=\color{blue}, % 关键字的颜色
  commentstyle=\color{dkgreen}, % 注释的颜色
  stringstyle=\color{mauve}, % 字符串的颜色
  breaklines=true, % 允许代码换行
  breakatwhitespace=true, % 在空格处换行
  tabsize=3, % 制表符的宽度
}

% 首行缩进宏包，使段落首行自动缩进
\RequirePackage{indentfirst}
% 设置浮动体（如图表）的标题样式
\RequirePackage{caption}
% 定制列表环境的宏包
\RequirePackage{enumitem}
% 提供下划线功能的宏包
\RequirePackage{ulem}
% 尺寸计算宏包
\RequirePackage{calc}
% 处理附录的宏包
\RequirePackage[titletoc,title]{appendix}
% 用于条件判断和环境钩子的宏包
\RequirePackage{etoolbox}
% 在参考文献环境开始时，添加到目录中
\AtBeginEnvironment{thebibliography}{%
    \phantomsection
    \addcontentsline{toc}{section}{\refname}
    }
% 超链接宏包
\RequirePackage{hyperref}

%% 文档布局设置
% 设置页面边距
\geometry{top=25mm,bottom=25mm,left=25mm,right=25mm}
% 设置正文行间距
\renewcommand*{\baselinestretch}{1.38}
% 修改 tabular 环境，设置表格中的行间距为正文行间距
\let\mcm@oldtabular\tabular
\let\mcm@endoldtabular\endtabular
\renewenvironment{tabular}%
	{\bgroup%
	\renewcommand{\arraystretch}{1.38}%
	\mcm@oldtabular}%
	{\mcm@endoldtabular\egroup}

% 每行缩进两个汉字
\setlength\parindent{2em}

% 设置字体
\RequirePackage{fontspec}
% 设置英文主体字体为 Times New Roman
\setmainfont{Times New Roman}
% 设置无衬线英文字体为 Arial
\setsansfont{Arial}
% 设置中文楷体字体
\setCJKfamilyfont{kai}[AutoFakeBold]{simkai.ttf}
% 定义使用楷体的命令
\newcommand*{\kai}{\CJKfamily{kai}}
% 设置中文宋体字体
\setCJKfamilyfont{song}[AutoFakeBold]{SimSun}
% 定义使用宋体的命令
\newcommand*{\song}{\CJKfamily{song}}

% 重新定义标准字号的字体大小和行间距
\renewcommand\normalsize{%
	\@setfontsize\normalsize{12.05}{14.45}%
	\abovedisplayskip 12\p@ \@plus3\p@ \@minus7\p@
	\abovedisplayshortskip \z@ \@plus3\p@
	\belowdisplayshortskip 6.5\p@ \@plus3.5\p@ \@minus3\p@}

% 数学环境、定理等设置
% 定义各种数学定理、定义等环境的中文名称
\newtheorem{definition}{\mcm@cap@definition}
\newtheorem{theorem}{\mcm@cap@theorem}
\newtheorem{lemma}{\mcm@cap@lemma}
\newtheorem{corollary}{\mcm@cap@corollary}
\newtheorem{assumption}{\mcm@cap@assumption}
\newtheorem{conjecture}{\mcm@cap@conjecture}
\newtheorem{axiom}{\mcm@cap@axiom}
\newtheorem{principle}{\mcm@cap@principle}
\newtheorem{problem}{\mcm@cap@problem}
\newtheorem{example}{\mcm@cap@example}
\newtheorem{proof}{\mcm@cap@proof}
\newtheorem{solution}{\mcm@cap@solution}

% 浮动环境设置
% 默认情况下，LaTeX 要求每页的文字至少占据 20%，否则该页就只单独放置一个浮动环境，
% 我们将这个要求降低到 5%
\renewcommand*{\textfraction}{0.05}
% 有时如果多个浮动环境连续放在一起，LaTeX 会将它们分在几个不同页，即使它们可在同一页放得下。
% 我们可以通过修改 \topfraction 和 \bottomfraction 分别设置顶端和底端的浮动环境的最大比例
\renewcommand*{\topfraction}{0.9}
\renewcommand*{\bottomfraction}{0.8}
% 有时 LaTeX 会把一个浮动环境单独放在一页，我们要求这个环境至少要占据 85% 才能单独放在一页。
% 注意：\floatpagefraction 的数值必须小于 \topfraction
\renewcommand*{\floatpagefraction}{0.85}

% 关于图片 graphicx
% 如果图片没有指定后缀，依次按下列顺序搜索
\DeclareGraphicsExtensions{.pdf,.eps,.jpg,.png}
% 设置图表搜索路径，可以给图表文件夹取如下名字
\graphicspath{{figures/}{figure/}{pictures/}%
  {picture/}{pic/}{pics/}{image/}{images/}}

% 图表标题设置
% 定义宋体标题字体
\DeclareCaptionFont{song}{\songti}
% 定义楷体标题字体
\DeclareCaptionFont{kai}{\kaishu}
% 定义小四字号标题字体
\DeclareCaptionFont{minusfour}{\zihao{-4}}
% 设置图的标题样式
\captionsetup[figure]{%
	format=hang,   % 标题从第二行开始都有缩进，应该和 justification=raggedright 的效果一样
	labelsep=quad, % 分隔符是一个空格
	font={kai,minusfour,bf}, % 图的字体，楷体小四加粗
	position=bottom % position=bottom 不代表标题放在下面，标题仍放在你放 \caption 的位置
}
% 设置表的标题样式
\captionsetup[table]{%
	format=hang,   % 标题从第二行开始都有缩进，应该和 justification=raggedright 的效果一样
	labelsep=quad, % 分隔符是一个空格
	font={kai,minusfour,bf}, % 表的字体，楷体小四加粗
	position=top % position=bottom 不代表标题放在下面，标题仍放在你放 \caption 的位置
}

% 列表环境设置
\setlist{%
	topsep=0.3em, % 列表顶端的垂直空白
	partopsep=0pt, % 列表环境前面紧接着一个空白行时其顶端的额外垂直空白
	itemsep=0ex plus 0.1ex, % 列表项之间的额外垂直空白
	parsep=0pt, % 列表项内的段落之间的垂直空白
	leftmargin=1.5em, % 环境的左边界和列表之间的水平距离
	rightmargin=0em, % 环境的右边界和列表之间的水平距离
	labelsep=0.5em, % 包含标签的盒子与列表项的第一行文本之间的间隔
	labelwidth=2em % 包含标签的盒子的正常宽度；若实际宽度更宽，则使用实际宽度
}

% 超链接设置
\hypersetup{%
         xetex,
		% unicode=false, % hyperref 和 xetex 同时使用时不能开启 Unicode 选项
         pdfstartview=FitH,
         CJKbookmarks=true,
         bookmarksnumbered=true,
         bookmarksopen=true,
         colorlinks, % 注释掉此项则交叉引用为彩色边框(将 colorlinks 和 pdfborder 同时注释掉)
         pdfborder=001,   % 注释掉此项则交叉引用为彩色边框
		 allcolors=black,
		 breaklinks=true}%

% 定义一个新的代码环境 tcode
\lstnewenvironment{tcode}
  {
    \lstset{basicstyle = \small\ttfamily,
        language=TeX,
        tabsize = 4,
        frame = single,
        escapechar = `,
        breaklines = true,
        breakatwhitespace = true,
        frameround = tttt,
    }
  }
  {}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 文档标记设置

% 中文标题名称设置
% 重新定义目录、插图清单等的中文名称
\renewcommand\contentsname{\mcm@cap@contentsname}
\renewcommand\listfigurename{\mcm@cap@listfigurename}
\renewcommand\listtablename{\mcm@cap@listtablename}
\renewcommand\refname{\mcm@cap@refname}
\renewcommand\indexname{\mcm@cap@indexname}
\renewcommand\figurename{\mcm@cap@figurename}
\renewcommand\tablename{\mcm@cap@tablename}
\renewcommand\appendixname{\mcm@cap@appendixname}
\renewcommand\abstractname{\mcm@cap@abstractname}

% 中文标题格式设置
% 设置目录深度为 3 级
\setcounter{secnumdepth}{3}
% 定义节标题编号格式
\def\@seccntformat#1{\csname the#1\endcsname\ }
% 章节编号为阿拉伯数字： “1 引言”
\renewcommand\thesection{\arabic{section} }
% 子节编号格式
\renewcommand\thesubsection{\arabic{section}\thinspace.\thinspace\arabic{subsection}}
% 子子节编号格式
\renewcommand\thesubsubsection{\thesubsection\thinspace.\thinspace\arabic{subsubsection}}
% 重新定义节标题样式，居中，字号为大标题
\renewcommand\section{\@startsection{section}{1}{\z@}%
 	{-3.5ex \@plus -1ex \@minus -.2ex}%
	{2.3ex \@plus.2ex}%
	{\centering\normalfont\Large\bfseries}}
% 重新定义子节标题样式，字号为小标题
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
	{-3.25ex\@plus -1ex \@minus -.2ex}%
	{1.5ex \@plus .2ex}%
	{\normalfont\large\bfseries}}
% 重新定义子子节标题样式，字号为正常大小
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
	{-3.25ex\@plus -1ex \@minus -.2ex}%
	{1.5ex \@plus .2ex}%
	{\normalfont\normalsize\bfseries}}
% 重新定义段落标题样式
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
	{3.25ex \@plus1ex \@minus.2ex}%
	{-1em}%
	{\normalfont\normalsize\bfseries}}
% 重新定义子段落标题样式
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
	 {3.25ex \@plus1ex \@minus .2ex}%
	 {-1em}%
	 {\normalfont\normalsize\bfseries}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 定义新环境和命令
%% 摘要两个字设置为 4 号
%% 定义摘要环境
\renewenvironment{abstract}{%
\if@twocolumn
		\section*{\abstractname}%
	\else
	 \begin{center}%
	{\zihao{4}\heiti \bfseries \abstractname\vspace{-.5em}\vspace{\z@}}
	 \end{center}%
 	 \quotation
	\fi}
	{\if@twocolumn\else\endquotation\newpage\null\fi}

% 重新定义引用环境，设置缩进等格式
\renewenvironment{quotation}
	{\list{}{\listparindent 2em%
	 \itemindent \listparindent
	 \rightmargin\z@
	 \leftmargin\z@
	 \parsep \z@ \@plus\p@}%
	\item\relax}
	{\endlist}

% 定义关键字命令，用于设置文档关键字
\newcommand\keywords[1]{%
	\renewcommand{\mcm@tokens@keywords}{#1}
	\par
	\vskip1ex
	{\noindent\zihao{-4}\heiti\mcm@cap@keywordsname：}~{\mcm@tokens@keywords}
	}

% 重定义参考文献环境
\renewenvironment{thebibliography}[1]
     {\section*{\refname}%
      % 为页眉设置大写的参考文献名称
      \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}%
      % 创建列表环境用于参考文献条目
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            % 设置左边界为标签宽度
            \leftmargin\labelwidth
            % 增加左边界和标签之间的间隔
            \advance\leftmargin\labelsep
            % 开启参考文献的代码设置
            \@openbib@code
            % 使用计数器 enumiv 进行编号
            \usecounter{enumiv}%
            % 清空父计数器的前缀
            \let\p@enumiv\@empty
            % 定义计数器显示为阿拉伯数字
            \renewcommand\theenumiv{\@arabic\c@enumiv}
            % 设置参考文献的行间距为单倍行距
            \setstretch{1} 
            % 设置参考文献的字号为五号字
            \zihao{5}} 
      % 允许文本松散排版
      \sloppy
      % 设置防止单个单词在页首的惩罚值
      \clubpenalty4000
      % 应用防止单个单词在页首的惩罚值
      \@clubpenalty \clubpenalty
      % 设置防止单个单词在页尾的惩罚值
      \widowpenalty4000%
      % 设置句号的间距因子
      \sfcode`\.\@m}
     {\def\@noitemerr
       % 若参考文献环境为空，给出警告
       {\@latex@warning{Empty `thebibliography' environment}}%
      % 结束列表环境
      \endlist}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 初始化
%%% 数学定理相关的常量，定义各种数学环境的中文名称
\newcommand*{\mcm@cap@definition}{定义}
\newcommand*{\mcm@cap@theorem}{定理}
\newcommand*{\mcm@cap@lemma}{引理}
\newcommand*{\mcm@cap@corollary}{推论}
\newcommand*{\mcm@cap@assumption}{假设}
\newcommand*{\mcm@cap@conjecture}{猜想}
\newcommand*{\mcm@cap@axiom}{公理}
\newcommand*{\mcm@cap@principle}{定律}
\newcommand*{\mcm@cap@problem}{问题}
\newcommand*{\mcm@cap@example}{例}
\newcommand*{\mcm@cap@proof}{证明}
\newcommand*{\mcm@cap@solution}{解}

 %%%  中文标题名称，定义目录、图表清单等的中文名称
\newcommand*{\mcm@cap@contentsname}{目录}
\newcommand*{\mcm@cap@listfigurename}{插图清单}
\newcommand*{\mcm@cap@listtablename}{附表清单}
\newcommand*{\mcm@cap@refname}{参考文献}
\newcommand*{\mcm@cap@indexname}{索引}
\newcommand*{\mcm@cap@figurename}{图}
\newcommand*{\mcm@cap@tablename}{表}
\newcommand*{\mcm@cap@appendixname}{附录}
\newcommand*{\mcm@cap@abstractname}{摘要}
 %%%  中文关键字，定义关键字的中文名称
\newcommand*{\mcm@cap@keywordsname}{关键词}


\renewcommand{\normalsize}{\zihao{-4}\kai} % 正文字体使用楷体小四

% 以上是数学建模论文模板
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 以下对应毕业论文的要求，在正文添加页眉，并调整标题的字体格式
%% 加载用于设置页眉页脚的宏包
%\RequirePackage{fancyhdr}
%% 设置页面样式为 fancy
%\pagestyle{fancy}
%% 清空页眉页脚的默认内容
%\fancyhf{}
%% 设置页眉为论文题目，使用小五宋体
%\fancyhead[C]{\zihao{-5} \songti \@title}  
%% 设置页脚为页码，使用小五加粗字体
%\fancyfoot[C]{\zihao{-5} \bfseries \thepage}  
%
%% 调整标题格式
%% 重新定义一级标题样式，三号加粗黑体，设置标题前后间距等
%\renewcommand{\section}{\@startsection{section}{1}{\z@}%
%    {-3.5ex \@plus -1ex \@minus -.2ex}%
%    {2.3ex \@plus.2ex}%
%    {\centering\normalfont\zihao{3}\bfseries}}  
%% 重新定义二级标题样式，四号加粗黑体，设置标题前后间距等
%\renewcommand{\subsection}{\@startsection{subsection}{2}{\z@}%
%    {-3.25ex\@plus -1ex \@minus -.2ex}%
%    {1.5ex \@plus .2ex}%
%    {\normalfont\zihao{4}\bfseries}}  
%% 重新定义三级标题样式，小四号加粗黑体，设置标题前后间距等
%\renewcommand{\subsubsection}{\@startsection{subsubsection}{3}{\z@}%
%    {-3.25ex\@plus -1ex \@minus -.2ex}%
%    {1.5ex \@plus .2ex}%
%    {\normalfont\zihao{-4}\bfseries}}  
    
% 结束当前文件的读取
\endinput
