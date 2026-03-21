/**
 * Example API — Demonstrates secure endpoint patterns
 */
import express from 'express';
import { z } from 'zod';

const app = express();
app.use(express.json());

// Zod schema for input validation
const CitizenQuerySchema = z.object({
  city: z.string().min(1).optional(),
  status: z.enum(['active', 'pending', 'inactive']).optional(),
});

// Simulated data (fake PII)
const citizens = [
  { id: 1, name: 'Jane Smith', city: 'Seattle', status: 'active' },
  { id: 2, name: 'John Doe', city: 'Portland', status: 'active' },
  { id: 3, name: 'Alice Johnson', city: 'Denver', status: 'pending' },
];

// GET /api/citizens — with input validation and safe responses
app.get('/api/citizens', (req, res) => {
  try {
    const query = CitizenQuerySchema.parse(req.query);
    let results = citizens;

    if (query.city) {
      results = results.filter(c =>
        c.city.toLowerCase().includes(query.city!.toLowerCase())
      );
    }
    if (query.status) {
      results = results.filter(c => c.status === query.status);
    }

    res.json({ success: true, data: results, count: results.length });
  } catch (error) {
    if (error instanceof z.ZodError) {
      res.status(400).json({ success: false, error: error.message });
    } else {
      res.status(500).json({ success: false, error: 'Internal server error' });
    }
  }
});

// Health check
app.get('/api/health', (_req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

const PORT = process.env.PORT || 3005;
app.listen(PORT, () => {
  console.log(`API server running on http://localhost:${PORT}`);
});

export default app;
