import mysql.connector


def connect_to_db(config):
    """Nawiązuje połączenie z bazą danych"""
    try:
        cnx = mysql.connector.connect(**config)
        return cnx
    except mysql.connector.Error as err:
        print(f"Błąd połączenia: {err}")
        return None