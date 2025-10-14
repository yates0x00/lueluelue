const fs = require('fs');
const { getDomain } = require('tldts');

// 读取文件内容
fs.readFile('aizhan_4.txt', 'utf8', (err, data) => {
  if (err) {
    console.error('读取文件出错:', err);
    return;
  }

  // 按行分割内容并处理每一行
  const lines = data.trim().split('\n');
  lines.forEach(line => {
    // 解析域名并获取domain属性
    const domain = getDomain(line);
    console.log(domain);
  });
});

