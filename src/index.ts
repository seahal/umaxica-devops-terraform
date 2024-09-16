import { Hono } from "hono";
const app = new Hono();
import { compress } from "hono/compress";
import { logger } from "hono/logger";
import { secureHeaders } from "hono/secure-headers";
import { testClient } from "hono/testing";

app.use(
    secureHeaders({
        xFrameOptions: "DENY",
        xXssProtection: "1",
    }),
);
app.use(compress());
app.use(logger());

app.get("/", (c) => {
    return c.html(`UMAXICA + ${Date.now()}`);
});

app.notFound((c) => {
    return c.html("Custome 404 ???", 404);
});

app.get("/api", (c) => {
    return c.json({ message: "hello" });
});

test('post', async () => {
    expect(10).toBe(10)
});

app.fire();
