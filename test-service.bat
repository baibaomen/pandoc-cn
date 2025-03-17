@echo off
setlocal enabledelayedexpansion

REM 测试HTTP服务的脚本

REM 服务地址
set SERVICE_URL=http://localhost:3000

REM 测试健康检查
echo 测试健康检查...
curl -s %SERVICE_URL%/health
echo.

REM 测试文本转换
echo 测试Markdown文本转换...
curl -s -X POST %SERVICE_URL%/convert/text ^
  -H "Content-Type: application/json" ^
  -d "{\"markdown\": \"# 测试标题\n\n这是一段中文内容。\n\n## 二级标题\n\n- 列表项1\n- 列表项2\n- 列表项3\"}" > response.json

type response.json
echo.

REM 使用PowerShell解析JSON
echo 使用PowerShell解析JSON...
powershell -Command "$json = Get-Content -Raw -Path response.json | ConvertFrom-Json; Write-Host $json.fileId" > fileid.txt
set /p FILE_ID=<fileid.txt
del fileid.txt

if defined FILE_ID (
  echo 文件ID: %FILE_ID%
  echo 下载链接: %SERVICE_URL%/download/%FILE_ID%.pdf
  
  REM 下载生成的PDF
  echo.
  echo 下载PDF文件...
  curl -s -o "test-output.pdf" "%SERVICE_URL%/download/%FILE_ID%.pdf"
  echo PDF文件已保存为 test-output.pdf
) else (
  echo 未能获取文件ID，转换可能失败
)

REM 测试文件上传 - 使用test-chinese.md
echo.
echo 测试Markdown文件上传 - 使用test-chinese.md...

REM 检查test-chinese.md是否存在
if not exist test-chinese.md (
  echo 错误: test-chinese.md文件不存在
  goto end
)

curl -s -X POST %SERVICE_URL%/convert/file -F "markdown=@test-chinese.md" > response2.json

type response2.json
echo.

REM 使用PowerShell解析JSON
echo 使用PowerShell解析JSON...
powershell -Command "$json = Get-Content -Raw -Path response2.json | ConvertFrom-Json; Write-Host $json.fileId" > fileid2.txt
set /p FILE_ID=<fileid2.txt
del fileid2.txt

if defined FILE_ID (
  echo 文件ID: %FILE_ID%
  echo 下载链接: %SERVICE_URL%/download/%FILE_ID%.pdf
  
  REM 下载生成的PDF
  echo.
  echo 下载PDF文件...
  curl -s -o "test-chinese-output.pdf" "%SERVICE_URL%/download/%FILE_ID%.pdf"
  echo PDF文件已保存为 test-chinese-output.pdf
) else (
  echo 未能获取文件ID，转换可能失败
)

REM 清理临时文件
del response.json
del response2.json

:end
echo.
echo 测试完成!
pause 