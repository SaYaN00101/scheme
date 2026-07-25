-- SchemeSeeker - Government Scheme Eligibility Finder
-- Complete Database Schema with 45+ Schemes
-- Run: mysql -u root -p < database.sql

CREATE DATABASE IF NOT EXISTS scheme_finder;
USE scheme_finder;

-- Drop tables if exist (for fresh setup)
DROP TABLE IF EXISTS pending_updates;
DROP TABLE IF EXISTS saved_schemes;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS schemes;
DROP TABLE IF EXISTS scheme_categories;
DROP TABLE IF EXISTS admins;

-- ==========================================
-- 1. SCHEME CATEGORIES
-- ==========================================
CREATE TABLE scheme_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    icon VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert Categories
INSERT INTO scheme_categories (name, icon, description) VALUES
('Farmers', 'bi bi-flower1', 'Schemes for farmers and agricultural workers'),
('Women', 'bi bi-female', 'Schemes for women empowerment and welfare'),
('Students', 'bi bi-book', 'Educational scholarships and student support'),
('Health', 'bi bi-heart-pulse', 'Healthcare and medical insurance schemes'),
('Senior Citizens', 'bi bi-person-walking', 'Pension and welfare for elderly citizens'),
('Employment', 'bi bi-briefcase', 'Job creation, loans, and skill development'),
('Housing', 'bi bi-house', 'Housing and shelter schemes');

-- ==========================================
-- 2. SCHEMES (Central + West Bengal State)
-- ==========================================
CREATE TABLE schemes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    scope ENUM('central', 'state') NOT NULL,
    state VARCHAR(50) DEFAULT 'all',
    min_age INT DEFAULT 0,
    max_age INT DEFAULT 120,
    gender ENUM('male', 'female', 'all') DEFAULT 'all',
    max_income DECIMAL(12,2) DEFAULT NULL,
    occupation VARCHAR(100) DEFAULT 'all',
    education_level VARCHAR(100) DEFAULT 'all',
    caste_category VARCHAR(50) DEFAULT 'all',
    benefit_details TEXT NOT NULL,
    documents_required TEXT NOT NULL,
    application_url VARCHAR(500),
    deadline VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES scheme_categories(id)
);

-- ==========================================
-- CENTRAL GOVERNMENT SCHEMES
-- ==========================================

-- 1. PM-KISAN (Farmers)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(1, 'PM-KISAN (Pradhan Mantri Kisan Samman Nidhi)', 'Financial support to small and marginal farmers across India. Provides income support of Rs. 6,000 per year in three equal installments of Rs. 2,000 each directly to farmers bank accounts through DBT.', 'central', 'all', 18, 120, 'all', NULL, 'farmer', 'all', 'all', 'Rs. 6,000 per year in three installments of Rs. 2,000 each. Additional Rs. 2 lakh life insurance under PM-KISAN credit card. Direct Benefit Transfer to Aadhaar-linked bank account.', 'Aadhaar Card, Bank Account Details (IFSC), Land Records (RoR/Patta), Voter ID, Passport Size Photo, Mobile Number linked to Aadhaar', 'https://pmkisan.gov.in', 'Ongoing - Open throughout the year');

