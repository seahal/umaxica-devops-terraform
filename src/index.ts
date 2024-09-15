import { Hono } from 'hono'

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

app.notFound((c) => {
    return c.text('Custome 404 ???', 404)
})

app.all('/get', (c) => {
    return c.text('all/')
});

app.on('GET', '/efg', (c) => {
    return c.text('efg/')
});

app.on(['GET', 'POST'], ['/en/fun/:id', '/ja/fun/:id'], (c) => {
    return·c.text(`fun:·$c.req.param('id')`)
});

app.fire()
