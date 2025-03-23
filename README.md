# Data Job Salary Dashboard (2020–2024)

An interactive Shiny dashboard to explore salary trends in data-related jobs across years, job categories, company countries, and experience levels.

🔗 **[👉 Click here to launch the live app](https://morgan-jj-cheng.shinyapps.io/Salaries-of-Data-Related-Jobs/)**

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

## 🎯 Project Purpose

1. **Understand Industry Landscape**  
   As a student in data-related fields, I was curious about salary distributions based on job titles, experience levels, and locations.

2. **Analyze AI’s Impact**  
   Since generative AI emerged in 2022, I wanted to see if it has led to changes in job types and salaries.

---

## 🔍 Key Features of the Dashboard

- **Filter Panel** (Sidebar):
  - Work year
  - Experience level
  - Employment type
  - Job category
  - Country

- **Main Dashboard**:
  - 📈 *Line chart*: Salary trend by year
  - 📊 *Bar chart*: Median salary by job category
  - 📦 *Boxplot*: Salary distribution by experience level or country

- **Submit Button**: Click to apply selected filters and update charts  
- **Data Table Tab**: View and search the filtered raw data

---

## 🛠️ Data Processing

- Verified no `NA` values in dataset
- Converted short codes (e.g., country code, company size) to full names
- Enriched job titles with categories using external references + manual classification for 337 unmatched entries

---

## 🚀 Run Locally

```r
# Clone the repo
git clone https://github.com/morgan-jj-cheng/data-job-salary.git

# Run the app
shiny::runApp("path_to_app")
