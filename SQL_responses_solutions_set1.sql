--Zadanie 1
--Proszę wyświetlić imiona i nazwiska pracowników, którzy pracują w dziale,
-- który znajduje się w budynku o nazwie 'Budynek A'.

select imie, nazwisko
from pracownicy as p
inner join dzialy as d
on p.dzial_id = d.id_dzialu
where d.budynek = "Budynek A"
--------------------------------------------------------------------------------------------------

--Zadanie 2
--Znajdź wszystkie produkty, których cena jest wyższa niż średnia cena produktów
--w danej kategorii.

select p.nazwa
from produkty as p
where cena > (
    select avg(p_subquery.cena)
    from produkty as p_subquery
    where p_subquery.kategoria_id = p.kategoria_id
)
-- usunięto group by bo powodowała błąd
--------------------------------------------------------------------------------------------------

--Zadanie 3
--Wyświetl listę pracowników, którzy nie mają żadnych przypisanych projektów.

select p.imie, p.nazwisko
from pracownicy as p
left join przypisania as pr
on p.id = pr.pracownik_id
where pr.projekt_id is null;
--------------------------------------------------------------------------------------------------

--4 Proszę wyświetlić imiona i nazwiska pracowników oraz nazwę projektu,
--nad którym aktualnie pracują, wraz z datą rozpoczęcia projektu.

select p.imie, p.nazwisko, prj.nazwa, prj.data_rozpoczecia
from pracownicy as p
inner join przypisania as pr on p.id = pr.pracownik_id
inner join projekty as prj on pr.projekt_id = prj.id
--------------------------------------------------------------------------------------------------

--5 Znajdź wszystkich pracowników, którzy mają wyższe wynagrodzenie
--niż średnia pensja w ich dziale.

select p.imie, p.nazwisko
from pracownicy as p
where p.wynagrodzenie > (
    select avg(p_subquery.wynagrodzenie)
    from pracownicy as p_subquery
    where p_subquery.dzial_id = p.dzial_id -- this group data per department
)
--------------------------------------------------------------------------------------------------

--6 Proszę wyświetlić wszystkie zamówienia, w których liczba zamówionych produktów
--jest większa niż średnia liczba produktów zamówionych we wszystkich zamówieniach.

--Please display all orders in which the number of ordered products is
--greater than the average number of products ordered across all orders.
--Use a subquery to calculate the average number of products per order and
--compare it to the number in each order.

select z.id, z.data_zamowienia
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
--------------------------------------------------------------------------------------------------
--7 Wyświetl wszystkie produkty, które zostały zamówione przez co najmniej
--dwóch różnych klientów.
--Display all products that have been ordered by at least two different customers.
--Use an INNER JOIN between the Products, Orders, and Customers tables,
--and then apply GROUP BY with HAVING COUNT(DISTINCT Customers.ID).


select prod.nazwa, prod.id
from produkty as prod
inner join zamowienia_produkty as zam_prod
    on prod.id = zam_prod.pordukt_id
inner join zamowienia as zam
    on zam_prod.zamowienie_id = zam.id
inner join klienci as kli
    on zam.klient_id = kli.id
group by prod.id
having count(distinct kli.id) >= 2;
--------------------------------------------------------------------------------------------------

--8 Proszę znaleźć wszystkich klientów, którzy złożyli zamówienie na produkt o
--nazwie "Laptop", ale nie złożyli zamówienia na produkt "Smartphone".
--8 Please find all customers who have placed an order for the product named
--"Laptop" but have not placed an order for the product "Smartphone".
--Use subqueries in the WHERE clause and NOT EXISTS to check for product orders.

