const express = require('express');
const router = express.Router();
const db = require('../config/db');

// Get all categories
router.get('/categories/all', async (req, res) => {
  try {
    const [categories] = await db.query('SELECT * FROM scheme_categories ORDER BY name');
    res.json({ success: true, categories });
  } catch (error) {
    console.error('Categories Error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch categories' });
  }
});

// List all schemes with optional filters
router.get('/', async (req, res) => {
  try {
    const { category, scope, search, page = 1, limit = 20 } = req.query;
    let query = `
      SELECT s.*, c.name as category_name, c.icon as category_icon 
      FROM schemes s 
      JOIN scheme_categories c ON s.category_id = c.id 
      WHERE s.is_active = TRUE
    `;
    const params = [];

    if (category) {
      query += ' AND s.category_id = ?';
      params.push(category);
    }

    if (scope) {
      query += ' AND s.scope = ?';
      params.push(scope);
    }

    if (search) {
      query += ' AND (s.name LIKE ? OR s.description LIKE ? OR s.benefit_details LIKE ?)';
      const searchTerm = `%${search}%`;
      params.push(searchTerm, searchTerm, searchTerm);
    }

    query += ' ORDER BY s.scope DESC, s.name LIMIT ? OFFSET ?';
    params.push(parseInt(limit), (parseInt(page) - 1) * parseInt(limit));

    const [schemes] = await db.query(query, params);

    // Get total count for pagination
    let countQuery = 'SELECT COUNT(*) as total FROM schemes WHERE is_active = TRUE';
    const countParams = [];
    
    if (category) {
      countQuery += ' AND category_id = ?';
      countParams.push(category);
    }
    if (scope) {
      countQuery += ' AND scope = ?';
      countParams.push(scope);
    }
    if (search) {
      countQuery += ' AND (name LIKE ? OR description LIKE ?)';
      const searchTerm = `%${search}%`;
      countParams.push(searchTerm, searchTerm);
    }

    const [countResult] = await db.query(countQuery, countParams);

    res.json({
      success: true,
      schemes,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: countResult[0].total,
        pages: Math.ceil(countResult[0].total / parseInt(limit))
      }
    });
  } catch (error) {
    console.error('List Schemes Error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch schemes' });
  }
});

// Get single scheme details
router.get('/:id', async (req, res) => {
  try {
    const [schemes] = await db.query(`
      SELECT s.*, c.name as category_name, c.icon as category_icon 
      FROM schemes s 
      JOIN scheme_categories c ON s.category_id = c.id 
      WHERE s.id = ? AND s.is_active = TRUE
    `, [req.params.id]);

    if (schemes.length === 0) {
      return res.status(404).json({ success: false, message: 'Scheme not found' });
    }

    res.json({ success: true, scheme: schemes[0] });
  } catch (error) {
    console.error('Scheme Detail Error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch scheme details' });
  }
});

// CORE: Eligibility matching
router.post('/find', async (req, res) => {
  try {
    const {
      age,
      gender,
      income,
      occupation,
      education,
      caste,
      state = 'west bengal'
    } = req.body;

    // Build eligibility query
    let query = `
      SELECT s.*, c.name as category_name, c.icon as category_icon 
      FROM schemes s 
      JOIN scheme_categories c ON s.category_id = c.id 
      WHERE s.is_active = TRUE
      AND s.min_age <= ? 
      AND s.max_age >= ?
      AND (s.gender = ? OR s.gender = 'all')
      AND (s.max_income >= ? OR s.max_income IS NULL)
      AND (s.occupation = ? OR s.occupation = 'all')
      AND (s.education_level = ? OR s.education_level = 'all')
      AND (s.caste_category = ? OR s.caste_category = 'all')
      AND (s.state = ? OR s.state = 'all')
      ORDER BY s.scope DESC, s.name
    `;

    const params = [
      parseInt(age) || 0,
      parseInt(age) || 120,
      gender || 'all',
      parseFloat(income) || 999999999,
      occupation || 'all',
      education || 'all',
      caste || 'all',
      state || 'west bengal'
    ];

    const [schemes] = await db.query(query, params);

    // Also find partial matches (schemes that match most criteria)
    let partialQuery = `
      SELECT s.*, c.name as category_name, c.icon as category_icon,
        (
          (CASE WHEN s.min_age <= ? THEN 1 ELSE 0 END) +
          (CASE WHEN s.max_age >= ? THEN 1 ELSE 0 END) +
          (CASE WHEN s.gender = ? OR s.gender = 'all' THEN 1 ELSE 0 END) +
          (CASE WHEN s.max_income >= ? OR s.max_income IS NULL THEN 1 ELSE 0 END) +
          (CASE WHEN s.occupation = ? OR s.occupation = 'all' THEN 1 ELSE 0 END) +
          (CASE WHEN s.education_level = ? OR s.education_level = 'all' THEN 1 ELSE 0 END) +
          (CASE WHEN s.caste_category = ? OR s.caste_category = 'all' THEN 1 ELSE 0 END) +
          (CASE WHEN s.state = ? OR s.state = 'all' THEN 1 ELSE 0 END)
        ) as match_score
      FROM schemes s 
      JOIN scheme_categories c ON s.category_id = c.id 
      WHERE s.is_active = TRUE
      HAVING match_score >= 5
      ORDER BY match_score DESC, s.scope DESC, s.name
    `;

    const [partialMatches] = await db.query(partialQuery, params);

    // Get unique schemes from both lists
    const exactMatchIds = new Set(schemes.map(s => s.id));
    const partialOnly = partialMatches.filter(s => !exactMatchIds.has(s.id));

    res.json({
      success: true,
      exactMatches: schemes,
      partialMatches: partialOnly,
      totalMatches: schemes.length,
      totalPartial: partialOnly.length,
      query: { age, gender, income, occupation, education, caste, state }
    });
  } catch (error) {
    console.error('Eligibility Match Error:', error);
    res.status(500).json({ success: false, message: 'Failed to find matching schemes' });
  }
});

// Get related schemes by category
router.get('/:id/related', async (req, res) => {
  try {
    const [scheme] = await db.query('SELECT category_id FROM schemes WHERE id = ?', [req.params.id]);
    
    if (scheme.length === 0) {
      return res.status(404).json({ success: false, message: 'Scheme not found' });
    }

    const [related] = await db.query(`
      SELECT s.*, c.name as category_name 
      FROM schemes s 
      JOIN scheme_categories c ON s.category_id = c.id 
      WHERE s.category_id = ? AND s.id != ? AND s.is_active = TRUE
      LIMIT 5
    `, [scheme[0].category_id, req.params.id]);

    res.json({ success: true, related });
  } catch (error) {
    console.error('Related Schemes Error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch related schemes' });
  }
});

module.exports = router;
