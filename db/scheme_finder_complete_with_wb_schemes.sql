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


-- ==========================================
-- ADDITIONAL WEST BENGAL SCHEMES FROM myScheme.gov.in API
-- 107 schemes extracted, cleaned, and mapped
-- Added: 2026-06-23
-- ==========================================

-- ==========================================
-- WEST BENGAL STATE SCHEMES FROM myScheme API
-- 107 schemes extracted and mapped
-- ==========================================

USE scheme_finder;

-- 1. Kanyashree Prakalpa
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Kanyashree Prakalpa', 'The scheme to improve the status and wellbeing of girls, specifically those from socio-economically disadvantaged families, through Conditional Cash Transfers by: Incentivising them to continue in education for a longer period of time, and complete secondary or higher secondary education.', 'state', 'west bengal', 13, 18, 'female', 120000, 'all', 'all', 'all', 'Tags: Girl, Education, Scholarship, Child Marriage Prevention, Vocational Training, Grants For Higher Education. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbkanyashree', 'Ongoing', TRUE);

-- 2. Pratyasha Scheme- West Bengal
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (7, 'Pratyasha Scheme- West Bengal', 'The Government of West Bengal has undertaken a housing project scheme named ” PRATYASHA” for Police Personnel (from Inspectors to Constables) working in the West Bengal Police to materialize their dreams of owning houses.', 'state', 'west bengal', 0, 120, 'all', NULL, 'police', 'all', 'all', 'Tags: Police, House, Flats, Financial Assistance, Housing Assistance. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/ps-west-bengal', 'Ongoing', TRUE);

-- 3. Gatidhara Scheme
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Gatidhara Scheme', 'The scheme “Gatidhara Scheme” was launched by the Transport Department, Government of West Bengal in August 2014 for employment of registered unemployed youth of the State in the transport sector.', 'state', 'west bengal', 18, 40, 'all', NULL, 'unemployed', 'all', 'all', 'Tags: Unemployed, Youth, Subsidy, Commercial Vehicle, Transport Service. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/gs-west-bengal', 'Ongoing', TRUE);

-- 4. Bina Mulya Samajik Suraksha Yojana
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Bina Mulya Samajik Suraksha Yojana', '"Bina Mulya Samajik Suraksha Yojana (BM-SSY)" is a comprehensive social security scheme for unorganized workers in the state of West Bengal, India. It was launched by the West Bengal government in 2017. ', 'state', 'west bengal', 60, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Maternity Benefits, Pension, Death Benefits, Medical Benefits. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/bmssy', 'Ongoing', TRUE);

-- 5. Widow Pension-West Bengal
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Widow Pension-West Bengal', 'The West Bengal government''s Women and Child Development and Social Welfare Department launched the "Widow Pension" scheme in 2010. This program aims to support widows facing economic hardship within the state.', 'state', 'west bengal', 60, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Financial Assistance, Social Welfare, Pension. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Age Proof, Income Certificate/BPL Card', 'https://www.myscheme.gov.in/schemes/wpwb', 'Ongoing', TRUE);

