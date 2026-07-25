const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const db = require('../config/db');
const { requireAdmin } = require('../middleware/auth');

// Admin login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ success: false, message: 'Email and password are required' });
    }

    const [admins] = await db.query('SELECT * FROM admins WHERE email = ?', [email]);

    if (admins.length === 0) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    const admin = admins[0];
    const isMatch = await bcrypt.compare(password, admin.password_hash);

    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    req.session.adminId = admin.id;
    req.session.adminName = admin.name;

    res.json({
      success: true,
      message: 'Admin login successful',
      admin: { id: admin.id, name: admin.name, email: admin.email }
    });
  } catch (error) {
    console.error('Admin Login Error:', error);
    res.status(500).json({ success: false, message: 'Login failed' });
  }
});

// Admin logout
router.post('/logout', (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'Logout failed' });
    }
    res.json({ success: true, message: 'Logged out successfully' });
  });
});

// Admin setup - create first admin
router.post('/setup', async (req, res) => {
  try {
    // Check if any admin exists
    const [existing] = await db.query('SELECT COUNT(*) as count FROM admins');
    
    if (existing[0].count > 0) {
      return res.status(403).json({ success: false, message: 'Admin already exists. Setup not allowed.' });
    }

    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({ success: false, message: 'All fields are required' });
    }

    const password_hash = await bcrypt.hash(password, 10);

    const [result] = await db.query(
      'INSERT INTO admins (name, email, password_hash) VALUES (?, ?, ?)',
      [name, email, password_hash]
    );

    res.json({
      success: true,
      message: 'Admin created successfully',
      admin: { id: result.insertId, name, email }
    });
  } catch (error) {
    console.error('Admin Setup Error:', error);
    res.status(500).json({ success: false, message: 'Setup failed' });
  }
});

// Get dashboard stats (requires admin)
router.get('/stats', requireAdmin, async (req, res) => {
  try {
    // Total schemes
    const [schemesCount] = await db.query('SELECT COUNT(*) as count FROM schemes');
    const [activeSchemes] = await db.query('SELECT COUNT(*) as count FROM schemes WHERE is_active = TRUE');
    const [centralSchemes] = await db.query('SELECT COUNT(*) as count FROM schemes WHERE scope = "central"');
    const [stateSchemes] = await db.query('SELECT COUNT(*) as count FROM schemes WHERE scope = "state"');

    // Total users
    const [usersCount] = await db.query('SELECT COUNT(*) as count FROM users');

    // Total saves
    const [savesCount] = await db.query('SELECT COUNT(*) as count FROM saved_schemes');

    // Popular schemes (most saved)
    const [popularSchemes] = await db.query(`
      SELECT s.id, s.name, s.scope, COUNT(ss.id) as save_count
      FROM schemes s
      LEFT JOIN saved_schemes ss ON s.id = ss.scheme_id
      WHERE s.is_active = TRUE
      GROUP BY s.id
      ORDER BY save_count DESC
      LIMIT 10
    `);

    // Schemes by category
    const [categoryStats] = await db.query(`
      SELECT c.name, COUNT(s.id) as scheme_count
      FROM scheme_categories c
      LEFT JOIN schemes s ON c.id = s.category_id AND s.is_active = TRUE
      GROUP BY c.id
      ORDER BY scheme_count DESC
    `);

    // Recent users
    const [recentUsers] = await db.query(
      'SELECT id, name, email, created_at FROM users ORDER BY created_at DESC LIMIT 5'
    );

    // Pending updates
    const [pendingUpdates] = await db.query(
      'SELECT COUNT(*) as count FROM pending_updates WHERE status = "pending"'
    );

    res.json({
      success: true,
      stats: {
        totalSchemes: schemesCount[0].count,
        activeSchemes: activeSchemes[0].count,
        centralSchemes: centralSchemes[0].count,
        stateSchemes: stateSchemes[0].count,
        totalUsers: usersCount[0].count,
        totalSaves: savesCount[0].count,
        pendingUpdates: pendingUpdates[0].count,
        popularSchemes,
        categoryStats,
        recentUsers
      }
    });
  } catch (error) {
    console.error('Stats Error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch stats' });
  }
});

// List all schemes for admin (including inactive)
router.get('/schemes', requireAdmin, async (req, res) => {
  try {
    const { page = 1, limit = 50 } = req.query;

    const [schemes] = await db.query(`
      SELECT s.*, c.name as category_name
      FROM schemes s
      JOIN scheme_categories c ON s.category_id = c.id
      ORDER BY s.created_at DESC
      LIMIT ? OFFSET ?
    `, [parseInt(limit), (parseInt(page) - 1) * parseInt(limit)]);

    const [countResult] = await db.query('SELECT COUNT(*) as total FROM schemes');

    res.json({
      success: true,
      schemes,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: countResult[0].total
      }
    });
  } catch (error) {
    console.error('Admin Schemes Error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch schemes' });
  }
});

// Create scheme (admin)
router.post('/schemes', requireAdmin, async (req, res) => {
  try {
    const {
      category_id, name, description, scope, state, min_age, max_age,
      gender, max_income, occupation, education_level, caste_category,
      benefit_details, documents_required, application_url, deadline
    } = req.body;

    const [result] = await db.query(`
      INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `, [category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline]);

    res.json({ success: true, message: 'Scheme created', schemeId: result.insertId });
  } catch (error) {
    console.error('Create Scheme Error:', error);
    res.status(500).json({ success: false, message: 'Failed to create scheme' });
  }
});

// Update scheme (admin)
router.put('/schemes/:id', requireAdmin, async (req, res) => {
  try {
    const {
      category_id, name, description, scope, state, min_age, max_age,
      gender, max_income, occupation, education_level, caste_category,
      benefit_details, documents_required, application_url, deadline, is_active
    } = req.body;

    await db.query(`
      UPDATE schemes SET
        category_id = ?, name = ?, description = ?, scope = ?, state = ?,
        min_age = ?, max_age = ?, gender = ?, max_income = ?, occupation = ?,
        education_level = ?, caste_category = ?, benefit_details = ?,
        documents_required = ?, application_url = ?, deadline = ?, is_active = ?
      WHERE id = ?
    `, [category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active, req.params.id]);

    res.json({ success: true, message: 'Scheme updated' });
  } catch (error) {
    console.error('Update Scheme Error:', error);
    res.status(500).json({ success: false, message: 'Failed to update scheme' });
  }
});

// Deactivate scheme (admin)
router.delete('/schemes/:id', requireAdmin, async (req, res) => {
  try {
    await db.query('UPDATE schemes SET is_active = FALSE WHERE id = ?', [req.params.id]);
    res.json({ success: true, message: 'Scheme deactivated' });
  } catch (error) {
    console.error('Deactivate Scheme Error:', error);
    res.status(500).json({ success: false, message: 'Failed to deactivate scheme' });
  }
});

// Get all users (admin)
router.get('/users', requireAdmin, async (req, res) => {
  try {
    const [users] = await db.query(
      'SELECT id, name, email, age, gender, annual_income, occupation, education_level, caste_category, district, created_at FROM users ORDER BY created_at DESC'
    );
    res.json({ success: true, users });
  } catch (error) {
    console.error('Admin Users Error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch users' });
  }
});

module.exports = router;
