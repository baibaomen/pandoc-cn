# Pandoc-Extra-CN

基于 pandoc/extra 镜像，增加了中文支持的 Pandoc 环境。

## 快速开始

### 镜像地址

```bash
baibaomen/pandoc-extra-cn:latest
```

### 使用方法

Windows:
```bash
docker run --rm --volume "%CD%:/data" baibaomen/pandoc-extra-cn:latest test-chinese.md -o test-chinese.pdf --pdf-engine=xelatex -V CJKmainfont="Source Han Sans CN"
```

Linux/macOS:
```bash
docker run --rm --volume "${PWD}:/data" baibaomen/pandoc-extra-cn:latest test-chinese.md -o test-chinese.pdf --pdf-engine=xelatex -V CJKmainfont="Source Han Sans CN"
```

## 支持的功能

- 支持中文
- 预装思源黑体（Source Han Sans CN）
- 支持 XeLaTeX 引擎
- 支持其他 pandoc-extra 原有功能

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。 