-- 6. Medical Expenses-Treatment for Major Ailments Including Surgery
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (4, 'Medical Expenses-Treatment for Major Ailments Including Surgery', '"Medical Expenses-Treatment for Major Ailments Including Surgery'''' scheme by the BOCW Welfare Board, Labour Dept.,West Bengal, is a welfare scheme that provides medical expenses for the treatment of beneficiary or his/ her dependents suffering from Cancer, Heart disease, Kidney disease, T.B. etc.', 'state', 'west bengal', 0, 120, 'all', NULL, 'construction_worker', 'all', 'all', 'Tags: Labour, Building Worker, Construction Worker, Treatment, Ailments, Surgery, Medical Expenses. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Medical Documents, Hospital Records', 'https://www.myscheme.gov.in/schemes/metfmaiswb', 'Ongoing', TRUE);

-- 7. West Bengal Transport Workers’ Social Security Scheme: Assistance on Death and Permanent Disablement
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (4, 'West Bengal Transport Workers’ Social Security Scheme: Assistance on Death and Permanent Disablement', 'The scheme provides financial relief to the beneficiaries in case of permanent disability due to accidents or their dependents/nominees in case of accidental or natural death.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'transport_worker', 'all', 'all', 'Tags: Social Empowerment, Transport Worker, Monthly Assistance, Death Assistance, Permanent Disablement. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Transport Worker Registration', 'https://www.myscheme.gov.in/schemes/wbtwssadpd', 'Ongoing', TRUE);

-- 8. Banglar Awaas Yojana (BAY)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (7, 'Banglar Awaas Yojana (BAY)', '"Banglar Awaas Yojana (BAY)" provides financial assistance to houseless households and those living in kutcha or dilapidated houses, helping them build pucca houses with essential amenities. The scheme offers financial assistance with additional support for toilets and unskilled workdays.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Housing, Citizen Empowerment. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Land Documents, Income Certificate', 'https://www.myscheme.gov.in/schemes/bay', 'Ongoing', TRUE);

-- 9. Banglar Yuba Sathi
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Banglar Yuba Sathi', 'The scheme aims to provide monthly financial assistance to educated unemployed youth of West Bengal to support them until they get employment or join another scheme. The objective is to ensure income support for eligible unemployed youth for a maximum period of 5 years.', 'state', 'west bengal', 0, 120, 'all', NULL, 'unemployed', 'all', 'all', 'Tags: Unemployed Youth Allowance, Youth Welfare, Monthly Allowance, Banglar Yuba Sathi. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/byswb', 'Ongoing', TRUE);

-- 10. Old Age Pension To Handloom Weavers Under Coop. Fold
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Old Age Pension To Handloom Weavers Under Coop. Fold', 'The “Old Age Pension To Handloom Weavers” scheme implemented by the MSME and Textiles Dept., aims to provide monthly financial assistance in the form of pension to a weaver member of a handloom cooperative society.

', 'state', 'west bengal', 60, 120, 'all', NULL, 'weaver', 'all', 'all', 'Tags: Pension, Handloom Weavers, Old Age. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Age Proof, Income Certificate/BPL Card', 'https://www.myscheme.gov.in/schemes/olahwucf', 'Ongoing', TRUE);

-- 11. Annapurna Yojana
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Annapurna Yojana', 'The scheme “Annapurna Yojana” implemented by the Women and Child Development and Social Welfare Department, Government of West Bengal aims to provide assured monthly financial assistance to eligible women residing in the state for their empowerment and socio-economic upliftment. Under the scheme, el', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Women Empowerment, Financial Assistance, Women Welfare, DBT. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/aywb', 'Ongoing', TRUE);

-- 12. Lakshmir Bhandar Scheme
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Lakshmir Bhandar Scheme', 'The "Lakshmir Bhandar" scheme is a flagship program to provide financial assistance to women from economically weaker sections of society, for the empowerment of women in the age group of 25-60 years, and enrolled in ‘Swasthya Sathi’.', 'state', 'west bengal', 0, 120, 'female', NULL, 'all', 'all', 'all', 'Tags: Financial Asisstance, Social Welfare, Women, Lakshmir Bhandar. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/lbs-wb', 'Ongoing', TRUE);

-- 13. West Bengal Student Credit Card Scheme
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (3, 'West Bengal Student Credit Card Scheme', 'The Higher Education Department, Government of West Bengal has introduced the Student Credit Card Scheme for the students of West Bengal to enable them to pursue higher education without having any financial constraints.', 'state', 'west bengal', 15, 40, 'all', NULL, 'student', 'all', 'all', 'Tags: Financial Assistance, Education Loan, Higher Study. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Previous Year Marksheet, Admission Certificate, Income Certificate', 'https://www.myscheme.gov.in/schemes/wbsccs', 'Ongoing', TRUE);

-- 14. Disability Pension - West Bengal
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Disability Pension - West Bengal', 'In 2010, the Women and Child Development and Social Welfare Department of the West Bengal State Government introduced the "Disability Pension" scheme.', 'state', 'west bengal', 60, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Financial Assistance, Social Welfare, Pension. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Age Proof, Income Certificate/BPL Card', 'https://www.myscheme.gov.in/schemes/dpwb', 'Ongoing', TRUE);

-- 15. Manabik Scheme
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Manabik Scheme', 'The Manabik Pension Scheme is a financial assistance program launched in 2018 to provide monthly pensions to individuals with disabilities in West Bengal.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Financial Assistance, Differently Abled, Pension, Social Welfare. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/ms', 'Ongoing', TRUE);

-- 16. Old Age Pension
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Old Age Pension', 'In 2010, the Women and Child Development and Social Welfare Department of the West Bengal State Government introduced the "Old Age Pension" scheme.', 'state', 'west bengal', 60, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Financial Assistance, Social Welfare, Pension, Old Age, Senior Citizens. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Age Proof, Income Certificate/BPL Card', 'https://www.myscheme.gov.in/schemes/oapwb', 'Ongoing', TRUE);

-- 17. West Bengal Migrant Workers’ Welfare Scheme: Death Assistance
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'West Bengal Migrant Workers’ Welfare Scheme: Death Assistance', '"West Bengal Migrant Workers’ Welfare Scheme: Death Assistance" is a social welfare scheme by the West Bengal Migrant Workers’ Welfare Board, Labour Dept., Government of West Bengal, that provides an one time assistance to the nominee in case of natural death/accidental death of the migrant worker.', 'state', 'west bengal', 0, 120, 'all', NULL, 'migrant_worker', 'all', 'all', 'Tags: Migrant, Social Welfare, Financial Assistance, Labour, Death, Accident, Worker. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Migrant Worker Registration', 'https://www.myscheme.gov.in/schemes/wbmwwsda', 'Ongoing', TRUE);

-- 18. West Bengal Migrant Workers’ Welfare Scheme: Repatriation of Dead Body
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'West Bengal Migrant Workers’ Welfare Scheme: Repatriation of Dead Body', '"West Bengal Migrant Workers’ Welfare Scheme: Repatriation of Dead Body" is a social welfare scheme implemented by the West Bengal Migrant Workers’ Welfare Board, that provides an one time assistance to the nominee for bringing the dead body of the registered migrant worker in case of death.', 'state', 'west bengal', 0, 120, 'all', NULL, 'migrant_worker', 'all', 'all', 'Tags: Cremation, Migrant, Social Welfare, Financial Assistance, Labour, Worker, Repatriation. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Migrant Worker Registration', 'https://www.myscheme.gov.in/schemes/wbmwwsc', 'Ongoing', TRUE);

-- 19. West Bengal Migrant Workers’ Welfare Scheme: Cremation
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'West Bengal Migrant Workers’ Welfare Scheme: Cremation', '"West Bengal Migrant Workers’ Welfare Scheme: Cremation" is a social welfare scheme by the West Bengal Migrant Workers’ Welfare Board, Labour Dept., Government of West Bengal, that provides an one time assistance to the nominee of the worker for cremation when the worker dies.', 'state', 'west bengal', 0, 120, 'all', NULL, 'migrant_worker', 'all', 'all', 'Tags: Social Welfare, Migrant, Financial Assistance, Labour, Cremation, Death, Worker. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Migrant Worker Registration', 'https://www.myscheme.gov.in/schemes/wbmwwsca', 'Ongoing', TRUE);

-- 20. West Bengal Artisans Financial Benefit Scheme 2024: Grant to Industrial Cooperative Society
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'West Bengal Artisans Financial Benefit Scheme 2024: Grant to Industrial Cooperative Society', '“Grant to Industrial Cooperative Society” is a sub-scheme under "West Bengal Artisans Financial Benefit Scheme 2024”, by the MSME and Textiles Dept, Government of West Bengal. It aims to create, support and sustain an enabling ecosystem for strengthening creativity and capacity of the artisans.', 'state', 'west bengal', 0, 120, 'all', NULL, 'artisan', 'all', 'all', 'Tags: Artisans, Financial Benefit, Purchase, Repair, Equipment, Tool Kits. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbafbsgics', 'Ongoing', TRUE);

-- 21. West Bengal Artisans Financial Benefit Scheme: Facilitation Supports
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'West Bengal Artisans Financial Benefit Scheme: Facilitation Supports', '“Facilitation Supports” is a sub-scheme under "West Bengal Artisans Financial Benefit Scheme 2024”, implemented by the MSME and Textiles Dept, Government of West Bengal. It aims to provide various types of facilitation support to the artisans and Industrial Cooperative Societies.', 'state', 'west bengal', 0, 120, 'all', NULL, 'artisan', 'all', 'all', 'Tags: Artisans, Facilitation Support. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbafbsfs', 'Ongoing', TRUE);

-- 22. Accidental Benefit 
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Accidental Benefit ', 'The "Accidental Benefit'''' scheme by the BOCW Welfare Board, Labour Department,West Bengal, is a welfare scheme that provides financial assistance to the beneficiary in case of hospitalization and disability due to an accident.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'construction_worker', 'all', 'all', 'Tags: Labour, Building Worker, Construction Worker, Accidental Benefit, Hospitalization, Disability. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/adwb', 'Ongoing', TRUE);

-- 23. Maternity Benefit
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Maternity Benefit', 'The "Maternity Benefit'''' scheme by the BOCW Welfare Board, Labour Department,West Bengal, is a welfare scheme that provides maternity benefits up to two times in a lifetime to the eligible female beneficiaries or the wives of male beneficiaries.
', 'state', 'west bengal', 18, 45, 'female', NULL, 'construction_worker', 'all', 'all', 'Tags: Labour, Building Worker, Construction Worker, Maternity, Pregnancy Care, Women. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/mbwb', 'Ongoing', TRUE);

-- 24. Pension Benefit
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Pension Benefit', 'The "Pension Benefit'''' scheme by the BOCW Welfare Board, Labour Department,West Bengal, is a welfare scheme that provides a monthly pension after completion of 60 years to the eligible registered member.
', 'state', 'west bengal', 60, 120, 'all', NULL, 'construction_worker', 'all', 'all', 'Tags: Labour, Building Worker, Construction Worker, Pension, Nominee. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Age Proof, Income Certificate/BPL Card', 'https://www.myscheme.gov.in/schemes/pbwb', 'Ongoing', TRUE);

-- 25. Tool Purchase Grant for the Construction Workers
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Tool Purchase Grant for the Construction Workers', '“Tool Purchase Grant for the Construction Workers” scheme by the BOCW Welfare Board, Labour Dep.t, West Bengal, is a welfare scheme that provides one time reimbursement to each registered beneficiary who is with the Board for a period of at least 6 months for purchasing tools for his profession.', 'state', 'west bengal', 0, 120, 'all', NULL, 'construction_worker', 'all', 'all', 'Tags: Labour, Building Worker, Construction Worker, Tool Purchase. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Labour Registration Certificate', 'https://www.myscheme.gov.in/schemes/tpgftcw', 'Ongoing', TRUE);

-- 26. Miscarriage Benefit 
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Miscarriage Benefit ', 'The "Miscarriage Benefit'''' scheme by the BOCW Welfare Board, Labour Department,West Bengal, is a welfare scheme that provides financial benefits for miscarriage up to two times in a lifetime to the eligible female beneficiaries or the wives of male beneficiaries.
', 'state', 'west bengal', 0, 120, 'female', NULL, 'construction_worker', 'all', 'all', 'Tags: Labour, Building Worker, Construction Worker, Miscarriage, Women. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/mbbwwb', 'Ongoing', TRUE);

-- 27. Financial Assistance for Education of Self/ Children of Beneficiaries 
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (3, 'Financial Assistance for Education of Self/ Children of Beneficiaries ', 'The "Financial Assistance for Education of Self/ Children of Beneficiaries'''' scheme by the BOCW Welfare Board, Labour Department, West Bengal, is a welfare scheme that provides financial assistance to the registered member or their children studying Higher Secondary and above.
', 'state', 'west bengal', 5, 35, 'all', NULL, 'construction_worker', 'all', 'all', 'Tags: Labour, Building Worker, Construction Worker, Education, Study, Scholarships. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/fafeoscob', 'Ongoing', TRUE);

-- 28. Cost of Spectacle for the Construction Workers  
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Cost of Spectacle for the Construction Workers  ', 'The “Cost of Spectacle for the Construction Workers” scheme by the BOCW Welfare Board, Labour Department,West Bengal, is a welfare scheme that provides reimbursement for purchasing spectacle to each registered beneficiary if required.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'construction_worker', 'all', 'all', 'Tags: Labour, Building Worker, Construction Worker, Spectacle Purchase. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Labour Registration Certificate', 'https://www.myscheme.gov.in/schemes/cosftcw', 'Ongoing', TRUE);

-- 29. Cost of Hearing Aid for the Construction Workers
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Cost of Hearing Aid for the Construction Workers', 'The “Cost of Hearing Aid for the Construction Workers” scheme by the BOCW Welfare Board, Labour Department,West Bengal, is a welfare scheme that provides reimbursement for purchasing Hearing Aids to each registered beneficiary if required.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'construction_worker', 'all', 'all', 'Tags: Labour, Building Worker, Construction Worker, Hearing Aid. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Labour Registration Certificate', 'https://www.myscheme.gov.in/schemes/cohaftcw', 'Ongoing', TRUE);

-- 30. West Bengal Transport Workers’ Social Security Scheme: Assistance for Purchase of Spectacles
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'West Bengal Transport Workers’ Social Security Scheme: Assistance for Purchase of Spectacles', 'This scheme provides financial assistance to eligible beneficiaries every 5 years to support the purchase of spectacles, ensuring better eye health and vision.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'transport_worker', 'all', 'all', 'Tags: Social Security, Transport Worker, Health & Wellness, Medical Appliance. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Transport Worker Registration', 'https://www.myscheme.gov.in/schemes/wbtwsaps', 'Ongoing', TRUE);

-- 31. West Bengal Transport Workers’ Social Security Scheme: Pension
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'West Bengal Transport Workers’ Social Security Scheme: Pension', 'The scheme provides pension benefits to transport workers of the state upon reaching 60 years of age.
', 'state', 'west bengal', 60, 120, 'all', NULL, 'transport_worker', 'all', 'all', 'Tags: Social Security, Transport Worker, Monthly Assistance, Pension. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Age Proof, Income Certificate/BPL Card, Transport Worker Registration', 'https://www.myscheme.gov.in/schemes/wbtwssp', 'Ongoing', TRUE);

-- 32. Shikshashree Scheme
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (3, 'Shikshashree Scheme', 'The scheme "Shikshashree Scheme” was implemented by the Government of West Bengal during the year 2014-15  by merging the existing schemes of Book Grants & Maintenance Grants to provide financial assistance to Schedule Caste students studying in classes V to VIII.', 'state', 'west bengal', 5, 35, 'all', NULL, 'student', 'all', 'sc', 'Tags: Scheduled Caste, Student, Scholarship, Financial Assistance, Class V-VIII. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Previous Year Marksheet, Admission Certificate, Income Certificate, SC Certificate', 'https://www.myscheme.gov.in/schemes/ss-west-bengal', 'Ongoing', TRUE);

-- 33. Swami Vivekananda Merit-cum-Means Scholarship
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (3, 'Swami Vivekananda Merit-cum-Means Scholarship', '"Swami Vivekananda Merit-cum-Means Scholarship" started by the Higher Education Department of West Bengal State for the financial assistance to the student.', 'state', 'west bengal', 5, 35, 'all', 250000, 'student', 'all', 'all', 'Tags: Student, Financial Assistance, Education. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Previous Year Marksheet, Admission Certificate, Income Certificate', 'https://www.myscheme.gov.in/schemes/svmcms', 'Ongoing', TRUE);

-- 34. Akanksha Housing Scheme
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (7, 'Akanksha Housing Scheme', 'Akanksha Housing Scheme was launched by the Housing Department, Government of West Bengal on 28/02/2014 to provide housing to the serving State Government employees.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Housing, West Bengal, State Government Employees. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Land Documents, Income Certificate', 'https://www.myscheme.gov.in/schemes/ahs', 'Ongoing', TRUE);

-- 35. Rupashree Prakalpa
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Rupashree Prakalpa', 'The scheme aims to mitigate the financial difficulties faced by poor families in bearing the expenses of their daughters’ marriages. Under this scheme, a one-time financial grant of ₹25,000/- is provided to economically stressed families at the time of their adult daughters’ marriages.', 'state', 'west bengal', 18, 35, 'female', 150000, 'all', 'all', 'all', 'Tags: Poor Families, Daughter, Marriage Assistance. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbrupashree', 'Ongoing', TRUE);

-- 36. Jai Johar (Old Age Pension) Scheme
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Jai Johar (Old Age Pension) Scheme', '“Jai Johar (Old Age Pension)” is a Social Security Scheme by the Tribal Development Dept, Govt of West Bengal. The scheme is aimed at the ST residents of West Bengal of the age of 60 years and above. A monthly pension of ₹ 1,000/- is transferred to the individual bank account of the beneficiary.', 'state', 'west bengal', 60, 120, 'all', NULL, 'all', 'all', 'st', 'Tags: Pension, Senior Citizen, Social Welfare, Financial Assistance, Scheduled Tribe. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, ST Certificate, Age Proof, Income Certificate/BPL Card', 'https://www.myscheme.gov.in/schemes/jjoaps', 'Ongoing', TRUE);

-- 37. Toposili Bandhu (Old Age Pension) Scheme
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Toposili Bandhu (Old Age Pension) Scheme', '"Toposili Bandhu" (Old Age Pension) scheme was initiated by the Backward Classes Welfare Department and Tribal Development Department of West Bengal Government. ', 'state', 'west bengal', 60, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Pension, Financial Assistance, Social Welfare. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Age Proof, Income Certificate/BPL Card', 'https://www.myscheme.gov.in/schemes/obs', 'Ongoing', TRUE);

-- 38. Yuvasree Prakalpa
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Yuvasree Prakalpa', '"Yuvasree" was launched  in 2013 by Labor Department, Government of West Bengal for providing financial assistance to jobseekers. ', 'state', 'west bengal', 18, 40, 'all', NULL, 'unemployed', 'all', 'all', 'Tags: Employment, Job Seeker, Financial Assistance, Placement. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/yuvasree', 'Ongoing', TRUE);

-- 39. Death Benefit
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Death Benefit', 'The "Death Benefit'''' scheme by the BOCW Welfare Board, Labour Department, West Bengal, is a welfare scheme that provides financial assistance to the nominee(s) of the beneficiary as death benefit.', 'state', 'west bengal', 0, 120, 'all', NULL, 'construction_worker', 'all', 'all', 'Tags: Labour, Building Worker, Construction Worker, Death Benefit, Accidental Death, Normal Death. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/dbftcwwb', 'Ongoing', TRUE);

-- 40. Funeral Expenses for the Construction Workers
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Funeral Expenses for the Construction Workers', 'The “Funeral Expenses for the Construction Workers” scheme by the BOCW Welfare Board, Labour Department,West Bengal, is a welfare scheme that provides financial assistance for funeral expenses to the nominees of a deceased registered member.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'construction_worker', 'all', 'all', 'Tags: Labour, Building Worker, Construction Worker, Funeral Expenses, Death. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Labour Registration Certificate', 'https://www.myscheme.gov.in/schemes/feftcwwb', 'Ongoing', TRUE);

