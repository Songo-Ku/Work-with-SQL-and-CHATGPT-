Zadanie 1
Proszę wyświetlić imiona i nazwiska pracowników, którzy pracują w dziale, który znajduje się w budynku o
nazwie 'Budynek A'.

select imie, nazwisko
from pracownicy as p
inner join dzialy as d on p.dzial_id = d.id_dzialu
where d.budynek = "Budynek A"

Zadanie 2
Znajdź wszystkie produkty, których cena jest wyższa niż średnia cena produktów w danej kategorii.

select p.nazwa
from produkty as p
where cena > (
    select avg(p_subquery.cena)
    from produkty as p_subquery
    where p_subquery.kategoria_id = p.kategoria_id
)
group by p.kategoria_id;

Zadanie 3
Wyświetl listę pracowników, którzy nie mają żadnych przypisanych projektów.

select p.imie, p.nazwisko
from pracownicy as p
left join przypisania as pr on p.id = pr.pracownik_id
where pr.projekt_id is null;

4 Proszę wyświetlić imiona i nazwiska pracowników oraz nazwę projektu, nad którym aktualnie pracują,
wraz z datą rozpoczęcia projektu.

select p.imie, p.nazwisko, prj.nazwa, prj.data_rozpoczecia
from pracownicy as p
inner join przypisania as pr on p.id = pr.pracownik_id
inner join projekty as prj on pr.projekt_id = prj.id

5 Znajdź wszystkich pracowników, którzy mają wyższe wynagrodzenie niż średnia pensja w ich dziale.

select p.imie, p.nazwisko
from pracownicy as p
where p.wynagrodzenie > (
    select avg(p_subquery.wynagrodzenie)
    from pracownicy as p_subquery
    where p_subquery.dzial_id = p.dzial_id -- this group data per department
)

6 Proszę wyświetlić wszystkie zamówienia, w których liczba zamówionych produktów jest większa niż średnia liczba
produktów zamówionych we wszystkich zamówieniach.

select z.zamowienie_id, z.data_zamowienia
from zamowienia as z
where z.zamowienie_id in (
    select zam.zamowienie_id,
    count(zam.produkt_id) as liczba_produktow,
    avg(ilosc) as srednia_liczba_produktow
      from zamowienia_produkty as zam
      group by zam.zamowienie_id
      having sum(zam.ilosc) > (
        select avg(sub_zam.ilosc)
        from zamowienia_produkty as sub_zam
      )
);


SELECT zamowienie_id, SUM(ilosc) AS liczba_produktow
FROM zamowienia_produkty
GROUP BY zamowienie_id;


6 Proszę wyświetlić wszystkie zamówienia, w których liczba zamówionych produktów jest większa niż średnia liczba
produktów zamówionych we wszystkich zamówieniach.

