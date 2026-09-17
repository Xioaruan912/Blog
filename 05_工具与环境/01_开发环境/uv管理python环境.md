MAC/Linux

```
curl -LsSf https://astral.sh/uv/install.sh | sh
```

WIN

```
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

可以快速构建项目

```
uv python install：安装 Python 版本。
uv python list：查看可用的 Python 版本。
uv python find：查找已安装的 Python 版本。
uv python pin：将当前项目固定到使用特定 Python 版本。
uv python uninstall：卸载 Python 版本。
```

```
执行独立的 Python 脚本，例如 example.py。

uv run：运行脚本。
uv add --script：向脚本添加依赖。
uv remove --script: 从脚本中移除依赖

```

```
建并处理 Python 项目，例如，使用 pyproject.toml。

uv init: 创建新的 Python 项目。
uv add: 向项目添加依赖。
uv remove: 从项目中移除依赖。
uv sync: 将项目的依赖与环境同步。
uv lock: 为项目的依赖创建锁文件。
uv run：在项目环境中运行命令。
uv tree：查看项目的依赖树。
uv build：将项目构建为分发存档。
uv publish：将项目发布到包索引。
```

```
在环境中管理包（替换 pip 和 pipdeptree）:

uv pip install：将包安装到当前环境。
uv pip show：显示已安装包的详细信息。
uv pip freeze: 列出已安装的包及其版本。
uv pip check: 检查当前环境是否有兼容的包。
uv pip list: 列出已安装的包。
uv pip uninstall: 卸载包。
uv pip tree：查看环境依赖树。
```

