const express = require('express');
const router = express.Router();
const { Low, JSONFile } = require('lowdb');
const dbFile = __dirname + '/db.json';
const adapter = new JSONFile(dbFile);
const db = new Low(adapter);
async function initDB() {
  await db.read();
  db.data = db.data || { routes: [] };
  await db.write();
}
initDB();

router.post('/routes', async (req,res)=>{
  await db.read();
  const { title, waypoints = [] } = req.body;
  const id = Date.now().toString(36);
  const newRoute = { id, title, waypoints, createdAt: new Date() };
  db.data.routes.unshift(newRoute);
  await db.write();
  res.json(newRoute);
});

router.get('/routes', async (req,res)=>{
  await db.read();
  res.json(db.data.routes || []);
});

module.exports = router;
