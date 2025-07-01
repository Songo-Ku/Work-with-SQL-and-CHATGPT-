import pandas as pd

from utils_connection_to_db.config import CONFIG_DB


def get_data_in_chunks(table_name, chunk_size=50):
    """Pobiera dane w kawałkach aby uniknąć problemów z pamięcią"""

    from utils_connection_to_db.connection import connect_to_db
    cnx = connect_to_db(CONFIG_DB)
    if not cnx:
        return

    # Sprawdź całkowitą liczbę rekordów
    count_query = f"SELECT COUNT(*) FROM {table_name}"
    total_rows = pd.read_sql(count_query, cnx).iloc[0, 0]

    all_data = []

    for offset in range(0, total_rows, chunk_size):
        chunk_query = f"""
        SELECT * FROM {table_name} 
        LIMIT {chunk_size} OFFSET {offset}
        """
        chunk_df = pd.read_sql(chunk_query, cnx)
        all_data.append(chunk_df)
        print(f"Pobrano {offset + len(chunk_df)}/{total_rows} rekordów")

    cnx.close()

    # Połącz wszystkie kawałki
    final_df = pd.concat(all_data, ignore_index=True)
    return final_df