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
    # 下载并安装文泉驿字体
    wget -qO wqy.tar.gz https://sourceforge.net/projects/wqy/files/wqy-zenhei/0.9.45%20%28Fighting-state%20RC1%29/wqy-zenhei-0.9.45.tar.gz && \
    tar xf wqy.tar.gz && \
    mkdir -p /usr/share/fonts/wenquanyi && \
    cp wqy-zenhei/wqy-zenhei.ttc /usr/share/fonts/wenquanyi/ && \
    rm -rf wqy-zenhei* && \
    # 更新字体缓存
    fc-cache -f -v

# 设置默认 LaTeX 模板中文支持
COPY templates/default.latex /root/.pandoc/templates/

# 清理缓存
RUN rm -rf /var/cache/apk/* 

#调用示例：
#docker run --rm --volume "${PWD}:/data" baibaomen/pandoc-extra-cn:latest test-chinese.md -o test-chinese.pdf --pdf-engine=xelatex -V CJKmainfont="WenQuanYi Zen Hei"