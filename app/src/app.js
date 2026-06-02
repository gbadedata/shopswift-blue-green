const express = require("express");
const helmet = require("helmet");
const cors = require("cors");
const client = require("prom-client");

const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());

client.collectDefaultMetrics();

const APP_NAME = process.env.APP_NAME || "ShopSwift";
const APP_VERSION = process.env.APP_VERSION || "v1.0.0";
const APP_ENV = process.env.APP_ENV || "blue";
const GIT_COMMIT = process.env.GIT_COMMIT || "local";
const PORT = process.env.PORT || 3000;

const products = [
  {
    id: 1,
    name: "Wireless Headphones",
    price: 49.99,
    category: "Electronics"
  },
  {
    id: 2,
    name: "Smart Fitness Watch",
    price: 79.99,
    category: "Wearables"
  },
  {
    id: 3,
    name: "Laptop Backpack",
    price: 34.99,
    category: "Accessories"
  },
  {
    id: 4,
    name: "Portable Desk Lamp",
    price: 24.99,
    category: "Home Office"
  }
];

app.get("/", (req, res) => {
  const badgeColour = APP_ENV === "green" ? "#16a34a" : "#2563eb";

  res.status(200).send(`
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>${APP_NAME}</title>
        <style>
          body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background: #f7f9fc;
            color: #111827;
          }
          .badge {
            display: inline-block;
            padding: 8px 12px;
            background: ${badgeColour};
            color: white;
            border-radius: 5px;
            font-weight: bold;
          }
          .card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
          }
          a {
            color: #2563eb;
            font-weight: bold;
            text-decoration: none;
          }
        </style>
      </head>
      <body>
        <h1>${APP_NAME}</h1>
        <span class="badge">${APP_ENV.toUpperCase()} - ${APP_VERSION}</span>

        <div class="card">
          <h2>Simple E-Commerce Demo</h2>
          <p>This app demonstrates blue-green deployment, traffic switching, rollback, and zero-downtime release behaviour.</p>
          <p><a href="/products">View Products API</a></p>
          <p><a href="/cart">View Cart API</a></p>
          <p><a href="/checkout">Checkout API</a></p>
          <p><a href="/version">Version API</a></p>
          <p><a href="/metrics">Metrics Endpoint</a></p>
        </div>
      </body>
    </html>
  `);
});

app.get("/products", (req, res) => {
  res.status(200).json({
    environment: APP_ENV,
    version: APP_VERSION,
    count: products.length,
    products
  });
});

app.get("/products/:id", (req, res) => {
  const product = products.find((item) => item.id === Number(req.params.id));

  if (!product) {
    return res.status(404).json({
      error: "Product not found"
    });
  }

  return res.status(200).json({
    environment: APP_ENV,
    version: APP_VERSION,
    product
  });
});

app.get("/cart", (req, res) => {
  res.status(200).json({
    environment: APP_ENV,
    version: APP_VERSION,
    cart: [
      {
        productId: 1,
        productName: "Wireless Headphones",
        quantity: 1,
        price: 49.99
      }
    ],
    total: 49.99
  });
});

app.get("/checkout", (req, res) => {
  res.status(200).json({
    environment: APP_ENV,
    version: APP_VERSION,
    message:
      APP_ENV === "green"
        ? "Checkout simulation completed with the improved green release."
        : "Checkout simulation completed with the stable blue release."
  });
});

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "healthy"
  });
});

app.get("/ready", (req, res) => {
  if (process.env.FORCE_NOT_READY === "true") {
    return res.status(503).json({
      status: "not_ready"
    });
  }

  return res.status(200).json({
    status: "ready"
  });
});

app.get("/version", (req, res) => {
  res.status(200).json({
    app: APP_NAME,
    version: APP_VERSION,
    environment: APP_ENV,
    commit: GIT_COMMIT,
    port: Number(PORT),
    status: "running"
  });
});

app.get("/metrics", async (req, res) => {
  res.set("Content-Type", client.register.contentType);
  res.end(await client.register.metrics());
});

module.exports = app;