-- 41. West Bengal Transport Workers’ Social Security Scheme: Family Pension
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'West Bengal Transport Workers’ Social Security Scheme: Family Pension', 'Under this scheme, beneficiaries, upon retirement or unfortunate demise, will have 50% of their last drawn amount transferred monthly to their families through a Direct Benefit Transfer (DBT) system.
', 'state', 'west bengal', 60, 120, 'all', NULL, 'transport_worker', 'all', 'all', 'Tags: Social Security, Transport Worker, Monthly Assistance, Family Pension. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Age Proof, Income Certificate/BPL Card, Transport Worker Registration', 'https://www.myscheme.gov.in/schemes/wbtwssfp', 'Ongoing', TRUE);

-- 42. West Bengal Freeship Scheme
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (3, 'West Bengal Freeship Scheme', 'The West Bengal Freeship Scheme (WBFS)has been launched by the Department of Higher Education,  Government of West Bengal. This freeship would be provided as a tuition fee waiver for the under Graduate students level in Engineering & Technology/ Pharmacy/ Architecture.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Tuition Fee Waiver, Freeship, Financial Support, Engineering & Technology, Pharmacy, Architecture. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbfs', 'Ongoing', TRUE);

-- 43. Lokprasar Prakalpo Scheme
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Lokprasar Prakalpo Scheme', 'The scheme “Lokprasar Prakalpo Scheme” was launched by the Department of Information & Cultural Affairs, Government of West Bengal in 2014 to revive the Folk and Tribal Culture in their respective genre across various zones and districts in the State.', 'state', 'west bengal', 60, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Folk, Artists, Tribal Culture, Pension, Financial Assistance, Performance Fee. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/lps', 'Ongoing', TRUE);

-- 44. West Bengal Migrant Workers’ Welfare Scheme: Accidental Disability
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'West Bengal Migrant Workers’ Welfare Scheme: Accidental Disability', '"West Bengal Migrant Workers’ Welfare Scheme: Accidental Disability" is a social welfare scheme by the West Bengal Migrant Workers’ Welfare Board, that provides one-time assistance to the registered Migrant Worker in case of disability arising out of accidents during work.', 'state', 'west bengal', 0, 120, 'all', NULL, 'migrant_worker', 'all', 'all', 'Tags: Migrant, Social Welfare, Financial Assistance, Labour, Accident, Disability, Worker. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Migrant Worker Registration', 'https://www.myscheme.gov.in/schemes/wbmwwsad', 'Ongoing', TRUE);

