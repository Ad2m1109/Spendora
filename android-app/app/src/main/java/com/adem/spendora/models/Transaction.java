package com.adem.spendora.models;


import java.util.Date;

public class Transaction {
    private String id;
    private String category;
    private double amount;
    private Date date;

    // Constructor
    public Transaction(String id, String category, double amount, Date date) {
        this.id = id;
        this.category = category;
        this.amount = amount;
        this.date = date;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
}