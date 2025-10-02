// src/frontend/server.js
const express = require('express');
const app = express();
const port = 80;

app.get('/', (req, res) => {
    res.send(`
        <h1>Node.js Frontend: Capstone Project</h1>
        <p>This service is routing traffic to the backend API.</p>
        <p>Active Backend Color: ${process.env.SERVICE_COLOR || 'N/A'}</p>
        <p>Frontend Version: ${process.env.APP_VERSION || 'v1.0.0'}</p>
        <p>Access the backend status at /api/status (via the internal Service).</p>
    `);
});

app.listen(port, () => {
    console.log(`Frontend listening on port ${port}`);
});