-- 2. Ayushman Bharat PM-JAY (Health)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(4, 'Ayushman Bharat (PM-JAY)', 'Worlds largest government-funded health assurance scheme providing cashless health coverage up to Rs. 5 lakh per family per year for secondary and tertiary care hospitalization. Now operational in West Bengal.', 'central', 'all', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Cashless hospitalization up to Rs. 5 lakh per family per year. Coverage of 1,900+ treatment procedures including surgeries. Pre-existing diseases covered from day one. Cashless treatment at 30,000+ empanelled hospitals. Rs. 200 transport allowance per hospitalization.', 'Aadhaar Card, Ration Card, SECC 2011 eligibility or BPL certificate, Mobile Number, Passport Size Photo. For senior citizens 70+: Age proof, Aadhaar Card.', 'https://pmjay.gov.in', 'Ongoing');

-- 3. National Scholarship Portal (Students)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(3, 'National Scholarship Portal (NSP)', 'Central governments unified digital scholarship platform offering multiple scholarships for SC/ST/OBC/Minority students from Class 1 to PhD level.', 'central', 'all', 5, 35, 'all', 250000, 'all', 'all', 'all', 'Pre-Matric Scholarship: Up to Rs. 3,500 per year. Post-Matric Scholarship: Up to Rs. 20,000 per year. Merit-cum-Means: Up to Rs. 20,000 per year. Top Class Education: Full tuition fee + Rs. 2,200/month living expenses.', 'Aadhaar Card, Income Certificate, Caste Certificate (SC/ST/OBC), Bank Account Details, Previous Year Marksheet, Institute Verification Certificate, Passport Size Photo, Domicile Certificate', 'https://scholarships.gov.in', 'Annual - Application opens August-October');

-- 4. IGNOAPS Pension (Senior Citizens)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(5, 'IGNOAPS (Indira Gandhi National Old Age Pension)', 'Central government pension scheme for elderly citizens living below the poverty line. Provides monthly financial assistance to destitute senior citizens aged 60 years and above.', 'central', 'all', 60, 120, 'all', NULL, 'all', 'all', 'all', 'Monthly pension of Rs. 200 for ages 60-79 years. Monthly pension of Rs. 500 for ages 80 years and above. State governments may add top-up amounts. Paid quarterly through DBT.', 'Age Proof (Birth Certificate/Voter ID), BPL Ration Card, Aadhaar Card, Bank/Post Office Account Details, Residence Proof, Passport Size Photo', 'https://nsap.nic.in', 'Ongoing');

-- 5. PMEGP (Employment)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(6, 'PMEGP (Prime Minister Employment Generation Programme)', 'Credit-linked subsidy scheme to generate self-employment opportunities through micro-enterprises. Provides loans for manufacturing, service, and business sectors with margin money subsidy.', 'central', 'all', 18, 65, 'all', NULL, 'unemployed', '8th', 'all', 'Maximum loan of Rs. 50 lakh (manufacturing) and Rs. 20 lakh (service). Subsidy: 15-35% of project cost. Interest rate: As per bank rates. Beneficiary contribution: 5-10%. No collateral required for loans up to Rs. 10 lakh.', 'Aadhaar Card, Caste Certificate, EDP Training Certificate, Project Report, Rural Area Certificate (if applicable), Bank Account Details, Passport Size Photo, Education Certificate (8th pass minimum for projects above Rs. 10 lakh)', 'https://www.kviconline.gov.in/pmegpeportal', 'Ongoing');

-- 6. Beti Bachao Beti Padhao + Sukanya Samriddhi (Women)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(2, 'Beti Bachao Beti Padhao + Sukanya Samriddhi Yojana', 'National campaign to save and educate the girl child. Linked with Sukanya Samriddhi Yojana which provides savings account for girl child with attractive interest rate of 8.2% per annum.', 'central', 'all', 0, 10, 'female', NULL, 'all', 'all', 'all', 'Sukanya Samriddhi Yojana: Minimum deposit Rs. 250 per year, Maximum Rs. 1.5 lakh per year. Interest rate: 8.2% p.a. (tax-free). Maturity at age 21. Partial withdrawal allowed at age 18 for education. Tax benefits under Section 80C.', 'Girl Child Birth Certificate, Parents/Guardians Aadhaar and PAN Card, Address Proof, Passport Size Photos of Parents and Child. Can be opened at Post Office or any authorized bank.', 'https://www.indiapost.gov.in', 'Open throughout the year');

-- 7. PMAY-Gramin (Housing)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(7, 'PMAY-Gramin (Pradhan Mantri Awaas Yojana - Rural)', 'Housing for All scheme providing pucca houses with basic amenities to eligible rural households. Targets homeless families and those living in kutcha/dilapidated houses.', 'central', 'all', 18, 120, 'all', NULL, 'all', 'all', 'all', 'Financial assistance of Rs. 1,20,000 in plain areas and Rs. 1,30,000 in hilly/North Eastern regions. Additional Rs. 12,000 for toilet under Swachh Bharat Mission. Up to 95 days of MGNREGA employment. Loan facility up to Rs. 70,000 at 3% interest subsidy.', 'Aadhaar Card, BPL/SECC 2011 eligibility proof, Bank Account Details (Aadhaar-linked), MGNREGA Job Card (if available), Consent form for Gram Sabha verification', 'https://pmayg.nic.in', 'Ongoing - Extended till 2029');

-- 8. PM Ujjwala Yojana (Women)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(2, 'PM Ujjwala Yojana (PMUY)', 'Scheme providing free LPG connections to women from Below Poverty Line households. Aims to replace unclean cooking fuels with clean LPG for better health of women and children.', 'central', 'all', 18, 120, 'female', NULL, 'all', 'all', 'all', 'Free LPG connection (security deposit waived). Free first refill and stove (hot plate). Subsidy of Rs. 300 per cylinder on first 4 refills per year (Rs. 1,200/year). Connection cost borne by government: Rs. 1,600 for 14.2kg or Rs. 1,150 for 5kg cylinder.', 'Aadhaar Card, Ration Card/Family ID, Address Proof, Bank Account Details, Passport Size Photo, Deprivation Declaration (14-point format), Mobile Number', 'https://pmuy.gov.in', 'Ongoing');

-- 9. PM Vishwakarma Yojana (Employment)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(6, 'PM Vishwakarma Yojana', 'Scheme to support traditional artisans and craftspeople (Vishwakarmas) engaged in 25 traditional trades. Provides toolkit incentives, skill training, and collateral-free credit support.', 'central', 'all', 18, 65, 'all', NULL, 'artisan', 'all', 'all', 'Toolkit incentive of Rs. 15,000 (e-voucher). Collateral-free credit: Rs. 1 lakh (first tranche) and Rs. 2 lakh (second tranche) at 5% interest. Basic and advanced skill training. Marketing support. Digital transaction incentives. PM Vishwakarma Certificate and ID Card.', 'Aadhaar Card, Bank Account Details, Passport Size Photo, Proof of trade/occupation (if available), Biometric registration at CSC', 'https://pmvishwakarma.gov.in', 'Ongoing');

-- 10. PM SVANidhi (Employment)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(6, 'PM SVANidhi (Street Vendor Atmanirbhar Nidhi)', 'Micro-credit scheme providing collateral-free working capital loans to street vendors to help resume and expand their businesses. Promotes digital transactions among vendors.', 'central', 'all', 18, 65, 'all', NULL, 'street_vendor', 'all', 'all', 'Tranche 1: Loan up to Rs. 15,000 (12 months tenure). Tranche 2: Loan up to Rs. 25,000 (18 months tenure). Tranche 3: Loan up to Rs. 50,000 (36 months tenure). Interest subsidy of 7% on regular repayment. Cashback up to Rs. 1,200/year on digital transactions. No collateral required.', 'Aadhaar Card, Certificate of Vending/ID Card from ULB, Bank Account Details, Passport Size Photo, Mobile Number, Self-declaration', 'https://pmsvanidhi.mohua.gov.in', 'Ongoing - Extended till 2030');

-- ==========================================
-- WEST BENGAL STATE GOVERNMENT SCHEMES
-- ==========================================

-- 11. Krishak Bandhu (Farmers)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(1, 'Krishak Bandhu Prakalpa', 'West Bengal governments flagship scheme for farmers providing assured income support and death benefit. Covers all farmers with cultivable land including sharecroppers (bargadars).', 'state', 'west bengal', 18, 60, 'all', NULL, 'farmer', 'all', 'all', 'Assured Income: Rs. 10,000/year for 1 acre or more of cultivable land. Rs. 4,000/year for less than 1 acre (in 2 installments - Kharif & Rabi). Death Benefit: Rs. 2 lakh one-time grant to family in case of death of farmer aged 18-60 years.', 'Land Records (RoR/Patta/Barga documents), Aadhaar Card, Voter ID, Bank Passbook/Cancelled Cheque, Passport Size Photo, Mobile Number', 'https://krishakbandhu.net', 'Ongoing - Open throughout the year');

-- 12. Lakshmir Bhandar Prakalpa (Women)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(2, 'Lakshmir Bhandar Prakalpa', 'Monthly financial assistance scheme for women from economically weaker households in West Bengal. One of the most popular women welfare schemes in the state providing direct cash transfer.', 'state', 'west bengal', 25, 60, 'female', NULL, 'all', 'all', 'all', 'General Category: Rs. 1,500 per month (Rs. 18,000/year). SC/ST Category: Rs. 1,700 per month (Rs. 20,400/year). Direct Benefit Transfer to Aadhaar-linked bank account. For women enrolled under Swasthya Sathi scheme.', 'Swasthya Sathi Card, Aadhaar Card, SC/ST Certificate (if applicable), Bank Account Details (single account in womans name only), Passport Size Photo, Residence Proof', 'Available at Duare Sarkar camps', 'Ongoing');

-- 13. Kanyashree Prakalpa (Women/Students)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(2, 'Kanyashree Prakalpa', 'Flagship scheme to prevent child marriage and promote education among adolescent girls. One of the worlds largest cash transfer programs for girls education with UNESCO recognition.', 'state', 'west bengal', 13, 18, 'female', 120000, 'student', '8th', 'all', 'K1: Annual scholarship of Rs. 1,000 for girls aged 13-18 in Class 8-12. K2: One-time grant of Rs. 25,000 for unmarried girls aged 18+ continuing education. K3: Variable financial aid for postgraduate and professional courses. Total potential benefit: Rs. 50,000+ over lifetime.', 'Birth Certificate/Aadhaar Card, Income Certificate (family income below Rs. 1.2 lakh), School/College Admission Certificate, Bank Account Details, Residence Proof, Declaration of Unmarried Status (for K2)', 'https://wbkanyashree.gov.in', 'Open throughout the year');

-- 14. Rupashree Prakalpa (Women)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(2, 'Rupashree Prakalpa', 'One-time financial grant for economically stressed families at the time of their adult daughters marriage. Aims to reduce financial burden on poor families during marriages.', 'state', 'west bengal', 18, 35, 'female', 150000, 'all', 'all', 'all', 'One-time grant of Rs. 25,000 at the time of first marriage. Direct transfer to bank account. Applicable for marriages effected on or after April 1, 2018. Both rural and urban areas covered.', 'Birth Certificate/Age Proof, Proof of West Bengal residency (5+ years or born in WB), Income Certificate (below Rs. 1.5 lakh), Bank Account (sole account holder), Marriage declaration, Prospective grooms age proof (21+ years)', 'Available at Duare Sarkar camps/BDO Office', 'Ongoing');

-- 15. Aikyashree Scholarship (Students)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(3, 'Aikyashree Scholarship', 'Comprehensive scholarship portal for minority community students (Muslim, Christian, Sikh, Buddhist, Jain, Parsi) in West Bengal. Covers education from Class 1 to PhD level.', 'state', 'west bengal', 5, 40, 'all', 200000, 'student', 'all', 'all', 'Pre-Matric: Up to Rs. 3,500/year (Class 1-10). Post-Matric: Up to Rs. 10,000/year (Class 11-PhD). Merit-cum-Means: Up to Rs. 20,000/year + maintenance allowance. Talent Support: Additional stipend for meritorious students. SVMCM for Minorities: Up to Rs. 8,000/month.', 'Aadhaar Card, Income Certificate (below Rs. 2 lakh), Minority Community Certificate, Bank Account Details, Previous Year Marksheet, Institute Verification, Passport Size Photo, Domicile Certificate', 'https://wbmdfcscholarship.in', 'Annual - Application opens July-September');

-- 16. Swami Vivekananda Merit Scholarship - SVMCM (Students)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(3, 'Swami Vivekananda Merit-cum-Means Scholarship (SVMCM)', 'Merit-based scholarship for economically backward students pursuing higher secondary, undergraduate, postgraduate, and professional courses in West Bengal institutions.', 'state', 'west bengal', 16, 40, 'all', 250000, 'student', '11th', 'all', 'Higher Secondary: Rs. 1,000/month. UG (Arts): Rs. 1,000/month, UG (Science): Rs. 1,500/month. PG (Arts): Rs. 2,000/month, PG (Science): Rs. 2,500/month. Engineering/Medical: Up to Rs. 5,000/month. M.Phil/PhD: Up to Rs. 8,000/month. Kanyashree K3 (girls): Relaxation in marks requirement.', 'Aadhaar Card, Income Certificate (below Rs. 2.5 lakh), Previous Qualifying Marksheet (min 60%), Admission Receipt, Bank Account Details, Passport Size Photo, Domicile Certificate', 'https://svmcm.wb.gov.in', 'Annual - Application opens after results');

-- 17. Sabuj Sathi (Students)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(3, 'Sabuj Sathi (Free Bicycle Scheme)', 'Universal free bicycle distribution scheme for all students of government and government-aided secondary and higher secondary schools and madrasahs in West Bengal.', 'state', 'west bengal', 13, 18, 'all', NULL, 'student', '9th', 'all', 'Free bicycle to all eligible students studying in Class 9-12 in government/government-aided schools. No income or caste criteria. Universal coverage. Over 1.5 crore students benefited since 2015. Aims to improve school attendance and reduce dropout rates.', 'School ID Card/Admission Certificate, Aadhaar Card (if available), Passport Size Photo, Parents declaration. Distributed through schools.', 'Through respective schools', 'Ongoing - New academic year enrollment');

-- 18. Swasthya Sathi (Health)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(4, 'Swasthya Sathi', 'Universal health coverage scheme by West Bengal government providing cashless medical treatment up to Rs. 5 lakh per family per year. One of the most comprehensive state health schemes in India.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Cashless health coverage up to Rs. 5 lakh per family per year. No family size limit. Covers 2,092+ medical packages. Cashless treatment at 2,290+ empanelled hospitals. Pre-existing diseases covered from day one. Rs. 200 transport allowance at discharge. Covers secondary and tertiary care including surgery, maternity, ICU, diagnostics.', 'Aadhaar Card, Khadyasathi Ration Card, Mobile Number, Employment Status Declaration, Domicile Document. Can apply online or at Duare Sarkar camps.', 'https://swasthyasathi.gov.in', 'Ongoing - Open throughout the year');

-- 19. Jai Bangla Pension (Senior Citizens)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(5, 'Jai Bangla Pension Scheme', 'Umbrella pension scheme for elderly citizens from economically weaker sections in West Bengal. Includes Taposili Bandhu (for SC) and Jai Johar (for ST) pension schemes.', 'state', 'west bengal', 60, 120, 'all', NULL, 'all', 'all', 'all', 'SC beneficiaries (Taposili Bandhu): Rs. 600/month. ST beneficiaries (Jai Johar): Rs. 1,000/month. General/OBC: Rs. 1,000/month (under Joy Bangla). Direct bank transfer monthly. For low-income families without regular pension income.', 'Age Proof, Aadhaar Card, Caste Certificate (SC/ST), Income Certificate/BPL Card, Bank Account Details, Residence Proof, Passport Size Photo', 'Available at Block Development Office/Duare Sarkar camps', 'Ongoing');

-- 20. Taposhili Bandhu (Senior Citizens)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(5, 'Taposhili Bandhu Pension (for SC)', 'Dedicated pension scheme for Scheduled Caste senior citizens in West Bengal aged 60 years and above. Now merged under Jai Bangla Pension umbrella.', 'state', 'west bengal', 60, 120, 'all', NULL, 'all', 'all', 'sc', 'Monthly pension of Rs. 600 for SC beneficiaries aged 60+. Direct Benefit Transfer to bank account. No contribution required from beneficiary. Additional benefits under Jai Bangla umbrella.', 'SC Caste Certificate, Age Proof, Aadhaar Card, Income Certificate, Bank Account Details, Residence Proof, Passport Size Photo', 'Available at BDO Office', 'Ongoing');

-- 21. Banglar Yuva Sathi (Employment)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(6, 'Banglar Yuva Sathi Prakalpa', 'Monthly financial assistance scheme for educated unemployed youth in West Bengal. Launched in 2026 to provide economic relief during job search period.', 'state', 'west bengal', 21, 40, 'all', NULL, 'unemployed', '10th', 'all', 'Monthly allowance of Rs. 1,500 through DBT. Maximum benefit: Rs. 90,000 over 5 years (60 months). Available until beneficiary secures employment. Scholarship recipients (Aikyashree, SVMCM) can also apply if unemployed.', 'Aadhaar Card, Madhyamik (Class 10) Marksheet and Admit Card, Bank Passbook (Aadhaar-linked), Residence Proof, Passport Size Photo, Voter ID, Income Certificate, Self-declaration of unemployment', 'https://yubasathi.wb.gov.in', 'Phase-based application');

-- 22. Karma Sathi Prakalpa (Employment)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(6, 'Karma Sathi Prakalpa', 'Soft loan and subsidy scheme for young entrepreneurs to set up manufacturing enterprises and small businesses in West Bengal. Promotes self-employment among youth.', 'state', 'west bengal', 18, 50, 'all', NULL, 'unemployed', '8th', 'all', 'Soft loan up to Rs. 2 lakh from Cooperative Bank. Project subsidy: 15% of project cost or max Rs. 25,000. Interest subsidy: 50% refund on timely repayment for 3 years. For manufacturing, service, trading sectors. Target: 1 lakh youth per year.', 'Aadhaar Card, Age Proof, Education Certificate (Class 8+), Project Report, Bank Account Details, Caste Certificate (if applicable), Residence Proof, Passport Size Photo', 'https://karmasathi.wb.gov.in', 'Ongoing');

-- 23. Banglar Bari / Bangla Awas Yojana (Housing)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(7, 'Banglar Bari (Bangla Awas Yojana)', 'West Bengal governments own housing scheme providing pucca houses to economically weaker families. State-funded alternative to PMAY for those left out of central scheme.', 'state', 'west bengal', 18, 120, 'all', NULL, 'all', 'all', 'all', 'Financial assistance for construction of pucca house. Installment-based disbursement linked to construction progress. Priority to families in kutcha/temporary houses. Special priority for widows, single mothers, differently-abled, SC/ST families.', 'Aadhaar Card, Ration Card, Voter ID, Income Certificate, Land Documents (if available), Disability Certificate (if applicable), Bank Account Details, Passport Size Photo', 'https://wbhousing.gov.in', 'Ongoing');

-- 24. West Bengal Student Credit Card (Students)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(3, 'West Bengal Student Credit Card', 'Collateral-free education loan scheme for students pursuing higher education within India or abroad. One of the most ambitious student loan schemes in India with low interest rates.', 'state', 'west bengal', 15, 40, 'all', NULL, 'student', '10th', 'all', 'Collateral-free loan up to Rs. 10 lakh. Simple interest rate: 4% per annum (3% if interest paid during study). Repayment period: Up to 15 years. Moratorium: 1 year after course completion. Covers tuition, hostel, books, laptop, study tours. Life insurance cover up to loan amount.', 'Aadhaar Card, Residence Proof (10+ years in WB), Age Proof, Admission Letter, Course Fee Structure, Previous Academic Marksheets, Co-borrower (Parent/Guardian) details, Bank Account Details, Passport Size Photo', 'https://wbscc.wb.gov.in', 'Open throughout the year');

-- ==========================================
-- ADDITIONAL CENTRAL SCHEMES
-- ==========================================

-- 25. PM Kisan Maan Dhan Yojana (Farmers/Senior)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(5, 'PM Kisan Maan Dhan Yojana (PM-KMDY)', 'Pension scheme for small and marginal farmers providing social security cover in old age. Voluntary contributory pension scheme with government matching contribution.', 'central', 'all', 18, 40, 'all', NULL, 'farmer', 'all', 'all', 'Monthly pension of Rs. 3,000 after attaining 60 years. Beneficiary contribution: Rs. 55-200/month (age-based). Matching contribution by Central Government. Family pension to spouse on death of beneficiary.', 'Aadhaar Card, Bank Account Details, PM-KISAN beneficiary ID (if available), Age Proof, Mobile Number, Passport Size Photo', 'https://pmkmy.gov.in', 'Ongoing');

-- 26. National Family Benefit Scheme (Women)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(2, 'National Family Benefit Scheme (NFBS)', 'Component of NSAP providing one-time financial assistance to bereaved families on death of primary breadwinner. Helps families cope with loss of income.', 'central', 'all', 18, 65, 'all', NULL, 'all', 'all', 'all', 'One-time lump sum grant of Rs. 20,000 on death of primary breadwinner aged 18-65 years. For BPL families. Paid to surviving spouse or eldest surviving household member.', 'Death Certificate of breadwinner, BPL Ration Card, Aadhaar Card of applicant, Bank Account Details, Age Proof of deceased, Residence Proof', 'https://nsap.nic.in', 'Must apply within 2 years of death');

-- 27. Atal Pension Yojana (All)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(5, 'Atal Pension Yojana (APY)', 'Government-backed pension scheme for unorganized sector workers. Guaranteed minimum pension ranging from Rs. 1,000 to Rs. 5,000 per month after age 60.', 'central', 'all', 18, 40, 'all', NULL, 'all', 'all', 'all', 'Guaranteed monthly pension: Rs. 1,000/2,000/3,000/4,000/5,000 (chosen by subscriber). Monthly contribution: Rs. 42-1,454 (age and pension amount based). Government co-contribution of 50% (max Rs. 1,000/year) for eligible subscribers for 5 years.', 'Aadhaar Card, Bank Account Details, Mobile Number, Passport Size Photo. Can be opened at any bank or post office.', 'https://www.npscra.nsdl.co.in', 'Ongoing');

-- 28. Pradhan Mantri Jan Dhan Yojana (All)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(6, 'Pradhan Mantri Jan Dhan Yojana (PMJDY)', 'National mission for financial inclusion providing universal access to banking facilities. Zero-balance bank account with insurance and overdraft facility.', 'central', 'all', 10, 120, 'all', NULL, 'all', 'all', 'all', 'Zero balance savings account. RuPay debit card with inbuilt accident insurance of Rs. 1 lakh (Rs. 2 lakh for accounts opened after Aug 2018). Overdraft facility up to Rs. 10,000. Life insurance cover of Rs. 30,000 for accounts opened before Jan 2015. Direct Benefit Transfer facility.', 'Aadhaar Card, PAN Card or Form 60, Address Proof, Passport Size Photo, Mobile Number', 'Any bank branch or Business Correspondent', 'Ongoing');

-- 29. Pradhan Mantri Suraksha Bima Yojana (All)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(4, 'Pradhan Mantri Suraksha Bima Yojana (PMSBY)', 'Accident insurance scheme providing affordable insurance coverage against accidental death and disability. Available through participating banks.', 'central', 'all', 18, 70, 'all', NULL, 'all', 'all', 'all', 'Accidental death coverage: Rs. 2 lakh. Total disability coverage: Rs. 2 lakh. Partial disability coverage: Rs. 1 lakh. Annual premium: Only Rs. 12. Auto-debit from bank account. Coverage period: 1 year (renewable).', 'Aadhaar Card, Bank Account (for auto-debit), Mobile Number. Can be enrolled at any participating bank.', 'Any bank branch', 'Annual renewal on June 1');

-- 30. Pradhan Mantri Jeevan Jyoti Bima Yojana (All)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(4, 'Pradhan Mantri Jeevan Jyoti Bima Yojana (PMJJBY)', 'Life insurance scheme offering affordable life cover for one year with annual renewal. Provides financial protection to family in case of death of insured.', 'central', 'all', 18, 50, 'all', NULL, 'all', 'all', 'all', 'Life insurance cover: Rs. 2 lakh. Annual premium: Only Rs. 436. Death coverage from any cause. Auto-debit from bank account. Coverage period: 1 year (renewable). Available through participating banks.', 'Aadhaar Card, Bank Account (for auto-debit), Mobile Number. Can be enrolled at any participating bank.', 'Any bank branch', 'Annual renewal on June 1');

-- 31. Stand-Up India (Women/SC/ST)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(6, 'Stand-Up India Scheme', 'Bank loan scheme to promote entrepreneurship among women and SC/ST communities. Provides loans for greenfield enterprises in manufacturing, trading, or services.', 'central', 'all', 18, 65, 'all', NULL, 'all', 'all', 'all', 'Composite loan between Rs. 10 lakh and Rs. 1 crore. Covers 75% of project cost. Maximum interest rate: MCLR + 3% + tenor premium. Repayment: Up to 7 years. RuPay debit card provided. Free support services: Pre-loan training, facilitation for obtaining approvals.', 'Aadhaar Card, Caste Certificate (SC/ST) or Gender proof, Project Report, Bank Account Details, Business Plan, Passport Size Photo, Residence Proof', 'Any scheduled commercial bank', 'Ongoing');

-- 32. MUDRA Loan (Employment)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(6, 'MUDRA Loan (PMMY)', 'Micro finance scheme providing loans up to Rs. 10 lakh to non-corporate, non-farm small/micro enterprises. Divided into Shishu, Kishor, and Tarun categories.', 'central', 'all', 18, 65, 'all', NULL, 'self_employed', 'all', 'all', 'Shishu: Up to Rs. 50,000. Kishor: Rs. 50,001 - Rs. 5 lakh. Tarun: Rs. 5,00,001 - Rs. 10 lakh. No collateral required. Interest rate as per bank. For manufacturing, trading, and service sector activities. Can be availed from any bank, MFI, or NBFC.', 'Aadhaar Card, Business Plan/Project Report, Identity Proof, Address Proof, Bank Account Details, Passport Size Photo, Quotation for machinery/equipment (if applicable)', 'Any bank branch', 'Ongoing');

-- ==========================================
-- ADDITIONAL WEST BENGAL STATE SCHEMES
-- ==========================================

-- 33. Medhashree Scholarship (Students)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(3, 'Medhashree Scholarship', 'Scholarship for meritorious SC/ST students in West Bengal pursuing higher secondary and undergraduate courses. Encourages academic excellence among reserved category students.', 'state', 'west bengal', 16, 25, 'all', 250000, 'student', '11th', 'sc', 'Higher Secondary Level: Rs. 800/month for 10 months. Undergraduate Level: Rs. 1,000/month for 10 months. Additional book grant: Rs. 2,000/year. For SC/ST students with 50%+ marks.', 'SC/ST Certificate, Income Certificate (below Rs. 2.5 lakh), Marksheet (50%+ marks), Aadhaar Card, Bank Account Details, School/College ID', 'https://wbscstdev.gov.in', 'Annual');

-- 34. Sikshashree Scholarship (Students)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(3, 'Sikshashree Scholarship', 'Scholarship for SC/ST students of Classes 5 to 8 in West Bengal. Aims to reduce dropout rates and encourage continuation of education among backward classes.', 'state', 'west bengal', 10, 14, 'all', NULL, 'student', '5th', 'sc', 'Annual scholarship of Rs. 750 for day scholars and Rs. 1,500 for hostellers. Additional one-time grant of Rs. 1,000 for books and stationery. For SC/ST students in government/government-aided schools.', 'SC/ST Certificate, School Admission Certificate, Aadhaar Card, Parents Income Certificate, Bank Account Details, Passport Size Photo', 'https://wbscstdev.gov.in', 'Annual - Through schools');

-- 35. Gyan Prasarak Scheme (Students)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(3, 'Gyan Prasarak Scheme', 'Stipend scheme for ST students in West Bengal pursuing general degree courses. Supports tribal students in completing graduation and higher education.', 'state', 'west bengal', 18, 30, 'all', NULL, 'student', '12th', 'st', 'Monthly stipend of Rs. 750 for undergraduate students. Annual book grant of Rs. 2,000. Hostel maintenance allowance for hostellers. For ST students in recognized institutions.', 'ST Certificate, Income Certificate, Admission Certificate, Aadhaar Card, Bank Account Details, Previous Marksheet', 'https://wbscstdev.gov.in', 'Annual');

-- 36. Manabik Pension (Disability)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(5, 'Manabik Pension (Disability Pension)', 'Monthly pension for persons with disabilities in West Bengal. Provides financial assistance to physically challenged individuals who are unable to earn a livelihood.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Monthly pension of Rs. 1,000 for persons with 40% or more disability. Additional Rs. 200 for attendant allowance (for severe disability). Disability certificate from CMOH required. Paid through DBT.', 'Disability Certificate (40%+ from CMOH), Aadhaar Card, BPL Card/Income Certificate, Bank Account Details, Passport Size Photo, Residence Proof', 'Available at BDO Office/SDO Office', 'Ongoing');

-- 37. Widow Pension Scheme (Women)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(2, 'Widow Pension Scheme (IGNWPS equivalent)', 'Monthly pension for widows and destitute women in West Bengal from economically weaker sections. State counterpart of central IGNOAPS widow pension.', 'state', 'west bengal', 40, 120, 'female', NULL, 'all', 'all', 'all', 'Monthly pension of Rs. 1,000 for widows aged 40-59 years. Rs. 1,500 for widows aged 60-79 years. Rs. 2,000 for widows aged 80+ years. Additional Rs. 1,000 under Lakshmir Bhandar if eligible. Paid monthly through DBT.', 'Husbands Death Certificate, Age Proof, Aadhaar Card, Income Certificate/BPL Card, Bank Account Details, Residence Proof, Passport Size Photo', 'Available at Block Development Office', 'Ongoing');

-- 38. Old Age Pension (State) (Senior)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(5, 'Old Age Pension (State Funded)', 'State-funded old age pension for senior citizens in West Bengal who are not covered under central IGNOAPS scheme. For economically weaker elderly above 60 years.', 'state', 'west bengal', 60, 120, 'all', NULL, 'all', 'all', 'all', 'Monthly pension of Rs. 1,000 for ages 60-79 years. Monthly pension of Rs. 1,500 for ages 80+ years. For low-income families not receiving any other pension. Can be combined with central IGNOAPS pension.', 'Age Proof, Aadhaar Card, Income Certificate (below Rs. 2 lakh), Bank Account Details, Residence Proof, Declaration of no other pension, Passport Size Photo', 'Available at BDO Office/Duare Sarkar camps', 'Ongoing');

-- 39. Kharif Crop Insurance (Farmers)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(1, 'Bangla Fasal Bima Yojana (Crop Insurance)', 'State crop insurance scheme for farmers in West Bengal protecting against crop loss due to natural calamities, pests, and diseases. Complements PMFBY.', 'state', 'west bengal', 18, 65, 'all', NULL, 'farmer', 'all', 'all', 'Insurance coverage up to Rs. 2 lakh per hectare. Premium: 2% of sum insured (kharif), 1.5% (rabi). Covers loss due to drought, flood, cyclone, pest attack. Claim settlement within 2 months. Premium subsidy by state government.', 'Land Records (RoR), Aadhaar Card, Bank Account Details, Sowing Certificate, Previous Crop Details, Passport Size Photo', 'Available at Block Agriculture Office', 'Seasonal - Before sowing');

-- 40. Matri Shakti Scheme (Women)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(2, 'Matri Shakti Bhandar Scheme', 'New scheme announced to replace Lakshmir Bhandar from June 2026. Provides enhanced monthly financial assistance to eligible women in West Bengal.', 'state', 'west bengal', 25, 60, 'female', NULL, 'all', 'all', 'all', 'Monthly financial assistance of Rs. 3,000 per month (Rs. 36,000/year). Higher amount than Lakshmir Bhandar. Auto-migration of existing Lakshmir Bhandar beneficiaries. DBT to Aadhaar-linked bank account.', 'Swasthya Sathi Card, Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'Will be notified from June 2026', 'Starting June 2026');

-- 41. Annapurna Bhandar Scheme (Women)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(2, 'Annapurna Bhandar Scheme', 'New food security scheme for women in West Bengal providing subsidized ration and monthly cash assistance. Comprehensive support for nutrition and household expenses.', 'state', 'west bengal', 25, 60, 'female', NULL, 'all', 'all', 'all', 'Monthly cash assistance for food and nutrition. Linked with Khadyasathi ration card. Subsidized food grains at Re. 1/kg for rice. Additional nutritional supplements for pregnant and lactating mothers.', 'Khadyasathi Ration Card, Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'Available at ration shops/Duare Sarkar', 'Ongoing');

-- 42. Yuvasree Arpan (Employment)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(6, 'Yuvasree Arpan Scheme', 'Unemployment allowance scheme for educated youth registered with Employment Bank in West Bengal. Predecessor to Banglar Yuva Sathi scheme.', 'state', 'west bengal', 18, 45, 'all', NULL, 'unemployed', '8th', 'all', 'Monthly unemployment allowance of Rs. 1,500. Available for youth registered with Employment Bank. Can avail for maximum 3 years or until employment. Skill training opportunities provided.', 'Employment Bank Registration, Aadhaar Card, Age Proof, Education Certificate (Class 8+), Bank Account Details, Residence Proof, Unemployment Declaration', 'https://employmentbankwb.gov.in', 'Ongoing');

-- 43. Gatidhara Scheme (Employment)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(6, 'Gatidhara Scheme', 'Scheme providing subsidy for purchase of commercial vehicles to unemployed youth in West Bengal. Promotes self-employment through transport sector.', 'state', 'west bengal', 20, 45, 'all', 250000, 'unemployed', '8th', 'all', 'Subsidy of Rs. 1 lakh for purchase of new commercial vehicle (max 6 wheels). Bank loan for remaining amount. Subsidy directly to bank. For unemployed youth starting transport business.', 'Aadhaar Card, Age Proof, Income Certificate (below Rs. 2.5 lakh), Education Certificate, Driving License (commercial), Bank Account Details, Vehicle quotation', 'https://wbmsme.gov.in', 'Ongoing');

-- 44. CMAT Scholarship (Students)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(3, 'CMAT Scholarship (Chief Minister Assistance for Technical Education)', 'Scholarship for meritorious students from economically weaker sections pursuing technical and professional courses in West Bengal. Merit-cum-means based.', 'state', 'west bengal', 18, 35, 'all', 250000, 'student', '12th', 'all', 'Full tuition fee waiver for government/government-aided institutions. Maintenance allowance: Rs. 2,000/month. Book grant: Rs. 5,000/year. For engineering, medical, management, and other professional courses.', 'Income Certificate (below Rs. 2.5 lakh), Marksheet (60%+ in qualifying exam), Admission Certificate, Aadhaar Card, Bank Account Details, Passport Size Photo', 'https://wbhed.gov.in', 'Annual');

-- 45. Gitanjali Scheme (Housing)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline) VALUES
(7, 'Gitanjali Housing Scheme', 'Affordable housing scheme for economically weaker sections in urban areas of West Bengal. Provides flats at subsidized rates with easy installment facility.', 'state', 'west bengal', 21, 60, 'all', 300000, 'all', 'all', 'all', '1-room flat: Rs. 2.5 lakh (market value Rs. 5 lakh). 2-room flat: Rs. 4 lakh (market value Rs. 8 lakh). Easy EMI facility. Priority for homeless families and those in slums. Available in municipal areas.', 'Aadhaar Card, Income Certificate (below Rs. 3 lakh), Voter ID, Bank Account Details, Residence Proof, BPL Card (if available), Passport Size Photo', 'https://wbhousing.gov.in', 'Project-based');

-- Additional schemes for scheme_finder

INSERT INTO schemes
(category_id,name,description,scope,state,min_age,max_age,gender,max_income,occupation,education_level,caste_category,benefit_details,documents_required,application_url,deadline,is_active)
VALUES
(3,'Oasis Scholarship','Scholarship for SC/ST/OBC students of West Bengal.','state','West Bengal',0,35,'all',250000,'student','all','SC/ST/OBC','Financial assistance for studies.','Aadhaar, caste certificate, income certificate, mark sheet','https://oasis.gov.in',NULL,1),

(3,'Nabanna Scholarship','Financial assistance for meritorious students.','state','West Bengal',0,35,'all',120000,'student','all','all','One-time educational grant.','Aadhaar, marksheet, income certificate','https://cmrf.wb.gov.in',NULL,1),

(6,'Utkarsh Bangla','Skill development programme for youth.','state','West Bengal',18,45,'all',NULL,'unemployed','all','all','Free skill training and placement support.','Aadhaar, educational proof','https://www.pbssd.gov.in',NULL,1),

(6,'Employment Bank','Employment assistance and job notifications.','state','West Bengal',18,60,'all',NULL,'all','all','all','Access to jobs and schemes.','Aadhaar, educational documents','https://employmentbankwb.gov.in',NULL,1),

(1,'Kisan Credit Card','Short-term credit support for farmers.','central','all',18,75,'all',NULL,'farmer','all','all','Easy agricultural loans.','Aadhaar, land records, bank passbook','https://pmkisan.gov.in',NULL,1),

(7,'PMAY Urban','Housing assistance in urban areas.','central','all',18,99,'all',300000,'all','all','all','Subsidized housing support.','Aadhaar, income proof','https://pmaymis.gov.in',NULL,1),

(4,'Shishu Sathi Scheme','Health protection for school children.','state','West Bengal',0,18,'all',NULL,'student','all','all','Medical coverage support.','School ID, Aadhaar','https://wb.gov.in',NULL,1),

(4,'Janani Suraksha Yojana','Safe motherhood scheme.','central','all',18,49,'female',NULL,'all','all','all','Cash assistance for institutional delivery.','Aadhaar, bank account','https://nhm.gov.in',NULL,1),

(1,'Matsyajibi Credit Card Scheme','Credit support for fishermen.','state','West Bengal',18,75,'all',NULL,'fisherman','all','all','Affordable loans.','Aadhaar, fisherman registration','https://wb.gov.in',NULL,1),

(4,'Niramay Health Scheme','Health support for special needs beneficiaries.','state','West Bengal',0,99,'all',NULL,'all','all','all','Medical assistance.','Aadhaar, medical documents','https://wb.gov.in',NULL,1);
-- ==========================================
-- USER MANAGEMENT TABLES
-- ==========================================

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    age INT,
    gender ENUM('male', 'female', 'other'),
    annual_income DECIMAL(12,2),
    occupation VARCHAR(100),
    education_level VARCHAR(50),
    caste_category VARCHAR(50),
    district VARCHAR(100),
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE saved_schemes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    scheme_id INT NOT NULL,
    saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (scheme_id) REFERENCES schemes(id) ON DELETE CASCADE,
    UNIQUE KEY unique_save (user_id, scheme_id)
);

CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pending_updates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    scheme_id INT,
    scheme_name VARCHAR(200),
    change_type VARCHAR(50),
    old_data TEXT,
    new_data TEXT,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    reviewed_by INT,
    reviewed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (scheme_id) REFERENCES schemes(id) ON DELETE SET NULL,
    FOREIGN KEY (reviewed_by) REFERENCES admins(id) ON DELETE SET NULL
);

-- Insert default admin (password: admin123 - change in production)
-- Using bcrypt hash for 'admin123'
INSERT INTO admins (name, email, password_hash) VALUES
('System Admin', 'admin@schemeseeker.in', '$2b$10$YourHashHere.ReplaceWithRealBcryptHash');

-- ==========================================
-- END OF DATABASE SCHEMA
-- ==========================================
