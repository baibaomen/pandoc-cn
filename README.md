# Pandoc Markdown转PDF HTTP服务

这是一个基于Docker的HTTP服务，用于将Markdown文档转换为PDF文件。服务支持中文，并使用思源黑体（Source Han Sans CN）作为默认中文字体。

## 功能特点

- 提供HTTP API接口，接收Markdown内容并转换为PDF
- 支持两种转换方式：直接提交Markdown文本或上传Markdown文件
- 生成唯一的文件ID，便于后续下载
- 提供文件下载链接
- 支持中文内容

## 使用方法

### 构建Docker镜像

```bash
docker build -t pandoc-md-to-pdf-service .
```

### 运行Docker容器

```bash
docker run -d -p 3000:3000 -v /path/to/local/data:/data pandoc-md-to-pdf-service
```

注意：请将 `/path/to/local/data` 替换为您想要存储PDF文件的本地目录路径。

### API接口

#### 1. 健康检查

```
GET /health
```

返回服务状态。

#### 2. 通过文本内容转换

```
POST /convert/text
Content-Type: application/json

{
  "markdown": "# 标题\n\n这是一段中文内容。"
}
```

#### 3. 通过文件上传转换

```
POST /convert/file
Content-Type: multipart/form-data

Form参数:
- markdown: [Markdown文件]
```

#### 4. 下载生成的PDF

```
GET /download/{fileId}.pdf
```

其中 `{fileId}` 是API返回的文件ID。

### 响应示例

成功响应：

```json
{
  "success": true,
  "fileId": "550e8400-e29b-41d4-a716-446655440000",
  "downloadUrl": "/download/550e8400-e29b-41d4-a716-446655440000.pdf"
}
```

错误响应：

```json
{
  "error": "错误信息",
  "details": "详细错误信息"
}
```

## 示例使用

### 使用curl发送Markdown文本

```bash
curl -X POST http://localhost:3000/convert/text \
  -H "Content-Type: application/json" \
  -d '{"markdown": "# 测试标题\n\n这是一段中文内容。"}'
```

### 使用curl上传Markdown文件

```bash
curl -X POST http://localhost:3000/convert/file \
  -F "markdown=@/path/to/your/document.md"
```

### 下载生成的PDF

使用浏览器访问：`http://localhost:3000/download/{fileId}.pdf`

或使用curl下载：

```bash
curl -o output.pdf http://localhost:3000/download/{fileId}.pdf
``` 