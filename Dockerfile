# 使用 pandoc/extra 作为基础镜像
FROM pandoc/extra:latest

# 安装中文字体和必要的 LaTeX 包
RUN apk add --no-cache \
    # 基础工具
    wget \
    # 字体相关
    fontconfig \
    # TeX Live 相关包
    texmf-dist-langchinese \
    && \
    # 下载并安装思源黑体
    wget -qO SourceHanSans.zip https://github.com/adobe-fonts/source-han-sans/releases/download/2.004R/SourceHanSansCN.zip && \
    unzip SourceHanSans.zip -d /tmp/SourceHanSans && \
    mkdir -p /usr/share/fonts/adobe && \
    cp /tmp/SourceHanSans/SubsetOTF/CN/*.otf /usr/share/fonts/adobe/ && \
    rm -rf /tmp/SourceHanSans SourceHanSans.zip && \
    # 更新字体缓存
    fc-cache -f -v

# 设置默认 LaTeX 模板中文支持
COPY templates/default.latex /root/.pandoc/templates/

# 清理缓存
RUN rm -rf /var/cache/apk/* 

#调用示例：
#docker run --rm --volume "${PWD}:/data" baibaomen/pandoc-extra-cn:latest test-chinese.md -o test-chinese.pdf --pdf-engine=xelatex -V CJKmainfont="Source Han Sans CN"