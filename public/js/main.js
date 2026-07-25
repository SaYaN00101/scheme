/**
 * SchemeSeeker - Main JavaScript
 * Frontend logic for the Government Scheme Eligibility Finder
 */

// ============================================
// CONFIGURATION
// ============================================
const API_BASE = '/api';

// ============================================
// LANGUAGE TRANSLATIONS
// ============================================
const translations = {
  en: {
    appName: 'SchemeSeeker',
    tagline: 'Find Government Schemes You Are Eligible For',
    home: 'Home',
    findSchemes: 'Find Schemes',
    schemes: 'Schemes',
    login: 'Login',
    register: 'Register',
    logout: 'Logout',
    profile: 'Profile',
    savedSchemes: 'Saved Schemes',
    admin: 'Admin',
    heroTitle: 'Discover Government Welfare Schemes For You',
    heroSubtitle: 'Enter your details and instantly find Central and West Bengal government schemes that match your eligibility.',
    getStarted: 'Get Started',
    browseSchemes: 'Browse All Schemes',
    howItWorks: 'How It Works',
    step1Title: 'Enter Your Details',
    step1Desc: 'Fill in your age, gender, income, occupation, and other basic information.',
    step2Title: 'Get Matched',
    step2Desc: 'Our system instantly checks eligibility across 45+ government schemes.',
    step3Title: 'Apply Easily',
    step3Desc: 'View scheme details, required documents, and apply directly through official portals.',
    categories: 'Scheme Categories',
    centralSchemes: 'Central Schemes',
    stateSchemes: 'State Schemes',
    viewAll: 'View All',
    searchPlaceholder: 'Search schemes...',
    eligibilityForm: 'Eligibility Form',
    personalInfo: 'Personal Information',
    age: 'Age',
    gender: 'Gender',
    male: 'Male',
    female: 'Female',
    other: 'Other',
    annualIncome: 'Annual Family Income (Rs.)',
    occupation: 'Occupation',
    education: 'Education Level',
    caste: 'Caste Category',
    state: 'State',
    findEligibleSchemes: 'Find Eligible Schemes',
    results: 'Results',
    exactMatches: 'Exact Matches',
    partialMatches: 'Partial Matches',
    noMatches: 'No exact matches found',
    adjustCriteria: 'Try adjusting your criteria for more results',
    schemeDetails: 'Scheme Details',
    benefits: 'Benefits',
    documents: 'Documents Required',
    eligibility: 'Eligibility Criteria',
    applyNow: 'Apply Now',
    saveScheme: 'Save Scheme',
    saved: 'Saved',
    share: 'Share',
    relatedSchemes: 'Related Schemes',
    loginRequired: 'Please login to save schemes',
    loading: 'Loading...',
    error: 'An error occurred',
    tryAgain: 'Try Again',
    footerAbout: 'SchemeSeeker helps citizens of West Bengal discover and apply for government welfare schemes they are eligible for.',
    quickLinks: 'Quick Links',
    support: 'Support',
    contactUs: 'Contact Us',
    faq: 'FAQ',
    privacy: 'Privacy Policy',
    terms: 'Terms of Service',
    allRightsReserved: 'All rights reserved.'
  },
  bn: {
    appName: 'স্কিমসীকার',
    tagline: 'আপনার যোগ্য সরকারি প্রকল্প খুঁজুন',
    home: 'হোম',
    findSchemes: 'প্রকল্প খুঁজুন',
    schemes: 'প্রকল্পসমূহ',
    login: 'লগইন',
    register: 'নিবন্ধন',
    logout: 'লগআউট',
    profile: 'প্রোফাইল',
    savedSchemes: 'সংরক্ষিত প্রকল্প',
    admin: 'অ্যাডমিন',
    heroTitle: 'আপনার জন্য সরকারি কল্যাণ প্রকল্প আবিষ্কার করুন',
    heroSubtitle: 'আপনার বিবরণ লিখুন এবং তাত্ক্ষণিকভাবে কেন্দ্রীয় এবং পশ্চিমবঙ্গ সরকারের প্রকল্পগুলি খুঁজুন যা আপনার যোগ্যতার সাথে মেলে।',
    getStarted: 'শুরু করুন',
    browseSchemes: 'সব প্রকল্প দেখুন',
    howItWorks: 'এটি কীভাবে কাজ করে',
    step1Title: 'আপনার বিবরণ লিখুন',
    step1Desc: 'আপনার বয়স, লিঙ্গ, আয়, পেশা এবং অন্যান্য প্রাথমিক তথ্য পূরণ করুন।',
    step2Title: 'ম্যাচ পান',
    step2Desc: 'আমাদের সিস্টেম তাত্ক্ষণিকভাবে ৪৫+ সরকারি প্রকল্পের যোগ্যতা পরীক্ষা করে।',
    step3Title: 'সহজে আবেদন করুন',
    step3Desc: 'প্রকল্পের বিবরণ, প্রয়োজনীয় নথিপত্র দেখুন এবং সরকারী পোর্টালের মাধ্যমে সরাসরি আবেদন করুন।',
    categories: 'প্রকল্পের বিভাগ',
    centralSchemes: 'কেন্দ্রীয় প্রকল্প',
    stateSchemes: 'রাজ্য প্রকল্প',
    viewAll: 'সব দেখুন',
    searchPlaceholder: 'প্রকল্প খুঁজুন...',
    eligibilityForm: 'যোগ্যতা ফর্ম',
    personalInfo: 'ব্যক্তিগত তথ্য',
    age: 'বয়স',
    gender: 'লিঙ্গ',
    male: 'পুরুষ',
    female: 'মহিলা',
    other: 'অন্যান্য',
    annualIncome: 'বার্ষিক পারিবারিক আয় (টাকা)',
    occupation: 'পেশা',
    education: 'শিক্ষার স্তর',
    caste: 'জাতির বিভাগ',
    state: 'রাজ্য',
    findEligibleSchemes: 'যোগ্য প্রকল্প খুঁজুন',
    results: 'ফলাফল',
    exactMatches: 'সঠিক ম্যাচ',
    partialMatches: 'আংশিক ম্যাচ',
    noMatches: 'কোন সঠিক ম্যাচ পাওয়া যায়নি',
    adjustCriteria: 'আরও ফলাফলের জন্য আপনার মানদণ্ড সমন্বয় করার চেষ্টা করুন',
    schemeDetails: 'প্রকল্পের বিবরণ',
    benefits: 'সুবিধা',
    documents: 'প্রয়োজনীয় নথিপত্র',
    eligibility: 'যোগ্যতার মানদণ্ড',
    applyNow: 'এখনই আবেদন করুন',
    saveScheme: 'প্রকল্প সংরক্ষণ করুন',
    saved: 'সংরক্ষিত',
    share: 'শেয়ার করুন',
    relatedSchemes: 'সম্পর্কিত প্রকল্প',
    loginRequired: 'প্রকল্প সংরক্ষণ করতে দয়া করে লগইন করুন',
    loading: 'লোড হচ্ছে...',
    error: 'একটি ত্রুটি ঘটেছে',
    tryAgain: 'আবার চেষ্টা করুন',
    footerAbout: 'স্কিমসীকার পশ্চিমবঙ্গের নাগরিকদের তাদের যোগ্য সরকারি কল্যাণ প্রকল্প আবিষ্কার এবং আবেদন করতে সহায়তা করে।',
    quickLinks: 'দ্রুত লিঙ্ক',
    support: 'সহায়তা',
    contactUs: 'যোগাযোগ করুন',
    faq: 'সাধারণ প্রশ্ন',
    privacy: 'গোপনীয়তা নীতি',
    terms: 'পরিষেবার শর্তাবলী',
    allRightsReserved: 'সর্বস্বত্ব সংরক্ষিত।'
  }
};

