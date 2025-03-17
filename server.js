const express = require('express');
const multer = require('multer');
const { v4: uuidv4 } = require('uuid');
const bodyParser = require('body-parser');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');
const app = express();
const port = 3000;

// 数据存储目录
const DATA_DIR = '/data';

// 确保数据目录存在
if (!fs.existsSync(DATA_DIR)) {
  fs.mkdirSync(DATA_DIR, { recursive: true });
}

// 配置文件上传
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, DATA_DIR);
  },
  filename: (req, file, cb) => {
    const fileId = uuidv4();
    req.fileId = fileId;
    cb(null, `${fileId}.md`);
  }
});

const upload = multer({ storage });

// 解析JSON请求体
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// 提供静态文件访问
app.use('/download', express.static(DATA_DIR));

// 健康检查端点
app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

// 处理Markdown文本转换为PDF
app.post('/convert/text', (req, res) => {
  const { markdown } = req.body;
  
  if (!markdown) {
    return res.status(400).json({ error: '缺少Markdown内容' });
  }
  
  const fileId = uuidv4();
  const mdFilePath = path.join(DATA_DIR, `${fileId}.md`);
  const pdfFilePath = path.join(DATA_DIR, `${fileId}.pdf`);
  
  // 写入Markdown文件
  fs.writeFileSync(mdFilePath, markdown);
  
  // 使用pandoc转换为PDF
  const cmd = `pandoc ${mdFilePath} -o ${pdfFilePath} --pdf-engine=xelatex -V CJKmainfont="Source Han Sans CN"`;
  
  exec(cmd, (error, stdout, stderr) => {
    if (error) {
      console.error(`执行错误: ${error}`);
      return res.status(500).json({ error: '转换失败', details: stderr });
    }
    
    // 返回下载链接
    const downloadUrl = `/download/${fileId}.pdf`;
    res.json({ 
      success: true, 
      fileId: fileId,
      downloadUrl: downloadUrl
    });
  });
});

// 处理Markdown文件上传并转换为PDF
app.post('/convert/file', upload.single('markdown'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: '未上传文件' });
  }
  
  const fileId = req.fileId;
  const mdFilePath = path.join(DATA_DIR, `${fileId}.md`);
  const pdfFilePath = path.join(DATA_DIR, `${fileId}.pdf`);
  
  // 使用pandoc转换为PDF
  const cmd = `pandoc ${mdFilePath} -o ${pdfFilePath} --pdf-engine=xelatex -V CJKmainfont="Source Han Sans CN"`;
  
  exec(cmd, (error, stdout, stderr) => {
    if (error) {
      console.error(`执行错误: ${error}`);
      return res.status(500).json({ error: '转换失败', details: stderr });
    }
    
    // 返回下载链接
    const downloadUrl = `/download/${fileId}.pdf`;
    res.json({ 
      success: true, 
      fileId: fileId,
      downloadUrl: downloadUrl
    });
  });
});

// 启动服务器
app.listen(port, '0.0.0.0', () => {
  console.log(`服务器运行在 http://0.0.0.0:${port}`);
}); 