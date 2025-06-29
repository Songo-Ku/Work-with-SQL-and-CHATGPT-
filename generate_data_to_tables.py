import mysql.connector
from faker import Faker
import random
from datetime import datetime, timedelta

# Konfiguracja połączenia
config = {
    'user': 'app_user',
    'password': 'test123',
    'host': 'localhost',
    'database': 'company_db'
}

fake = Faker('pl_PL')  # Polski faker


def connect_to_db():
    """Nawiązuje połączenie z bazą danych"""
    try:
        cnx = mysql.connector.connect(**config)
        return cnx
    except mysql.connector.Error as err:
        print(f"Błąd połączenia: {err}")
        return None


def generate_dzialy(cursor, count=10):
    """Generuje działy"""
    dzialy_names = ['IT', 'HR', 'Finanse', 'Marketing', 'Sprzedaż', 'Produkcja',
                    'Logistyka', 'R&D', 'Obsługa Klienta', 'Administracja']
    budynki = ['A', 'B', 'C', 'D', 'E']

    sql = "INSERT INTO dzialy (nazwa, budynek) VALUES (%s, %s)"
    data = [(name, random.choice(budynki)) for name in dzialy_names[:count]]

    cursor.executemany(sql, data)
    print(f"Wygenerowano {count} działów")


def generate_pracownicy(cursor, count=300):
    """Generuje pracowników"""
    # Pobierz istniejące działy
    cursor.execute("SELECT dzial_id FROM dzialy")
    dzial_ids = [row[0] for row in cursor.fetchall()]

    sql = "INSERT INTO pracownicy (imie, nazwisko, dzial_id, wynagrodzenie, przelozony_id) VALUES (%s, %s, %s, %s, %s)"
    data = []

    for i in range(count):
        imie = fake.first_name()
        nazwisko = fake.last_name()
        dzial_id = random.choice(dzial_ids)
        wynagrodzenie = round(random.uniform(3000, 15000), 2)
        # 20% szans na przełożonego (jeśli już istnieją pracownicy)
        przelozony_id = random.randint(1, max(1, i)) if i > 0 and random.random() < 0.2 else None

        data.append((imie, nazwisko, dzial_id, wynagrodzenie, przelozony_id))

    cursor.executemany(sql, data)
    print(f"Wygenerowano {count} pracowników")


def generate_projekty(cursor, count=50):
    """Generuje projekty"""
    sql = "INSERT INTO projekty (nazwa, data_rozpoczecia) VALUES (%s, %s)"
    data = []

    for _ in range(count):
        nazwa = f"Projekt {fake.company()}"
        data_rozpoczecia = fake.date_between(start_date='-2y', end_date='today')
        data.append((nazwa, data_rozpoczecia))

    cursor.executemany(sql, data)
    print(f"Wygenerowano {count} projektów")


def generate_przypisania(cursor, count=300):
    """Generuje przypisania pracowników do projektów"""
    # Pobierz istniejących pracowników i projekty
    cursor.execute("SELECT id FROM pracownicy")
    pracownik_ids = [row[0] for row in cursor.fetchall()]

    cursor.execute("SELECT projekt_id FROM projekty")
    projekt_ids = [row[0] for row in cursor.fetchall()]

    sql = "INSERT INTO przypisania (pracownik_id, projekt_id, data_przypisania) VALUES (%s, %s, %s)"
    data = []

    for _ in range(count):
        pracownik_id = random.choice(pracownik_ids)
        projekt_id = random.choice(projekt_ids)
        data_przypisania = fake.date_between(start_date='-1y', end_date='today')
        data.append((pracownik_id, projekt_id, data_przypisania))

    cursor.executemany(sql, data)
    print(f"Wygenerowano {count} przypisań")