// Current language
let currentLang = localStorage.getItem('language') || 'en';

// ============================================
// LANGUAGE FUNCTIONS
// ============================================
function setLanguage(lang) {
  currentLang = lang;
  localStorage.setItem('language', lang);
  document.body.classList.toggle('lang-bn', lang === 'bn');
  applyTranslations();
  updateLangButtons();
}

function t(key) {
  return translations[currentLang]?.[key] || translations.en[key] || key;
}

function applyTranslations() {
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.getAttribute('data-i18n');
    if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
      if (el.hasAttribute('placeholder')) {
        el.placeholder = t(key);
      }
    } else {
      el.textContent = t(key);
    }
  });
}

function updateLangButtons() {
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.lang === currentLang);
  });
}

// ============================================
// UTILITY FUNCTIONS
// ============================================
function formatCurrency(amount) {
  if (!amount) return 'Not specified';
  return 'Rs. ' + parseInt(amount).toLocaleString('en-IN');
}

function formatDate(dateString) {
  if (!dateString) return 'N/A';
  return new Date(dateString).toLocaleDateString('en-IN', {
    year: 'numeric', month: 'long', day: 'numeric'
  });
}

function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

function showToast(message, type = 'success') {
  const container = document.querySelector('.toast-container') || createToastContainer();
  const toast = document.createElement('div');
  toast.className = `toast-item toast-${type}`;
  toast.innerHTML = `
    <i class="bi ${type === 'success' ? 'bi-check-circle' : type === 'error' ? 'bi-x-circle' : 'bi-exclamation-triangle'}"></i>
    <span>${escapeHtml(message)}</span>
  `;
  container.appendChild(toast);
  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateX(100%)';
    setTimeout(() => toast.remove(), 300);
  }, 3000);
}

