const express = require('express');
const app = express();
const port = 3000;

// Simulate database connection string (will be fetched from Key Vault in a real app)
const DB_HOST = process.env.DB_HOST || 'mongodb-0.mongodb-service';
const APP_VERSION = process.env.APP_VERSION || '1.0.0';

app.get('/api/status', (req, res) => {
    res.json({ message: `backend api is operational...`,
        status: 'ok', 
        version: APP_VERSION, 
        database_connection: `attempting to connect to ${DB_HOST}`,
        color: process.env.SERVICE_COLOR || 'unknown' });
})


app.listen(port, () => {
    console.log(`Backend API listening at http://localhost:${port}`);
})