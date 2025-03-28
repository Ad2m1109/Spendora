# Spendora
Spendora – Personal Finance Tracking Application
![Interface Screenshot](logo.png)
## 1. Introduction
 1.1 Context Managing personal finances is essential for individuals who want to better organize their income and expenses. This application aims to provide an intuitive and visual solution for tracking finances and achieving savings goals.

 1.2 Objectives The main goal of this project is to develop a mobile application that allows users to:

- Track their income and expenses.
- Visualize their financial situation using graphs.
- Set savings goals and monitor progress.
- Generate financial reports to better understand their spending habits.

 1.3 Target Audience The application is designed for individuals who want to optimize their financial management simply and efficiently.

 1.4 Actors and Roles **"User":**

- Registers and logs into the application.
- Adds, edits, and deletes financial transactions.
- Views reports and graphs.
- Defines and tracks savings goals.

## 2. Functional Requirements

### 2.1 Core Features

#### 2.1.1 User Authentication

- User registration and login.
- Profile management (editing personal information).
- Secure password storage (hashed with bcrypt).

#### 2.1.2 Income and Expense Management

- Add, edit, and delete income and expense entries.
- Categorize transactions (salary, groceries, rent, etc.).
- Assign a date and amount to each transaction.

#### 2.1.3 Dashboard

- Display financial balance (total income, total expenses, net savings).
- Visualize transactions through graphs (pie charts, bar charts).
- Analyze trends and provide recommendations.

#### 2.1.4 Financial Goals

- Set personalized savings goals.
- Track progress toward goals.
- Receive alerts and notifications when important thresholds are reached.

#### 2.1.5 Reports and Insights

- Generate monthly and annual financial reports.
- Analyze expenses by category.
- Export data in CSV format.

### 2.2 Optional Features

- Dark mode and theme customization.
- API integration with banks for automatic transaction synchronization.
- Multi-currency support.

## 3. Non-Functional Requirements

### 3.1 Performance Requirements

- Response time under 2 seconds.
- Support for multiple simultaneous users.
- Optimized database with indexing for fast queries.

### 3.2 Security Requirements

- Password encryption.
- Protection against attacks (SQL Injection, XSS, CSRF).
- Mandatory HTTPS connection.

## 4. Technical Architecture

- **Mobile Application:** Developed with **Flutter**.
- **Backend:** Developed in Python for data processing and analysis.
- **Database:** MySQL.
- **Visualization:** Graph generation using Python (Matplotlib, Seaborn).
- **Hosting:** Heroku, Vercel, or AWS.
- **Version Control:** Git/GitHub.

## Product Backlog - Spendora

|ID|User Story|Priority|
|---|---|---|
|US1|As a user, I want to sign up with an email and password.|High|
|US2|As a user, I want to log in and log out.|High|
|US3|As a user, I want to edit my profile (name, password, photo).|Medium|
|US4|As a user, I want to add a transaction with a category, amount, and date.|High|
|US5|As a user, I want to edit or delete an existing transaction.|Medium|
|US6|As a user, I want to categorize my transactions (rent, groceries, salary, etc.).|High|
|US7|As a user, I want to see a summary of my income and expenses on my dashboard.|High|
|US8|As a user, I want to see graphs illustrating my expenses by category.|Medium|
|US9|As a user, I want to track my balance over time.|Medium|
|US10|As a user, I want to set a savings goal.|High|
|US11|As a user, I want to receive a notification when I reach a certain percentage of my goal.|Medium|
|US12|As a user, I want to generate a monthly financial report.|Medium|
|US13|As a user, I want to export my transactions as a CSV file.|Low|
|US14|As a user, I want my data to be securely encrypted.|High|
|US15|As a user, I want to log in using face recognition.|Medium|

## Sprint Plan - Spendora

### Sprint 1: Authentication and User Management (2 weeks)

| ID  | User Story                            | Priority |
| --- | ------------------------------------- | -------- |
| US1 | Sign up with email and password.      | High     |
| US2 | Log in and log out.                   | High     |
| US3 | Edit profile (name, password, photo). | Medium   |

### Sprint 2: Financial Transactions Management (2 weeks)

| ID  | User Story                                               | Priority |
| --- | -------------------------------------------------------- | -------- |
| US4 | Add a transaction with a category, amount, and date.     | High     |
| US5 | Edit or delete an existing transaction.                  | Medium   |
| US6 | Categorize transactions (rent, groceries, salary, etc.). | High     |

### Sprint 3: Dashboard and Visualization (2 weeks)

| ID  | User Story                                              | Priority |
| --- | ------------------------------------------------------- | -------- |
| US7 | View a summary of income and expenses on the dashboard. | High     |
| US8 | View expense graphs by category.                        | Medium   |
| US9 | Track balance over time.                                | Medium   |

### Sprint 4: Financial Goals and Notifications (1 week)

| ID   | User Story                                     | Priority |
| ---- | ---------------------------------------------- | -------- |
| US10 | Set a savings goal.                            | High     |
| US11 | Receive a notification when a goal is reached. | Medium   |

### Sprint 5: Reports and Exporting (1 week)

| ID   | User Story                           | Priority |
| ---- | ------------------------------------ | -------- |
| US12 | Generate a monthly financial report. | Medium   |
| US13 | Export transactions as a CSV file.   | Low      |

### Sprint 6: Security and Optimization (1 week)

| ID   | User Story                     | Priority |
| ---- | ------------------------------ | -------- |
| US14 | Secure data with encryption.   | High     |
| US15 | Log in using face recognition. | Medium   |

## Release Plan - Spendora

| Release       | Sprints             | Goal                             | Outcome                                                                                               | Time    |
| ------------- | ------------------- | -------------------------------- | ----------------------------------------------------------------------------------------------------- | ------- |
| **Release 1** | Sprint 1 & Sprint 2 | User Management & Transactions   | Users can register, log in, manage profiles, and track transactions.                                  | 4 weeks |
| **Release 2** | Sprint 3 & Sprint 4 | Dashboard & Financial Goals      | Users can view financial summaries, graphs, and track savings goals.                                  | 3 weeks |
| **Release 3** | Sprint 5 & Sprint 6 | Reports, Security & Optimization | Users can generate reports, export data, enjoy improved security, and use face recognition for login. | 2 weeks |

📅 **Total estimated duration:** 9 weeks 
🚀 **Incremental feature delivery after each release.**