function createToastContainer() {
  const container = document.createElement('div');
  container.className = 'toast-container';
  document.body.appendChild(container);
  return container;
}

function showLoading(element, message = 'Loading...') {
  element.innerHTML = `
    <div class="text-center py-5">
      <div class="spinner mx-auto mb-3"></div>
      <p class="text-secondary">${message}</p>
    </div>
  `;
}

function showError(element, message = 'An error occurred') {
  element.innerHTML = `
    <div class="text-center py-5">
      <i class="bi bi-exclamation-circle" style="font-size: 3rem; color: var(--danger);"></i>
      <h4 class="mt-3">Error</h4>
      <p class="text-secondary">${message}</p>
      <button class="btn btn-primary mt-2" onclick="location.reload()">
        <i class="bi bi-arrow-clockwise"></i> Try Again
      </button>
    </div>
  `;
}

// ============================================
// AUTH STATE
// ============================================
let currentUser = null;
let isAdmin = false;

async function checkSession() {
  try {
    const response = await fetch('/api/session');
    const data = await response.json();
    if (data.loggedIn) {
      if (data.isAdmin) {
        isAdmin = true;
        currentUser = { name: data.adminName, isAdmin: true };
      } else {
        currentUser = { id: data.userId, name: data.userName };
      }
    }
    updateAuthUI();
  } catch (error) {
    console.log('Session check failed');
  }
}

function updateAuthUI() {
  const authNav = document.getElementById('authNav');
  if (!authNav) return;

  if (currentUser) {
    authNav.innerHTML = `
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
          <i class="bi bi-person-circle"></i> ${escapeHtml(currentUser.name)}
        </a>
        <ul class="dropdown-menu dropdown-menu-end">
          ${isAdmin ? `
            <li><a class="dropdown-item" href="/admin/dashboard"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
            <li><hr class="dropdown-divider"></li>
          ` : `
            <li><a class="dropdown-item" href="/profile"><i class="bi bi-person"></i> Profile</a></li>
            <li><a class="dropdown-item" href="/saved"><i class="bi bi-bookmark-fill"></i> Saved Schemes</a></li>
            <li><hr class="dropdown-divider"></li>
          `}
          <li><a class="dropdown-item text-danger" href="#" onclick="handleLogout(event)"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
        </ul>
      </li>
    `;
  } else {
    authNav.innerHTML = `
      <li class="nav-item">
        <a class="nav-link" href="/login"><i class="bi bi-box-arrow-in-right"></i> Login</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="/register"><i class="bi bi-person-plus"></i> Register</a>
      </li>
    `;
  }
}

async function handleLogout(e) {
  e.preventDefault();
  try {
    await fetch('/api/users/logout', { method: 'POST' });
    currentUser = null;
    isAdmin = false;
    window.location.href = '/';
  } catch (error) {
    showToast('Logout failed', 'error');
  }
}

// ============================================
// SCHEME FUNCTIONS
// ============================================
async function loadCategories() {
  const container = document.getElementById('categoriesContainer');
  if (!container) return;

  showLoading(container, 'Loading categories...');

  try {
    const response = await fetch(`${API_BASE}/schemes/categories/all`);
    const data = await response.json();

    if (data.success) {
      container.innerHTML = data.categories.map((cat, index) => `
        <div class="col-6 col-md-4 col-lg-3 fade-in" style="animation-delay: ${index * 0.1}s">
          <div class="card category-card" onclick="window.location.href='/results?category=${cat.id}'">
            <div class="category-icon">
              <i class="bi ${getCategoryIcon(cat.name)}"></i>
            </div>
            <h5 class="category-name">${escapeHtml(cat.name)}</h5>
            <p class="category-count">${cat.description}</p>
          </div>
        </div>
      `).join('');
    }
  } catch (error) {
    showError(container, 'Failed to load categories');
  }
}

