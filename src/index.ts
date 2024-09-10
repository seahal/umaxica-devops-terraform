import { Hono } from 'hono/quick'

const app = new Hono()

app.get('/', (c) => {
  return c.text(`UMAXICA + ${Date.now() }`)
})

app.fire()
