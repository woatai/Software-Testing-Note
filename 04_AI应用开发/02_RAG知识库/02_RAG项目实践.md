---
title: RAG 项目实践
type: project
status: active
updated: 2026-08-26
tags:
  - RAG
  - personal-test-rag
  - LexarRAG
  - AI评测
---

# RAG 项目实践

> [!info] 笔记定位
> 这篇笔记回答“我实际搭建、测试和验证过什么”。实践分为三个阶段：先用简易 RAG 建立可控基线，再测试 LexarRAG 的复杂链路，最后把 RAG 落到可复用的 AI 测试用例平台。

相关知识：[[00_RAG核心知识]]、[[01_RAG评测与测试]]。

## 一、实践路线

```mermaid
flowchart LR
    A["搭建简易 RAG"] --> B["跑通端到端"]
    B --> C["建立 Gold Set 和评测基线"]
    C --> D["测试 LexarRAG"]
    D --> E["分层定位与对比实验"]
    E --> F["形成评测报告和面试证据"]
```

两个阶段不是重复造两个项目：

- `personal-test-rag` 用来理解每一层、控制变量并验证评测方法；
- `LexarRAG` 用来练习复杂系统的黑盒评测、白盒 Trace 和版本回归。

## 二、记录规则

为了避免把“计划做”和“已经做过”混在一起，后续统一使用以下状态：

| 状态 | 含义 |
| --- | --- |
| 已实现 | 代码或配置已经存在 |
| 已验证 | 已实际运行，并保存了命令、输出或报告 |
| 待验证 | 已有实现，但当前还没有真实运行证据 |
| 计划中 | 尚未实现，只是后续方案 |

每次实验至少记录：

```text
实验目标
→ 基线版本与配置
→ 本次只修改的变量
→ 使用的评测集版本
→ 指标结果
→ 失败样本
→ 结论与下一步
```

## 三、第一阶段：personal-test-rag

项目位置：[personal-test-rag README](/Users/Admin/Documents/personal-test-rag/README.md)

### 1. 阶段目标

自己搭建一条最小、可解释、可控制的 RAG 链路，理解数据怎样进入知识库、问题怎样找到 Chunk，以及怎样证明检索和回答有效。

### 2. 当前范围

```text
Markdown 白名单
→ 清洗
→ 标题感知切片
→ bge-m3 Embedding
→ PostgreSQL + pgvector 精确余弦检索
→ qwen3:1.7b 生成（当前本机配置）
→ 答案与程序生成的真实引用
```

首版暂不包含：

- PDF、Word、图片和 OCR；
- BM25、查询改写和 Rerank；
- Agent 和工具调用；
- 登录、复杂权限和前端。

### 3. 当前能力概览

| 能力 | 当前状态 |
| --- | --- |
| FastAPI、SQLAlchemy、Alembic 项目骨架 | 已实现 |
| Markdown 白名单、清洗和标题切片 | 已实现 |
| Ollama Embedding 和 LLM 客户端 | 已实现 |
| pgvector 精确向量检索 | 已实现 |
| 增量同步、失败保留旧索引 | 已实现 |
| 低相关度拒答和真实引用 | 已实现 |
| 10 条检索评测数据与脚本 | 已实现，需扩充 |
| 31 条普通自动化测试 | 已验证，2026-08-08 全部通过 |
| PostgreSQL/pgvector、Ollama 与本地模型 | 已验证，数据库健康；`bge-m3`、`qwen3:1.7b` 已就绪 |
| 真实知识索引 | 已验证，当前有 8 篇文档、283 个 Chunk；同步 dry-run 全部跳过 |
| API 启动与真实端到端问答 | 待验证，检查时 8000 端口未启动服务 |
| 10 条检索评测基线 | 待验证，`evals/results` 尚无真实结果 |

### 4. 第一阶段评测重点

初始评测先保持简单：

- 正确文档或标题是否进入 Top-5；
- 第一个正确结果排在第几位；
- 无答案问题是否拒答；
- 引用是否来自实际知识库；
- 检索和完整问答耗时；
- 失败属于解析、切片、检索还是生成。

### 5. 后续实践顺序

- [x] 确认 Docker、PostgreSQL、Ollama、模型和真实索引环境；
- [ ] 启动 API 并完成一次真实端到端问答；
- [ ] 运行现有 10 条检索评测并保存基线；
- [ ] 将评测集扩充到 30～50 条；
- [ ] 增加同义问法、相似概念、干扰项和无答案问题；
- [ ] 增加 MRR、延迟和失败分类；
- [ ] 分别比较 Chunk、Top-K 和拒答阈值；
- [ ] 形成第一份基线评测报告。

### 6. 实验记录

#### 2026-08-08：第一阶段环境复核

- 已验证：`uv run pytest -q` 的 31 条测试全部通过；PostgreSQL 容器健康；Ollama 已有 `bge-m3` 和 `qwen3:1.7b`。
- 已验证：数据库中有 8 篇文档和 283 个 Chunk；同步 dry-run 发现 8 篇文档均无需更新。
- 待验证：API 当时未启动，因此尚未留下真实问答和引用证据。
- 待验证：评测结果目录只有占位文件，10 条种子用例还没有第一份基线结果。

> [!todo] 等第一次真实评测完成后补充
> 这里记录配置、指标、失败样本和结论，不复制大段终端输出。完整 JSON 结果保留在项目的 `evals/results` 中。

## 四、第二阶段：LexarRAG

项目位置：[LexarRAG README](/Users/Admin/Documents/lexar-rag/README.md)

### 1. 为什么选择它作为被测系统

LexarRAG 已经包含比简易项目更完整的企业知识库能力，适合用来练习复杂 RAG 的测试和评测，而不是继续停留在概念层面。

当前可以观察的链路包括：

- PDF、DOCX、XLSX、PPTX、HTML、图片和 OCR；
- 文档清洗和质量报告；
- 父子层级切片；
- Dense + BM25 混合检索；
- Query Rewrite、RRF 和 Rerank；
- 上下文分组、压缩、引用和置信度；
- 知识草稿、发布、版本和回滚；
- Retrieval Log、审计和回放。

### 2. 与简易 RAG 的差异

| 维度 | personal-test-rag | LexarRAG |
| --- | --- | --- |
| 实践目的 | 理解基础链路并建立基线 | 练习复杂系统评测 |
| 文档 | Markdown 白名单 | 多格式、OCR 和复杂版式 |
| 切片 | 标题感知切片 | 父子层级切片 |
| 检索 | Dense 向量检索 | Dense + BM25 + RRF |
| 查询优化 | 无 | Query Rewrite |
| 重排 | 无 | Rerank |
| 上下文 | 直接使用 Top-K | 扩展、去重、分组和压缩 |
| 运维 | 增量同步 | 草稿、发布、版本和回滚 |
| 可观测性 | 基础分数和引用 | 较完整的 Retrieval Log |

### 3. 当前评测能力判断

LexarRAG 已经有多个 `evaluate_*` 脚本，可以检查：

- 接口是否产生回答；
- 回答是否包含引用；
- 是否返回来源、证据分组和 Citation Highlight；
- 是否记录置信度和 Retrieval Log。

这些更接近冒烟验证和链路检查。后续还需要补充带真值的评测集，以及 Hit@K、Recall@K、MRR、回答正确性和 Faithfulness 等指标。

#### 第 2 天最小检索评测闭环（计划中）

当前已验证的线上知识范围是 Release v2：只包含 `lexar-rag-smoke.md` 的一个 Chunk，标题路径为 `LexarRAG Smoke Test`。因此第一版种子集先固定为 4 条可回答问题和 2 条无答案问题，不把仓库 README 或模型常识误当成线上知识真值：

| 类型 | 问题方向 | 预期判定 |
| --- | --- | --- |
| 正例 | Milvus 的职责 | 命中 smoke 文档并回答“向量存储” |
| 正例 | Embedding 的职责 | 命中 smoke 文档并回答“生成向量” |
| 正例 | 检索后由谁回答 | 命中 smoke 文档并回答“生成模型根据证据回答” |
| 正例 | 测试关键词 | 命中 smoke 文档并回答 `RAG_SMOKE_2026` |
| 负例 | Milvus 向量数据如何备份和恢复 | 与来源有词面重叠，但当前线上知识中没有备份策略依据 |
| 负例 | 项目支持哪些 OCR 格式 | 当前线上知识中无依据，即使仓库 README 写过也不能算可回答 |

人工核对时固定 `question`、`gold_source`、`gold_heading`、`reference_points`、`answerable`、`dataset_version`，并记录 Release、Revision、模型、Top-K、阈值和功能开关。第 2 天的第一份基线只评检索：使用原始问题，关闭 LLM Query Rewrite，不执行答案生成；分别保存 Dense、BM25、RRF 和 Rerank 的有序结果，正例计算 Hit@K 和 MRR，负例检查是否错误保留无关证据。

第 2 天使用自定义 Python 检索评测脚本 `backend/scripts/evaluate_retrieval_seed.py`，直接调用项目 `HybridRetriever`，并在脚本内将 `rewrite_enabled` 临时设为 `false`；不修改线上配置。Embedding 和 Rerank 仍属于被测检索链路，应固定模型版本，并同时保留 RRF 重排前与 Rerank 重排后的结果。该脚本已实现；首轮不引入 Ragas、DeepEval 等额外评测框架。