-- 45. West Bengal Artisans Financial Benefit Scheme 2024: Grant to Individual Artisans
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'West Bengal Artisans Financial Benefit Scheme 2024: Grant to Individual Artisans', '“Grant to Individual Artisans” is a sub-scheme under "West Bengal Artisans Financial Benefit Scheme 2024”, by the MSME and Textiles Dept, Government of West Bengal, aims to create, support and sustain an enabling ecosystem for strengthening creativity and capacity of the artisans.', 'state', 'west bengal', 0, 120, 'all', NULL, 'artisan', 'all', 'all', 'Tags: Artisans, Financial Benefit, Purchase, Repair, Equipment, Tool Kits. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbafbgia', 'Ongoing', TRUE);

-- 46. West Bengal Handloom and Khadi Weavers Financial Benefit Scheme 2024: Assistance to Individual Handloom Weaver
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'West Bengal Handloom and Khadi Weavers Financial Benefit Scheme 2024: Assistance to Individual Handloom Weaver', '“Assistance to Individual Handloom Weaver" is a sub-scheme under "West Bengal Handloom and Khadi Weavers Financial Benefit Scheme 2024”, implemented by the MSME and Textiles Dept, Government of West Bengal aims to  provide one-time financial assistance to the individual Handloom weavers.

', 'state', 'west bengal', 0, 120, 'all', NULL, 'weaver', 'all', 'all', 'Tags: Handloom, Handloom Weaver, Financial Benefit. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/aihw', 'Ongoing', TRUE);

-- 47. Refund of Subscriptions for the Construction Workers
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Refund of Subscriptions for the Construction Workers', 'The “Refund of Subscriptions for the Construction Workers” scheme by the BOCW Welfare Board, Labour Department, West Bengal, is a welfare scheme that provides reimbursement of the entire subscription, with 8% interest, to the beneficiary at age 60, after 3 years if they choose to leave the Board, or', 'state', 'west bengal', 0, 120, 'all', NULL, 'construction_worker', 'all', 'all', 'Tags: Labour, Construction Worker, Subscriptions Refund. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Labour Registration Certificate', 'https://www.myscheme.gov.in/schemes/rosftcw', 'Ongoing', TRUE);

-- 48. West Bengal Transport Workers’ Social Security Scheme: Assistance on Hospitalization
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (4, 'West Bengal Transport Workers’ Social Security Scheme: Assistance on Hospitalization', 'The scheme provides financial assistance to transport workers who are hospitalized for 5 or more days due to an accident.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'transport_worker', 'all', 'all', 'Tags: Social Security, Transport Worker, Hospitalization, Medical Assistance. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Medical Documents, Hospital Records, Transport Worker Registration', 'https://www.myscheme.gov.in/schemes/wbtwssah', 'Ongoing', TRUE);

-- 49. State Welfare Scheme For Purohits
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'State Welfare Scheme For Purohits', 'The scheme "State Welfare Scheme for Purohits" was launched in September 2020 to benefit the financially distressed practicing temple /tribal purohit or priests of other communities like Christians, Jain, and Buddhists.', 'state', 'west bengal', 0, 120, 'all', NULL, 'priest', 'all', 'all', 'Tags: Economically Backward, Purohit, Priests, Financial Assistance, House. Level: state. For: Individual.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/swsp', 'Ongoing', TRUE);

-- 50. West Bengal Transport Workers’ Social Security Scheme: Assistance for Education of Children
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (3, 'West Bengal Transport Workers’ Social Security Scheme: Assistance for Education of Children', 'This scheme provides financial support to beneficiaries for their children''s (maximum two) education at various levels, including higher secondary, graduation, post-graduation, and professional courses like engineering and medical studies.
', 'state', 'west bengal', 5, 35, 'all', NULL, 'transport_worker', 'all', 'all', 'Tags: Social Security, Transport Worker, Engineering And Medical, Education, Scholarship, Higher Secondary, Graduation, Post-Graduation. Level: state. For: Family.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Transport Worker Registration', 'https://www.myscheme.gov.in/schemes/wbtwsae', 'Ongoing', TRUE);

-- 51. NIJASHAREE HOUSING SCHEME
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (7, 'NIJASHAREE HOUSING SCHEME', 'The scheme “NIJASHAREE HOUSING SCHEME” is an initiative by the Govt. of West Bengal which envisages the construction of multi-storied Lower Income Group (LIG)/Middle Income Group (MIG) flats on the public lands belonging to the State Government, local bodies and parastatals.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: House, Flats, Lower Income Group, Middle Income Group. Level: state. For: Family.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Land Documents, Income Certificate', 'https://www.myscheme.gov.in/schemes/nhs-west-bengal', 'Ongoing', TRUE);

-- 52. Scheme of Death Benefit for Weavers & Artisans of West Bengal
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Scheme of Death Benefit for Weavers & Artisans of West Bengal', '"Scheme of Death Benefit for Weavers & Artisans of West Bengal" is a social welfare scheme implemented by the Department of Micro, Small and Medium Enterprises and Textiles, Government of West Bengal aims to provide financial assistance to the family of the deceased weaver /artisan.', 'state', 'west bengal', 0, 120, 'all', NULL, 'weaver', 'all', 'all', 'Tags: Weavers, Social Welfare, Artisans, Death. Level: state. For: Family.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/sdbwaw', 'Ongoing', TRUE);

-- 53. Karma Sathi Prakalpa
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Karma Sathi Prakalpa', 'The scheme aims to help young entrepreneurs in the state establish new manufacturing enterprises and small businesses, including those offering services and trading. The scheme offers soft loans and subsidies for new income-generating projects.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Employment, Entrepreneur, West Bengal, Loan, Subsidy. Level: state. For: Family.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/ksp', 'Ongoing', TRUE);

-- 54. West Bengal Transport Workers’ Social Security Scheme: Medical Benefit for Major Ailments
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (4, 'West Bengal Transport Workers’ Social Security Scheme: Medical Benefit for Major Ailments', 'This scheme provides financial assistance for the treatment of beneficiaries or their family members suffering from major ailments like cancer, TB, brain stroke, cardiac problems, and others.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'transport_worker', 'all', 'all', 'Tags: Social Security, Transport Worker, Health & Wellness, Major Ailments, Medical Benefit. Level: state. For: Family.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Medical Documents, Hospital Records, Transport Worker Registration', 'https://www.myscheme.gov.in/schemes/wbtwsmbma', 'Ongoing', TRUE);

-- 55. West Bengal Transport Workers’ Social Security Scheme: Funeral Expenses
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'West Bengal Transport Workers’ Social Security Scheme: Funeral Expenses', 'The scheme provides monetary support to help cover funeral costs in the unfortunate event of a beneficiary''s demise.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'transport_worker', 'all', 'all', 'Tags: Social Security, Transport Worker, Social Empowerment, Funeral Expenses. Level: state. For: Family.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Transport Worker Registration', 'https://www.myscheme.gov.in/schemes/wbtwsfe', 'Ongoing', TRUE);

-- 56. Sishu Saathi
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (4, 'Sishu Saathi', '“Sishu Saathi”, a scheme of the Health and Family Welfare Department, Government of West Bengal as part of the Rastriya Bal Swasthya Karyakram (RBSK) under National Health Mission is meant to treat Indian children of 0-18 years age group with zero out of pocket expenditure.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Sishu Saathi, Social Welfare, Financial Assistance, Child Health. Level: state. For: Family.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbsishusathi', 'Ongoing', TRUE);

-- 57. Krishak Bandhu Scheme
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (1, 'Krishak Bandhu Scheme', 'The scheme aims to provide financial security to farmers through direct income support and death/disability benefits. It benefits small and marginal farmers with annual assistance of ₹5,000/- per acre and a one-time payout of ₹2,00,000/- in case of death.', 'state', 'west bengal', 0, 120, 'all', NULL, 'farmer', 'all', 'all', 'Tags: Farmer, Financial Assistance, Agriculture, Income, Death, Disability. Level: state. For: Family.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Land Records (RoR/Patta)', 'https://www.myscheme.gov.in/schemes/kbs', 'Ongoing', TRUE);

-- 58. West Bengal Transport Workers’ Social Security Scheme: Assistance for Marriage
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'West Bengal Transport Workers’ Social Security Scheme: Assistance for Marriage', 'The scheme provides financial aid for the marriage of eligible beneficiaries or their dependent sons/daughters (up to two marriages).
', 'state', 'west bengal', 0, 120, 'female', NULL, 'transport_worker', 'all', 'all', 'Tags: Social Security, Transport Worker, Marriage Assistance, Women. Level: state. For: Family.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Transport Worker Registration', 'https://www.myscheme.gov.in/schemes/wbtwsam', 'Ongoing', TRUE);

-- 59. West Bengal Transport Workers’ Social Security Scheme: Maternity Benefit
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (2, 'West Bengal Transport Workers’ Social Security Scheme: Maternity Benefit', 'This scheme provides financial assistance to a beneficiary on successful delivery of a child or miscarriage by such beneficiary or his wife.
', 'state', 'west bengal', 18, 45, 'all', NULL, 'transport_worker', 'all', 'all', 'Tags: Social Security, Transport Worker, Health & Wellness, Maternity Benefit, Medical Benefit, Pregnant Women. Level: state. For: Family.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Transport Worker Registration', 'https://www.myscheme.gov.in/schemes/wbtwsmb', 'Ongoing', TRUE);

-- 60. Samajik Mukti
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Samajik Mukti', 'The government issued ''Samajik Mukti'' (Social Freedom) cards to unorganised sector workers of the State for Provident Fund & Other Social Benefit scheme.', 'state', 'west bengal', 0, 120, 'all', NULL, 'construction_worker', 'all', 'all', 'Tags: Labour, Provident Fund, Unorganised Sector, Social, Financial. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/sm', 'Ongoing', TRUE);

-- 61. Banglashree for Micro, Small and Medium Enterprises: Interest Subsidy on Term Loan (IS)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Banglashree for Micro, Small and Medium Enterprises: Interest Subsidy on Term Loan (IS)', '“Interest Subsidy on Term Loan (IS)” incentives under “Banglashree for MSMEs” scheme implemented by the MSMEs Dept., Government of West Bengal, aims to provide Interest Subsidy on annual interest liability on the Term Loan borrowed from a Commercial Bank to an eligible micro or small enterprise.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: MSME, Incentives, Interest Subsidy, Financial Assistance, Term Loan, Entrepreneurship. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/bis', 'Ongoing', TRUE);

-- 62. Banglashree for Micro, Small and Medium Enterprises: Subsidy for Work Force Welfare Assistance (WWAS)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Banglashree for Micro, Small and Medium Enterprises: Subsidy for Work Force Welfare Assistance (WWAS)', '“Subsidy for Work Force Welfare Assistance (WWAS)” incentives under “Banglashree for MSMEs” scheme implemented by the MSMEs Dept., Government of West Bengal, aims to provide reimbursement of expenditure incurred for paying contribution towards Employees State Insurance (ESI) and Employees Provident.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: MSME, Incentives, Work Force Welfare, Financial Assistance, Entrepreneurship, Subsidy, Reimbursement, WWAS. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/bmsmewwas', 'Ongoing', TRUE);

-- 63.  The West Bengal Incentive Scheme: Additional Incentive on Generation of Employment
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' The West Bengal Incentive Scheme: Additional Incentive on Generation of Employment', '“Additional Incentive on Generation of Employment” incentives under “The West Bengal Incentive Scheme” scheme by the Dept. of Tourism, Government of West Bengal, aims to provide reimbursement of expenditure incurred for paying contribution towards ESI and EPF.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Tourism, Incentives, Waiver, Tourism Units, Entrepreneurship, Subsidy, Reimbursement, Employment Generation. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbisaige', 'Ongoing', TRUE);

-- 64.  The West Bengal Incentive Scheme: Interest Subsidy on Term Loan
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' The West Bengal Incentive Scheme: Interest Subsidy on Term Loan', '“Interest Subsidy on Term Loan” incentives under “The West Bengal Incentive Scheme” scheme by the Dept. of Tourism, Government of West Bengal, aims to provide Interest Subsidy on annual interest liability on the Term Loan borrowed from a Bank to an approved project of an eligible unit.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Tourism, Incentives, Interest Subsidy, Tourism Units, Entrepreneurship, Subsidy, Reimbursement, Term Loan, MSME. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbisistl', 'Ongoing', TRUE);

-- 65.  West Bengal Textile Incentive Scheme: Incentive for Energy Efficiency
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' West Bengal Textile Incentive Scheme: Incentive for Energy Efficiency', '“Incentive for Energy Efficiency” incentives under “West Bengal Textile Incentive Scheme” scheme implemented by the Dept. of MSME&T, Government of West Bengal, aims to provide a reimbursement for the cost of energy and installations for energy conservation as per energy audit.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Textile, Incentives, Waiver, Entrepreneurship, Subsidy, Reimbursement, Electricity Duty. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbtisiee', 'Ongoing', TRUE);

