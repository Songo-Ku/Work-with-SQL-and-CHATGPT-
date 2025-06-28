# Project Name

## Table of Contents
1. [Introduction](#introduction)
2. [Usage](#Usage)
3. [CreateTable](#CreateTable)
4. [WorkWithPython](#WorkWithPython)


## Introduction
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
I had first contact in 2019 with this language




## Usage
Open tasks, open sql responses to each set. 

Additionally I pasted case and story to question number 6 from set1 and show problem solve with Chatgpt 
and generation sample data from only description to chagpt. It shows how effectively I can use AI agent
to solve real problems and USE SQL on a daily basis.

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
.venv\Scripts\activate
pip install -r requirements.txt
run script:
generate_data_to_tables.py
