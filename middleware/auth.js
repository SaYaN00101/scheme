// Authentication middleware

const requireUser = (req, res, next) => {
  if (req.session && req.session.userId) {
    next();
  } else {
    if (req.xhr || req.headers.accept?.includes('application/json')) {
      return res.status(401).json({ success: false, message: 'Please login to access this feature' });
    }
    res.redirect('/login.html?redirect=' + encodeURIComponent(req.originalUrl));
  }
};

const requireAdmin = (req, res, next) => {
  if (req.session && req.session.adminId) {
    next();
  } else {
    if (req.xhr || req.headers.accept?.includes('application/json')) {
      return res.status(403).json({ success: false, message: 'Admin access required' });
    }
    res.redirect('/admin/login.html');
  }
};

const optionalAuth = (req, res, next) => {
  // Just check if user is logged in, don't require it
  next();
};

module.exports = {
  requireUser,
  requireAdmin,
  optionalAuth
};