-- 66. Incentive Scheme for MSMEs in Powerloom Sector: Subsidy on Stamp Duty and Registration Fees
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Incentive Scheme for MSMEs in Powerloom Sector: Subsidy on Stamp Duty and Registration Fees', '“Subsidy on Stamp Duty and Registration Fees” incentives under the “Incentive Scheme for MSMEs in Powerloom Sector” scheme by the Dept. of MSME & T, Government of West Bengal, aims to provide reimbursement for stamp duty and registration fee paid by it for the purpose of registration of documents.', 'state', 'west bengal', 0, 120, 'all', NULL, 'self_employed', 'all', 'all', 'Tags: Powerloom, Waiver, Stamp Duty, Entrepreneurship, Subsidy, Reimbursement, Registration Fees. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/ismpsssd', 'Ongoing', TRUE);

-- 67. Credit Linked Subsidy Scheme for Rural Entrepreneurs to set up Custom Hiring Centres (CHC) of Farm Machinery
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (1, 'Credit Linked Subsidy Scheme for Rural Entrepreneurs to set up Custom Hiring Centres (CHC) of Farm Machinery', '“Credit Linked Subsidy Scheme for Rural Entrepreneurs to set up Custom Hiring Centres (CHC) of Farm Machinery”  by the Agriculture Dep, Government of West Bengal aims to provide opportunity to rural entrepreneurs for setting up of Custom Hiring Centres.', 'state', 'west bengal', 0, 120, 'all', NULL, 'self_employed', 'all', 'all', 'Tags: Agriculture, Farmers, Credit Linked Subsidy, Financial Assistance, Entrepreneurs, Custom Hiring Centres, Farm Machinery, Subsidy. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/chc', 'Ongoing', TRUE);

-- 68. Farm Machinery Bank (FMB)/Farm Machinery Hub (FMH)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (1, 'Farm Machinery Bank (FMB)/Farm Machinery Hub (FMH)', '“Farm Machinery Bank (FMB)/Farm Machinery Hub (FMH)”  by the Agriculture Department, Government of West Bengal aims to facilitate end-to-end (from land development to residue management) use of farm machinery which can be within the reach of the small and marginal farmers at reasonable charges.
', 'state', 'west bengal', 18, 40, 'all', NULL, 'farmer', 'all', 'all', 'Tags: Agriculture, Farmers, Employment, Subsidy, Rural, Youth, Farm Machinery, Entrepreneurs, Machinery Bank, Machinery Hub. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Land Records (RoR/Patta)', 'https://www.myscheme.gov.in/schemes/fmh', 'Ongoing', TRUE);

-- 69.  West Bengal Textile Incentive Scheme: Subsidy for Water conservation/ Environment Compliance
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' West Bengal Textile Incentive Scheme: Subsidy for Water conservation/ Environment Compliance', '“Subsidy for Water Conservation/ Environment Compliance” incentives under “West Bengal Textile Incentive Scheme” scheme by the Dept. of MSME&T , Government of West Bengal, aims to provide reimbursement of expenditure incurred by it towards the cost of captive Effluent Water Treatment Plant.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Textile, Incentives, Waiver, Entrepreneurship, Subsidy, Reimbursement, Water Conservation, Environment Compliance. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbtisswcec', 'Ongoing', TRUE);

-- 70.  West Bengal Textile Incentive Scheme: Waiver of Fees for Land Conversion and Mutation
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' West Bengal Textile Incentive Scheme: Waiver of Fees for Land Conversion and Mutation', '“Waiver of Fees for Land Conversion and Mutation” incentives under “West Bengal Textile Incentive Scheme” scheme implemented by the Dept. of MSME&T, Government of West Bengal, aims to provide a waiver of fees for conversion and mutation of the land as approved in the project.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Textile, Incentives, Waiver, Entrepreneurship, Subsidy, Reimbursement, Land Conversion, Mutation. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbtiswfflcm', 'Ongoing', TRUE);

