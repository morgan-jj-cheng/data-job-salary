# Data Job Salary Dashboard (2020–2024)

An interactive dashboard to explore salary trends in data-related jobs across years, job categories, company countries, and experience levels.

🔗 **[Try the App](https://morgan-jj-cheng.shinyapps.io/data-job-salary/)**

---

## 📊 Dataset Overview

- **Name**: Salaries of Data-Related Jobs (2020–2024)  
- **Source**: [Kaggle – Latest Data Science Job Salaries 2020 - 2024](https://www.kaggle.com/)  
- **Size**: 14,838 rows × 8 columns  
- **Time Range**: 2020 - 2024

### Variables

**Categorical**
- `work_year`: Year of the job record
- `experience_level`: Entry, Mid, Senior, Executive
- `employment_type`: Part-time, Full-time, Freelance, Contract
- `job_title`: Job title
- `job_category`: Manually classified into 10 groups
- `company_size`: Small, Medium, Large
- `country_company`: Converted from country code to full name

**Numerical**
- `salary_in_usd`: Salary in USD ($15,000 – $800,000)

---

## 🔍 Key Features of the Dashboard

- **Filter Panel** (Sidebar):
  - Work year
  - Experience level
  - Employment type
  - Job category
  - Country

- **Main Dashboard**:
  - *Distribution chart*: Salary distribution by experience level
  - *Boxplot*: Salary distribution by experience level and job title
  - *World map*: Median salary by year and country
  - *Line chart*: Salary trend by year
  - *Data Table*: View and customize filtering with raw data

---

## 🛠️ Data Processing

- Verified no `NA` values in dataset
- Converted short codes (e.g., country code, company size) to full names
- Enriched job titles with categories using external references + manual classification for 337 unmatched entries