def generate_kategorie(cursor):
    """Generuje kategorie produktów"""
    kategorie_names = ['Elektronika', 'Odzież', 'Dom i Ogród', 'Sport', 'Książki',
                       'Motoryzacja', 'Zdrowie', 'Zabawki', 'Biuro', 'Jedzenie']

    sql = "INSERT INTO kategorie (nazwa) VALUES (%s)"
    data = [(name,) for name in kategorie_names]

    cursor.executemany(sql, data)
    print(f"Wygenerowano {len(kategorie_names)} kategorii")


def generate_produkty(cursor, count=300):
    """Generuje produkty"""
    cursor.execute("SELECT kategoria_id FROM kategorie")
    kategoria_ids = [row[0] for row in cursor.fetchall()]

    sql = "INSERT INTO produkty (nazwa, cena, kategoria_id) VALUES (%s, %s, %s)"
    data = []

    for _ in range(count):
        nazwa = fake.catch_phrase()
        cena = round(random.uniform(10, 1000), 2)
        kategoria_id = random.choice(kategoria_ids)
        data.append((nazwa, cena, kategoria_id))

    cursor.executemany(sql, data)
    print(f"Wygenerowano {count} produktów")


def generate_klienci(cursor, count=100):
    """Generuje klientów"""
    sql = "INSERT INTO klienci (nazwa) VALUES (%s)"
    data = [(fake.company(),) for _ in range(count)]

    cursor.executemany(sql, data)
    print(f"Wygenerowano {count} klientów")


def generate_zamowienia(cursor, count=300):
    """Generuje zamówienia"""
    cursor.execute("SELECT klient_id FROM klienci")
    klient_ids = [row[0] for row in cursor.fetchall()]

    sql = "INSERT INTO zamowienia (data_zamowienia, klient_id) VALUES (%s, %s)"
    data = []

    for _ in range(count):
        data_zamowienia = fake.date_between(start_date='-1y', end_date='today')
        klient_id = random.choice(klient_ids)
        data.append((data_zamowienia, klient_id))

    cursor.executemany(sql, data)
    print(f"Wygenerowano {count} zamówień")


def generate_zamowienia_produkty(cursor, count=300):
    """Generuje pozycje zamówień"""
    cursor.execute("SELECT id FROM zamowienia")
    zamowienie_ids = [row[0] for row in cursor.fetchall()]

    cursor.execute("SELECT id FROM produkty")
    produkt_ids = [row[0] for row in cursor.fetchall()]

    sql = "INSERT INTO zamowienia_produkty (zamowienie_id, produkt_id, ilosc) VALUES (%s, %s, %s)"
    data = []

    for _ in range(count):
        zamowienie_id = random.choice(zamowienie_ids)
        produkt_id = random.choice(produkt_ids)
        ilosc = random.randint(1, 10)
        data.append((zamowienie_id, produkt_id, ilosc))

    cursor.executemany(sql, data)
    print(f"Wygenerowano {count} pozycji zamówień")


def main():
    """Główna funkcja generująca wszystkie dane"""
    cnx = connect_to_db()
    if not cnx:
        return

    cursor = cnx.cursor()

    try:
        print("Rozpoczynam generowanie danych...")

        # Generuj dane w odpowiedniej kolejności (ze względu na klucze obce)
        generate_dzialy(cursor, 10)
        cnx.commit()

        generate_pracownicy(cursor, 300)
        cnx.commit()

        generate_projekty(cursor, 50)
        cnx.commit()

        generate_przypisania(cursor, 300)
        cnx.commit()

        generate_kategorie(cursor)
        cnx.commit()

        generate_produkty(cursor, 300)
        cnx.commit()

        generate_klienci(cursor, 100)
        cnx.commit()

        generate_zamowienia(cursor, 300)
        cnx.commit()

        generate_zamowienia_produkty(cursor, 300)
        cnx.commit()

        print("✅ Wszystkie dane zostały wygenerowane pomyślnie!")

    except mysql.connector.Error as err:
        print(f"Błąd: {err}")
        cnx.rollback()

    finally:
        cursor.close()
        cnx.close()


if __name__ == "__main__":
    main()