-- 71.  The West Bengal Incentive Scheme: Reimbursement of Stamp Duty and Registration Fee
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' The West Bengal Incentive Scheme: Reimbursement of Stamp Duty and Registration Fee', '“Reimbursement of Stamp Duty and Registration Fee” incentives under the “WBIS” scheme implemented by the Dept. of Tourism, Government of West Bengal, aims to provide a reimbursement of stamp duty and registration fee paid by the eligible units for the purpose of registration of documents.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Tourism, Incentives, Stamp Duty, Tourism Units, Entrepreneurship, Subsidy, Reimbursement, Adventure, Registration Fee. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbisrsdrf', 'Ongoing', TRUE);

-- 72. West Bengal Artisans Financial Benefit Scheme: Support for Digital Marketing
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'West Bengal Artisans Financial Benefit Scheme: Support for Digital Marketing', '“Support for Digital Marketing” is a sub-scheme under "West Bengal Artisans Financial Benefit Scheme”, by the MSME and Textiles Dept, Government of West Bengal, aims to provide access to digital markets and e-commerce to the artisans.', 'state', 'west bengal', 0, 120, 'all', NULL, 'artisan', 'all', 'all', 'Tags: Artisans, Digital Marketing, E-commerce. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbafbssdm', 'Ongoing', TRUE);

-- 73.  West Bengal Textile Incentive Scheme: Waiver of Electricity Duty
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' West Bengal Textile Incentive Scheme: Waiver of Electricity Duty', '“Waiver of Electricity Duty” incentives under “West Bengal Textile Incentive Scheme” scheme implemented by the Dept. of MSME&T, Government of West Bengal,  aims to provide waiver of electricity duty on the electricity consumed in its approved project.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Textile, Incentives, Waiver, Entrepreneurship, Subsidy, Reimbursement, Electricity Duty. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbtiswed', 'Ongoing', TRUE);

-- 74.  West Bengal Textile Incentive Scheme: State Capital Investment Subsidy
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' West Bengal Textile Incentive Scheme: State Capital Investment Subsidy', '“State Capital Investment Subsidy” incentives under “West Bengal Textile Incentive Scheme” scheme implemented by the Dept. of MSME&T, Government of West Bengal, aims to provide a State Capital Investment Subsidy of the fixed capital investment.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Textile, Incentives, State Capital Investment Subsidy, Entrepreneurship, Subsidy, Reimbursement. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbtisscis', 'Ongoing', TRUE);

-- 75. Incentive Scheme for MSMEs in Powerloom Sector: Work Force Welfare Assistance
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Incentive Scheme for MSMEs in Powerloom Sector: Work Force Welfare Assistance', '“Work Force Welfare Assistance” incentive under the “Incentive Scheme for MSMEs in Powerloom Sector” scheme implemented by the Dept. of MSME & T, Government of West Bengal,  aims to provide reimbursement of expenditure incurred for paying contribution towards ESI and EPF.', 'state', 'west bengal', 0, 120, 'all', NULL, 'self_employed', 'all', 'all', 'Tags: Powerloom, Waiver, Work Force Welfare, Entrepreneurship, Subsidy, Reimbursement, ESI, EPF. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/ismpswfwa', 'Ongoing', TRUE);

-- 76.  Incentive Scheme for MSMEs in Powerloom Sector: State Capital Investment Subsidy
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' Incentive Scheme for MSMEs in Powerloom Sector: State Capital Investment Subsidy', '“State Capital Investment Subsidy” incentives under “Incentive Scheme for MSMEs in Powerloom Sector” scheme implemented by the Dept. of MSME & T, Government of West Bengal, aims to provide subsidy of the fixed capital investment made for its approved project.', 'state', 'west bengal', 0, 120, 'all', NULL, 'self_employed', 'all', 'all', 'Tags: Powerloom, Incentives, State Capital Investment Subsidy, Entrepreneurship, Subsidy, Reimbursement. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/ismpsscis', 'Ongoing', TRUE);

-- 77. West Bengal Incentive Scheme for Approved Industrial Park (SAIP) for MSMEs: Reimbursement of Stamp Duty
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'West Bengal Incentive Scheme for Approved Industrial Park (SAIP) for MSMEs: Reimbursement of Stamp Duty', '“Reimbursement of Stamp Duty” under the “SAIP for MSMEs” scheme, aims to provide reimbursement of stamp duty paid by the SPV for registration of land documents.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'self_employed', 'all', 'all', 'Tags: Entrepreneurship, MSMEs, Stamp Duty, Industrial Park, Fiscal Incentives. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/saiprsd', 'Ongoing', TRUE);

-- 78. West Bengal Incentive Scheme for Approved Industrial Park (SAIP) for MSMEs: Incentive for Basic and Essential Common Infrastructure Facilities
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'West Bengal Incentive Scheme for Approved Industrial Park (SAIP) for MSMEs: Incentive for Basic and Essential Common Infrastructure Facilities', 'The “Incentive for Basic and Essential Common Infrastructure Facilities” under the “SAIP for MSMEs” scheme, aims to provide one time back-ended incentive for development of Basic and Essential Common Infrastructure Facilities based on land area.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'self_employed', 'all', 'all', 'Tags: Entrepreneurship, Industrial Park, Fiscal Incentives, Infrastructure Facilities. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/saipibeci', '2025-09-15', TRUE);

-- 79. One Time Assistance to Small and Marginal Farmers for Purchase of Small Farm Implements (OTA-SFI)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (1, 'One Time Assistance to Small and Marginal Farmers for Purchase of Small Farm Implements (OTA-SFI)', '“One Time Assistance to Small and Marginal Farmers for Purchase of Small Farm Implements (OTA-SFI)”  by the Agriculture Department, Government of West Bengal aims to aid the farmers in procuring manually operated small farm implements necessary for agricultural operations.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'farmer', 'all', 'all', 'Tags: Agriculture, Farmers, Small Farm Implements, Financial Assistance. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Land Records (RoR/Patta)', 'https://www.myscheme.gov.in/schemes/ota-sfi', 'Ongoing', TRUE);

-- 80. Banglashree for Micro, Small and Medium Enterprises: Subsidy for Energy Efficiency (EES)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Banglashree for Micro, Small and Medium Enterprises: Subsidy for Energy Efficiency (EES)', '“Subsidy for Energy Efficiency (EES)” incentives under “Banglashree for MSMEs” scheme implemented by the MSMEs Dept., Government of West Bengal, aims to provide a reimbursement for the cost of energy and installations for energy conservation as per energy audit.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: MSME, Incentives, Energy Efficiency, Entrepreneurship, Subsidy. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/ees', 'Ongoing', TRUE);

-- 81.  The West Bengal Incentive Scheme: Waiver of Electricity Duty
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' The West Bengal Incentive Scheme: Waiver of Electricity Duty', '“Waiver of Electricity Duty” incentives under “The West Bengal Incentive Scheme” scheme implemented by the Dept. of Tourism, Government of West Bengal, aims to provide waiver of electricity duty on the electricity consumed in its approved project.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Tourism, Incentives, Waiver, Tourism Units, Entrepreneurship, Subsidy, Reimbursement, Electricity Duty, MSME. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbiswed', 'Ongoing', TRUE);

-- 82.  The West Bengal Incentive Scheme: State Capital Investment Subsidy
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' The West Bengal Incentive Scheme: State Capital Investment Subsidy', '“State Capital Investment Subsidy” incentives under “The West Bengal Incentive Scheme” scheme implemented by the Dept. of Tourism, Government of West Bengal, aims to provide a State Capital Investment Subsidy of the fixed capital investment.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Tourism, Incentives, State Capital Investment Subsidy, Tourism Units, Entrepreneurship, Subsidy, Reimbursement, MsmeS. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbisscis', 'Ongoing', TRUE);

-- 83. Banglashree for Micro, Small and Medium Enterprises: Subsidy on Stamp Duty and Registration Fee (SDRFS)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Banglashree for Micro, Small and Medium Enterprises: Subsidy on Stamp Duty and Registration Fee (SDRFS)', '“Subsidy on Stamp Duty and Registration Fee (SDRFS)” incentives under “Banglashree for MSMEs” scheme implemented by the MSMEs Dept., Government of West Bengal, provides a reimbursement of stamp duty and registration fee paid by the eligible enterprises for the purpose of registration of documents.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: MSME, Incentives, Stamp Duty, Financial Assistance, Entrepreneurship, Subsidy, Registration Fee, Reimbursement. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/sdrfs', 'Ongoing', TRUE);

