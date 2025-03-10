# Pandoc-Extra-CN

本项目基于 [Pandoc](https://github.com/jgm/pandoc)（一个通用文档转换工具）的 pandoc/extra 镜像，增加了中文支持的 Pandoc 环境。Pandoc 是由 John MacFarlane 开发的开源文档转换工具，能够在多种标记格式之间进行转换。

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

本项目的 Dockerfile 和相关配置文件采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

注意：本项目中包含的 Pandoc 软件使用 GPL-2.0 许可证。使用本 Docker 镜像时，请同时遵守 Pandoc 的 GPL 许可证要求。 