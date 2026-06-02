const request = require("supertest");
const app = require("../src/app");

describe("ShopSwift API", () => {
  test("GET /health returns healthy", async () => {
    const response = await request(app).get("/health");
    expect(response.statusCode).toBe(200);
    expect(response.body.status).toBe("healthy");
  });

  test("GET /ready returns ready", async () => {
    const response = await request(app).get("/ready");
    expect(response.statusCode).toBe(200);
    expect(response.body.status).toBe("ready");
  });

  test("GET /version returns application metadata", async () => {
    const response = await request(app).get("/version");
    expect(response.statusCode).toBe(200);
    expect(response.body.app).toBe("ShopSwift");
    expect(response.body.status).toBe("running");
  });

  test("GET /products returns product list", async () => {
    const response = await request(app).get("/products");
    expect(response.statusCode).toBe(200);
    expect(response.body.products.length).toBeGreaterThan(0);
  });

  test("GET /cart returns cart simulation", async () => {
    const response = await request(app).get("/cart");
    expect(response.statusCode).toBe(200);
    expect(response.body.total).toBeGreaterThan(0);
  });

  test("GET /checkout returns checkout simulation", async () => {
    const response = await request(app).get("/checkout");
    expect(response.statusCode).toBe(200);
    expect(response.body.message).toContain("Checkout simulation completed");
  });

  test("GET /products/999 returns 404", async () => {
    const response = await request(app).get("/products/999");
    expect(response.statusCode).toBe(404);
    expect(response.body.error).toBe("Product not found");
  });
});
