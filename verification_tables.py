import mysql.connector

from utils_connection_to_db.config import CONFIG_DB
from utils_connection_to_db.connection import connect_to_db


# Lista tabel do sprawdzenia
TABLES = ['dzialy', 'pracownicy', 'projekty', 'przypisania',
          'kategorie', 'produkty', 'klienci', 'zamowienia',
          'zamowienia_produkty']

print(CONFIG_DB)


def verify_table_exists(tables):
    cnx = connect_to_db(CONFIG_DB)
    if not cnx:
        return

    try:
        cursor = cnx.cursor()
        for table in tables:
            # Sprawdź liczbę rekordów
            cursor.execute(f"SELECT COUNT(*) FROM {table}")
            count = cursor.fetchone()[0]

            print(f"📊 Tabela '{table}': {count} rekordów")

            # Pokaż przykładowy rekord jeśli istnieją dane
            if count > 0:
                cursor.execute(f"SELECT * FROM {table} LIMIT 1")
                sample = cursor.fetchone()
                print(f"   Przykład: {sample}")
            print()

        cursor.close()
        cnx.close()

    except mysql.connector.Error as err:
        print(f"❌ Błąd: {err}")
        cursor.close()
        cnx.close()


if __name__ == "__main__":
    verify_table_exists(TABLES)


query = """
    select     
"""