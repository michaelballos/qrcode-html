import express, { Request, Response } from 'express';
import nodeHtmlToImage from 'node-html-to-image';
const app = express();
const port = 3000;

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