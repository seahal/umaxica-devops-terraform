import {} from 'hono'
import {cors} from 'hono/cors'
import {basicAuth} from 'hono/basic-auth'
import {prettyJSON} from 'hono/pretty-json'

type Bindings = {
    USERNAME: string
    PASSWORD: string
}

const app = new Hono()

app.get('/', (c) => {
    c.text('aa');
})

export default app