前端评测入口只能改善操作体验，不能代替评测执行器。当前先用 CLI 固定数据集、配置、指标和报告格式，便于批量运行、复现、回归和接入 CI；首份真实基线稳定后，可以增加仅管理员可见的“检索评测”页面，由它调用同一套后端评测逻辑，负责选择固定数据集、触发任务、查看进度、展示指标与失败样本以及下载 JSON。前端和 API 不应另写一套指标公式，也不应复用包含 Query Rewrite 和答案生成的聊天接口，否则会造成评测口径漂移并重新引入 LLM 干扰。

脚本实现按六步组织：读取并校验 JSONL 用例；解析当前 Published Release 和目标 collection；读取有效运行配置并仅在内存中关闭 Query Rewrite；加载该 Release 的固定语料；逐题调用 `HybridRetriever.invoke()`，保存 Dense、BM25、RRF、Rerank 的来源、标题、Chunk、排名、分数和耗时；最后按人工 `gold_sources`/`gold_headings` 计算各阶段 Hit@K、MRR 和负例错误召回率，连同安全配置快照写入 JSON。环境或模型服务异常单独记为执行错误，不计入检索失败；报告不保存 API Key、完整服务地址或其他秘密。

`GET /api/v2/chat/stream` 和前端“智能问答”页面保留为下一阶段的端到端黑盒测试入口，用来评价回答、引用、拒答和完整延迟。该接口同时包含 LLM Query Rewrite 与答案生成，不能单独证明检索质量；当接口样本失败时，再用第 2 天的分阶段检索结果定位问题。当前前端开发服务器监听 3001，Vite 代理目标是后端 8002；聊天接口会创建会话和审计记录，不是纯只读调用。

当前已验证的有效配置为：`retrieval_k=50`、`retrieval_score_threshold=0.1`、`rerank_top_k=4`，Query Rewrite、Dense、BM25、父切片扩展和 Rerank 均开启，`rrf_k=60`。这一组值只能作为首份基线记录，不能直接解释为“最优配置”。

失败定位按阶段判断：Gold Passage 在 Dense/BM25 均缺失属于召回问题；进入候选但在 RRF 或 Rerank 后消失属于融合或重排问题；无答案问题仍保留 smoke Chunk 属于错误召回或证据门控问题；正确证据已进入最终上下文而答案仍错，才转向生成层排查。

#### 工具选择与 Baseline v1（计划中）

首轮不需要引入 Ragas、DeepEval 或 LLM 裁判。人工真值保存在 JSONL；自定义 Python CLI 读取数据并调用 `HybridRetriever`；完整逐题结果保存为 JSON；汇总报告输出 Markdown 或 CSV；`unittest` 只用于验证评测器公式和边界条件。这样依赖最少，也能直接得到 Top-K、Hit@5、MRR 和失败样本。

