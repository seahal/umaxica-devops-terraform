import { Hono } from "hono";
const app = new Hono();
import { compress } from "hono/compress";
import { etag } from "hono/etag";
import { logger } from "hono/logger";
import { secureHeaders } from "hono/secure-headers";
import { testClient } from "hono/testing";

app.use(
    secureHeaders({
        xFrameOptions: "DENY",
        xXssProtection: "1",
    }),
);
app.use(compress(), logger());

app.get("/", (c) => c.json({ message: "abc" }));

app.fire();
