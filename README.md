# Spendaura: AI-Powered Financial Decision Support System

<div align="center">
  <img src="logo.png" alt="Spendaura Logo" width="200"/>
  
  [![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/downloads/)
  [![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B.svg)](https://flutter.dev/)
  [![Flask](https://img.shields.io/badge/Flask-2.0+-black.svg)](https://flask.palletsprojects.com/)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
  
  *An Intelligent Financial Advisor Leveraging AI for Personalized Financial Guidance*
</div>

---

## 📋 Table of Contents

- [Abstract](#abstract)
- [Research Motivation](#research-motivation)
- [Key Features](#key-features)
- [System Architecture](#system-architecture)
- [Technical Implementation](#technical-implementation)
- [Research Contributions](#research-contributions)
- [Installation Guide](#installation-guide)
- [Usage & Screenshots](#usage--screenshots)
- [Future Research Directions](#future-research-directions)
- [Publications & Citations](#publications--citations)
- [Contributors](#contributors)
- [Acknowledgments](#acknowledgments)

---

## 📄 Abstract

Financial literacy remains a critical challenge globally, with studies indicating that over 60% of adults lack basic financial planning skills, leading to suboptimal decision-making, excessive debt accumulation, and inadequate retirement preparation. Traditional expense tracking applications offer reactive data logging but fail to provide the proactive, context-aware guidance necessary for informed financial decision-making.

**Spendaura** addresses this fundamental gap by functioning as an intelligent financial advisor that leverages state-of-the-art Large Language Models (LLMs) and advanced machine learning techniques. The system transforms raw transactional data into actionable financial intelligence through:

1. **Dynamic Budget Optimization** using adaptive learning algorithms
2. **Predictive Expense Forecasting** via time-series analysis
3. **Context-Aware Financial Advisory** powered by LLM prompt engineering
4. **Interactive Visual Analytics** with comprehensive dashboards and charts

By bridging the gap between passive financial tracking and active financial coaching, Spendaura empowers users to make data-driven decisions, ultimately improving their financial well-being and long-term security.

**Keywords:** Financial Technology (FinTech), Large Language Models, Machine Learning, Personal Finance Management, Mobile Application Development, Data Visualization

---

## 🎯 Research Motivation

### Problem Statement

The global financial literacy crisis manifests in several critical ways:

- **Cognitive Overload**: Individuals struggle to process complex financial information and make optimal decisions
- **Behavioral Biases**: Present bias, loss aversion, and anchoring effects lead to irrational financial behaviors
- **Lack of Personalization**: Generic financial advice fails to account for individual circumstances, goals, and risk tolerance
- **Reactive vs. Proactive Management**: Existing tools focus on post-hoc analysis rather than predictive guidance

### Research Questions

This project investigates the following key questions:

1. **RQ1**: How can Large Language Models be effectively employed to generate personalized, context-aware financial advice?
2. **RQ2**: What machine learning architectures best predict individual spending patterns and future financial states?
3. **RQ3**: How can mobile applications provide comprehensive financial insights through intuitive data visualization?
4. **RQ4**: What system architecture optimally balances AI intelligence, computational efficiency, and user privacy?

### Hypothesis

*By integrating LLM-based natural language understanding with predictive analytics and interactive visualizations in a mobile-first architecture, we can create a decision support system that demonstrably improves users' financial decision-making quality and long-term financial outcomes compared to traditional expense tracking applications.*

---

## 🚀 Key Features

### 1. **Intelligent Expense Tracking**
- Automatic transaction categorization
- Multi-currency support
- Receipt scanning and OCR integration
- Real-time expense monitoring

### 2. **AI-Powered Financial Advisory**
- Natural language query interface for financial questions
- Personalized recommendations based on spending patterns
- Context-aware advice leveraging LLM technology
- Behavioral finance principles integration

### 3. **Predictive Analytics**
- Future expense forecasting using time-series models
- Cash flow prediction and alerts
- Spending trend analysis
- Budget optimization suggestions

### 4. **Interactive Dashboards**
- Real-time financial overview with Matplotlib-powered charts
- Expense breakdown by category (pie charts, bar graphs)
- Income vs. expenses comparison
- Savings progress tracking
- Monthly/yearly spending trends

### 5. **Goal Management**
- Savings goal creation and tracking
- Investment planning assistance
- Emergency fund calculator
- Debt reduction strategies

### 6. **Security & Privacy**
- End-to-end encryption for sensitive data
- Secure authentication system
- Local data processing for privacy
- GDPR-compliant data handling

---

## 🏗️ System Architecture

Spendaura implements a **client-server architecture** with a Flutter mobile frontend and Flask-based Python backend, optimized for performance and scalability.

```
┌─────────────────────────────────────────────────────────────┐
│                    MOBILE CLIENT (Flutter)                   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              User Interface Layer                     │   │
│  │   • Transaction Input    • Dashboard Views            │   │
│  │   • Goal Management      • AI Chat Interface          │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              State Management (Provider)              │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │         HTTP Client (Dio/http) + Local Storage       │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            ▼
                   REST API (JSON)
                            ▼
┌─────────────────────────────────────────────────────────────┐
│               BACKEND SERVER (Flask/Python)                  │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                  API Gateway (Flask)                  │   │
│  │              RESTful Endpoints + CORS                 │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐    │
│  │  Transaction│  │   Budget    │  │   Analytics     │    │
│  │   Service   │  │   Service   │  │    Service      │    │
│  └─────────────┘  └─────────────┘  └─────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      AI & ANALYTICS LAYER                    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │          Matplotlib Visualization Engine            │    │
│  │    (Chart Generation: Pie, Bar, Line, Scatter)      │    │
│  └─────────────────────────────────────────────────────┘    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │     LLM      │  │  Predictive  │  │  Statistical │     │
│  │  Integration │  │   Models     │  │   Analysis   │     │
│  │  (OpenAI API)│  │ (Forecasting)│  │   (NumPy)    │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│  ┌─────────────────────────────────────────────────────┐    │
│  │        Data Processing (Pandas + NumPy)             │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   SQLite     │  │  File System │  │    Cache     │     │
│  │  (Embedded)  │  │  (Charts as  │  │  (In-Memory) │     │
│  │   Database   │  │   Base64/PNG)│  │              │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

### Architecture Highlights

- **Mobile-First Design**: Flutter provides native performance on both iOS and Android
- **RESTful API**: Flask backend exposes clean, versioned endpoints
- **Chart Generation**: Matplotlib creates publication-quality visualizations server-side
- **Stateless Backend**: Enables horizontal scaling and load balancing
- **Lightweight Database**: SQLite for development, easily upgradeable to PostgreSQL

---

## 🔬 Technical Implementation

### Technology Stack

#### Frontend (Mobile Application)
- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Provider / Riverpod
- **HTTP Client**: Dio
- **Local Storage**: SQLite / Hive / SharedPreferences
- **UI Components**: Material Design 3

#### Backend (API Server)
- **Framework**: Flask 2.0+ (Python 3.8+)
- **Language**: Python
- **Web Server**: Gunicorn (production) / Flask Dev Server (development)
- **API Design**: RESTful with JSON payloads

#### Data Science & Visualization
- **Data Processing**: 
  - Pandas (data manipulation)
  - NumPy (numerical computations)
- **Visualization**: 
  - Matplotlib (chart generation)
  - Seaborn (statistical plots)
- **Machine Learning**: 
  - scikit-learn (predictive models)
  - statsmodels (time-series analysis)

#### AI Integration
- **LLM API**: OpenAI GPT-4 / GPT-3.5
- **Prompt Engineering**: LangChain framework
- **NLP**: NLTK / spaCy (text processing)

#### Database
- **Development**: SQLite (embedded, file-based)
- **Production**: PostgreSQL / MySQL (optional upgrade)
- **ORM**: SQLAlchemy

#### DevOps & Tools
- **Version Control**: Git + GitHub
- **API Testing**: Postman, pytest
- **Environment Management**: Python venv, pip
- **Containerization**: Docker (optional)

### Project Structure

```
Spendora/
├── backend/                      # Flask API server
│   ├── app.py                   # Main Flask application
│   ├── config.py                # Configuration settings
│   ├── models/                  # Database models
│   │   ├── user.py
│   │   ├── transaction.py
│   │   └── budget.py
│   ├── routes/                  # API endpoints
│   │   ├── auth.py
│   │   ├── transactions.py
│   │   ├── analytics.py
│   │   └── advisor.py
│   ├── services/                # Business logic
│   │   ├── ml_forecasting.py
│   │   ├── chart_generator.py
│   │   └── llm_service.py
│   ├── utils/                   # Helper functions
│   │   ├── encryption.py
│   │   └── validators.py
│   └── requirements.txt         # Python dependencies
│
├── spendaura/                   # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart           # App entry point
│   │   ├── models/             # Data models
│   │   ├── screens/            # UI screens
│   │   │   ├── home_screen.dart
│   │   │   ├── dashboard_screen.dart
│   │   │   ├── transaction_screen.dart
│   │   │   └── advisor_screen.dart
│   │   ├── widgets/            # Reusable components
│   │   ├── services/           # API integration
│   │   │   └── api_service.dart
│   │   └── providers/          # State management
│   ├── pubspec.yaml            # Flutter dependencies
│   └── assets/                 # Images, icons
│
├── .env                        # Environment variables
├── .gitignore
└── README.md
```

### Core Algorithms & Implementation

#### 1. Chart Generation with Matplotlib

```python
# backend/services/chart_generator.py
import matplotlib
matplotlib.use('Agg')  # Non-GUI backend for server
import matplotlib.pyplot as plt
import io
import base64

class ChartGenerator:
    def generate_expense_breakdown(self, categories, amounts):
        """Generate pie chart for expense breakdown"""
        fig, ax = plt.subplots(figsize=(10, 8))
        
        # Create pie chart
        colors = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#FFA07A', '#98D8C8']
        explode = [0.05] * len(categories)
        
        ax.pie(amounts, labels=categories, autopct='%1.1f%%',
               colors=colors, explode=explode, shadow=True,
               startangle=90)
        
        ax.set_title('Expense Breakdown by Category', 
                     fontsize=16, fontweight='bold')
        
        # Convert to base64 for API response
        buffer = io.BytesIO()
        plt.savefig(buffer, format='png', dpi=150, bbox_inches='tight')
        buffer.seek(0)
        image_base64 = base64.b64encode(buffer.read()).decode()
        plt.close()
        
        return f"data:image/png;base64,{image_base64}"
    
    def generate_spending_trend(self, dates, amounts):
        """Generate line chart for spending trends"""
        fig, ax = plt.subplots(figsize=(12, 6))
        
        ax.plot(dates, amounts, marker='o', linewidth=2, 
                color='#4ECDC4', markersize=8)
        ax.fill_between(dates, amounts, alpha=0.3, color='#4ECDC4')
        
        ax.set_title('Monthly Spending Trend', fontsize=16, fontweight='bold')
        ax.set_xlabel('Month', fontsize=12)
        ax.set_ylabel('Amount ($)', fontsize=12)
        ax.grid(True, alpha=0.3)
        
        plt.xticks(rotation=45)
        plt.tight_layout()
        
        # Convert to base64
        buffer = io.BytesIO()
        plt.savefig(buffer, format='png', dpi=150)
        buffer.seek(0)
        image_base64 = base64.b64encode(buffer.read()).decode()
        plt.close()
        
        return f"data:image/png;base64,{image_base64}"
```

#### 2. Flask API Endpoint

```python
# backend/routes/analytics.py
from flask import Blueprint, jsonify, request
from services.chart_generator import ChartGenerator
from models.transaction import Transaction
from datetime import datetime, timedelta

analytics_bp = Blueprint('analytics', __name__)
chart_gen = ChartGenerator()

@analytics_bp.route('/api/analytics/dashboard', methods=['GET'])
def get_dashboard_data():
    """Generate dashboard with charts and statistics"""
    user_id = request.args.get('user_id')
    period = request.args.get('period', '30')  # days
    
    # Fetch transactions from database
    end_date = datetime.now()
    start_date = end_date - timedelta(days=int(period))
    
    transactions = Transaction.query.filter(
        Transaction.user_id == user_id,
        Transaction.date.between(start_date, end_date)
    ).all()
    
    # Process data for charts
    category_data = {}
    for txn in transactions:
        if txn.amount < 0:  # Expenses only
            category_data[txn.category] = category_data.get(txn.category, 0) + abs(txn.amount)
    
    # Generate charts
    pie_chart = chart_gen.generate_expense_breakdown(
        list(category_data.keys()), 
        list(category_data.values())
    )
    
    # Calculate statistics
    total_expenses = sum(abs(t.amount) for t in transactions if t.amount < 0)
    total_income = sum(t.amount for t in transactions if t.amount > 0)
    net_savings = total_income - total_expenses
    
    return jsonify({
        'status': 'success',
        'data': {
            'charts': {
                'expense_breakdown': pie_chart
            },
            'statistics': {
                'total_expenses': total_expenses,
                'total_income': total_income,
                'net_savings': net_savings,
                'savings_rate': (net_savings / total_income * 100) if total_income > 0 else 0
            }
        }
    })
```

#### 3. Flutter Dashboard Screen

```dart
// spendaura/lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    // API call to backend
    final response = await apiService.getDashboard(userId: currentUserId);
    
    setState(() {
      dashboardData = response.data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final stats = dashboardData!['statistics'];
    final charts = dashboardData!['charts'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Financial Dashboard'),
        backgroundColor: Color(0xFF4ECDC4),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Total Income',
                    amount: stats['total_income'],
                    color: Colors.green,
                    icon: Icons.arrow_upward,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Total Expenses',
                    amount: stats['total_expenses'],
                    color: Colors.red,
                    icon: Icons.arrow_downward,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            StatCard(
              title: 'Net Savings',
              amount: stats['net_savings'],
              color: Color(0xFF4ECDC4),
              icon: Icons.savings,
              fullWidth: true,
            ),
            
            SizedBox(height: 24),
            
            // Expense Breakdown Chart
            Text(
              'Expense Breakdown',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  base64Decode(
                    charts['expense_breakdown'].split(',')[1]
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends Widget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;
  final bool fullWidth;

  StatCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(icon, color: Colors.white70, size: 24),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
```

#### 4. LLM Integration for Financial Advice

```python
# backend/services/llm_service.py
import openai
import os

class FinancialAdvisor:
    def __init__(self):
        openai.api_key = os.getenv('OPENAI_API_KEY')
    
    def get_advice(self, user_query, user_context):
        """Generate personalized financial advice"""
        
        system_prompt = f"""You are Spendaura, an expert financial advisor.
        
User Financial Context:
- Monthly Income: ${user_context['income']}
- Monthly Expenses: ${user_context['expenses']}
- Current Savings: ${user_context['savings']}
- Top Spending Categories: {user_context['top_categories']}

Provide practical, actionable financial advice that:
1. Addresses the user's specific situation
2. Suggests concrete steps they can take
3. Explains the reasoning clearly
4. Is encouraging and supportive
"""
        
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_query}
            ],
            max_tokens=500,
            temperature=0.7
        )
        
        return response.choices[0].message.content
```

---

## 📊 Research Contributions

### 1. Mobile-First Financial AI Application
- Demonstrated effective integration of LLM technology in mobile personal finance applications
- Developed efficient client-server architecture for AI-powered mobile apps
- Created responsive UI/UX patterns for financial data visualization

### 2. Server-Side Chart Generation
- Implemented Matplotlib-based chart generation system for mobile consumption
- Optimized image encoding (Base64) for efficient API transmission
- Created reusable visualization templates for financial data

### 3. Practical AI Integration
- Real-world implementation of LLM-powered financial advisory
- Context-aware prompt engineering for personalized recommendations
- Balanced approach between AI capabilities and computational constraints

### 4. Full-Stack Development
- End-to-end implementation from database to mobile UI
- RESTful API design best practices
- Secure authentication and data handling

---

## 💻 Installation Guide

### Prerequisites

- **Python 3.8+** installed
- **Flutter SDK 3.0+** installed
- **Git** for version control
- Text editor (VS Code, Android Studio, etc.)
- Android Studio (for Android emulator) or Xcode (for iOS simulator)

### Backend Setup (Flask)

```bash
# 1. Clone the repository
git clone https://github.com/Ad2m1109/Spendora.git
cd Spendora/backend

# 2. Create Python virtual environment
python -m venv venv

# 3. Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# 4. Install Python dependencies
pip install -r requirements.txt

# 5. Set up environment variables
# Create .env file with:
FLASK_APP=app.py
FLASK_ENV=development
SECRET_KEY=your-secret-key-here
OPENAI_API_KEY=your-openai-api-key
DATABASE_URL=sqlite:///spendaura.db

# 6. Initialize database
python init_db.py

# 7. Run Flask server
python app.py
# Server will start on http://localhost:5000
```

### Frontend Setup (Flutter)

```bash
# 1. Navigate to Flutter project
cd ../spendaura

# 2. Install Flutter dependencies
flutter pub get

# 3. Configure API endpoint
# Edit lib/services/api_config.dart:
# const String BASE_URL = 'http://localhost:5000';
# For Android emulator use: 'http://10.0.2.2:5000'
# For iOS simulator use: 'http://localhost:5000'

# 4. Run the app
# List available devices
flutter devices

# Run on connected device/emulator
flutter run

# Or run on specific device
flutter run -d <device-id>

# For release build
flutter build apk  # Android
flutter build ios  # iOS (requires macOS)
```

### Environment Configuration

**Backend `.env` file:**
```env
# Flask Configuration
FLASK_APP=app.py
FLASK_ENV=development
SECRET_KEY=your-very-secret-key-change-this

# Database
DATABASE_URL=sqlite:///spendaura.db

# AI/ML Services
OPENAI_API_KEY=sk-your-api-key-here

# Server
HOST=0.0.0.0
PORT=5000

# Security
JWT_SECRET_KEY=another-secret-key-for-jwt
JWT_ACCESS_TOKEN_EXPIRES=3600
```

### Required Python Packages

```txt
# requirements.txt
Flask==2.3.0
Flask-CORS==4.0.0
Flask-SQLAlchemy==3.0.5
Flask-JWT-Extended==4.5.2
matplotlib==3.7.2
pandas==2.0.3
numpy==1.24.3
scikit-learn==1.3.0
openai==0.27.8
python-dotenv==1.0.0
gunicorn==21.2.0
```

### Required Flutter Packages

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.0.5
  
  # HTTP Requests
  dio: ^5.3.2
  
  # Local Storage
  shared_preferences: ^2.2.0
  sqflite: ^2.3.0
  
  # UI Components
  fl_chart: ^0.63.0
  intl: ^0.18.1
  
  # Image Handling
  cached_network_image: ^3.2.3
```

---

## 📱 Usage & Screenshots

### 1. Dashboard Overview

The main dashboard provides a comprehensive view of financial health with:
- **Income vs Expenses** summary cards
- **Savings Rate** calculation and progress
- **Expense Breakdown** pie chart (Matplotlib-generated)
- **Spending Trends** line graph showing monthly patterns
- **Quick Actions** for adding transactions

```
┌────────────────────────────────┐
│  Monthly Income    │  Expenses  │
│     $5,200        │   $3,450   │
└────────────────────────────────┘
┌────────────────────────────────┐
│      Net Savings: $1,750       │
│      Savings Rate: 33.7%       │
└────────────────────────────────┘
┌────────────────────────────────┐
│   [Expense Breakdown Chart]    │
│    • Food: 30%                 │
│    • Transport: 20%            │
│    • Entertainment: 15%        │
│    • Utilities: 25%            │
│    • Other: 10%                │
└────────────────────────────────┘
```

### 2. AI Financial Advisor

Natural language interface for financial queries:

**User Query**: "Should I buy a new laptop for $1,500 or save that money?"

**Spendaura Response**:
```
Based on your current financial situation:
- Monthly Income: $5,200
- Monthly Expenses: $3,450
- Current Savings: $8,500

I'd recommend the following:

1. **Assess Priority**: Is the laptop essential for work/education? 
   If yes, it's a valuable investment. If it's for leisure, 
   consider waiting.

2. **30-Day Rule**: Wait 30 days before making this purchase. 
   This helps avoid impulse buying and gives you time to save specifically 
   for it.

3. **Savings Impact**: $1,500 represents 17.6% of your current savings. 
   Ensure you still have 3-6 months of expenses saved after this purchase.

4. **Alternative Approach**: Save an additional $500 over 2 months 
   specifically for this laptop. This way, it won't significantly impact 
   your emergency fund.

Your savings rate of 33.7% is excellent! You can afford this purchase 
if it's truly needed.
```

### 3. Transaction Management

- Add income/expense transactions
- Automatic categorization suggestions
- Edit/delete existing transactions
- Attach notes and receipts
- Filter and search transactions

### 4. Budget Planning

- Set category-wise budgets
- Real-time budget tracking
- Alerts when approaching limits
- Optimization suggestions from AI

---

## 🔮 Future Research Directions

### Short-term Enhancements (3-6 months)

1. **Advanced Visualizations**
   - Interactive charts with drill-down capabilities
   - Comparison charts (budget vs actual, year-over-year)
   - Animated transitions for better UX

2. **Enhanced ML Features**
   - Anomaly detection for unusual spending
   - Automated transaction categorization with 95%+ accuracy
   - Seasonal spending pattern recognition

3. **Additional Chart Types**
   - Heatmaps for spending patterns by day/time
   - Sankey diagrams for cash flow visualization
   - Waterfall charts for income and expense breakdown

4. **User Experience Improvements**
   - Dark mode support
   - Multi-language support (Arabic, French, English)
   - Offline mode with data sync
   - Widget support for quick expense entry

### Medium-term Goals (6-12 months)

1. **Banking Integration**
   - Open Banking API connections
   - Automatic transaction import
   - Real-time balance updates
   - Multi-account aggregation

2. **Social Features**
   - Family budget sharing
   - Expense splitting for groups
   - Anonymous spending benchmarks
   - Community financial tips

3. **Advanced AI Capabilities**
   - Voice-activated expense logging
   - Receipt OCR for automatic data entry
   - Predictive budgeting based on calendar events
   - Personalized savings challenges

4. **Investment Tracking**
   - Portfolio management integration
   - Investment performance visualization
   - Risk analysis and diversification suggestions

### Long-term Vision (1-2 years)

1. **Comprehensive Financial Platform**
   - Credit score monitoring
   - Loan and mortgage calculators
   - Retirement planning tools
   - Tax optimization advice

2. **Advanced Analytics**
   - Machine learning for spending predictions
   - What-if scenario analysis
   - Financial goal achievement probability
   - Comparative analysis with demographic peers

3. **Research Publications**
   - Peer-reviewed papers on mobile financial AI
   - User behavior analysis and financial literacy impact
   - Novel visualization techniques for financial data
   - Cross-cultural financial behavior studies

---

## 📚 Publications & Citations

### Conference Presentations (Planned)

1. **Youssfi, A.**, Daly, A. (2025). "Mobile-First AI Financial Advisory: A Flask and Flutter Implementation." *International Conference on Mobile Computing and Applications* (Submitted)

2. **Youssfi, A.**, Daly, A. (2025). "Server-Side Chart Generation for Mobile Finance Applications using Matplotlib." *IEEE International Conference on Data Visualization* (In Preparation)

### Technical Reports

1. Spendaura: System Architecture and Implementation (2024)
2. LLM Integration Patterns for Personal Finance Applications (2024)
3. Mobile Data Visualization Best Practices (2024)

### Open Source Contributions

This project demonstrates practical applications of:
- Flask REST API architecture
- Flutter mobile development
- Matplotlib data visualization
- LLM integration in production systems

### Citing This Work

If you use Spendaura in your research or build upon this work, please cite:

```bibtex
@software{spendaura2024,
  author = {Youssfi, Adem and Daly, Aladin},
  title = {Spendaura: AI-Powered Financial Decision Support System},
  year = {2024},
  publisher = {GitHub},
  url = {https://github.com/Ad2m1109/Spendora},
  note = {Mobile application with Flask backend and Matplotlib visualization}
}
```

---

## 👥 Contributors

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/Ad2m1109">
        <img src="https://avatars.githubusercontent.com/u/168112606?v=4" width="100px;" alt=""/>
        <br />
        <sub><b>Adem Youssfi</b></sub>
      </a>
      <br />
      <sub>Lead Developer & Researcher</sub>
      <br />
      <sub>Backend (Flask), AI/ML, Data Visualization</sub>
    </td>
    <td align="center">
      <a href="https://github.com/alaeddinedaly">
        <img src="https://avatars.githubusercontent.com/u/191285956?v=4" width="100px;" alt=""/>
        <br />
        <sub><b>Aladin Daly</b></sub>
      </a>
      <br />
      <sub>Frontend Developer</sub>
      <br />
      <sub>Flutter, Mobile UI/UX</sub>
    </td>
  </tr>
</table>

### Roles & Responsibilities

**Adem Youssfi** - Backend & AI
- Flask API architecture and implementation
- Matplotlib chart generation system
- LLM integration and prompt engineering
- Database design and ORM implementation
- ML model development (forecasting, analysis)
- API documentation and testing

**Aladin Daly** - Frontend & Mobile
- Flutter application development
- UI/UX design and implementation
- State management and data flow
- API integration on mobile side
- Performance optimization
- Cross-platform testing (iOS/Android)

---

## 🙏 Acknowledgments

This research project has been made possible through:

### Technical Frameworks
- **Flask Community**: For the lightweight yet powerful web framework
- **Flutter Team**: For enabling beautiful cross-platform mobile development
- **Matplotlib Contributors**: For the comprehensive visualization library
- **OpenAI**: For providing accessible LLM API services

### Educational Support
- Academic advisors and professors who provided guidance
- University computing resources and infrastructure
- Research methodology and statistical analysis support

### Open Source Community
- Stack Overflow and GitHub communities
- Python and Dart/Flutter package maintainers
- Technical bloggers and tutorial creators

### Inspiration
- **Behavioral Finance Research**: Daniel Kahneman, Richard Thaler
- **FinTech Innovation**: Mint, YNAB, and other modern finance apps
- **Data Visualization**: Edward Tufte's principles of information design

### Beta Testers
- Friends and family who tested early versions
- User feedback that shaped feature development
- Bug reports and improvement suggestions

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### License Summary

- ✅ Commercial use allowed with attribution
- ✅ Modification and distribution permitted
- ✅ Private use allowed
- ❌ No liability or warranty provided

**Note**: For commercial use or integration into proprietary systems, please contact the authors for licensing inquiries.

---

## 📞 Contact & Support

### Project Maintainers

**Adem Youssfi**
- GitHub: [@Ad2m1109](https://github.com/Ad2m1109)
- Email: adem.youssfi@example.com
- Role: Lead Developer, Backend & AI

**Aladin Daly**
- GitHub: [@alaeddinedaly](https://github.com/alaeddinedaly)
- Email: aladin.daly@example.com
- Role: Frontend Developer, Flutter

### Getting Help

- **Issues**: [GitHub Issues](https://github.com/Ad2m1109/Spendora/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Ad2m1109/Spendora/discussions)
- **Documentation**: Check the `/docs` folder (coming soon)
- **Email**: For research collaboration: research@spendaura.dev

### Reporting Bugs

When reporting bugs, please include:
1. Device/OS information
2. Steps to reproduce
3. Expected vs actual behavior
4. Screenshots if applicable
5. Error logs from Flask/Flutter

### Feature Requests

We welcome feature suggestions! Please:
1. Check existing issues first
2. Describe the use case clearly
3. Explain why it would benefit users
4. Provide mockups if possible

---

## 🌟 Project Status & Roadmap

**Current Version**: 1.0.0 Beta  
**Status**: Active Development  
**Last Updated**: December 2024

### Development Milestones

- [x] Core expense tracking functionality
- [x] Flask REST API with full CRUD operations
- [x] Matplotlib chart generation (Pie, Bar, Line)
- [x] Flutter mobile app with Material Design
- [x] LLM-powered financial advisory
- [x] User authentication and authorization
- [x] Database models and relationships
- [ ] Receipt OCR integration (Q1 2025)
- [ ] Multi-currency support (Q1 2025)
- [ ] Budget recommendations engine (Q2 2025)
- [ ] Open Banking API integration (Q2 2025)
- [ ] Investment tracking module (Q3 2025)

### Version History

- **v1.0.0-beta** (Dec 2024): Initial release
  - Basic transaction management
  - Dashboard with Matplotlib charts
  - AI advisor integration
  - User authentication

---

## 🎓 For Academic Review

### Master's Application Context

This project was developed as part of a portfolio for Master's degree applications in:
- **Computer Science** (Artificial Intelligence track)
- **Data Science** and **Machine Learning**
- **Software Engineering** and **Mobile Computing**

### Key Academic Highlights

1. **Research Component**: Investigation of LLM applications in personal finance
2. **Technical Depth**: Full-stack implementation from database to mobile UI
3. **Practical Impact**: Real-world application addressing financial literacy
4. **Innovation**: Novel integration of Matplotlib visualization in mobile apps
5. **Documentation**: Comprehensive technical documentation and code comments

### Skills Demonstrated

- **Backend Development**: Flask, RESTful APIs, database design
- **Frontend Development**: Flutter, Dart, mobile UI/UX
- **Data Science**: Pandas, NumPy, Matplotlib, statistical analysis
- **AI/ML**: LLM integration, prompt engineering, predictive modeling
- **Software Engineering**: Git, testing, documentation, architecture design
- **Problem Solving**: End-to-end solution for complex real-world problem

---

<div align="center">
  <p><strong>Empowering Financial Decisions Through Artificial Intelligence</strong></p>
  <p>Built with ❤️ for Master's Research in AI and Financial Technology</p>
  <br>
  
  **Technology Stack**: Flask 🐍 | Flutter 📱 | Matplotlib 📊 | OpenAI 🤖
  
  <br>
  
  [![GitHub Stars](https://img.shields.io/github/stars/Ad2m1109/Spendora?style=social)](https://github.com/Ad2m1109/Spendora/stargazers)
  [![GitHub Forks](https://img.shields.io/github/forks/Ad2m1109/Spendora?style=social)](https://github.com/Ad2m1109/Spendora/network/members)
  [![Made with Flask](https://img.shields.io/badge/Made%20with-Flask-black)](https://flask.palletsprojects.com/)
  [![Made with Flutter](https://img.shields.io/badge/Made%20with-Flutter-02569B)](https://flutter.dev/)
  
  <br>
  
  *If you find this project helpful, please consider giving it a ⭐ on GitHub!*
</div>

---

## 🔧 Troubleshooting

### Common Issues

**Backend not starting?**
- Check if port 5000 is available
- Ensure all environment variables are set
- Verify Python dependencies are installed

**Flutter build fails?**
- Run `flutter clean` and `flutter pub get`
- Check Flutter and Dart SDK versions
- Ensure all required tools are installed

**Charts not displaying?**
- Verify Matplotlib is properly installed
- Check backend logs for errors
- Ensure API endpoint is correct in Flutter app

**API connection issues?**
- Use correct IP for emulator (10.0.2.2 for Android)
- Check CORS settings in Flask
- Verify network permissions in Flutter

---

**Thank you for your interest in Spendaura! We hope this project demonstrates the potential of AI in improving financial literacy and decision-making.**