function getCategoryIcon(name) {
  const icons = {
    'Farmers': 'bi-flower1',
    'Women': 'bi-gender-female',
    'Students': 'bi-mortarboard',
    'Health': 'bi-heart-pulse',
    'Senior Citizens': 'bi-person-walking',
    'Employment': 'bi-briefcase',
    'Housing': 'bi-house-door'
  };
  return icons[name] || 'bi-grid';
}

async function loadSchemes(containerId, options = {}) {
  const container = document.getElementById(containerId);
  if (!container) return;

  showLoading(container, 'Loading schemes...');

  try {
    const params = new URLSearchParams();
    if (options.category) params.append('category', options.category);
    if (options.scope) params.append('scope', options.scope);
    if (options.search) params.append('search', options.search);
    params.append('limit', options.limit || 20);

    const response = await fetch(`${API_BASE}/schemes?${params}`);
    const data = await response.json();

    if (data.success) {
      if (data.schemes.length === 0) {
        container.innerHTML = `
          <div class="col-12 empty-state">
            <i class="bi bi-search empty-state-icon"></i>
            <h3>No schemes found</h3>
            <p>Try different search criteria</p>
          </div>
        `;
        return;
      }

      container.innerHTML = data.schemes.map((scheme, index) =>
        createSchemeCard(scheme, index)
      ).join('');
    }
  } catch (error) {
    showError(container, 'Failed to load schemes');
  }
}

function createSchemeCard(scheme, index = 0) {
  const scopeClass = scheme.scope === 'central' ? 'scope-central' : 'scope-state';
  const scopeText = scheme.scope === 'central' ? 'Central' : 'State';
  const maxIncomeText = scheme.max_income ? `Up to ${formatCurrency(scheme.max_income)}` : 'No limit';
  const ageRange = `${scheme.min_age}-${scheme.max_age === 120 ? '+' : scheme.max_age} years`;

  return `
    <div class="col-md-6 col-lg-4 fade-in" style="animation-delay: ${index * 0.05}s">
      <div class="card scheme-card h-100">
        <div class="card-body">
          <span class="scheme-scope-badge ${scopeClass}">${scopeText}</span>
          <div class="scheme-category">
            <i class="bi ${getCategoryIcon(scheme.category_name)}"></i>
            ${escapeHtml(scheme.category_name)}
          </div>
          <h5 class="scheme-title">${escapeHtml(scheme.name)}</h5>
          <p class="scheme-description">${escapeHtml(scheme.description.substring(0, 150))}...</p>
          <div class="scheme-benefits">
            <span class="scheme-benefits-text">
              <i class="bi bi-gift-fill me-1"></i>
              ${escapeHtml(scheme.benefit_details.substring(0, 100))}...
            </span>
          </div>
          <div class="scheme-meta">
            <span class="scheme-meta-item"><i class="bi bi-calendar"></i> ${ageRange}</span>
            <span class="scheme-meta-item"><i class="bi bi-currency-rupee"></i> ${maxIncomeText}</span>
          </div>
        </div>
        <div class="card-footer d-flex justify-content-between align-items-center">
          <a href="/scheme/${scheme.id}" class="btn btn-primary btn-sm">
            View Details <i class="bi bi-arrow-right"></i>
          </a>
          <button class="bookmark-btn ${scheme.isSaved ? 'saved' : ''}" onclick="toggleSave(event, ${scheme.id})" title="Save scheme">
            <i class="bi ${scheme.isSaved ? 'bi-bookmark-fill' : 'bi-bookmark'}"></i>
          </button>
        </div>
      </div>
    </div>
  `;
}

async function toggleSave(event, schemeId) {
  event.preventDefault();
  event.stopPropagation();

  if (!currentUser) {
    showToast('Please login to save schemes', 'warning');
    setTimeout(() => window.location.href = '/login', 1500);
    return;
  }

  try {
    const response = await fetch(`${API_BASE}/users/save-scheme`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ scheme_id: schemeId })
    });
    const data = await response.json();

    if (data.success) {
      const btn = event.currentTarget;
      btn.classList.toggle('saved');
      const icon = btn.querySelector('i');
      icon.classList.toggle('bi-bookmark');
      icon.classList.toggle('bi-bookmark-fill');
      showToast('Scheme saved!');
    }
  } catch (error) {
    showToast('Failed to save scheme', 'error');
  }
}

