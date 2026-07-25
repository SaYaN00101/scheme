require('dotenv').config();
const express = require('express');
const session = require('express-session');
const path = require('path');
const app = express();

const PORT = process.env.PORT || 3000;
const SESSION_SECRET = process.env.SESSION_SECRET || 'schemeseeker_secret_key_2026';

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Session configuration
app.use(session({
  secret: SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: false, // Set to true in production with HTTPS
    maxAge: 24 * 60 * 60 * 1000 // 24 hours
  }
}));

// Static files
app.use(express.static(path.join(__dirname, 'public')));
app.use('/views', express.static(path.join(__dirname, 'views')));

// Serve HTML files from views directory
app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'views', 'index.html')));
app.get('/form', (req, res) => res.sendFile(path.join(__dirname, 'views', 'form.html')));
app.get('/results', (req, res) => res.sendFile(path.join(__dirname, 'views', 'results.html')));
app.get('/scheme/:id', (req, res) => res.sendFile(path.join(__dirname, 'views', 'scheme-detail.html')));
app.get('/login', (req, res) => res.sendFile(path.join(__dirname, 'views', 'login.html')));
app.get('/register', (req, res) => res.sendFile(path.join(__dirname, 'views', 'register.html')));
app.get('/admin', (req, res) => res.sendFile(path.join(__dirname, 'views', 'admin', 'login.html')));
app.get('/admin/dashboard', (req, res) => res.sendFile(path.join(__dirname, 'views', 'admin', 'dashboard.html')));

// API Routes
app.use('/api/schemes', require('./routes/schemes'));
app.use('/api/users', require('./routes/users'));
app.use('/api/admin', require('./routes/admin'));

// Check session status
app.get('/api/session', (req, res) => {
  if (req.session.userId) {
    res.json({ loggedIn: true, userId: req.session.userId, userName: req.session.userName });
  } else if (req.session.adminId) {
    res.json({ loggedIn: true, isAdmin: true, adminId: req.session.adminId, adminName: req.session.adminName });
  } else {
    res.json({ loggedIn: false });
  }
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'SchemeSeeker API is running' });
});

// 404 handler
app.use((req, res) => {
  if (req.path.startsWith('/api/')) {
    res.status(404).json({ success: false, message: 'API endpoint not found' });
  } else {
    res.sendFile(path.join(__dirname, 'views', 'index.html'));
  }
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Server Error:', err);
  res.status(500).json({ success: false, message: 'Internal server error' });
});

app.listen(PORT, () => {
  console.log('=================================================');
  console.log('  SchemeSeeker - Government Scheme Finder');
  console.log('  Server running on http://localhost:' + PORT);
  console.log('=================================================');
  console.log('Routes:');
  console.log('  Home:        http://localhost:' + PORT + '/');
  console.log('  Form:        http://localhost:' + PORT + '/form');
  console.log('  Login:       http://localhost:' + PORT + '/login');
  console.log('  Register:    http://localhost:' + PORT + '/register');
  console.log('  Admin:       http://localhost:' + PORT + '/admin');
  console.log('=================================================');
});
