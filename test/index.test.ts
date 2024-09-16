import { describe, expect, test } from "bun:test";
import { testClient } from "hono/testing";

describe("test my app", () => {
	test("2 + 2", () => {
		expect(1).toBe(1);
	});
	test("sample", () => {
		expect(1).toBe(1);
	});
});
