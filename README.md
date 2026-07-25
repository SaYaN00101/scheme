# SchemeSeeker - Government Scheme Eligibility Finder

A comprehensive web application for citizens of West Bengal to discover and check their eligibility for Central Government and West Bengal State Government welfare schemes.

## Features

- **Eligibility Checker**: Enter your demographic details and instantly find matching schemes
- **45+ Government Schemes**: Comprehensive database of Central and State schemes
- **Bilingual Support**: English and Bengali language support
- **User Authentication**: Register/login to save and bookmark schemes
- **Admin Dashboard**: Manage schemes, view statistics, and monitor usage
- **Responsive Design**: Works on mobile, tablet, and desktop
- **Category Browsing**: Browse schemes by category (Farmers, Women, Students, Health, etc.)

## Tech Stack

- **Frontend**: HTML5, CSS3, JavaScript, Bootstrap 5, Bootstrap Icons
- **Backend**: Node.js, Express.js
- **Database**: MySQL (via mysql2/promise)
- **Authentication**: bcrypt, express-session
- **Fonts**: Inter, Noto Sans Bengali (Google Fonts)

## Project Structure

```
scheme_finder/
  config/
    db.js              # MySQL connection pool
  routes/
    schemes.js         # Scheme search, filter, eligibility matching
    users.js           # User registration, login, profile
    admin.js           # Admin login, CRUD, statistics
  middleware/
    auth.js            # Authentication guards
  public/
    css/
      style.css        # Custom styles & theme
    js/
      main.js          # Frontend JavaScript
  views/
    index.html         # Home page
    form.html          # Eligibility form
    results.html       # Matching schemes display
    scheme-detail.html # Single scheme details
    login.html         # User login
    register.html      # User registration
    admin/
      login.html       # Admin login
      dashboard.html   # Admin panel
  database.sql         # Complete database schema + 45 schemes
  server.js            # Express server entry point
  .env                 # Environment variables
  package.json         # Dependencies
```

## Quick Start

### 1. Prerequisites
- Node.js (v14 or higher)
- MySQL (v5.7 or higher)

### 2. Database Setup
```bash
# Login to MySQL
mysql -u root -p

# Create database and import schema
mysql -u root -p < database.sql
```

### 3. Environment Configuration
```bash
# Copy the .env file and update with your credentials
cp .env.example .env

# Edit .env with your MySQL credentials
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=scheme_finder
PORT=3000
SESSION_SECRET=your_secret_key
```

### 4. Install Dependencies
```bash
npm install
```

### 5. Start the Server
```bash
# Development mode (with nodemon)
npm run dev

# Production mode
npm start
```

The application will be available at `http://localhost:3000`

### 6. Create Admin Account
```bash
# Use curl or Postman to create the first admin
curl -X POST http://localhost:3000/api/admin/setup \
  -H "Content-Type: application/json" \
  -d '{"name":"Admin","email":"admin@schemeseeker.in","password":"admin123"}'
```

## API Endpoints

### Schemes
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/schemes | List all schemes (with filters) |
| GET | /api/schemes/:id | Get single scheme details |
| POST | /api/schemes/find | Core eligibility matching |
| GET | /api/schemes/categories/all | List all categories |

### Users
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/users/register | Register new user |
| POST | /api/users/login | User login |
| POST | /api/users/logout | User logout |
| GET | /api/users/profile | Get user profile |
| PUT | /api/users/profile | Update profile |
| GET | /api/users/saved-schemes | Get saved schemes |
| POST | /api/users/save-scheme | Save a scheme |
| DELETE | /api/users/save-scheme/:id | Remove saved scheme |

### Admin
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/admin/setup | Create first admin |
| POST | /api/admin/login | Admin login |
| POST | /api/admin/logout | Admin logout |
| GET | /api/admin/stats | Dashboard statistics |
| GET | /api/admin/schemes | List all schemes (admin) |
| POST | /api/admin/schemes | Create scheme |
| PUT | /api/admin/schemes/:id | Update scheme |
| DELETE | /api/admin/schemes/:id | Deactivate scheme |
| GET | /api/admin/users | List all users |

## Pages

| Route | Description |
|-------|-------------|
| `/` | Home page with categories and featured schemes |
| `/form` | Eligibility checker form |
| `/results` | Matching schemes based on form input |
| `/scheme/:id` | Detailed scheme information |
| `/login` | User login |
| `/register` | User registration |
| `/admin` | Admin login |
| `/admin/dashboard` | Admin dashboard |

## Schemes Included

### Central Government Schemes (15+)
- PM-KISAN, Ayushman Bharat (PM-JAY), National Scholarship Portal
- IGNOAPS Pension, PMEGP, Beti Bachao Beti Padhao + Sukanya Samriddhi
- PMAY-Gramin, PM Ujjwala Yojana, PM Vishwakarma, PM SVANidhi
- PM Kisan Maan Dhan, National Family Benefit Scheme
- Atal Pension Yojana, PM Jan Dhan Yojana, PMSBY, PMJJBY
- Stand-Up India, MUDRA Loan

### West Bengal State Schemes (30+)
- Krishak Bandhu, Lakshmir Bhandar, Kanyashree Prakalpa
- Rupashree Prakalpa, Aikyashree Scholarship, SVMCM
- Sabuj Sathi, Swasthya Sathi, Jai Bangla Pension
- Taposhili Bandhu, Banglar Yuva Sathi, Karma Sathi
- Banglar Bari, Student Credit Card, Medhashree
- Sikshashree, Gyan Prasarak, Manabik Pension
- Widow Pension, Old Age Pension, Bangla Fasal Bima
- Matri Shakti Bhandar, Annapurna Bhandar, Yuvasree Arpan
- Gatidhara, CMAT Scholarship, Gitanjali Housing

## License

This project is for educational purposes. All scheme data is sourced from publicly available government information.

## Credits

- Bootstrap 5 - UI Framework
- Bootstrap Icons - Icon library
- Google Fonts - Inter and Noto Sans Bengali fonts
- Scheme data sourced from official government portals
