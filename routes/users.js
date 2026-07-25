const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const db = require('../config/db');
const { requireUser } = require('../middleware/auth');

// Register
router.post('/register', async (req, res) => {
  try {
    const { name, email, password, age, gender, annual_income, occupation, education_level, caste_category, district } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({ success: false, message: 'Name, email and password are required' });
    }

    // Check if email already exists
    const [existing] = await db.query('SELECT id FROM users WHERE email = ?', [email]);
    if (existing.length > 0) {
      return res.status(409).json({ success: false, message: 'Email already registered' });
    }

    // Hash password
    const password_hash = await bcrypt.hash(password, 10);

    const [result] = await db.query(
      `INSERT INTO users (name, email, password_hash, age, gender, annual_income, occupation, education_level, caste_category, district) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [name, email, password_hash, age || null, gender || null, annual_income || null, occupation || null, education_level || null, caste_category || null, district || null]
    );

    res.json({
      success: true,
      message: 'Registration successful',
      user: { id: result.insertId, name, email }
    });
  } catch (error) {
    console.error('Register Error:', error);
    res.status(500).json({ success: false, message: 'Registration failed' });
  }
});

// Login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ success: false, message: 'Email and password are required' });
    }

    const [users] = await db.query('SELECT * FROM users WHERE email = ?', [email]);

    if (users.length === 0) {
      return res.status(401).json({ success: false, message: 'Invalid email or password' });
    }

    const user = users[0];
    const isMatch = await bcrypt.compare(password, user.password_hash);

    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Invalid email or password' });
    }

    // Set session
    req.session.userId = user.id;
    req.session.userName = user.name;

    res.json({
      success: true,
      message: 'Login successful',
      user: { id: user.id, name: user.name, email: user.email }
    });
  } catch (error) {
    console.error('Login Error:', error);
    res.status(500).json({ success: false, message: 'Login failed' });
  }
});

// Logout
router.post('/logout', (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'Logout failed' });
    }
    res.json({ success: true, message: 'Logged out successfully' });
  });
});

// Get profile (requires login)
router.get('/profile', requireUser, async (req, res) => {
  try {
    const [users] = await db.query(
      'SELECT id, name, email, age, gender, annual_income, occupation, education_level, caste_category, district, created_at FROM users WHERE id = ?',
      [req.session.userId]
    );

    if (users.length === 0) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    res.json({ success: true, user: users[0] });
  } catch (error) {
    console.error('Profile Error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch profile' });
  }
});

// Update profile
router.put('/profile', requireUser, async (req, res) => {
  try {
    const { name, age, gender, annual_income, occupation, education_level, caste_category, district } = req.body;

    await db.query(
      `UPDATE users SET name = ?, age = ?, gender = ?, annual_income = ?, occupation = ?, education_level = ?, caste_category = ?, district = ? WHERE id = ?`,
      [name, age || null, gender || null, annual_income || null, occupation || null, education_level || null, caste_category || null, district || null, req.session.userId]
    );

    res.json({ success: true, message: 'Profile updated successfully' });
  } catch (error) {
    console.error('Update Profile Error:', error);
    res.status(500).json({ success: false, message: 'Failed to update profile' });
  }
});

// Get saved schemes
router.get('/saved-schemes', requireUser, async (req, res) => {
  try {
    const [saved] = await db.query(`
      SELECT s.*, c.name as category_name, ss.saved_at
      FROM saved_schemes ss
      JOIN schemes s ON ss.scheme_id = s.id
      JOIN scheme_categories c ON s.category_id = c.id
      WHERE ss.user_id = ? AND s.is_active = TRUE
      ORDER BY ss.saved_at DESC
    `, [req.session.userId]);

    res.json({ success: true, savedSchemes: saved });
  } catch (error) {
    console.error('Saved Schemes Error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch saved schemes' });
  }
});

// Save a scheme
router.post('/save-scheme', requireUser, async (req, res) => {
  try {
    const { scheme_id } = req.body;

    if (!scheme_id) {
      return res.status(400).json({ success: false, message: 'Scheme ID is required' });
    }

    await db.query(
      'INSERT IGNORE INTO saved_schemes (user_id, scheme_id) VALUES (?, ?)',
      [req.session.userId, scheme_id]
    );

    res.json({ success: true, message: 'Scheme saved successfully' });
  } catch (error) {
    console.error('Save Scheme Error:', error);
    res.status(500).json({ success: false, message: 'Failed to save scheme' });
  }
});

// Remove saved scheme
router.delete('/save-scheme/:id', requireUser, async (req, res) => {
  try {
    await db.query(
      'DELETE FROM saved_schemes WHERE user_id = ? AND scheme_id = ?',
      [req.session.userId, req.params.id]
    );

    res.json({ success: true, message: 'Scheme removed from saved list' });
  } catch (error) {
    console.error('Remove Saved Scheme Error:', error);
    res.status(500).json({ success: false, message: 'Failed to remove scheme' });
  }
});

module.exports = router;
