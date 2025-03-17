#!/bin/bash

# 测试HTTP服务的脚本

# 服务地址
SERVICE_URL="http://localhost:3000"

# 测试健康检查
echo "测试健康检查..."
curl -s $SERVICE_URL/health
echo -e "\n"

# 测试文本转换
echo "测试Markdown文本转换..."
RESPONSE=$(curl -s -X POST $SERVICE_URL/convert/text \
  -H "Content-Type: application/json" \
  -d '{"markdown": "# 测试标题\n\n这是一段中文内容。\n\n## 二级标题\n\n- 列表项1\n- 列表项2\n- 列表项3"}')

echo $RESPONSE
FILE_ID=$(echo $RESPONSE | grep -o '"fileId":"[^"]*"' | cut -d'"' -f4)

if [ -n "$FILE_ID" ]; then
  echo -e "\n文件ID: $FILE_ID"
  echo "下载链接: $SERVICE_URL/download/$FILE_ID.pdf"
  
  # 下载生成的PDF
  echo -e "\n下载PDF文件..."
  curl -s -o "test-output.pdf" "$SERVICE_URL/download/$FILE_ID.pdf"
  echo "PDF文件已保存为 test-output.pdf"
else
  echo "未能获取文件ID，转换可能失败"
fi

# 测试文件上传 - 使用test-chinese.md
echo -e "\n\n测试Markdown文件上传 - 使用test-chinese.md..."

# 检查test-chinese.md是否存在
if [ ! -f "test-chinese.md" ]; then
  echo "错误: test-chinese.md文件不存在"
  exit 1
fi

RESPONSE=$(curl -s -X POST $SERVICE_URL/convert/file \
  -F "markdown=@test-chinese.md")

echo $RESPONSE
FILE_ID=$(echo $RESPONSE | grep -o '"fileId":"[^"]*"' | cut -d'"' -f4)

if [ -n "$FILE_ID" ]; then
  echo -e "\n文件ID: $FILE_ID"
  echo "下载链接: $SERVICE_URL/download/$FILE_ID.pdf"
  
  # 下载生成的PDF
  echo -e "\n下载PDF文件..."
  curl -s -o "test-chinese-output.pdf" "$SERVICE_URL/download/$FILE_ID.pdf"
  echo "PDF文件已保存为 test-chinese-output.pdf"
else
  echo "未能获取文件ID，转换可能失败"
fi

echo -e "\n测试完成!" 