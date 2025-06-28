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

--select z.id as zamowienie_id,
--from zamowienia as z
--where z.id in (
--
--)

select zam_p.zamowienie_id,
    count(zam_p.produkt_id) as liczba_produktow,
    avg(zam_p.ilosc) as srednia_liczba_produktow
from zamowienia_produkty as zam
group_by zam_p.zamowienie_id
having sum(zam_p.ilosc) > (
    select avg(sub_zam_p.ilosc)
    from zamowienia_produkty as sub_zam
)








select z.zamowienie_id, z.data_zamowienia
from zamowienia as z
where z.zamowienie_id in (
    select zam.zamowienie_id,
        count(zam.produkt_id) as liczba_produktow,
        avg(zam.ilosc) as srednia_liczba_produktow
      from zamowienia_produkty as zam
      group by zam.zamowienie_id
      having sum(zam.ilosc) > (
        select avg(sub_zam.ilosc)
        from zamowienia_produkty as sub_zam
      )
);


SELECT zamowienie_id, data_zamowienia
FROM zamowienia
WHERE zamowienie_id IN (
    SELECT zamowienie_id
    FROM zamowienia_produkty
    GROUP BY zamowienie_id
    HAVING COUNT(produkt_id) > (  -- liczba produktów
        SELECT AVG(liczba_produktow_na_zamowienie)  -- średnia liczba produktów
        FROM (subquery obliczające liczbę produktów dla każdego zamówienia)
    )
);

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





10 wyswietlw szystkie zamowienia  efekt koncowy

9 ustalic liczbe wszystkich produktow dla zamowienia
8 ustalic srednia liczbe zamowionych produktow we wszystkich zamowieniach.
7 sprawdzic warunek dla zamowienia









