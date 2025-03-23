# 💼 data-job-salary

An interactive Shiny dashboard for exploring salary trends in data-related jobs from 2020 to 2024.

## 📊 Dataset Overview

- **Name**: Salaries of Data-Related Jobs (2020–2024)  
- **Source**: [Kaggle – Latest Data Science Job Salaries 2020 - 2024](https://www.kaggle.com/)  
- **Size**: 14,838 rows × 8 columns  
- **Time Range**: 2020 - 2024

### Variables

**Categorical**
- `work_year`: Year of the job record (2020–2024)
- `experience_level`: Entry, Mid, Senior, Executive
- `employment_type`: Part-time, Full-time, Freelance, Contract
- `job_title`: Job title
- `job_category`: Job category (manually classified into 10 groups)
- `company_size`: Small, Medium, Large
- `country_company`: Company location (converted from country code)

**Numerical**
- `salary_in_usd`: Salary in USD (ranging from $15,000 to $800,000)

---

## 🎯 Project Purpose

1. **Curiosity in the Field**  
   As a data student, I'm interested in exploring how salaries vary by title, experience, and geography.

2. **Impact of Generative AI**  
   With generative AI booming since 2022, I wanted to examine if it brought new roles or influenced salary levels.

---

## 🔍 Analysis Goals

- Salary trends vs. job category
- Salary vs. experience level
- Salary by country
- Changes before and after AI became mainstream
- Trends in job category growth

---

## 🛠️ Data Preparation

- Checked for NA values — none found ✅
- Transformed:
  - `experience_level`, `company_size`: expanded and converted to factors
  - `country_company`: converted from code to full name using `left_join`
  - `job_category`: enriched via external source, then manually classified 337 unmatched titles

---

## 🖥️ Shiny App Features

- **Sidebar Filters**: Five dimensions (e.g., year, level, job category)
- **Main Panel**:
  - Top graph: Line chart for salary trends
  - Bottom two: Bar or box plots for comparisons
- **Table Tab**: Displays raw dataset
- **Submit Button**: To apply filters and update graphs
- *(Planned)*: Let users choose number of data entries shown

---

## 📦 How to Run

```r
# Clone this repo
git clone https://github.com/morgan-jj-cheng/data-job-salary.git

# In R
shiny::runApp("path_to_app")
