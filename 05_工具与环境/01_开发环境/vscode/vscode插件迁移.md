# 插件迁移

```
code --list-extensions > vscode-extensions.txt
```

然后macos通过下面命令

```
cat vscode-extensions.txt | while read extension; do
  code --install-extension "$extension"
done
```

windows

```
while read extension; do code --install-extension "$extension"; done < vscode-extensions.txt
```