--the best solution I found is with usage of CTE common table expression and it divide into 3 queries one query.
WITH laptop_zamowienia AS (
    SELECT DISTINCT zamowienie_id
    FROM zamowienia_produkty
    INNER JOIN produkty ON zamowienia_produkty.produkt_id = produkty.produkt_id
    WHERE produkty.nazwa = 'Laptop'
),
smartphone_zamowienia AS (
    SELECT DISTINCT zamowienie_id
    FROM zamowienia_produkty
    INNER JOIN produkty ON zamowienia_produkty.produkt_id = produkty.produkt_id
    WHERE produkty.nazwa = 'Smartphone'
)
SELECT DISTINCT k.klient_id
FROM zamowienia AS z
INNER JOIN klienci AS k ON z.klient_id = k.klient_id
INNER JOIN zamowienia_produkty AS zp ON z.zamowienie_id = zp.zamowienie_id
WHERE zp.zamowienie_id IN (SELECT zamowienie_id FROM laptop_zamowienia)
  AND zp.zamowienie_id NOT IN (SELECT zamowienie_id FROM smartphone_zamowienia);


--------------------------------------------------------------------------------------------------

--9. Wyświetl nazwisko pracownika oraz nazwę jego bezpośredniego przełożonego,
--zakładając, że przełożeni są zapisani w tej samej tabeli co pracownicy.
--Użyj SELF JOIN (łączenie tabeli z samą sobą) na tabeli Pracownicy do
--odnalezienia przełożonych.
--
--9 Display the last name of an employee and the name of their direct supervisor,
--assuming supervisors are stored in the same table as employees.
--Use a SELF JOIN (joining the table with itself) on the Employees table to
--find supervisors.

select p.nazwisko, p2.nazwisko as przelozony_nazwisko
from pracownicy as p
left join pracownicy as p2 -- lub inner if we want to avoid employees who dont have supervisor
    on p.przelozony_id= p2.id

--------------------------------------------------------------------------------------------------
--9B "Znajdź pracowników, którzy mają takich samych przełożonych jak
--inni pracownicy, ale w różnych działach."
-- musi sie zgadzac ze dzial jest inny to jeden z warunkow
-- laczenie po przelozony id  w selfjoinie,




select p1.nazwisko, p1.przelozony_id as przelozony_1, p2.przelozony_id as przelozony_2
from pracownicy as p1
inner join pracownicy as p2
    on p1.przelozony_id = p2.przelozony_id
    and p1.dzial_id != p2.dzial_id

-- bez duplikatów a,b; b,a
select p1.nazwisko, p1.przelozony_id as przelozony_1, p2.przelozony_id as przelozony_2,
p1.nazwisko as nazwisko1, p2.nazwisko as nazwisko2
from pracownicy as p1
inner join pracownicy as p2
on p1.przelozony_id = p2.przelozony_id
and p1.dzial_id != p2.dzial_id
and p1.id < p2.id  -- warunek eliminujacy duplikaty


SELECT p1.imie AS pracownik_imie, p1.nazwisko AS pracownik_nazwisko,
       p2.imie AS inny_pracownik_imie, p2.nazwisko AS inny_pracownik_nazwisko,
       p1.dzial_id AS pracownik_dzial, p2.dzial_id AS inny_pracownik_dzial
FROM pracownicy AS p1
INNER JOIN pracownicy AS p2
    ON p1.przełożony_id = p2.przełożony_id  -- Pracownicy mają tego samego przełożonego
    AND p1.dzial_id != p2.dzial_id         -- Ale są w różnych działach
    AND p1.id != p2.id
ORDER BY p1.nazwisko, p2.nazwisko;

--------------------------------------------------------------------------------------------------

--10 Find the average number of products ordered per order in each product category.
--Use an INNER JOIN between the Orders, Products, and Categories tables
--and GROUP BY to calculate the average number of products per
--order in each category.













--after analysis this query for 8. is wrong because it show only records in 1
--order so for only 1 order per user limitation it would be correct
SELECT k.nazwa
FROM klienci AS k
INNER JOIN zamówienia AS z ON k.klient_id = z.klient_id
INNER JOIN zamowienia_produkty AS zp ON z.zamowienie_id = zp.zamowienie_id
INNER JOIN produkty AS p ON zp.produkt_id = p.produkt_id
LEFT JOIN zamowienia_produkty AS zp2 ON zp2.zamowienie_id = z.zamowienie_id
LEFT JOIN produkty AS p2 ON zp2.produkt_id = p2.produkt_id AND p2.nazwa = 'Smartphone'
WHERE p.nazwa = 'Laptop'
AND p2.produkt_id IS NULL
GROUP BY k.nazwa;