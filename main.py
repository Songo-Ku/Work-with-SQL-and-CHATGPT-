import mysql.connector
import pandas as pd
from pkg_resources import non_empty_lines

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



    except mysql.connector.Error as err:
        print(f"❌ Błąd: {err}")
        cursor.close()
        cnx.close()


def main_query_execute(CONFIG_DB):
    cnx = connect_to_db(CONFIG_DB)
    if not cnx:
        return

    try:
        # piszemy query















        query = """
            select id
            from zamowienia as z
            where z.id in (
                select zp.zamowienie_id
                from zamowienia_produkty as zp
                group by zp.zamowienie_id
                having count(zp.produkt_id) >  (
                    select avg(liczba_produktow_per_order) as srednia_liczba_produktow
                    from (
                        Select  sub_zp.zamowienie_id, 
                                count(distinct sub_zp.produkt_id) as liczba_produktow_per_order
                        from zamowienia_produkty as sub_zp
                        group by sub_zp.zamowienie_id
                    ) as produkty_na_zamowienie
                )
            )
        """
        # query = 'select count(*) from zamowienia'

        query = """
            select 
                z.id as id_zamowienia,
                (
                    select sum(sub_zp_2.ilosc)
                    from zamowienia_produkty as sub_zp_2
                    where sub_zp_2.zamowienie_id = z.id
                ) as ilosc_produktow,
                (
                    select count(sub_zp_3.produkt_id)
                    from zamowienia_produkty as sub_zp_3
                    where sub_zp_3.zamowienie_id = z.id
                ) as liczba_produktow 
            from zamowienia as z
            where z.id in (
                select zp.zamowienie_id
                from zamowienia_produkty as zp
                group by zp.zamowienie_id
                having count(zp.produkt_id) >  (
                    select avg(liczba_produktow_per_order) as srednia_liczba_produktow
                    from (
                        Select  sub_zp.zamowienie_id, 
                                count(distinct sub_zp.produkt_id) as liczba_produktow_per_order
                        from zamowienia_produkty as sub_zp
                        group by sub_zp.zamowienie_id
                    ) as produkty_na_zamowienie
                )
            )
        """
        query = """
            select
                z.id,
                z.data_zamowienia,
                zp_info.ilosc_produktow,
                zp_info.liczba_produktow
            from zamowienia as z
            inner join (
                select
                    zp.zamowienie_id,
                    sum(zp.ilosc) as ilosc_produktow,
                    count(zp.produkt_id) as liczba_produktow
                from zamowienia_produkty as zp
                group by zp.zamowienie_id
                having count(distinct zp.produkt_id) > (
                    select avg(produkty_na_zamowienie.liczba_produktow_per_order) as srednia_liczba_produktow
                    from (
                        select sub_zp2.zamowienie_id, count(distinct sub_zp2.produkt_id) as liczba_produktow_per_order
                        from zamowienia_produkty as sub_zp2
                        group by sub_zp2.zamowienie_id
                    ) as produkty_na_zamowienie
                )
            ) as zp_info
            on zp_info.zamowienie_id = z.id
        """


        query = """
            select p.nazwa, p.id
            from produkty as p
            inner join zamowienia_produkty as zp
            on zp.produkt_id = p.id
            inner join zamowienia as z
            on z.id = zp.zamowienie_id
            inner join klienci as k
            on k.klient_id = z.klient_id
            group by p.id, p.nazwa
            having count(distinct p.id) >= 2;   
        """
        query = """
            select k.klient_id
            from klienci as k
            inner join zamowienia as z
            on k.klient_id = z.klient_id
            inner join zamowienia_produkty as zp
            on z.id = zp.zamowienie_id
            inner join produkty as p
            on zp.produkt_id = p.id
            where p.nazwa = 'Laptop' 
            and k.klient_id not in (
                select distinct k2.klient_id
                from klienci as k2
                inner join zamowienia as z2 on k2.klient_id = z2.klient_id
                inner join zamowienia_produkty as zp2 on z2.id = zp2.zamowienie_id
                inner join produkty as p2 on zp2.produkt_id = p2.id
                where p2.nazwa = 'Smartphone'
            )
        """

        query = """
            select p1.imie, p1.nazwisko, p1.id as pracownik_id,  p2.id as przelozony_id, p2.nazwisko as przelozony_nazwisko
            from pracownicy as p1
            left join pracownicy as p2
            on p2.id = p1.przelozony_id
        """
        # query = """
        #     select * from pracownicy as p1
        # """

        query = """
            select p1.nazwisko, p1.przelozony_id as przelozony_1, p2.przelozony_id as przelozony_2,
            p1.nazwisko as nazwisko1, p2.nazwisko as nazwisko2
            from pracownicy as p1
            inner join pracownicy as p2
            on p1.przelozony_id = p2.przelozony_id
            and p1.dzial_id != p2.dzial_id
            and p1.id < p2.id  -- warunek eliminujacy duplikaty
        """
        query = """
            select p1.przelozony_id as przelozony_id,
            p1.nazwisko as nazwisko1, p2.nazwisko as nazwisko2, 
            p3.nazwisko as przelozony_nazwisko
            from pracownicy as p1
            inner join pracownicy as p2
            on p1.przelozony_id = p2.przelozony_id
            and p1.dzial_id != p2.dzial_id
            and p1.id < p2.id  -- warunek eliminujacy duplikaty
            inner join pracownicy as p3
            on p3.id = p1.przelozony_id
        """
        query = """
            select k.nazwa as nazwa_kategorii, count(distinct p.nazwa)
            from zamowienia as z
            inner join zamowienia_produkty as zp
            on z.id = zp.zamowienie_id
            inner join produkty as p
            on p.id = zp.produkt_id
            inner join kategorie as k
            on k.kategoria_id = p.kategoria_id
            group by k.nazwa 

        """
        query = """
            SELECT 
                k.nazwa AS kategoria,
                AVG(per_order.total_quantity) AS srednia_ilosc_produktow_na_zamowienie
            FROM (
                SELECT 
                    zp.zamowienie_id,
                    p.kategoria_id,
                    SUM(zp.ilosc) AS total_quantity
                FROM zamowienia_produkty zp
                INNER JOIN zamowienia z ON zp.zamowienie_id = z.id
                INNER JOIN produkty p ON zp.produkt_id = p.id
                GROUP BY zp.zamowienie_id, p.kategoria_id
            ) AS per_order
            INNER JOIN kategorie k ON per_order.kategoria_id = k.kategoria_id
            GROUP BY k.kategoria_id, k.nazwa;
        """











        df = pd.read_sql(query, cnx)
        cnx.close()
        return df

    except mysql.connector.Error as err:
        print(f"❌ Błąd: {err}")
        cnx.close()
        return None



if __name__ == "__main__":
    df = main_query_execute(CONFIG_DB)

    print(df)

