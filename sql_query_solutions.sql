-- 1
select imie, nazwisko
from pracownicy
inner join działy
on pracownicy.dzial_id = dzialy.id
where dzialy.budynek = 'A'
-- 2

select p.nazwa
from produkty as p
where p.cena > (
    select avg(p_subquery.cena)
    from produkty as p_subquery
    where p_subquery.kategoria_id = p.kategoria_id
)
-- 3
select p.imie, p.nazwisko
from pracownicy as p
left join przypisania as pr
on p.id = pr.pracownik_id
where pr.projekt_id is null;

-- 4
select p.imie, p.nazwisko, proj.nazwa, proj.data_rozpoczecia
from pracownicy as p
inner join przypisania as pr
on p.id = pr.pracownik_id
inner join projekty as proj
on proj.id = pr.projekt_id;

-- 5
select p.imie, p.nazwisko
from pracownicy as p
where p.wynagrodzenie > (
    select avg(sub_p.wynagrodzenie)
    from pracownicy as sub_p
    where p.dzial_id = sub_p.dzial_id
)

-- 6

-- partly soluition to use in where clause
select zam_p.zamowienie_id,
    count(zam_p.produkt_id) as liczba_produktow,
    avg(zam_p.ilosc) as srednia_liczba_produktow
from zamowienia_produkty as zam
group_by zam_p.zamowienie_id
having sum(zam_p.ilosc) > (
    select avg(sub_zam_p.ilosc)
    from zamowienia_produkty as sub_zam
)
--pełna 6
SELECT z.id, z.data_zamowienia
FROM zamowienia AS z
WHERE z.id IN (
    SELECT zp.zamowienie_id
    FROM zamowienia_produkty AS zp
    GROUP BY zp.zamowienie_id
    HAVING COUNT(zp.produkt_id) > (
        SELECT AVG(liczba_produktow_na_zamowienie)
        FROM (
            SELECT COUNT(zp2.produkt_id) AS liczba_produktow_na_zamowienie
            FROM zamowienia_produkty AS zp2
            GROUP BY zp2.zamowienie_id
        ) AS srednie_zamowienia
    )
);
--6A
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
--6B
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
output:
    id_zamowienia  ilosc_produktow  liczba_produktow
0              51             17.0                 2
1              82             14.0                 2
2             166             11.0                 2
3              28             17.0                 2
4             290             21.0                 3
..            ...              ...               ...
83             72             18.0                 2
84             88             18.0                 3
85            129             13.0                 2
86              6             18.0                 4
87             27              9.0                 2

--7
--pierwsza faza samo polaczenie tabel przed filtrami
        query = """
            select p.nazwa, p.id
            from produkty as p
            inner join zamowienia_produkty as zp
            on zp.produkt_id = p.id
            inner join zamowienia as z
            on z.id = zp.zamowienie_id
            inner join klienci as k
            on k.klient_id = z.klient_id
        """

--końcowa wersja
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

--8 opcja 1 z join
select k.id
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
-- 8 opcja 2 z subquery w where

select k.id
from klienci as k
inner join zamowienia as z
on k.klient_id = z.klient_id
inner join zamowienia_produkty as zp
on z.id = zp.zamowienie_id
where p.nazwa in (
    select p2.nazwa
    from produkty as p2
    inner join
)
and k.klient_id not in (
    select distinct k2.klient_id
    from klienci as k2
    inner join zamowienia as z2 on k2.klient_id = z2.klient_id
    inner join zamowienia_produkty as zp2 on z2.id = zp2.zamowienie_id
    inner join produkty as p2 on zp2.produkt_id = p2.id
    where p2.nazwa = 'Smartphone'
)


SELECT DISTINCT k.nazwa
FROM klienci k
INNER JOIN zamowienia z ON k.klient_id = z.klient_id
INNER JOIN zamowienia_produkty zp ON z.id = zp.zamowienie_id
INNER JOIN produkty p ON zp.produkt_id = p.id
WHERE p.nazwa = 'Laptop'
AND k.klient_id NOT IN (
    SELECT z2.klient_id
    FROM zamowienia z2
    INNER JOIN zamowienia_produkty zp2 ON z2.id = zp2.zamowienie_id
    INNER JOIN produkty p2 ON zp2.produkt_id = p2.id
    WHERE p2.nazwa = 'Smartphone'
    AND z2.klient_id IS NOT NULL
);


--# poprawiona z left join
SELECT DISTINCT k.nazwa
FROM klienci AS k
INNER JOIN zamowienia AS z ON k.klient_id = z.klient_id
INNER JOIN zamowienia_produkty AS zp ON z.id = zp.zamowienie_id
INNER JOIN produkty AS p ON zp.produkt_id = p.id
LEFT JOIN (
    SELECT DISTINCT z2.klient_id
    FROM zamowienia z2
    INNER JOIN zamowienia_produkty zp2 ON z2.id = zp2.zamowienie_id
    INNER JOIN produkty p2 ON zp2.produkt_id = p2.id
    WHERE p2.nazwa = 'Smartphone'
) AS smartphone_buyers ON k.klient_id = smartphone_buyers.klient_id
WHERE p.nazwa = 'Laptop'
AND smartphone_buyers.klient_id IS NULL;



select k.klient_id
from klienci as k
inner join zamowienia as z
on k.klient_id = z.klient_id
inner join zamowienia_produkty as zp
on z.id = zp.zamowienie_id
inner join produkty as p
on zp.produkt_id = p.id
where p.nazwa = 'Laptop' and
k.klient_id not in (
    select distinct z2.klient_id
    from zamowienia as z2
    inner join zamowienia_produkty as zp2
    on zp2.zamowienie_id = z2.id
    inner join produkty as p2
    on p2.id = zp2.produkt_id
    where p2.nazwa = 'Smartphone' and
    z2.klient_id is not null
);

--9.
--nazwisko i przelozony




--kod sql musi zawierac rwarunek sprawdzenia samego siebie,
--oraz sprawdzenia czy ktos ma przelozonego

select imie, nazwisko, p2.id as przelozony_id, p2.nazwisko as przelozony_nazwisko
from pracownicy as p1
left join pracownicy as p2
on p2.przelozony_id = p1.id
--where p1.id =! p1.przelozony_id and p1.id = p2.przelozony_id and p1.przelozony_id is not null

select p1.nazwisko, p1.przelozony_id as przelozony_1, p2.przelozony_id as przelozony_2,
p1.nazwisko as nazwisko1, p2.nazwisko as nazwisko2
from pracownicy as p1
inner join pracownicy as p2
on p1.przelozony_id = p2.przelozony_id
and p1.dzial_id != p2.dzial_id
and p1.id < p2.id  -- warunek eliminujacy duplikaty


-- dodatkowo sprawdza jeszcze nazwisko przelozonego i musi wykonac kolejny selfjoin
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

-- 10

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