// ============================================
// ELIGIBILITY FORM
// ============================================
function initEligibilityForm() {
  const form = document.getElementById('eligibilityForm');
  if (!form) return;

  form.addEventListener('submit', async (e) => {
    e.preventDefault();

    const formData = {
      age: parseInt(document.getElementById('age').value),
      gender: document.getElementById('gender').value,
      income: parseFloat(document.getElementById('income').value) || 0,
      occupation: document.getElementById('occupation').value,
      education: document.getElementById('education').value,
      caste: document.getElementById('caste').value,
      state: 'west bengal'
    };

    // Store form data for results page
    sessionStorage.setItem('eligibilityForm', JSON.stringify(formData));
    window.location.href = '/results';
  });
}

// ============================================
// RESULTS PAGE
// ============================================
async function loadResults() {
  const container = document.getElementById('resultsContainer');
  if (!container) return;

  const formData = JSON.parse(sessionStorage.getItem('eligibilityForm') || '{}');
  if (!formData.age) {
    container.innerHTML = `
      <div class="col-12 text-center py-5">
        <i class="bi bi-info-circle" style="font-size: 3rem; color: var(--info);"></i>
        <h4 class="mt-3">No Search Criteria</h4>
        <p class="text-secondary">Please fill the eligibility form first</p>
        <a href="/form" class="btn btn-primary mt-2">Go to Form</a>
      </div>
    `;
    return;
  }

  showLoading(container, 'Finding matching schemes...');

  try {
    const response = await fetch(`${API_BASE}/schemes/find`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(formData)
    });
    const data = await response.json();

    if (data.success) {
      const summaryEl = document.getElementById('resultsSummary');
      if (summaryEl) {
        summaryEl.innerHTML = `
          <span class="badge bg-success me-2">${data.totalMatches} Exact Matches</span>
          ${data.totalPartial > 0 ? `<span class="badge bg-warning text-dark">${data.totalPartial} Partial Matches</span>` : ''}
        `;
      }

      let html = '';

      if (data.exactMatches.length > 0) {
        html += `<div class="row g-4">`;
        html += data.exactMatches.map((s, i) => createSchemeCard(s, i)).join('');
        html += `</div>`;
      }

      if (data.partialMatches.length > 0) {
        html += `
          <div class="mt-5">
            <h4 class="mb-4"><i class="bi bi-check-circle text-warning"></i> Partial Matches</h4>
            <p class="text-secondary mb-4">These schemes match most of your criteria. You may still be eligible.</p>
            <div class="row g-4">
              ${data.partialMatches.map((s, i) => createSchemeCard(s, i)).join('')}
            </div>
          </div>
        `;
      }

      if (data.exactMatches.length === 0 && data.partialMatches.length === 0) {
        html = `
          <div class="empty-state">
            <i class="bi bi-search empty-state-icon"></i>
            <h3>No Schemes Found</h3>
            <p>Try adjusting your criteria. Some schemes have no strict income limits.</p>
            <a href="/form" class="btn btn-primary mt-3">
              <i class="bi bi-arrow-left"></i> Modify Criteria
            </a>
          </div>
        `;
      }

      container.innerHTML = html;
    }
  } catch (error) {
    showError(container, 'Failed to find matching schemes');
  }
}

