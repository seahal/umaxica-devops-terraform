import { Hono } from "hono";
import { secureHeaders } from "hono/secure-headers";
const app = new Hono();
app.use(
    secureHeaders({
        xFrameOptions: "DENY",
        xXssProtection: "1",
    }),
);

app.get("/", (c) => {
    return c.html(`UMAXICA + ${Date.now()}`);
});

app.notFound((c) => {
    return c.html("Custome 404 ???", 404);
});

app.fire();