-- 84. Incentive Scheme for MSMEs in Powerloom Sector: Interest Subsidy on Term Loan
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Incentive Scheme for MSMEs in Powerloom Sector: Interest Subsidy on Term Loan', '“Interest Subsidy on Term Loan” incentives under the “Incentive Scheme for MSMEs in Powerloom Sector” scheme implemented by the Dept. of MSME & T, Government of West Bengal, aims to provide subsidy on annual interest liability on the Term Loan borrowed from a Bank to an approved project.', 'state', 'west bengal', 0, 120, 'all', NULL, 'self_employed', 'all', 'all', 'Tags: Powerloom, Incentives, Interest Subsidy, Entrepreneurship, Subsidy, Reimbursement, Term Loan. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/ismpsistl', 'Ongoing', TRUE);

-- 85. Incentive Scheme for MSMEs in Powerloom Sector: Waiver of Electricity Duty
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Incentive Scheme for MSMEs in Powerloom Sector: Waiver of Electricity Duty', '“Waiver of Electricity Duty” incentives under the “Incentive Scheme for MSMEs in Powerloom Sector” scheme implemented by the Dept. of MSME & T, Government of West Bengal, aims to provide reimbursement of electricity duty on the electricity consumed for the manufacturing activity.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'self_employed', 'all', 'all', 'Tags: Powerloom, Waiver, Electricity Duty, Entrepreneurship, Subsidy, Reimbursement. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/ismpswed', 'Ongoing', TRUE);

-- 86. Incentive Scheme for MSMEs in Powerloom Sector: Subsidy for State Goods and Services Tax (SGST)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Incentive Scheme for MSMEs in Powerloom Sector: Subsidy for State Goods and Services Tax (SGST)', '“Subsidy for State Goods and Services Tax (SGST)” incentive under the “Incentive Scheme for MSMEs in Powerloom Sector” scheme implemented by the Dept. of MSME & T, Government of West Bengal, aims to provide refund of Net SGST paid to the Government of West Bengal for its approved project.', 'state', 'west bengal', 0, 120, 'all', NULL, 'self_employed', 'all', 'all', 'Tags: Powerloom, Waiver, State Goods And Services Tax, Entrepreneurship, Subsidy, Reimbursement, GST, SGST. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/ismpsssgst', 'Ongoing', TRUE);

-- 87.  The West Bengal Incentive Scheme: Additional Incentive for Adventure Tour Operators
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' The West Bengal Incentive Scheme: Additional Incentive for Adventure Tour Operators', '“Additional Incentive for Adventure Tour Operators” incentives under the “WBIS” scheme by the Dept. of Tourism, Government of West Bengal, aims to provide reimbursement incentives with SGST payments for purchasing tents, dinghies, adventure & sports equipment, and related accessories.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Tourism, Incentives, Tour Operators, Tourism Units, Entrepreneurship, Subsidy, Reimbursement, Adventure. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbisaito', 'Ongoing', TRUE);

-- 88. West Bengal Handloom and Khadi Weavers Financial Benefit Scheme 2024: Supply of Yarn to Societies etc. at Subsidized Rate
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'West Bengal Handloom and Khadi Weavers Financial Benefit Scheme 2024: Supply of Yarn to Societies etc. at Subsidized Rate', '“Supply of Yarn to Societies etc. at Subsidized Rate" is a sub-scheme under "West Bengal Handloom and Khadi Weavers Financial Benefit Scheme 2024”, by the MSME and Textiles Dept, Government of West Bengal aims to  provide supply of subsidized yarn to the PWCS, Khadi Weavers'' Societies etc.', 'state', 'west bengal', 0, 120, 'all', NULL, 'weaver', 'all', 'all', 'Tags: Handloom, Khadi Weavers, PWCS, Khadi Societies, Yarn, Subsidized Rate. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/syssr', 'Ongoing', TRUE);

-- 89.  The West Bengal Incentive Scheme: Tourism Promotion Assistance in lieu of Interest Subsidy
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' The West Bengal Incentive Scheme: Tourism Promotion Assistance in lieu of Interest Subsidy', '“Tourism Promotion Assistance in lieu of Interest Subsidy” incentive under the “The West Bengal Incentive Scheme” aims to provide Tourism Promotion Assistance for SGST irrespective of the location of the project, which will be in lieu of interest subsidy. ', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Tourism, Tourism Promotion, Interest Subsidy, Entrepreneurship. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbistpais', 'Ongoing', TRUE);

-- 90. West Bengal Incentive Scheme for Approved Industrial Park (SAIP) for MSMEs: Incentive for Setting up a Power Sub Station
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'West Bengal Incentive Scheme for Approved Industrial Park (SAIP) for MSMEs: Incentive for Setting up a Power Sub Station', 'The “Incentive for Setting up a Power Sub Station” under the “SAIP for MSMEs” scheme, facilitates the Private Industrial Park in the provision of quality power.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'self_employed', 'all', 'all', 'Tags: Entrepreneurship, MSMEs, Incentives, Incentives, Non-Fiscal Incentives. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/saipispss', '2025-09-15', TRUE);

-- 91. Banglashree for Micro, Small and Medium Enterprises: Power Subsidy (PS)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Banglashree for Micro, Small and Medium Enterprises: Power Subsidy (PS)', '“Power Subsidy (PS)” incentives under “Banglashree for MSMEs” scheme implemented by the MSMEs Dept., Government of West Bengal, aims to provide power subsidy on the electricity consumed for the manufacturing activity to an eligible micro or small enterprise.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: MSME, Incentives, Power Subsidy, Entrepreneurship, Subsidy. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/bmsmeps', 'Ongoing', TRUE);

-- 92. Banglashree for Micro, Small and Medium Enterprises: Subsidy for Water Conservation/Environment Compliance (WCS)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Banglashree for Micro, Small and Medium Enterprises: Subsidy for Water Conservation/Environment Compliance (WCS)', '“Subsidy for Water Conservation/Environment Compliance” incentives  by the MSMEs Dept., Government of West Bengal, aims to provide reimbursement of expenditure incurred by it towards the cost of captive Effluent Water Treatment Plant for wastewater recycling and/ or other pollution control devices.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: MSME, Incentives, Water Conservation, Environment Compliance, Entrepreneurship, Subsidy, Reimbursement, WCS. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/bmsmewcs', 'Ongoing', TRUE);

-- 93. West Bengal Handloom and Khadi Weavers Financial Benefit Scheme 2024: Support for One Time Settlement (OTS) of NPA Accounts of PWCS
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'West Bengal Handloom and Khadi Weavers Financial Benefit Scheme 2024: Support for One Time Settlement (OTS) of NPA Accounts of PWCS', '“Support for One Time Settlement (OTS) of NPA Accounts of PWCS" is a sub-scheme under "West Bengal Handloom and Khadi Weavers Financial Benefit Scheme 2024” by the MSME and Textiles Dept, Government of West Bengal aims to make PWCS debt free by providing financial support for OTS of NPA accounts.', 'state', 'west bengal', 0, 120, 'all', NULL, 'weaver', 'all', 'all', 'Tags: Handloom, Khadi Weavers, NPA, PWCS, OTS. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/otsnpa', 'Ongoing', TRUE);

-- 94.  The West Bengal Incentive Scheme: Subsidy for Quality Improvement
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' The West Bengal Incentive Scheme: Subsidy for Quality Improvement', '“Subsidy for Quality Improvement” incentives under the “WBIS” scheme aims to provide a reimbursement for the fixed capital investment expenditure incurred for quality improvement, modernization and installation of pollution control devices and for obtaining ISI/BIS/ISO certification.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Tourism, Incentives, Quality Improvement, Tourism Units, Entrepreneurship, Subsidy, Reimbursement. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbissqi', 'Ongoing', TRUE);

-- 95.  West Bengal Textile Incentive Scheme: Power Subsidy
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' West Bengal Textile Incentive Scheme: Power Subsidy', '“Power Subsidy” incentives under “West Bengal Textile Incentive Scheme” scheme implemented by the Dept. of MSME&T, Government of West Bengal, aims to provide power subsidy on electricity consumption for 5 years from the date of commencement of production.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Textile, Incentives, Waiver, Entrepreneurship, Subsidy, Reimbursement, Power Subsidy. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbisps', 'Ongoing', TRUE);

