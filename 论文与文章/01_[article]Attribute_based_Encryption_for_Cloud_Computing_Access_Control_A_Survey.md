# Attribute-based Encryption for Cloud Computing Access Control: A Survey

https://dl.acm.org/doi/epdf/10.1145/3398036

基于属性的云计算过程控制的加密方法：一个调查

论文的开始介绍一下

## 组成人员

![image-20260405211213914](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260405211213914.png)

分别是

1. 西安邮电大学——[YINHUI ZHANG](https://gr.xupt.edu.cn/info/1235/6771.htm)  与新加坡管理大学有深度合作 
2. 新加坡管理学院——[Robert H. Deng](https://faculty.smu.edu.sg/profile/robert-h-deng-891)，[Shengmin Xu](https://ccs.fjnu.edu.cn/15/99/c16741a333209/page.htm)，Jianfei Sun
3. 西安邮电大学——[Dong Zheng](https://www.xiyou.edu.cn/info/2407/70272.htm)

以及头衔

## ABE的基本介绍

![image-20260405212141953](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260405212141953.png)

下面是我对于上述文章的泛读 也就是随便翻译理解的

```
基本属性加密对于云上计算权限控制在本文被审阅，
一个分类学（taxonomy）和对于ABE综合（comprehensive）评估（assessment）标准（criteria）被第一次被建议（proposed）在分类学，ABE主题是被归类（assorted）到密钥策略（key-policy）主题中的，密文（ciphertext）策略ABE主题，反量子（anti-quantum）ABE主题和通用结构（generic constructions)。在依据（accordance）密码学（cryptographically）的功能特点，密文策略ABE是依据其基本特性（regard to basic functionality）被进一步划分（further divided)为9个子分类（subcategories）：基本功能，撤销机制（Revocation），可溯源（accountability），隐藏策略（Policy Hiding），策略更新（Policy Updating），多方认证机构（Multi-authority），分层架构（Hierarchy），离线计算（offline computation），外包计算（Outsourced computation），此外，一个系统的方式对于讨论和比较存在的ABE主题被关注，对于密钥策略的ABE和不同类型的密文策略ABE，对应的访问控制权限常见可以被呈现和被具体的事情所解释，特别的，我们首先给出ABE的语法 其次给出对抗模型和安全目标，本文对ABE模型讨论的是依据设计策略和特性比较在对于安全和性能的评估场景，与前言的论文相比，本文不仅提供了12中不同的ABE模型，还做出了综合性和整体性的比较，最终一个对于ABE模型的文件被提出
```

Gemini翻译

```
本文对用于云计算访问控制的属性基加密（ABE）进行了综述。

首先，提出了一种 ABE 的分类法（Taxonomy）和综合评估标准。在该分类法中，ABE 方案被归类为：密钥策略 ABE（KP-ABE）方案、密文策略 ABE（CP-ABE）方案、抗量子 ABE 方案以及通用构造（Generic Constructions）。

根据密码学的功能特性，CP-ABE 被进一步细分为九个子类别，涉及：基础功能、撤销机制、可追溯性（Accountability）、策略隐藏、策略更新、多权威机构、分层架构、离线计算以及外包计算。此外，文中还提出了一套系统的方法论，用于讨论和比较现有的 ABE 方案。

针对 KP-ABE 和每一类 CP-ABE，文中都给出了相应的访问控制场景，并通过具体案例进行了说明。具体而言，文中先给出了 ABE 的语法（Syntax），随后介绍了对手模型（Adversarial Model）和安全目标。文章根据设计策略和特殊功能对 ABE 方案进行了讨论，并根据所提出的评估标准，从安全性和性能两个维度进行了对比。

与相关的最新综述论文相比，本文不仅提供了涵盖 12 个类别的更广泛的 ABE 方案分类，还进行了更全面、更整体的对比。最后，指出了 ABE 领域中存在的一些开放性研究挑战。
```

可以发现 这个就是一个全文的概述 并且为什么我的论文好的意思（更全面、更整体的对比）

那么第一段的完整内容就是如下：

1. 简单叙述了 ABE是什么
2. 在本文中我们对 ABE 分类为多少个
3. 对于CP-ABE 我们又具体划分了9个子类别
4. 对于不同的ABE 我们都给出了 访问控制场景 并且在安全和性能中比较
5. 最后说明本文的优势

那么下面就是 对本文工作资助的展示

![image-20260405220131439](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260405220131439.png)

包括 资助者 作者详情 和论文的许可相关的声明

# INTRODUCTION

这里开始正式的论文介绍 

# 单词记录

分类学（taxonomy）

综合（comprehensive）

评估（assessment）

标准（criteria）

被建议（proposed）

密钥策略（key-policy）

依据（accordance）

归类（assorted）

密文（ciphertext）

密码学（cryptographically）

反量子（anti-quantum）

进一步划分（further divided)

依据其基本特性（regard to basic functionality）

子分类（subcategories）