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

# 安装Node.js和npm
RUN apk add --no-cache nodejs npm

# 创建应用目录
WORKDIR /app

# 复制应用文件
COPY server.js package.json /app/

# 安装依赖
RUN npm install

# 创建数据目录
RUN mkdir -p /data

# 清理缓存
RUN rm -rf /var/cache/apk/*

# 暴露端口
EXPOSE 3000

# 覆盖基础镜像的ENTRYPOINT
ENTRYPOINT []

# 设置启动命令
CMD ["node", "/app/server.js"] 