// ============================================
// SCHEME DETAIL PAGE
// ============================================
async function loadSchemeDetail() {
  const container = document.getElementById('schemeDetail');
  if (!container) return;

  const schemeId = window.location.pathname.split('/').pop();
  showLoading(container, 'Loading scheme details...');

  try {
    const response = await fetch(`${API_BASE}/schemes/${schemeId}`);
    const data = await response.json();

    if (data.success) {
      const s = data.scheme;
      const scopeClass = s.scope === 'central' ? 'scope-central' : 'scope-state';
      const scopeText = s.scope === 'central' ? 'Central Government' : 'West Bengal State';

      container.innerHTML = `
        <div class="detail-header">
          <div class="container">
            <div class="row align-items-center">
              <div class="col-lg-8">
                <span class="scheme-scope-badge ${scopeClass}">${scopeText}</span>
                <div class="scheme-category mt-3" style="background: rgba(255,255,255,0.2); color: white;">
                  <i class="bi ${getCategoryIcon(s.category_name)}"></i>
                  ${escapeHtml(s.category_name)}
                </div>
                <h1 class="text-white mt-3">${escapeHtml(s.name)}</h1>
                <p class="text-white-50">${escapeHtml(s.description)}</p>
                <div class="detail-meta">
                  <div class="detail-meta-item">
                    <i class="bi bi-calendar"></i> Age: ${s.min_age}-${s.max_age === 120 ? '+' : s.max_age} years
                  </div>
                  <div class="detail-meta-item">
                    <i class="bi bi-currency-rupee"></i> Income: ${s.max_income ? 'Up to ' + formatCurrency(s.max_income) : 'No limit'}
                  </div>
                  <div class="detail-meta-item">
                    <i class="bi bi-gender-ambiguous"></i> Gender: ${s.gender === 'all' ? 'All' : s.gender}
                  </div>
                </div>
              </div>
              <div class="col-lg-4 text-lg-end mt-4 mt-lg-0">
                <a href="${s.application_url}" target="_blank" class="btn btn-success btn-lg">
                  <i class="bi bi-box-arrow-up-right"></i> Apply Now
                </a>
                <button class="bookmark-btn ms-2" onclick="toggleSave(event, ${s.id})" title="Save scheme" style="width: 50px; height: 50px;">
                  <i class="bi bi-bookmark"></i>
                </button>
              </div>
            </div>
          </div>
        </div>

        <div class="container py-5">
          <div class="row g-4">
            <div class="col-lg-8">
              <div class="card detail-card">
                <div class="card-body">
                  <h4 class="detail-card-title"><i class="bi bi-gift"></i> Benefits</h4>
                  <div class="benefits-list">
                    ${s.benefit_details.split('.').filter(b => b.trim()).map(b => `
                      <div class="benefit-item">
                        <i class="bi bi-check-circle-fill"></i>
                        <span>${escapeHtml(b.trim())}</span>
                      </div>
                    `).join('')}
                  </div>
                </div>
              </div>

              <div class="card detail-card">
                <div class="card-body">
                  <h4 class="detail-card-title"><i class="bi bi-file-text"></i> Documents Required</h4>
                  <div class="documents-list">
                    ${s.documents_required.split(',').map(d => `
                      <div class="document-item">
                        <i class="bi bi-file-earmark-text"></i>
                        <span>${escapeHtml(d.trim())}</span>
                      </div>
                    `).join('')}
                  </div>
                </div>
              </div>

              <div class="card detail-card">
                <div class="card-body">
                  <h4 class="detail-card-title"><i class="bi bi-check2-square"></i> Eligibility Criteria</h4>
                  <ul class="list-group list-group-flush">
                    <li class="list-group-item d-flex justify-content-between">
                      <span><i class="bi bi-calendar text-primary"></i> Age Range</span>
                      <strong>${s.min_age} - ${s.max_age === 120 ? 'No upper limit' : s.max_age + ' years'}</strong>
                    </li>
                    <li class="list-group-item d-flex justify-content-between">
                      <span><i class="bi bi-gender-ambiguous text-primary"></i> Gender</span>
                      <strong>${s.gender === 'all' ? 'All Genders' : s.gender.charAt(0).toUpperCase() + s.gender.slice(1)}</strong>
                    </li>
                    <li class="list-group-item d-flex justify-content-between">
                      <span><i class="bi bi-currency-rupee text-primary"></i> Max Income</span>
                      <strong>${s.max_income ? formatCurrency(s.max_income) : 'No limit'}</strong>
                    </li>
                    <li class="list-group-item d-flex justify-content-between">
                      <span><i class="bi bi-briefcase text-primary"></i> Occupation</span>
                      <strong>${s.occupation === 'all' ? 'All' : s.occupation}</strong>
                    </li>
                    <li class="list-group-item d-flex justify-content-between">
                      <span><i class="bi bi-book text-primary"></i> Education</span>
                      <strong>${s.education_level === 'all' ? 'All' : s.education_level}</strong>
                    </li>
                    <li class="list-group-item d-flex justify-content-between">
                      <span><i class="bi bi-people text-primary"></i> Caste</span>
                      <strong>${s.caste_category === 'all' ? 'All Categories' : s.caste_category.toUpperCase()}</strong>
                    </li>
                    <li class="list-group-item d-flex justify-content-between">
                      <span><i class="bi bi-geo-alt text-primary"></i> State</span>
                      <strong>${s.state === 'all' ? 'All India' : 'West Bengal'}</strong>
                    </li>
                  </ul>
                </div>
              </div>
            </div>

            <div class="col-lg-4">
              <div class="card detail-card">
                <div class="card-body">
                  <h5 class="mb-3">Quick Links</h5>
                  <a href="${s.application_url}" target="_blank" class="btn btn-success w-100 mb-2">
                    <i class="bi bi-box-arrow-up-right"></i> Official Website
                  </a>
                  <button class="btn btn-outline-primary w-100 mb-2" onclick="toggleSave(event, ${s.id})">
                    <i class="bi bi-bookmark"></i> Save for Later
                  </button>
                  ${s.deadline ? `
                    <div class="alert alert-info mt-3 mb-0">
                      <i class="bi bi-clock"></i> <strong>Deadline:</strong> ${escapeHtml(s.deadline)}
                    </div>
                  ` : ''}
                </div>
              </div>

              <div id="relatedSchemes"></div>
            </div>
          </div>
        </div>
      `;

      // Load related schemes
      loadRelatedSchemes(schemeId);
    } else {
      container.innerHTML = `
        <div class="container py-5 text-center">
          <i class="bi bi-exclamation-circle" style="font-size: 4rem; color: var(--danger);"></i>
          <h3 class="mt-3">Scheme Not Found</h3>
          <p class="text-secondary">The scheme you are looking for does not exist.</p>
          <a href="/" class="btn btn-primary mt-3">Go Home</a>
        </div>
      `;
    }
  } catch (error) {
    showError(container, 'Failed to load scheme details');
  }
}

