import express, { Request, Response } from 'express';
const app = express();
const port = 3000;
const nodeHtmlToImage = require('node-html-to-image');

export function ImageWriter() {
app.get('/qrcode', async (req: Request, res: Response) => {
  const image  = await nodeHtmlToImage({
    html: '<html><body><div>Check out what I just did! #cool</div></body></html>'
  })
  res.writeHead(200, { 'Content-Type': 'image/png' });
  res.end(image, 'binary');
});

app.listen(port, () => console.log(`App listening on port ${port}!`));
}