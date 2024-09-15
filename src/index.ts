import { Hono } from 'hono/quick'

const app = new Hono()

app.get('/', (c) => {
  return c.text(`UMAXICA + ${Date.now() }`)
})

app.get('/abc', (c) => {
                return c.text("abc")
})

app.get('/api/:id', (c) => {
                    c.header('X-Message', 'hi');
                    const id = c.req.param('id');
                    console.log(id);
                    return c.json({ok: true, message: 'hello, world!', id:  `${id}`});
})

app.fire()