async function loadRelatedSchemes(schemeId) {
  const container = document.getElementById('relatedSchemes');
  if (!container) return;

  try {
    const response = await fetch(`${API_BASE}/schemes/${schemeId}/related`);
    const data = await response.json();

    if (data.success && data.related.length > 0) {
      container.innerHTML = `
        <div class="card detail-card">
          <div class="card-body">
            <h5 class="mb-3"><i class="bi bi-link-45deg text-primary"></i> Related Schemes</h5>
            <div class="list-group list-group-flush">
              ${data.related.map(r => `
                <a href="/scheme/${r.id}" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                  <div>
                    <h6 class="mb-1">${escapeHtml(r.name)}</h6>
                    <small class="text-secondary">${r.scope === 'central' ? 'Central' : 'State'}</small>
                  </div>
                  <i class="bi bi-chevron-right text-secondary"></i>
                </a>
              `).join('')}
            </div>
          </div>
        </div>
      `;
    }
  } catch (error) {
    console.log('Failed to load related schemes');
  }
}

// ============================================
// AUTH FORMS
// ============================================
function initLoginForm() {
  const form = document.getElementById('loginForm');
  if (!form) return;

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const submitBtn = form.querySelector('button[type="submit"]');
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Logging in...';

    try {
      const response = await fetch(`${API_BASE}/users/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          email: document.getElementById('email').value,
          password: document.getElementById('password').value
        })
      });
      const data = await response.json();

      if (data.success) {
        showToast('Login successful!');
        const redirect = new URLSearchParams(window.location.search).get('redirect') || '/';
        setTimeout(() => window.location.href = redirect, 500);
      } else {
        showToast(data.message, 'error');
        submitBtn.disabled = false;
        submitBtn.innerHTML = 'Login';
      }
    } catch (error) {
      showToast('Login failed', 'error');
      submitBtn.disabled = false;
      submitBtn.innerHTML = 'Login';
    }
  });
}

function initRegisterForm() {
  const form = document.getElementById('registerForm');
  if (!form) return;

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    if (password !== confirmPassword) {
      showToast('Passwords do not match', 'error');
      return;
    }

    const submitBtn = form.querySelector('button[type="submit"]');
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Creating account...';

    try {
      const response = await fetch(`${API_BASE}/users/register`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          name: document.getElementById('name').value,
          email: document.getElementById('email').value,
          password: password,
          age: parseInt(document.getElementById('age')?.value) || null,
          gender: document.getElementById('gender')?.value || null,
          annual_income: parseFloat(document.getElementById('income')?.value) || null,
          occupation: document.getElementById('occupation')?.value || null,
          education_level: document.getElementById('education')?.value || null,
          caste_category: document.getElementById('caste')?.value || null,
          district: document.getElementById('district')?.value || null
        })
      });
      const data = await response.json();

      if (data.success) {
        showToast('Registration successful! Please login.');
        setTimeout(() => window.location.href = '/login', 1000);
      } else {
        showToast(data.message, 'error');
        submitBtn.disabled = false;
        submitBtn.innerHTML = 'Create Account';
      }
    } catch (error) {
      showToast('Registration failed', 'error');
      submitBtn.disabled = false;
      submitBtn.innerHTML = 'Create Account';
    }
  });
}

// ============================================
// ADMIN DASHBOARD
// ============================================
async function loadAdminDashboard() {
  const container = document.getElementById('adminDashboard');
  if (!container) return;

  try {
    const response = await fetch(`${API_BASE}/admin/stats`);
    const data = await response.json();

    if (!data.success) {
      window.location.href = '/admin';
      return;
    }

    const s = data.stats;

    container.innerHTML = `
      <div class="row g-4 mb-4">
        <div class="col-md-3">
          <div class="stat-card">
            <div class="stat-icon blue"><i class="bi bi-grid"></i></div>
            <div class="stat-info"><h3>${s.totalSchemes}</h3><p>Total Schemes</p></div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="stat-card">
            <div class="stat-icon green"><i class="bi bi-check-circle"></i></div>
            <div class="stat-info"><h3>${s.activeSchemes}</h3><p>Active Schemes</p></div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="stat-card">
            <div class="stat-icon orange"><i class="bi bi-people"></i></div>
            <div class="stat-info"><h3>${s.totalUsers}</h3><p>Registered Users</p></div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="stat-card">
            <div class="stat-icon red"><i class="bi bi-bookmark"></i></div>
            <div class="stat-info"><h3>${s.totalSaves}</h3><p>Total Saves</p></div>
          </div>
        </div>
      </div>

      <div class="row g-4">
        <div class="col-lg-8">
          <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
              <h5 class="mb-0">Popular Schemes</h5>
              <a href="#" class="btn btn-sm btn-primary" onclick="showAddSchemeModal(); return false;">+ Add Scheme</a>
            </div>
            <div class="card-body p-0">
              <div class="table-responsive">
                <table class="table table-hover">
                  <thead><tr><th>Scheme</th><th>Scope</th><th>Saves</th></tr></thead>
                  <tbody>
                    ${s.popularSchemes.map(p => `
                      <tr>
                        <td>${escapeHtml(p.name)}</td>
                        <td><span class="badge ${p.scope === 'central' ? 'bg-danger' : 'bg-success'}">${p.scope}</span></td>
                        <td>${p.save_count}</td>
                      </tr>
                    `).join('')}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
        <div class="col-lg-4">
          <div class="card">
            <div class="card-header"><h5 class="mb-0">Categories</h5></div>
            <div class="card-body">
              ${s.categoryStats.map(c => `
                <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                  <span>${escapeHtml(c.name)}</span>
                  <span class="badge bg-primary">${c.scheme_count}</span>
                </div>
              `).join('')}
            </div>
          </div>
        </div>
      </div>

      <div class="card mt-4">
        <div class="card-header"><h5 class="mb-0">Recent Users</h5></div>
        <div class="card-body p-0">
          <div class="table-responsive">
            <table class="table table-hover">
              <thead><tr><th>Name</th><th>Email</th><th>Joined</th></tr></thead>
              <tbody>
                ${s.recentUsers.map(u => `
                  <tr>
                    <td>${escapeHtml(u.name)}</td>
                    <td>${escapeHtml(u.email)}</td>
                    <td>${formatDate(u.created_at)}</td>
                  </tr>
                `).join('')}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    `;
  } catch (error) {
    container.innerHTML = '<div class="alert alert-danger">Failed to load dashboard data</div>';
  }
}

// ============================================
// INITIALIZATION
// ============================================
document.addEventListener('DOMContentLoaded', () => {
  // Check session
  checkSession();

  // Initialize language
  setLanguage(currentLang);

  // Page-specific initialization
  const path = window.location.pathname;

  if (path === '/' || path === '/index.html') {
    loadCategories();
    loadSchemes('featuredSchemes', { limit: 6 });
  } else if (path === '/form' || path === '/form.html') {
    initEligibilityForm();
  } else if (path === '/results' || path === '/results.html') {
    loadResults();
  } else if (path.startsWith('/scheme/')) {
    loadSchemeDetail();
  } else if (path === '/login' || path === '/login.html') {
    initLoginForm();
  } else if (path === '/register' || path === '/register.html') {
    initRegisterForm();
  } else if (path === '/admin/dashboard') {
    loadAdminDashboard();
  }

  // Language switcher event listeners
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.addEventListener('click', () => setLanguage(btn.dataset.lang));
  });
});
