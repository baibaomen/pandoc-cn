#!/bin/bash

# 构建镜像
docker build -t baibaomen/pandoc-extra-cn:latest .

# 测试生成 PDF
docker run --rm --volume "${PWD}:/data" baibaomen/pandoc-extra-cn:latest test-chinese.md -o test-chinese.pdf --pdf-engine=xelatex -V CJKmainfont="Source Han Sans CN"