这里的“不引入”只是阶段选择，不代表 Ragas 或 DeepEval 不能评检索。当前 Gold 已精确标注来源、标题和 Chunk，Hit@K、MRR 可以不调用裁判模型而确定性计算；只有 6 题、1 个 Chunk 时，再增加常用的 LLM 语义评估会带来凭据、成本、延迟和评分波动，却不会改善第一份排名基线的可解释性。Ragas 同时提供 LLM 与非 LLM 指标，适合后续补充 Context Precision/Recall、Faithfulness 等数据集评测；DeepEval 的 RAG 指标和阈值断言更适合端到端答案评测及 CI，但其常用 Contextual Precision 等指标是 LLM-as-a-Judge，并需要 `actual_output`、`expected_output`、`retrieval_context` 等字段。进入第 3 天答案评测后，再从二者中选择一个补充 Answer Relevancy 和 Faithfulness；原有 Hit@K、MRR 仍作为确定性检索真值，不能被语义裁判替代。参考：[Ragas 指标](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/)、[Ragas Context Precision](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/context_precision/)、[DeepEval RAG 评测](https://deepeval.com/guides/guides-rag-evaluation)、[DeepEval Contextual Precision](https://deepeval.com/docs/metrics-contextual-precision)。

指标的 K 必须与实际返回数量一致。当前 `retrieval_k=50`、`rerank_top_k=4`，因此可以计算 Dense/BM25/RRF 的 Hit@5，但最终 Rerank 应报告 Hit@4；若目标明确要求最终 Hit@5，应先把系统的 Rerank Top-K 正式设置并冻结为 5，不能只在评测脚本中静默改口径。

当前已验证的 Release v2 只有一篇 `lexar-rag-smoke.md` 和一个 Chunk，不适合直接构造有代表性的 20 题。先用 6 条 `smoke-v0` 验证脚本、字段和公式；随后扩充并冻结可人工审核的 Published Release，再建立 20 条 `seed-v1`，生成 `baseline-v1.json` 和至少一份失败分析。20 题可先覆盖直接事实、同义改写、精确关键词、相似干扰、无答案和少量多证据问题。

> [!success] 2026-08-10 评测执行器状态
> 已实现并验证：`backend/scripts/evaluate_retrieval_seed.py` 支持 JSONL 校验、Published Release/KB 范围检查、内存关闭 Query Rewrite、四阶段 Top-K、Hit@K、MRR、负例错误召回率、安全配置快照，以及 Dense/BM25/Rerank 降级保护；`backend/tests/test_retrieval_evaluator.py` 的 9 项测试通过。`backend/evals/retrieval/smoke-v0.jsonl` 已按 Release v2 的 KB 1、标题 `LexarRAG Smoke Test` 和运行时 Chunk ID `1` 建立，共 4 条正例、2 条无答案负例。
>
> 第一次 CLI 实跑已生成 `backend/evals/retrieval/results/baseline-v1.json`：6 题全部执行完成，Dense、BM25、RRF 的正例 Hit@5 均为 1.0、MRR 均为 1.0，两个负例在各阶段都发生错误召回。活动 Rerank 档案的连通测试为 401，实际运行 6 次均降级为原顺序，因此报告 `degradedCaseCount=6`、`validForBaseline=false`、进程退出码为 2；这是一份可用于排障的失败尝试，不能冒充有效 Baseline v1。待管理员修复 Rerank 凭据并通过连接测试后，用同一命令覆盖重跑。
>
> 失败样本 `smoke-006` 问“LexarRAG 支持哪些 OCR 文件格式”，已冻结知识中没有 OCR 依据，但唯一 smoke Chunk 仍被 Dense/BM25 召回并进入 RRF；BM25 主要受到共同词 `LexarRAG` 的影响，而当前检索阶段没有把弱相关候选拒绝为空。这个样本暴露的是小语料下的错误召回和证据门控问题，不是答案生成问题。

> [!note] 2026-08-13 第 2 天目标进度判断
> 工程产物已基本齐备：6 条 `smoke-v0`、原始 JSON、中文 Excel、Phoenix 展示、失败样本和评测相关 17 项通过的测试均已有证据。截图中的最小目标尚差两项：修复 Rerank 凭据并重跑出 `validForBaseline=true` 的首份基线；由本人不看笔记说明 Gold Source、Hit@K、MRR、负例错误召回率与延迟，并复述 `smoke-006` 的失败层级。若凭据可立即使用，预计还需 2～4 小时完成最小验收。
>
> 当前 Release v2 只有 1 个 Chunk，6 条用例只能证明评测链路跑通，不能代表真实 RAG 检索质量。若目标升级为一份有代表性的检索基线，还需冻结更丰富的知识版本、人工审核约 20 条 `seed-v1`，再重跑并分析失败，预计额外需要 1～2 个专注学习日。

> [!note] `00_RAG核心知识.md` 作为评测语料的使用原则
> 该笔记包含 8 个大章节和明确的 Markdown 标题，适合扩充检索评测语料，覆盖直接事实、同义改写、概念对比、多证据和无答案问题。但不直接上传持续修改中的 Obsidian 原文件：先复制为带版本号的冻结评测版，移除 YAML frontmatter、笔记定位、Obsidian 双链等非知识正文，再在 LexarRAG 中预览解析与切片，审核后发布为固定 Release。Gold Set 仍独立保存在 JSONL 中，并优先用标题路径和 Chunk ID 标注真值；只有一篇文档时不能只用文件名判断命中。单篇笔记适合验证同文档章节排序和拒答门控，后续仍需加入其他主题文档，才能评价跨文档干扰下的真实检索效果。

> [!note] 个人知识库首批评测语料（已验证）
> 首批没有全量导入 179 篇笔记，而是制作并发布 4 份冻结语料：`rag-core-v1.md`、`rag-evaluation-v1.md`、清理内部链接后的 `customer-service-rules-v1.md`，以及从 JMeter 长文提取接口关联和 CSV 参数化等内容的 `jmeter-api-testing-v1.md`。前两篇用于测试相近 RAG 概念的章节排序，客服话术用于业务规则、合规表达和拒答，JMeter 子集用于精确术语与操作步骤。导航页、每日记录、简历、面试复盘、`99_归档`、只有“是什么/怎么用”的短占位笔记，以及未经清理的 MySQL/Pytest/JMeter 长文未进入 v1，避免引入隐私、重复版本、弱真值和标题结构噪声。

> [!success] 2026-08-13 个人知识库评测语料 v1 入库结果
> 冻结文件保存在 `project_out/eval-corpus-v1/`，Obsidian 原笔记未被直接上传或改写。LexarRAG 上传批次为 Batch 2，4 个条目均已审核并发布到 Release v4：RAG 核心知识 27 个 Chunk、RAG 评测知识 22 个 Chunk、客服规则 10 个 Chunk、JMeter 接口测试 15 个 Chunk，共 74 个 Chunk。解析过程未启用 OCR，4 篇均无解析警告、风险等级为 `none`、抽样召回率为 1.0。
>
> Release v3 首次建索引时，本机 Ollama 未运行，导致新增文本无法调用 `bge-m3:latest` 生成 1024 维向量；该失败没有切换线上索引，Release v2 继续可用。启动 Ollama，并在 macOS 上使用不 fork 的 RQ `SimpleWorker` 重试后，Index Job 5 完成 5/5 个文档，Release v4 于 16:13:54 发布，Milvus 稳定别名已指向 v4 的索引集合。这个入库阶段只完成语料发布，`seed-v1` Gold Set、评测问题和测试报告在随后补齐。

> [!success] 2026-08-13 `seed-v1` 基础评测集
> 已为 Release v4 的 4 份冻结文档新增 `backend/evals/retrieval/seed-v1.jsonl`：共 24 条用例，RAG 核心、RAG 评测、客服话术、JMeter 各 5 条可回答正例和 1 条不可回答负例。正例用来源文件、标题路径和当前运行时 Chunk ID 三重标注，负例不填写 Gold 身份，避免把“文档没有依据”误当成某个 Chunk 的命中。
>
> 已验证：JSONL 可被评测器完整解析（24 条、20 正例、4 负例），4 个 KB 的分配均为 6 条；所有正例的 Gold 身份都能在当前 Release v4 的 Chunk 元数据中对应。首次离线试跑 24 条均执行完成，但因 Rerank 服务错误全部标记为 `degraded`，所以 `validForBaseline=false`；诊断结果为 BM25 Hit@5 18/20、RRF 15/20，4 条负例在各阶段均发生错误召回。该结果用于定位检索和服务问题，不作为正式质量基线；修复 Rerank 和负例门控后应使用同一份 `seed-v1` 重跑。

> [!warning] 2026-08-13 `seed-v1` 评审结论（待修复后冻结）
> 这 24 条已满足基础题量和文档覆盖，但当前只能作为评测草稿，不能作为可信 Gold Set。已确认 Dense 与 BM25 对同一正文返回了不同的 Chunk ID 口径，导致 Dense 正确召回仍被判为未命中，并使 RRF 中出现同一正文的重复候选；因此首次试跑的 Dense 0%、BM25 90% 和 RRF 75% 不能用于判断模型质量。按来源和标题临时复核时，Dense 实际有 19/20 条正例进入 Top-5，进一步证明原始指标被身份口径污染。
>
> Gold 还需人工修订：`eval-005` 的答案正文位于下一个 Chunk，当前 Chunk 只含章节开头；`eval-002`、`customer-005`、`jmeter-001` 等存在多个可以独立支持答案的 Chunk，不能只标一个而把其他正确证据判错。每条用例目前只检索自己的单个 KB，因此测到的是单文档内章节排序，不是 Release v4 的跨文档干扰；数据集也没有绑定 Release/Manifest，发布新 Revision 后可能拿旧 Gold 误判。下一轮应先统一 Dense/BM25/RRF 的 canonical Chunk identity，再补齐多 Gold、Release 绑定和跨文档用例，最后修复 Rerank 后重跑。

> [!success] 2026-08-13 `seed-v2` 优化与复核结果
> 已新增 `backend/evals/retrieval/seed-v2.jsonl`，保留 24 条可人工审核的规模，并完成以下修订：所有题都在 KB 2～5 的共同语料中检索；正例使用跨 Dense/BM25 一致的 `logical_id` 作为主 Gold Passage，原 Chunk ID 只用于审计；多答案题允许多个 Gold；每条题增加 `reference_points`；数据集绑定 Release v4 和 Manifest Hash；负例改为备份命令、实时生产指标、退款承诺和硬件性能等更接近真实提问的高风险边界题。`seed-v1` 保留为评审历史，不再作为当前基线输入。
>
> 检索公共身份也已统一：运行时文档和索引元数据均保留 `logical_id`，Retriever 去重优先使用它，评测器在存在 Gold Logical ID 时不再用阶段特有 Chunk ID 判分。相关 169 项测试通过；24 条均通过结构、Release 绑定和 Gold 存在性校验。真实试跑结果为 Dense、BM25、RRF 各命中 19/20，RRF Top-K 未再出现相同 Logical ID 的重复候选；唯一共同未命中为 `eval-001`，属于可以继续分析的真实跨文档召回失败。4 条负例仍全部保留了候选，且 Rerank 服务仍报 `RERANK_SERVICE_ERROR`，所以本轮 `validForBaseline=false`，只能作优化后的诊断报告，待修复证据门控和 Rerank 后再冻结正式基线。

#### 查看知识库与向量存储（已验证）

LexarRAG 对同一批知识采用两类存储：MySQL 保存文档、版本、Release、Chunk 正文和元数据；Milvus 保存用于相似度检索的 Chunk 文本、1024 维 `dense` 向量、`kb_id` 和检索元数据。两边通过 `kb_id`、`revision_id`、`chunk_id` 对应，Milvus 是可重建的检索索引，不是原始知识的唯一副本。

- 前端：访问 `http://127.0.0.1:3001/knowledge`，可查看文档列表、上传批次、版本、Release 和 Chunk 预览，但不会展示完整的 1024 个向量数值。
- MySQL：本地容器为 `lexar-rag-mysql`，数据库为 `lexar_rag_db`；可在终端进入只读查看：

```bash
docker exec -it lexar-rag-mysql sh -lc \
  'mysql --default-character-set=utf8mb4 -uroot "$MYSQL_DATABASE"'
```

```sql
SELECT id, name, status, chunk_count, published_revision_id
FROM kb_knowledge_base ORDER BY id;

SELECT id, kb_id, revision_id, LEFT(content, 100), metadata
FROM kb_chunk WHERE kb_id BETWEEN 2 AND 5 ORDER BY kb_id, id;

SELECT id, version_number, status, target_collection, published_time
FROM kb_knowledge_release ORDER BY id;
```

- Milvus：连接地址为 `127.0.0.1:19530`，稳定别名为 `lexar_knowledge_active`。当前别名指向 Release v4 集合，已验证共有 75 条实体；KB 1～5 分别有 1、27、22、10、15 条向量记录。查看向量时不要一次打印全部 1024 维，可先检查长度和前 8 维。

日常测试定位通常不需要查看原始 1024 维向量，只保留四类证据即可：当前 Release/KB/Revision；Chunk 正文、标题和 `chunk_id`；Dense、BM25、RRF、Rerank 各阶段的 Top-K、分数和顺序；最终 Context、回答和引用。只有遇到“索引构建失败、向量数量不一致、切换 Embedding 后整体异常”时，才进一步检查 Milvus 集合、实体数量、向量维度、模型指纹和服务连通性；具体浮点数一般没有人工分析价值。

#### 完全脱离 Codex 的手动 CLI 评测

评测不需要启动前端或 FastAPI，也不需要用自然语言指挥 Codex；只要 MySQL、Milvus 和当前配置启用的 Embedding/Rerank 服务可用，就能在普通终端重复执行：

```bash
cd /Users/Admin/Documents/lexar-rag/backend
source .venv312/bin/activate

jq -c . evals/retrieval/smoke-v0.jsonl >/dev/null

python scripts/evaluate_retrieval_seed.py \
  --dataset evals/retrieval/smoke-v0.jsonl \
  --output evals/retrieval/results/baseline-v1.json \
  --top-k 5

jq '.summary' evals/retrieval/results/baseline-v1.json
jq '.cases[] | select(.id == "smoke-006")' \
  evals/retrieval/results/baseline-v1.json
```

需要把本地 JSON 发布到 Phoenix 时，先在仓库根目录启动服务，再在 `backend` 目录发布；这一步只重放已经算好的结果，不会调用 LLM：

```bash
cd /Users/Admin/Documents/lexar-rag
docker compose -f backend/evals/phoenix/compose.yml up -d

cd backend
PHOENIX_COLLECTOR_ENDPOINT=http://127.0.0.1:6006 \
  .venv312/bin/python -m scripts.phoenix_retrieval_reporter \
  --report evals/retrieval/results/baseline-v1.json
```

浏览器打开 `http://127.0.0.1:6006`。也可以在执行检索脚本时追加 `--publish-phoenix`；Phoenix 发布失败只打印 warning，不改变本地 JSON 和原有退出码。

- 退出码 `0` 且 `summary.validForBaseline=true`：本次运行没有执行错误或链路降级，可以作为该固定配置的基线。
- 退出码 `2` 且报告已生成：查看 `errorCaseCount`、`degradedCaseCount` 和逐题 `degradationReasons`，不能直接把它命名为有效基线。
- 退出码 `2` 且没有生成新报告：优先检查 JSONL 字段、Published Release、KB 范围以及外部服务配置。
- 正例重点检查各阶段 `hit`、`goldRank` 和 `topK`；负例重点检查 `falseRetrieval`。改变数据集、模型、Top-K、阈值或功能开关后必须生成新报告，不能和旧基线混算。

> [!note] 当前报告能力边界
> 已验证：检索评测执行器以 JSON 作为机器可读原始证据，并可从同一份 JSON 生成单文件中文 HTML 和中文 Excel，或可选发布到 Phoenix Web 工作台。HTML 是默认人类阅读与交付格式，Excel 适合表格筛选和人工二次分析，Phoenix 适合多次实验对比；三者都不应取代 JSON 的事实源地位。项目当前仍没有检索评测 API 或前端评测页面。
>
> 已实现并验证：`backend/scripts/retrieval_html_report.py` 复用现有确定性报告模型，展示概览、阶段指标、失败用例、全部明细、配置和内嵌 JSON 快照；CSS/少量 JavaScript 全部内联且不依赖 CDN，支持失败/降级筛选、证据折叠、打印 PDF 和窄屏阅读。问题、Top-K 预览、来源和原始 JSON 均作 HTML 转义，并使用离线 CSP；指标与结论仍由 Python 逻辑生成，不由浏览器或 LLM 另行计算。`evaluate_retrieval_seed.py` 已接入 `--html-output`；19 项检索评测/Excel/HTML/Phoenix 定向测试通过，真实 `baseline-v1.html` 已在桌面和 360px 窄屏完成视觉与交互检查。生成文件放在 `backend/evals/retrieval/results/`，与同轮 JSON 使用相同文件名主干；普通时间戳运行不入库，只保留人工确认的基线产物。当前 HTML 只是展示已有失败报告，原 JSON 仍为 `validForBaseline=false`，不能因报告样式完成就改称有效基线。

> [!success] 2026-08-10 Phoenix 最小接入
> 已接入本地 Phoenix 17.5.0 与官方 `arize-phoenix-client==2.13.0`。`backend/scripts/phoenix_retrieval_reporter.py` 把现有 JSON 映射成 Dataset 和 Experiment；`evaluate_retrieval_seed.py` 新增显式的 `--publish-phoenix`/`--phoenix` 开关。Phoenix 只负责版本化展示和实验对比，Hit、单题 reciprocal rank、错误召回、延迟和状态仍由纯 Python 确定性 evaluator 读取原报告，不调用 LLM-as-a-Judge。实测 `smoke-v0` 发布为 6 条 Dataset example、6 条 Experiment run 和 84 条 code-evaluator annotation；Phoenix/检索定向测试 14 项通过。后端全量 913 项中有 1 项既有用户重置流程测试失败（登录响应无 token），单独重跑仍失败，与本次 Phoenix 文件无调用关系，应另行排查，不能把全量套件记为通过。

> [!note] 报告插件选择
> `allure-pytest` 最接近传统自动化测试报告，支持用例层级、步骤、附件和历史趋势，但当前执行器是独立 CLI，回归测试使用 `unittest`；接入 Allure 需要先把每道种子题包装成参数化 pytest 用例，并额外安装 Allure CLI，Hit@K、MRR 等仍要自定义展示或作为附件。`pytest-html` 更轻，可以生成单个 HTML，但同样要求 pytest，且不擅长跨多次 RAG 实验比较。当前选择 Phoenix，是因为它直接支持 Dataset、逐题 Experiment、指标列和多次运行对比；只有当目标明确变成 CI 用例报告时再考虑 Allure。参考：[Allure Pytest](https://allurereport.org/docs/pytest/)、[pytest-html](https://pytest-html.readthedocs.io/en/stable/user_guide.html)、[Phoenix](https://arize.com/docs/phoenix/)、[MLflow GenAI Evaluation](https://www.mlflow.org/docs/latest/genai/eval-monitor/running-evaluation/traces/)。

Phoenix 的报告形态是持续运行的 Web 工作台，而不是一次执行生成的静态报告文件。当前 `smoke-v0` 已实测接入：Dataset 保存题目和 Gold，Experiment 结果表按题展示问题、完整 Top-K 输出、参考值以及 `dense_hit`、`bm25_hit`、`rrf_hit`、各阶段 `reciprocalRank`、`falseRetrieval`、延迟和状态；汇总 Hit Rate/MRR 保存在 Experiment metadata 的原始 summary 中。不同配置运行可并排比较；当前尚未接 OpenTelemetry/OpenInference 运行时 Trace，因此这次能分析离线逐题结果，但不能从失败行追入在线 Retriever/Reranker span。已在 Phoenix 17.5.0 的 `Settings → General` 实际核对：没有 Language/Locale 选项，内置导航和指标界面为英文；中文问题、Gold、证据和自定义说明仍可原样展示。若只为阅读可使用浏览器整页翻译；若需要稳定的中文交付物，仍应从原始 JSON 生成中文 Markdown/HTML，而不是修改 Phoenix 前端。本次发布的报告仍为 `validForBaseline=false`：Phoenix 成功只证明报告链路已接通，不能消除原报告中的 Rerank 401 降级。参考：[Phoenix Experiments](https://arize.com/docs/phoenix/datasets-and-experiments/how-to-experiments/run-experiments)、[Tracing](https://arize.com/docs/phoenix/tracing)、[Metrics Dashboard](https://arize.com/docs/phoenix/tracing/llm-traces/metrics)。

### 4. 第二阶段测试路线

> [!note] 学习路线调整（计划中）
> Gold Set 和检索评测可以直接以 LexarRAG 作为主要被测系统，这样能同时练习企业级知识版本、混合检索、重排和 Trace。首轮仍应限制为一小批可人工审核的固定知识，并先只评检索、不接生成判分；`personal-test-rag` 保留为结构简单、便于解释指标与排查评测脚本的对照基线。

首轮按阶段分别保存 Dense、BM25、RRF、Rerank 和最终上下文的有序结果，用同一份 Gold Passage 计算 Hit@K、Recall@K 和 MRR，才能判断结果在哪一层改善或退化。

#### 第一步：理解系统

梳理知识入库和问答链路，确认每一层的输入、输出、配置和 Trace 字段。

#### 第二步：建立黑盒基线

使用固定知识和问题，从用户视角验证回答、引用、拒答、权限、稳定性和延迟。

#### 第三步：建立 Gold Set

为问题标记预期来源、片段、答案要点、是否可回答、风险等级和数据集版本。

#### 第四步：白盒定位

结合 Retrieval Log 检查 Dense、BM25、RRF、Query Rewrite、Rerank 和最终上下文，确定失败发生在哪一层。

#### 第五步：功能消融

在同一评测集上逐步比较：

```text
Dense Only
→ Dense + BM25
→ 增加 Query Rewrite
→ 增加 RRF
→ 增加 Rerank
→ 增加父子扩展与上下文压缩
```

#### 第六步：版本回归

保存系统版本、知识版本、模型、Prompt 和检索配置，比较优化前后的效果、延迟和失败样本。

### 5. 后续实践顺序

- [x] 完成本地环境和依赖检查；
- [ ] 梳理一条完整请求的 Retrieval Log；
- [x] 选择小规模、可人工审核的测试知识；
- [ ] 建立并人工核对第一版 6 条种子集；
- [ ] 跑出检索基线并解释至少一个实际失败样本；
- [ ] 将种子集扩充为 30～50 条 Gold Set；
- [ ] 运行现有冒烟评测脚本；
- [ ] 增加检索层指标；
- [ ] 增加回答判分和人工抽检；
- [ ] 完成至少一组消融实验；
- [ ] 输出测试报告、失败案例和改进建议。

### 6. 实验与缺陷记录

#### 2026-08-09：LexarRAG 启动前检查

- 已验证：后端 `.env` 和 `.venv312` 已存在，Python 3.12.13 可导入 FastAPI、SQLAlchemy 与 PyMilvus；MySQL、Redis、Milvus 端口正在监听，Docker daemon 可用。
- 已验证：当前最新发布知识版本为 Release v2，包含 KB 1 `lexar-rag-smoke.md`、Revision 1 和一个 Chunk。
- 待验证：8000 端口尚未监听，API 和真实评测尚未运行。
- 环境缺口：仓库指南提到的 `docker-compose.local.yml` 在当前提交 `2ce89a3` 中不存在，因此暂时不能直接执行文档中的完整环境启动命令。
- 结论：可以直接开始最小种子集和检索基线练习；在保存结果 JSON 与失败记录前，评测结论仍标记为“待验证”。
- 下一步：先恢复或补齐本地部署方式，配置必需服务与模型，再固定一条问题追踪 `Query Rewrite → Dense/BM25 → RRF → Rerank → 父子扩展/上下文压缩 → 生成与引用`。

#### 2026-08-10：LexarRAG 本地开发启动与关闭

- 当前前端 Vite 开发服务器固定监听 `3001`，代理默认指向后端 `8002`；README 中的后端 `8000` 示例与当前前端默认代理不一致，启动时必须统一端口，或通过 `VITE_API_PROXY_TARGET` 显式指定代理目标。
- 本地开发进程按顺序可分为 API、知识 outbox dispatcher、知识 RQ worker 和索引重建 worker；它们都在 `backend/.venv312` 中运行。OCR 开关开启时，还需要单独运行 `ocr-service` 的 `8010` 服务。
- 当前 checkout 没有 `docker-compose.local.yml`，因此 README/AGENTS 中的完整 Compose 命令在本目录不能直接执行；MySQL、Redis、Milvus 以及 OCR 需要使用已有本地服务或自行启动的容器。
- 本次检查实际看到 `lexar-rag-mysql`、`lexar-rag-redis`、Milvus 依赖、`lexar-rag-ocr` 和 `lexar-rag-frontend` 容器正在运行；前端容器的 `VITE_API_PROXY_TARGET` 为 `http://host.docker.internal:8002`，而本机尚未监听 8002，因此可保留这些容器，只在宿主机启动后端 API 和所需 worker。
- 关闭前台进程使用 `Ctrl-C`；若进程已后台运行，先用端口查询命令确认 PID，再只结束对应 PID，避免误杀其他服务。该操作流程已有代码和配置依据，但尚未在本次对话中完成一次真实端到端启动验证，状态仍为“待验证”。

#### 2026-08-13：本地开发服务启动验证

- 已验证：Docker Desktop 启动后恢复 `lexar-rag-etcd`、`lexar-rag-minio`、`lexar-rag-mysql`、`lexar-rag-redis`、`lexar-rag-milvus` 和 `lexar-rag-ocr`；Milvus `9091/19530`、MySQL `3306`、Redis `6379`、OCR `8010` 可用。
- 已验证：使用 `backend/.venv312/bin/uvicorn app.main:app --host 0.0.0.0 --port 8002 --reload` 启动 API，`GET /health` 返回 `{"status":"up","name":"LexarRAG API","environment":"dev"}`。
- 已验证：`outbox_dispatcher`、`run_worker` 和 `index_rebuild_worker` 均成功监听 Redis 队列；索引 worker 完成启动恢复维护任务。
- 已验证：由于宿主机没有 `npm`，使用 Node 22 Docker 容器运行 Vite，前端 `3001` 返回 HTTP 200，代理目标为 `http://host.docker.internal:8002`。
- 当前状态：API、前端、OCR、数据库与队列服务均已启动；本次只验证健康检查和进程启动，尚未完成一次真实上传、索引发布和问答闭环，后者仍为“待验证”。

## 五、三个阶段最终要形成的能力

完成三个阶段实践后，需要能够回答：

1. 一个最小 RAG 是怎样搭建和运行的；
2. 怎样构建可靠的评测集；
3. 怎样计算检索层和生成层指标；
4. 怎样区分解析、检索、重排和生成问题；
5. 怎样用固定评测集证明一个优化确实有效；
6. 怎样将一次失败转化成可重复的回归用例。

## 六、七天学习验收标准（计划中）

每天按“能讲清楚、能独立操作、能留下证据”验收，不以看完资料或运行过一次命令作为掌握。

> [!warning] 适用边界
> 这七天是“RAG 与客服智能体评测专项”，能够覆盖伊智面试中的评测集、批量执行、检索指标、裁判校准、多轮 Agent 和失败定位，但不等于完整的伊智式 AI 测试面试准备。完整准备还需单独补充 AI 生成用例的可追溯工作流、AI 生成 UI 脚本的工程化，以及 SaaS/支付功能测试与表达训练。

执行前提：每天至少保留一段完整的实操时间；LexarRAG 的环境检查最晚在第 4 天完成。第 5 天只要求分析一条完整 Trace，不要求一天掌握或改造全部复杂链路。

| 天数 | 最低掌握程度 | 可复核证据 |
| --- | --- | --- |
| 第 1 天：最小 RAG | 能画出入库与问答链路，说明 Chunk、Embedding、检索、生成和引用各自作用；启动 API，独立完成一次同步和问答 | 一次成功问答及其检索结果、引用或运行记录 |
| 第 2 天：Gold Set 与检索评测 | 能说明 Gold Source、Hit@K、MRR、拒答准确率和延迟；能人工核对种子集并运行第一份基线；能解释至少一个失败样本 | 固定版种子集、检索结果 JSON、失败样本记录 |
| 第 3 天：答案评测 | 能区分回答正确性、Faithfulness、相关性和引用正确性；能为小样本标注答案要点，设计判分 Rubric，并用人工结果校准裁判；至少包含一组客服话术业务样本，不能只测技术笔记 | 带 `reference_points` 的用例、人工与裁判对照结果 |
| 第 4 天：多轮 Agent 与工具调用 | 能区分最终答案评测和轨迹评测；检查工具名称、参数、权限、幂等、业务结果和失败兜底；用小规模模拟对话验证，不要求搭建完整多 Agent 平台 | 多轮用例、工具 Trace、确定性断言和至少一个失败轨迹 |
| 第 5 天：LexarRAG 单链路分析 | 能把 Dense、BM25、Query Rewrite、RRF、Rerank、父子切片和上下文压缩放回完整链路；只选一条请求，用 Trace 判断结果在哪一层变化 | 一条完整请求的链路图与 Retrieval Log；环境未跑通只能标记“理解”，不能标记“已验证” |
| 第 6 天：报告与失败案例 | 能写清环境、数据集、配置、指标、失败、结论和限制；失败案例能够复现，并能给出有证据的改进方向 | 一份基线评测报告和至少 2 个可复现失败案例 |
| 第 7 天：面试表达 | 能按“结论—步骤—业务例子—指标”回答评测集来源、批量执行、裁判校准、RAG 召回、多轮 Agent 和失败定位；能区分已实现、已验证和计划中 | 一次录音或文字模拟回答、计时结果和追问清单 |

阶段完成不等于掌握全部公式或复杂框架。七天结束时的最低目标，是能够独立完成并解释一个最小 RAG 评测闭环，再把同样的方法迁移到 LexarRAG。

## 七、面试中的能力边界

后续表达统一采用：

> 我已经实现了什么；哪些内容经过了真实运行验证；哪些是我在 LexarRAG 中完成的测试与评测；哪些仍然只是下一步计划。

不把代码存在等同于运行验证，也不把学习方案描述成生产项目经验。

## 八、第三阶段：AI 测试用例 RAG 平台

项目入口：`/Users/Admin/Documents/testcase_ai_/README.md`。

### 1. 已落地并验证的主流程

```text
项目业务知识包
→ 文档解析与切片
→ Embedding 与版本化索引
→ Dense + BM25 + RRF 混合检索
→ 带来源证据的结构化用例生成
→ 证据一致性检查
→ JSON/XLSX 导出
→ 人工确认后回写正式用例库并重新索引
```

- `home-service` 默认业务包已迁移 40 份知识源，其中 16 份正式业务用例工作簿包含 2,179 条非空用例；首次同步生成 2,486 个 Chunk，第二次无变更同步复用同一 Revision，没有重复建版本。
- 使用本地 Ollama `bge-m3`、MySQL 和 Milvus 完成真实索引；自然语言查询“用户付款后申请退款，之前使用的优惠券应该退回来吗”时，正式用例 `TC-RAG-0708`、`TC-RAG-0710` 排在前两位。
- 30 条人工 Gold Query 均引用真实存在的正式用例 ID。在 Query Rewrite 和 Rerank 关闭的配置下，实测 `HitRate@10 = 1.0`、`Recall@10 = 1.0`、`MRR@10 = 0.9611`，通过 0.80 的验收阈值。
- `ecommerce-demo` 使用同一套代码完成独立同步和检索，未修改平台核心代码，证明“核心平台 + 可替换业务知识包”的隔离方式可以复用到电商领域。
- FastAPI 的健康检查和检索接口均返回 200；数据库迁移已到当前 Head；代码质量检查通过，自动化测试 11 项通过。

### 2. 生成验证暴露出的关键问题

本地 `qwen3:1.7b` 已完成一次退款边界用例生成，但模型对部分金额边界给出了与正式用例证据冲突的预期结果。因此平台增加了证据一致性门禁：生成结果与引用用例的预期结果不一致时，不允许直接标记为可采纳，而是把生成任务置为 `needs_clarification`，保留问题给人工复核。

> [!important] 已确认的实践结论
> 检索评测通过，只能证明正确证据能被召回，不能证明模型会忠实使用证据。测试用例生成至少要分别验收“召回是否正确”“引用是否真的支持结论”“结构是否符合契约”“是否经过人工确认”，不能只看最终文本是否像一条测试用例。

### 3. 当前能力边界

- Query Rewrite 与 Rerank 目前只保留项目级配置开关，尚未接入实际检索链路；当前基线是 Dense + BM25 + RRF。
- 重复检测目前是精确内容指纹，不是语义相似度去重；语义阈值去重仍是下一阶段能力。
- 审批回写的备份、临时文件、原子替换、幂等和重索引已经在临时业务包中验证；为了保护正式资产，尚未对 16 份正式 Excel 做破坏性回写演练。
- 当前 30 条评测集用于检索层验收；生成质量还需要继续扩充带答案要点、证据支持关系和人工结论的生成评测集。
- 当前 30 条检索评测均为有答案正例，每条都提供明确 `module`，并默认只检索 `approved_case`，统一取 `Top10`；而生产生成链路以“需求标题 + 模块提示 + 正文”为 Query、不限制知识来源类型，并按项目配置取 `Top12`。因此现有 `HitRate@10 = 1.0`、`Recall@10 = 1.0` 只能证明“已知模块内的正式用例召回”表现良好，不能覆盖业务规则召回、跨模块需求、无答案误召回或真实生成上下文的整体质量。
- 计划中：新增一份与生成链路同口径的检索集，包含完整需求 Query、`module=null` 的跨模块问题、业务规则与正式用例的多证据标注、相似干扰项和无答案负例；同时观察 Hit@K、Recall@K、Precision@K、MRR、负例错误召回率和延迟。生成层再分别使用 Gold Passage 与真实检索上下文执行同一批需求，以隔离检索错误和生成错误。

### 4. `home-service` 知识同步的输入边界（已实现）

知识同步只扫描 `projects/home-service/project.yaml` 的 `sources`；正式用例来源是 `projects/home-service/knowledge/approved-cases/modules/*.xlsx`，并排除 `模块索引.xlsx`、Excel 临时锁文件和备份文件。`legacy/cases/modules_backup_20260423_175748/` 是历史备份目录，不是知识源；只修改这里再调用同步接口，不会改变已发布知识版本。

手工维护正式 Excel 时，先把修改保存到正式知识源目录，再调用 `POST /api/v1/projects/home-service/knowledge/sync`。`POST /api/v1/projects/home-service/validate` 只做清单与路径预检查，检索接口只用于同步后的抽查，二者都不是必需的同步步骤。通过平台审批生成草稿时应调用审批接口；该流程写入正式工作簿后会自动触发知识同步，不需要再手工重复调用同步接口。

### 5. 测试用例优化时的修改对象（已实现）

- 优化某条现有正式用例的步骤、数据、前置条件或预期结果：以 `projects/home-service/knowledge/approved-cases/modules/{模块}.xlsx` 为基准制作草稿，评审通过后再合并回正式工作簿。
- 发现业务事实、状态流转、金额或权限规则本身缺失或错误：先修改 `projects/home-service/knowledge/business-rules/modules/{模块}.md`，再据此补充或修正用例，避免只把正确规则写在 Excel 中。
- 希望以后所有 AI 草稿遵循新的通用质量要求：优先修改项目级 `knowledge/policies/业务测试约束.md`；只有跨项目通用的输出契约才修改平台 Prompt。

安全流转顺序是：`正式工作簿副本 → outputs/home-service 草稿优化 → 人工评审 → 合并正式工作簿 → 知识同步 → 检索或评测抽查`。`legacy` 只用于历史追溯和恢复，不作为优化工作的起点。

### 6. 需求输入接口与生成接口的关系（已验证）

`POST /api/v1/requirements` 与 `POST /api/v1/requirements/upload` 是两种可替换的需求输入方式，不是必须依次调用的上下游接口：前者校验手工提交的 `title + content`，后者把 `.md`、`.markdown`、`.txt` 或 `.docx` 解析为同一个 `RequirementInput`。两者都不保存需求、不检索知识，也不生成测试用例。

```text
手工文本 ─→ /requirements ─────────┐
                                   ├→ RequirementInput → /testcase-generations
需求文件 ─→ /requirements/upload ──┘
```

手工文本也可以跳过单独的校验接口，直接作为 `POST /api/v1/testcase-generations` 请求体中的 `requirement`；文件上传则需要先复制解析结果，再调用生成接口。项目知识首次使用或知识源变更后先执行知识同步，日常生成不必每次重复同步。首次冒烟测试先验证到生成与导出，暂不调用审批接口，因为审批会修改正式用例工作簿并自动重新索引。

生成格式只选择 `json` 时，文件固定写入 `outputs/{project_id}/{generation_id}/testcases.json`；接口响应的 `artifacts.json` 会返回同一文件的绝对路径。

2026-08-16 已在本地运行中的 FastAPI 实测两个需求入口均返回 HTTP 200，并统一返回 `title`、`content`、`source_name`；同时确认 MySQL、Milvus、Ollama 及所需生成/Embedding 模型可用。

### 7. 测试用例生成接口的内部链路（已实现）

`POST /api/v1/testcase-generations` 是同步 RAG 生成接口：一次请求内完成版本锁定、知识检索、模型生成、质量门禁、导出和结果持久化，调用方会等待完整结果返回。

```text
校验项目与当前知识 Revision
→ 创建 running 生成记录
→ 标题 + 模块提示 + 正文组成检索 Query
→ bge-m3 Dense + BM25 + RRF 检索证据
→ 项目规则 + 需求 + 证据组成 Prompt
→ qwen3 生成严格结构化 JSON（格式错误最多修复一次）
→ 丢弃无效证据 ID、检查正式用例引用一致性、精确去重
→ succeeded / needs_clarification / failed
→ 导出所选文件并把完整结果写回 MySQL
```

任务开始时固定 `active_revision_id`，避免生成过程中知识同步导致证据漂移。`module_hint` 不只是给模型看的提示，也会作为精确检索过滤条件；跨模块需求可设为 `null`。接口不会把本次需求自动加入知识库，不会修改正式用例 Excel，也不会自动审批或重新同步知识；这些属于独立流程。

响应中的 `cases` 是模型生成并通过结构与质量校验后保留的草稿用例；`evidence` 是本次生成实际使用的 Top-K 检索证据。后者返回知识 Chunk 而非整份文档：`source_type=approved_case` 且带 `case_id` 表示命中的正式用例，`source_type=business_rule` 表示命中的业务规则片段，也可能出现 workflow、policy、requirement 等其他项目知识类型。需要只观察检索结果时，应单独调用 `POST /api/v1/retrieval/search`。

独立检索接口接收 `project_id + query + module + source_types + top_k`，不接收生成接口的嵌套 `requirement` 或 `output_formats`；需求标题和正文应合并成一个 `query` 字符串。2026-08-16 使用“支付与结算”需求、限定 `approved_case` 与 `business_rule` 实测返回 12 条证据，包含订单业务规则 Chunk 和多条带 `case_id` 的正式用例；该调用不生成新用例、不导出文件，也不修改知识库。

### 8. 本地日常启动边界（配置已核对）

`testcase_ai_` 与 `personal-test-rag` 是两个独立项目，不能混用 Docker Desktop 中的 Compose 容器组：前者需要 MySQL、etcd、MinIO 和 Milvus；后者的容器组只提供 PostgreSQL + pgvector，不能作为测试用例平台的数据服务。

当前本地配置使用 Ollama，因此日常启动顺序是：

```text
Ollama 可用
→ 启动 testcase_ai_ 的 4 个 Compose 容器并等待 MySQL、Milvus healthy
→ 在 /Users/Admin/Documents/testcase_ai_ 运行 uv run testcase-ai serve
→ 访问 http://127.0.0.1:8000/health 或 /docs
```

本机已安装 `/Applications/Ollama.app`，推荐直接打开应用，或在终端执行 `open -a Ollama`，让 API 服务在后台运行。排错时也可以执行 `ollama serve` 在前台启动并观察日志，但该终端需要保持打开，按 `Ctrl-C` 会停止服务。启动后用 `ollama list` 或访问 `http://127.0.0.1:11434/api/version` 检查服务；不需要预先执行 `ollama run`，测试用例平台请求模型时会按需加载。参考：[Ollama macOS](https://docs.ollama.com/macos)、[CLI Reference](https://docs.ollama.com/cli)。

Docker Desktop 中点击 `testcase_ai_` 容器组的启动按钮，等价于在仓库根目录执行 `docker compose up -d mysql etcd minio milvus`。`uv run testcase-ai serve` 只启动 FastAPI，不会代替 Docker 数据服务或 Ollama，也不会自动建立知识索引。

`uv sync --extra dev`、复制并配置 `.env`、拉取模型属于新环境安装步骤；`uv run alembic upgrade head` 应在首次初始化或代码新增数据库迁移后执行；`uv run testcase-ai knowledge sync --project <项目ID>` 应在项目首次使用或知识源发生变化后执行，日常启动不必每次重复同步。

### 9. 生成结果可视化与评审报告（报告已验证，页面计划中）

当前适合增加一个内部使用的最小“生成与审核页”，但不适合立即建设完整管理后台。生成、结果查询、继续澄清、JSON/XLSX/HTML 下载和显式审批接口均已存在，页面可以降低直接阅读大段 JSON 的成本，并把“草稿用例 → 引用证据 → 澄清 → 人工选择 → 审批”串成可操作闭环。2026-08-17 在当前工作树运行 `uv run pytest -q`，21 项测试通过；`uv run ruff check src tests` 通过。

第一版只需要需求输入、生成状态、用例列表、引用证据侧栏、澄清提交、选中审批和文件下载；页面直接消费现有 API，不能另写检索、证据判定、重复检测或审批规则，原始 JSON 仍是事实源。登录、多角色、仪表盘、复杂导航、异步任务中心和视觉精修继续保持在一期之外。

开始页面实现前，先用少量真实需求继续验证 `succeeded`、`needs_clarification` 和 `failed` 三类结果，并补足生成/查询/澄清/下载/审批的 HTTP 集成测试。页面完成只能证明人工操作更方便，不能替代与真实生成链路同口径的检索评测、生成质量评测或正式 Excel 审批演练。

> [!warning] 2026-08-17 单次生成结果的评审信号（已验证）
> 本地结果 `outputs/home-service/1df147a5-1fa1-4b7b-afca-1ab27179fd89/testcases.json` 对应“支付与结算需求”：状态为 `needs_clarification`，保留 9 条草稿，检索 12 条证据，跳过 1 条与正式用例完全重复的草稿，并返回 1 条澄清问题。9 条草稿全部为 `inferred`、引用数均为 0、`coverage_tags` 均为空且每条只有一个步骤；其中多条在测试路径、步骤和预期结果上高度重复，仅支付方式不同，现有精确去重只与正式用例比较，没有消除同批生成结果内部的重复。这些结构信号足以把本次结果标为“不可直接审批、需要逐条复核”，但不能单凭结构统计判断业务预期是否正确。
>
> 已实现并验证：单次评审报告从同一份 JSON 自动生成概览、阻断项、用例审查表、覆盖分布、证据映射、澄清项、重复项和已转义的原始 JSON；第一版只使用确定性规则，不虚构综合质量分。新任务默认输出 `testcases.json`、带“生成评审”工作表的 `testcases.xlsx` 和离线 `review.html`，历史任务可通过下载接口或 `testcase-ai report` 补生成 HTML；报告不显示服务器绝对产物路径。截图对应的真实结果已生成 `review.html`，并在 1440px 桌面和 390px 窄屏完成视觉检查，能够直接显示 0% 引用覆盖、0% 证据利用、待澄清和同批重复等阻断信号。

### 10. 主链路可视化调试台（已实现）

2026-08-18 已落地 FastAPI 同源的本地统一工作台：`GET /workbench?generation_id={id}`。它把需求与任务状态、准实时 Trace、阶段摘要、用例与证据评审、澄清、审批资格和 JSON/XLSX/HTML 下载放在一个页面，但没有把原有交付物合并成第二套数据。JSON 仍是机器可读事实源，Excel 仍用于逐条人工审核，`review.html` 仍是可离线打开的静态快照，审批仍只由后端服务执行。

生成服务已拆成“准备任务 + 执行任务”。准备阶段校验项目并把当时的 `revision_id` 写入 `generation_runs`；后续 Dense、BM25、RRF 和正式库去重都显式使用这个锁定版本，即使任务执行前项目的 `active_revision_id` 被修改或清空，也不会漂移到别的知识版本。同步接口继续直接执行；异步接口使用 FastAPI 进程内单线程执行器，先返回 `202 + generation_id + workspace_url`，页面每秒轮询一次新增事件。服务启动时遗留的 `queued/running` 任务会改为 `failed + execution_interrupted` 并追加失败 Trace，不自动重试。

新增的异步接口包括：

- `POST /api/v1/testcase-generation-jobs`：创建任务并立即返回；
- `GET /api/v1/testcase-generation-jobs/{id}`：读取请求、状态、结果、评审、审批资格和审批摘要；
- `GET /api/v1/testcase-generation-jobs/{id}/trace?after_sequence=N`：按游标增量读取 Trace；
- `GET /api/v1/testcase-generation-jobs/{id}/trace/evidence/{evidence_id}`：按任务锁定版本读取证据正文；
- `POST /api/v1/testcase-generation-jobs/{id}/continue`：保留父结果并创建澄清后续任务。

`generation_trace_events` 以 `generation_id + sequence` 唯一标识阶段事件，记录阶段名、运行状态、开始/完成时间、耗时、脱敏摘要和错误码。已接入的固定主链路是“初始化 → Dense → BM25 → RRF → Prompt → 模型 → Schema 校验 → 可选 Schema 修复 → 引用落地 → Grounding → 正式库去重 → 文件导出 → 结果持久化”。Trace 只保留数量、过滤条件、证据 ID、排名、分数、Hash、长度、耗时和脱敏错误，不保存 API Key、完整 Prompt、模型原始响应或证据正文；正文只能通过版本受限的证据详情接口按需读取。

审批资格已提取到唯一策略，`review.html`、Excel、工作台和 `ApprovalService` 共用。生成失败、无用例、全局或无法匹配用例的澄清会阻断全部审批；明确关联具体用例的澄清、`evidence_status=needs_clarification` 和未知证据引用只阻断对应用例；推断用例、缺覆盖标签、单步骤和同批重复只告警。评审结论新增“部分用例阻断”，页面只能勾选后端判定可审批的用例，并明确提示一次任务部分审批后不能再次追加。

工作台使用原生 HTML/CSS/JavaScript，无 Node 前端工程和外部资源；业务文本统一通过 `textContent` 渲染，页面配置同源 CSP。历史任务没有 Trace 时仍可查看最终结果、评审和下载，并显示“历史任务无阶段数据”。首版仍明确不包含 SSE、Redis、独立 Worker、登录、多角色、任务取消/重试、在线编辑和跨任务统计。

#### 10.1 已验证结果

本轮在当前工作树完成以下验证：

- Ruff 与 `git diff --check` 通过，自动化测试由原 21 项增至 41 项并全部通过；
- 原同步生成、查询、澄清、JSON/XLSX/HTML 导出、CLI 和审批主链路保持兼容；原四份公开 Schema 未改变，新 Job/Trace/评审/审批契约单独导出；
- 正常后台任务按固定顺序写入 Trace，并且只生成一套 JSON、XLSX 和 `review.html`；
- 首次 Schema 校验失败、第二次修复成功时，能够看到失败的校验事件和成功的修复事件；模型异常会形成脱敏失败事件和任务失败终态；
- 进程中断恢复会关闭仍在运行的阶段并追加 `execution_interrupted`；历史无 Trace 任务仍可读取；
- Alembic 可从空库升级到 `0002_generation_trace_events` Head；构建出的 wheel 包含工作台 HTML、CSS 和 JavaScript；
- 工作台已在 1440×900 桌面和 390×844 窄屏实测，Dense/BM25 阶段、候选排名、部分阻断、用例与证据、澄清、审批和下载均可显示，浏览器控制台无错误。
- 新建任务表单曾因页面标题与“需求标题”输入框重复使用 `create-title`，JavaScript 取到标题元素后在读取 `.value` 时中断，表现为按钮已点击但后端没有 POST、数据库也没有新任务；已改为唯一 DOM ID，并增加页面 ID 唯一性回归测试。排查“任务一直未完成”时，应先按“浏览器是否发出 POST → 服务是否收到请求 → `generation_runs` 是否创建记录 → Trace 最后阶段”逐层确认，不能直接假定模型调用卡住。
- Trace 事件在阶段开始时以 `running` 写入，并在结束时原地更新同一个 `sequence`；增量游标如果第一次看到 `running` 就越过该 sequence，页面将永远收不到后续终态与 `duration_ms`，表现为阶段一直显示省略号和 `—`，终态后仍持续轮询。现已改为游标只越过终态事件，前端按 sequence 覆盖旧事件，并在运行阶段根据 `started_at` 显示动态已用时间。实测任务 `cde5cbe0-ae6c-4c5e-93b0-0f2d0eef46d1` 已正常完成：Dense 3.104 秒、BM25 12.092 秒、RRF 1 毫秒、模型 30.182 秒。

这次实践确认了一个重要边界：可视化解决的是“更快理解一次运行发生了什么”，不是替代 RAG 质量评测。Trace 适合定位阶段、版本、排名和失败点；JSON/Excel/HTML 适合评审一次最终结果；跨任务 Hit@K、MRR、错误召回和生成正确性仍需要独立评测集与实验报告。

### 11. 当前召回机制（已实现）

当前测试用例平台使用“先隔离候选范围，再双路召回，最后按排名融合”的混合检索：

```text
Query
→ 按 project_id + revision_id + 可选 module/source_type 过滤
→ Dense 语义召回 Top-K ─┐
                          ├→ RRF 按名次融合 → 最终 Top-K 证据
→ BM25 关键词召回 Top-K ─┘
```

- Dense：用同一个 Embedding Provider 分别向量化知识 Chunk 和 Query，在 Milvus 中按余弦相似度检索，擅长匹配用词不同但语义相近的内容。
- BM25：直接对过滤范围内的 Chunk 正文计算关键词相关度；中英混合分词保留英文/数字词元、整段中文字符和中文二元组，补足用例编号、专有词和精确业务术语。
- RRF：不直接相加两路原始分数，而是按每一路的排名累计 `1 / (rrf_k + rank)`；同一 Chunk 同时进入两路前排时会得到两次加分，因此通常更容易排到最终结果前面。
- 版本边界：正式生成固定任务创建时的知识 `revision_id`；普通独立检索默认使用项目当前生效版本，避免不同版本的 Chunk 混召回。
- 当前边界：Query Rewrite 和 Rerank 只有配置开关，尚未进入执行链；融合结果没有相关度阈值过滤，因此最终 Top-K 是候选排序结果，不等于每条都已被证明业务相关。

`ecommerce-demo` 当前配置为 Dense Top-10、BM25 Top-10、RRF `k=60`，融合后返回 Top-8。这里三个 Top-K 分别控制两路粗召回候选数和最终交给下游的证据数，不能混为同一个参数。

### 12. 测试意图优先的用例生成链路（工程已实现并验证）

2026-08-19，`testcase_ai_` 新增项目级 `generation.strategy`：未声明时继续使用 `direct`，本地 `home-service` 启用 `intent_first`。新链路不再把一次宽召回结果直接交给模型生成完整用例，而是先建立可审查的覆盖计划：

```text
加载 LLM 测试设计规则
→ 仅召回 policy / business_rule / workflow / glossary / api_spec
→ 规划结构化测试意图
→ 按意图补充规则并单独召回 approved_case
→ 判断 covered / partial / new / needs_clarification
→ 只为 partial / new 生成草稿
→ 引用、Grounding、正式库精确重复和同批重复门禁
```

这个拆分解决了两个原有问题：一是正式用例不会在规则规划阶段混入并被误当成业务真值；二是正式库已经完整覆盖的意图只返回只读 `reused_cases`，不会再次生成草稿。`partial` 必须保留匹配正式用例和具体差异，`new` 才生成完整新草稿；审批仍只读取 `cases`。

初始规则召回不使用严格模块过滤，`module_hint` 只加入 Query；逐意图检索先查意图模块，模块内无候选时退回跨模块 Top-5。金额、退款、佣金、权限、审核、保险和分账等高风险结论如果没有包含相应业务概念的规则证据，会把对应意图转为澄清；安全的其他意图仍可继续生成和审批。通用边界、异常和健壮性意图可以标记为 `inferred`，但必须保存测试方法依据。

正常任务最多经过测试意图规划、覆盖判断和缺失用例生成三个模型阶段；每个阶段的 JSON Schema、意图 ID、正式用例 ID 和 evidence ID 校验失败时只修复一次，再次失败则任务失败。澄清续跑沿用父任务锁定的知识 Revision，避免回答前后知识版本漂移。平台级规则只维护在根目录 `policies/LLM测试用例生成规则.md`，开发环境优先读取该文件，wheel 内打包同一文件作为兜底；Trace 只保存来源、长度和 SHA-256，不保存规则正文。

结果契约新增 `test_intents`、`coverage_matches` 和 `reused_cases`，历史 JSON 缺少这些字段时按空列表读取。Excel 的“全部用例”仍只保存可审批草稿，并新增“覆盖计划”和“复用正式用例”；HTML 与工作台可按意图查看规则依据、覆盖原因、正式用例差异和新草稿，复用正式用例没有审批选择框。

#### 12.1 当前验证边界

- 自动化覆盖 `direct` 默认兼容、三阶段调用与一次修复、四类覆盖决策、规则/正式用例召回隔离、错误模块回退、高风险意图级澄清、正式用例只读复用、部分覆盖差异草稿、异步任务、澄清续跑 Revision、历史结果、JSON/XLSX/HTML 和审批隔离。
- 当前工作树 `uv run pytest -q` 共 58 项通过，`uv run ruff check src tests scripts`、JavaScript 语法检查、Schema 一致性和 `git diff --check` 通过。
- wheel 已构建并安装到独立临时环境，确认工作区规则不存在时能从 `testcase_ai/resources/LLM测试用例生成规则.md` 加载同一份规则。
- 尚未用真实 LLM 和人工业务评审集证明 `covered` 错误复用数为 0，也尚未基于真实样本调优逐意图 Top-5；因此当前状态是“工程落地和自动化验证完成，真实模型业务验收待执行”，不能宣称生成质量已经达标。

#### 12.2 独立召回调试与 `intent_first` 口径统一（已实现并验证）

2026-08-20，工作台移除旧的“全知识召回”调试语义，将入口改为“调试初始规则召回”。`POST /api/v1/retrieval/debug` 由后端固定只允许 `policy / business_rule / workflow / glossary / api_spec` 五类来源，不使用模块过滤，也不再接受调用方传入 `module` 或 `source_types`；`module_hint` 仅作为 Query 的一部分帮助召回。即使绕过页面直接调用接口，也不能把 `requirement` 或 `approved_case` 混入该候选池。

正式用例仍只在测试意图规划完成后，按意图通过独立的 `approved_case` 检索进入覆盖判断。通用 `POST /api/v1/retrieval/search` 保留给显式知识查询，但不代表生成链路的初始召回范围，工作台不再提供“全部知识召回”入口。自动化已验证初始候选池会排除正式用例、非法来源覆盖参数返回 422，并通过 58 项全量测试、Ruff、JavaScript 语法检查、Schema 导出、wheel 构建和本地工作台页面检查。

#### 12.3 需求级系统版本与产品档位（已实现并验证）

本轮把原先逐条测试用例的 `applicable_versions` 语义收敛为需求级作用域，避免把不同维度的“版本”混在一起：

```text
RequirementInput.scope
├── system_version       系统业务版本
├── product_tier         目标产品档位
├── upgrade_from_tier    升级前档位（升级场景）
└── upgrade_to_tier      升级后档位（升级场景）
```

- `project.yaml` 可声明 `requirement_scope.system_versions` 和 `product_tiers`，工作台创建任务时按项目清单提供选择；若项目未声明该配置，页面只显示“全部/不限定”等默认项，不能凭知识正文自动推断选项。`ecommerce-demo` 已配置 `1.0`、基础版、升级版、尊享版；`home-service` 已配置系统版本 `2026.08` 和标准版、升级版、尊享版。
- 需求作用域会进入检索 Query、模型 Prompt、Trace 和 Excel 顶部元数据；新生成的 `TestCaseV1`、测试意图和复用快照不再输出单条“适用版本”字段。
- 升级场景要求同时填写原档位与目标档位，且两者不能相同；未指定作用域时，只有证据显示版本/档位会改变预期时才产生对应澄清问题。
- 历史 JSON、旧模型 Trace 和含“适用版本”列的旧 Excel 仍可读取/审批写回；旧字段会被忽略，不会重新进入新结果。解析器不再把旧 Excel 版本列写入知识 Chunk。
- `KNOWLEDGE_INDEX_FORMAT_VERSION` 已升到 `3`，因此下一次知识同步会为解析口径变化创建新的 Revision，旧 Revision 仍保留用于回滚；本轮只完成代码和自动化验证，尚未对真实业务库执行同步。
- 工作台新增 `GET /api/v1/projects` 自动发现接口：扫描有效 `project.yaml`，从数据库活动 Published Revision 判断 `knowledge_ready`；前端显示知识库名称和 `project_id`，未同步项目保留展示但禁用。当前实际扫描到 `ecommerce-demo` 和 `home-service`，并已验证 `home-service` 的 `2026.08`、标准版、升级版、尊享版配置可被读取。

已验证：`uv run pytest -q`、`uv run ruff check src tests scripts`、`git diff --check` 和工作台 JavaScript 语法检查均通过；另外用旧扁平作用域请求和旧逐用例版本字段做了兼容性断言。

### 13. 澄清答案回写需求知识（工程已实现并验证）

当前工作台在填写全部澄清答案后提供“仅继续生成”与“继续生成并创建知识草案”的整批确认。继续生成仍沿用父任务锁定的旧 Revision；知识草案在独立后台执行器中推荐最多三个目标并生成可编辑项，一条答案可以拆成多个文档项。原问题、原答案、原因和影响范围作为不可变快照保存在 `knowledge_change_proposals` 与 `knowledge_change_items`，二次编辑只更新草案版本，不覆盖原答案。

草案项限定 `requirement`、`business_rule`、`workflow`、`api_spec`、`glossary` 五类业务 Markdown 来源，支持追加章节、替换章节正文、新增章节和新建文档。工作台展示只读问题语境、目标候选、编辑正文和 Unified Diff；保存、重新起草、驳回和发布均为显式操作，更新与发布提交 `expected_version`，过期版本返回 409。切换目标保留当前正文并标记可能不匹配，只有用户确认“按当前目标重新起草”才允许模型覆盖正文。

批量发布在项目级锁内完成 Hash 校验、重叠修改检查、备份、临时文件原子替换和知识同步；同一批选中项只生成一个新 Revision，未选项保持草稿。文件被外部修改、同步失败或进程中断时不会静默覆盖正式知识，失败会恢复旧文件并保留审计信息。发布成功后才显示“基于此知识版本重新生成”，由用户手动创建精确锁定该 Revision 的新任务；未发布草案不会进入 RAG。

已验证：新增 Alembic `0003_knowledge_change_proposals` 迁移、知识变更 REST/OpenAPI 契约及 JSON Schema；Markdown 嵌套标题定位、四类修改、路径逃逸、显式版本冲突和现有接口兼容测试通过。`uv run pytest -q` 与 `uv run ruff check .` 全部通过。当前仍是本地单用户版本，DOCX 仅作为只读上下文，真实模型业务质量和生产并发演练需另行验收。