-- 96. Incentive Scheme for MSMEs in Powerloom Sector: Subsidy for Standard Quality Compliance
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Incentive Scheme for MSMEs in Powerloom Sector: Subsidy for Standard Quality Compliance', '“Subsidy for Standard Quality Compliance” incentive under the “Incentive Scheme for MSMEs in Powerloom Sector” scheme by the Dept. of MSME & T, Government of West Bengal, aims to provide reimbursement of the expenditure incurred for obtaining certification from approved Institutions/ Research Labs.', 'state', 'west bengal', 0, 120, 'all', NULL, 'self_employed', 'all', 'all', 'Tags: Powerloom, Waiver, Quality Compliance, Certification, Entrepreneurship, Subsidy, Reimbursement. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/ismpsssqc', 'Ongoing', TRUE);

-- 97. Incentive Scheme for MSMEs in Powerloom Sector: Subsidy for Patent Registration
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Incentive Scheme for MSMEs in Powerloom Sector: Subsidy for Patent Registration', '“Subsidy for Patent Registration” incentive under the “Incentive Scheme for MSMEs in Powerloom Sector” scheme implemented by the Dept. of MSME & T, Government of West Bengal,  aims to provide reimbursement of expenditure incurred by it for obtaining Patent Registration.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'self_employed', 'all', 'all', 'Tags: Powerloom, Waiver, Entrepreneurship, Subsidy, Reimbursement, Patent Registration. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/ismpsspr', 'Ongoing', TRUE);

-- 98. Incentive Scheme for MSMEs in Powerloom Sector: Subsidy for Energy Efficiency
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Incentive Scheme for MSMEs in Powerloom Sector: Subsidy for Energy Efficiency', '“Subsidy for Energy Efficiency” incentives under the “Incentive Scheme for MSMEs in Powerloom Sector” scheme implemented by the Dept. of MSME & T, Government of West Bengal, aims to provide a reimbursement for the cost of energy audit and installations for energy conservation as per energy audit.', 'state', 'west bengal', 0, 120, 'all', NULL, 'self_employed', 'all', 'all', 'Tags: Powerloom, Energy Audit, Energy Efficiency, Entrepreneurship, Subsidy, Reimbursement, Energy Conservation, Energy Installations. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/ismpssee', 'Ongoing', TRUE);

-- 99. West Bengal Incentive Scheme for Approved Industrial Park (SAIP) for MSMEs: Construction of Approach Road
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'West Bengal Incentive Scheme for Approved Industrial Park (SAIP) for MSMEs: Construction of Approach Road', 'The “Construction of Approach Road” under the “SAIP for MSMEs” scheme, facilitates the Private Industrial Park in provision with Approach Road catering to the AIP.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'construction_worker', 'all', 'all', 'Tags: Entrepreneurship, MSMEs, Industrial Park, Approach Road Construction, Subsidy. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Labour Registration Certificate', 'https://www.myscheme.gov.in/schemes/saipcar', '2025-09-15', TRUE);

-- 100.  The West Bengal Incentive Scheme: Capacity Utilisation
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, ' The West Bengal Incentive Scheme: Capacity Utilisation', '“Capacity Utilisation” incentives under the “The West Bengal Incentive Scheme” implemented by the Dept. of Tourism, Government of West Bengal, aims to provide additional Floor Area Ratio (FAR) over and above the maximum permissible FAR as may be fixed by the competent authority.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Tourism, Entrepreneurship, Capacity Utilisation, Incentives. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbiscu', 'Ongoing', TRUE);

-- 101. Financial Support Scheme for Farm Mechanization (FSSM)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (1, 'Financial Support Scheme for Farm Mechanization (FSSM)', '"Financial Support Scheme for Farm Mechanization (FSSM)" by the Agriculture Department, Government of West Bengal aims to provide financial support as subsidy to the small and marginal farmers of the State for purchase of power operated farm equipment/ machinery.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'farmer', 'all', 'all', 'Tags: Agriculture, Farmer, Mechanization, Financial Assistance. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Land Records (RoR/Patta)', 'https://www.myscheme.gov.in/schemes/fssm', 'Ongoing', TRUE);

-- 102. Banglashree for Micro, Small and Medium Enterprises: Subsidy for Standard Quality Compliance (SCCS)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Banglashree for Micro, Small and Medium Enterprises: Subsidy for Standard Quality Compliance (SCCS)', '“Subsidy for Standard Quality Compliance (SCCS)” incentives under “Banglashree for MSMEs” scheme implemented by the MSMEs Dept., Government of West Bengal, aims to provide reimbursement of the expenditure incurred for obtaining certification from approved Institutions/ Research Laboratories.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: MSME, Incentives, Standard Quality Compliance, Certification, Entrepreneurship, Subsidy, Reimbursement, SCCS. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/bmsmesccs', 'Ongoing', TRUE);

-- 103. Banglashree for Micro, Small and Medium Enterprises: State Capital Investment Subsidy (CIS)
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Banglashree for Micro, Small and Medium Enterprises: State Capital Investment Subsidy (CIS)', '“State Capital Investment Subsidy (CIS)” incentives under “Banglashree for MSMEs” scheme implemented by the MSMEs Department, Government of West Bengal, aims to provide Capital Investment Subsidy for its approved project to an eligible micro or small enterprise.', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: MSME, Incentives, Subsidy, Financial Assistance, Entrepreneurship. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/cis', 'Ongoing', TRUE);

-- 104. West Bengal Handloom and Khadi Weavers Financial Benefit Scheme 2024: Assistance to Viable and Potentially Viable PWCS
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'West Bengal Handloom and Khadi Weavers Financial Benefit Scheme 2024: Assistance to Viable and Potentially Viable PWCS', '“Assistance to Viable and Potentially Viable PWCS" is a sub-scheme under "West Bengal Handloom and Khadi Weavers Financial Benefit Scheme 2024”, by the MSME and Textiles Dept, Government of West Bengal aims to provide financial assistance to the societies who will fulfill the criteria of viability.', 'state', 'west bengal', 0, 120, 'all', NULL, 'weaver', 'all', 'all', 'Tags: Handloom, Khadi Weavers, PWCS, Khadi Societies. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/avpv', 'Ongoing', TRUE);

-- 105. Incentive Scheme for MSMEs in Powerloom Sector: Subsidy for Water Conservation/ Environment Compliance
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'Incentive Scheme for MSMEs in Powerloom Sector: Subsidy for Water Conservation/ Environment Compliance', '“Subsidy for Water Conservation/ Environment Compliance” incentive under the “Incentive Scheme for MSMEs in Powerloom Sector” scheme by the Dept. of MSME & T, Government of West Bengal, aims to provide reimbursement for expenditure incurred towards cost of captive sound pollution control devices.
', 'state', 'west bengal', 0, 120, 'all', NULL, 'self_employed', 'all', 'all', 'Tags: Powerloom, Waiver, Environment Compliance, Entrepreneurship, Subsidy, Reimbursement, Water Conservation. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/ismpsswcec', 'Ongoing', TRUE);

-- 106. West Bengal Textile Incentive Scheme: Reimbursement of Stamp Duty and Registration Fee
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (6, 'West Bengal Textile Incentive Scheme: Reimbursement of Stamp Duty and Registration Fee', '“Reimbursement of Stamp Duty and Registration Fee” incentives under “West Bengal Textile Incentive Scheme” scheme implemented by the Dept. of MSME&T, Government of West Bengal, aims to provide a reimbursement of stamp duty and registration fee paid by the eligible textile sector enterprises for', 'state', 'west bengal', 0, 120, 'all', NULL, 'all', 'all', 'all', 'Tags: Textile, Incentives, Waiver, Entrepreneurship, Subsidy, Reimbursement, Stamp Duty, Registration Fee. Level: state. For: Infra.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo', 'https://www.myscheme.gov.in/schemes/wbtisrsdre', 'Ongoing', TRUE);

-- 107. Sabooj Sathi
INSERT INTO schemes (category_id, name, description, scope, state, min_age, max_age, gender, max_income, occupation, education_level, caste_category, benefit_details, documents_required, application_url, deadline, is_active)
VALUES (5, 'Sabooj Sathi', 'The Sabooj Sathi Scheme is a student welfare initiative launched by the government of West Bengal, India, to provide bicycles to students in the state. Under the scheme, bicycles are distributed free of cost to students studying in government and government-aided schools from classes IX to XII. ', 'state', 'west bengal', 0, 120, 'all', NULL, 'student', 'all', 'all', 'Tags: Sabooj Sathi Scheme West Bengal Government, Student Welfare, Bicycles Distribution, Empowerment, Social Inclusion, Free Transportation, Sustainable Development. Level: state. For: None.', 'Aadhaar Card, Bank Account Details, Residence Proof, Passport Size Photo, Previous Year Marksheet, Admission Certificate, Income Certificate', 'https://www.myscheme.gov.in/schemes/wbsaboojsathi', 'Ongoing', TRUE);
