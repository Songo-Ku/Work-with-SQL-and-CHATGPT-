# Project Name

## Table of Contents
1. [Introduction](#introduction)
2. [Usage](#Usage)
3. [CreateTable](#CreateTable)
4. [WorkWithPython](#WorkWithPython)
5. [Installation_Requirements](#Installation_Requirements)
6. [ValidationGenData](#ValidationGenData)

## Introduction
UPDATED 06-2025
To better quality I created DB, tables, sample data via python script. DB is mysql.
Added instructions how to tables and fill them with data.

General idea why I added this project??
Working with ChatGPT and SQL, I realized that I can use AI to generate SQL queries but main reason
is to show how dangerous AI can be and unexpected errors can occur when we dont expect them.

This show I am able to work with different type of data and sql dialects with CHATGPT.
One of most interesting thing what I realize during my work with chatgpt that you have to be sceptical and 
double check answers. 
his answers and make proper questions to evaluate he gave me correct answer or made mistake. I paste example 
when I had to struggle with chatgpt and mistakes in few answers in row. It shows that person who works with
Chatgpt need to have poper skills: analytical mind, problem solving also being consistent, knowledgeable
familiar with data and sql and overall problems or solutions.

Case with mistakes of chatgpt about generating examples and solution in file:
"exanoke_mistakes_of_chatgpt_and_my_evaluation.txt"

I generated structure of example simple db, then asked for generate easy and advance set of queries.
I also showed in file analysis_chatgpt_task7_set1.txt, analysis_chatgpt_task8_set1.txt  how I can describe sample data by text to chatbgpt, 
how I define question, describe problems, find soultions, ask for help, go through query and divide into steps
to better understand problem or query and how queries work on sample data in imagination before start
to use query on production data and kill DB. It also show I am familiar with DB in at least intermediate lvl
and in some idea, ways in advance. 

I worked with sql in last 4 years (mainly mysql also postgresql) and 
I had first contact in 2018/19 with this language.

## Usage
Open tasks, open sql responses to each set. 

Additionally I pasted case and story to question number 6 from set1 and show problem solve with Chatgpt 
and generation sample data from only description to chagpt. It shows how effectively I can use AI agent
to solve real problems and USE SQL on a daily basis.

For more advance users: 
I prepared steps to create database, tables and fill them with data. Then we can see inputs and outputs.

## CreateTable

CREATE DATABASE firma_db;
USE firma_db;


-- Tabela działy
CREATE TABLE dzialy (
    dzial_id INT PRIMARY KEY AUTO_INCREMENT,
    nazwa VARCHAR(100) NOT NULL,
    budynek VARCHAR(50)
);

-- Tabela pracownicy
CREATE TABLE pracownicy (
    id INT PRIMARY KEY AUTO_INCREMENT,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    dzial_id INT,
    wynagrodzenie DECIMAL(10,2),
    przelozony_id INT,
    FOREIGN KEY (dzial_id) REFERENCES dzialy(dzial_id),
    FOREIGN KEY (przelozony_id) REFERENCES pracownicy(id)
);

-- Tabela projekty
CREATE TABLE projekty (
    projekt_id INT PRIMARY KEY AUTO_INCREMENT,
    nazwa VARCHAR(100) NOT NULL,
    data_rozpoczecia DATE
);

-- Tabela przypisania
CREATE TABLE przypisania (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pracownik_id INT,
    projekt_id INT,
    data_przypisania DATE,
    FOREIGN KEY (pracownik_id) REFERENCES pracownicy(id),
    FOREIGN KEY (projekt_id) REFERENCES projekty(projekt_id)
);

-- Tabela kategorie
CREATE TABLE kategorie (
    kategoria_id INT PRIMARY KEY AUTO_INCREMENT,
    nazwa VARCHAR(100) NOT NULL
);

-- Tabela produkty
CREATE TABLE produkty (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nazwa VARCHAR(100) NOT NULL,
    cena DECIMAL(10,2),
    kategoria_id INT,
    FOREIGN KEY (kategoria_id) REFERENCES kategorie(kategoria_id)
);

-- Tabela klienci
CREATE TABLE klienci (
    klient_id INT PRIMARY KEY AUTO_INCREMENT,
    nazwa VARCHAR(100) NOT NULL
);

-- Tabela zamówienia
CREATE TABLE zamowienia (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_zamowienia DATE,
    klient_id INT,
    FOREIGN KEY (klient_id) REFERENCES klienci(klient_id)
);

-- Tabela zamowienia_produkty
CREATE TABLE zamowienia_produkty (
    zamowienie_id INT,
    produkt_id INT,
    ilosc INT,
    PRIMARY KEY (zamowienie_id, produkt_id),
    FOREIGN KEY (zamowienie_id) REFERENCES zamowienia(id),
    FOREIGN KEY (produkt_id) REFERENCES produkty(id)
);

## WorkWithPython
via pycharm add venv
activate venv:
```
.venv\Scripts\activate
pip install -r requirements.txt
```

run script:
generate_data_to_tables.py


## Installation_Requirements
Install python, mysql8.*
coordinate path to mysql and python in environment variables.

Create DB:

create database company_db
show databases;
Create usera:

CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'test123'; sprawdzenie czy utworzono
select user, host from mysql.user; < powinien wyswietlic sie w tabeli z userami przypisanie praw dla usera do bazy danych
GRANT ALL PRIVILEGES ON company_db.* TO 'app_user'@'localhost' WITH GRANT OPTION; Odświeżenie uprawnień
FLUSH PRIVILEGES; check if user has privileges
SHOW GRANTS FOR 'app_user'@'localhost';


## ValidationGenData
check number of records in each table
```sql
SELECT 'dzialy' as tabela, COUNT(*) as liczba_rekordow FROM dzialy
UNION ALL
SELECT 'pracownicy', COUNT(*) FROM pracownicy
UNION ALL
SELECT 'projekty', COUNT(*) FROM projekty
UNION ALL
SELECT 'przypisania', COUNT(*) FROM przypisania
UNION ALL
SELECT 'kategorie', COUNT(*) FROM kategorie
UNION ALL
SELECT 'produkty', COUNT(*) FROM produkty
UNION ALL
SELECT 'klienci', COUNT(*) FROM klienci
UNION ALL
SELECT 'zamowienia', COUNT(*) FROM zamowienia
UNION ALL
SELECT 'zamowienia_produkty', COUNT(*) FROM zamowienia_produkty;
```

OUTPUT from CMD mysqlsh connected to db:
+---------------------+-----------------+
| tabela              | liczba_rekordow |
+---------------------+-----------------+
| dzialy              |              10 |
| pracownicy          |             300 |
| projekty            |              50 |
| przypisania         |             300 |
| kategorie           |              10 |
| produkty            |             300 |
| klienci             |             100 |
| zamowienia          |             300 |
| zamowienia_produkty |             300 |
+---------------------+-----------------+


-- check first 5 records in each table
```sql
SELECT * FROM dzialy LIMIT 5;
SELECT * FROM pracownicy LIMIT 5;
SELECT * FROM projekty LIMIT 5;
SELECT * FROM przypisania LIMIT 5;
SELECT * FROM kategorie LIMIT 5;
SELECT * FROM produkty LIMIT 5;
SELECT * FROM klienci LIMIT 5;
SELECT * FROM zamowienia LIMIT 5;
SELECT * FROM zamowienia_produkty LIMIT 5;
```

