import http from 'http';
import PG from 'pg';

const PORT = Number(process.env.PORT || 3000);

const DB_HOST = process.env.DB_HOST || 'postgres';
const DB_PORT = Number(process.env.DB_PORT || 5432);
const DB_USER = process.env.DB_USER || 'appuser';
const DB_PASSWORD = process.env.DB_PASSWORD || 'apppass';
const DB_NAME = process.env.DB_NAME || 'appdb';

const pool = new PG.Pool({
  host: DB_HOST,
  port: DB_PORT,
  user: DB_USER,
  password: DB_PASSWORD,
  database: DB_NAME,
  max: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000,
});

async function handleApi(res) {
  res.setHeader('Content-Type', 'application/json');

  let database = false;
  let userAdmin = false;

  try {
    const { rows } = await pool.query(
      "SELECT role FROM users WHERE username = 'admin' LIMIT 1"
    );

    database = true;
    userAdmin = rows?.[0]?.role === 'admin';

    res.writeHead(200);
    res.end(JSON.stringify({ database, userAdmin }));
  } catch (err) {
    console.error('DB query failed:', err);
    res.writeHead(200);
    res.end(JSON.stringify({ database, userAdmin }));
  }
}

const server = http.createServer(async (req, res) => {
  console.log(`Request: ${req.method} ${req.url}`);

  if (req.url === '/api' || req.url === '/api/') {
    await handleApi(res);
    return;
  }

  res.writeHead(404);
  res.end('Not Found');
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`Backend listening on 0.0.0.0:${PORT}`);
});

process.on('SIGTERM', async () => {
  try {
    await pool.end();
  } catch (_) {}
  process.exit(0);
});
