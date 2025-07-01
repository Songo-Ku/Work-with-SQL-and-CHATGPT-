





select id
from zamowienia as z
where z.id in (
    select zp.zamowienie_id
    from zamowienia_produkty as zp
    group by zp.zamowienie_id
    having count(zp.product_id) >  (
        select avg(liczba_produktow_per_order) as srednia_liczba_produktow
        from (
            Select  zamowienie_id, count(distinct zamowienie_id) as liczba_produktow_per_order
            from zamowienia_produkty zp
            group by zamowienie_id
        ) as produkty_na_zamowienie
    )
)


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
        select avg(sub_zp1.liczba_produktow_per_order) as srednia_liczba_produktow
        from (
            select count(sub_zp2.produkt_id) as liczba_produktow_per_order
            from zamowienia_produkty as sub_zp2
            group by sub_zp2.zamowienie_id
        ) as produkty_na_zamowienie
    )
) as zp_info
on zp_info.zamowienie_id = z.id









--wyświetlić wszystkie produkty
--produkty zamowione przez minimum 2 różnych klientow,
-- czyli produkty, które mają co najmniej 2 unikalne zamówienia
--tabele: produkty, zamowienia_produkty, zamowienia, klienci

select p.nazwa, p.id
from produkty as p
inner join zamowienia_produkty as zp
on zp.produkt_id = p.id
inner join zamowienia as z
on z.id = zp.zamowienia_id
inner join klienci as k
on k.id = z.klient_id


-- produkty z zamowienia_produkty
-- zamowienia_produkty z zamowienia
-- zamowienia z klientami


--zapytanie o klientow polaczone z produktami
-- w subqueryt where uzyc zapytanie zwracajace zamowienia bez smartphone
-- w tym where zalaczyc tylko tych bez zmartfone
-- jesli juz mamy zamowienia ktore zawieraja laptopy to zwrocic tylko klienta id i nazwe


--klient ma tylko id, wiec polaczyc z zamowienia, zamowienia potem potem polaczyc z ZM
--wtedy uzyc where clause gdzie zapytac o zamowienia ktore nie maja tego jednego produktu

select
from klienci as k
inner join zamowienia as z
on k.klient_id = z.klient_id
inner join zamowienia_produkty as zp
on z.id = zp.zamowienie_id
where zp.produkt_id = (
    select id from produkty where nazwa = 'Laptop'
)


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



-- znajdz srednia dla kazdej kategorii wczesniej trzeba miec opcje uzycia distinct()


select z.id as zamowienie_id, p.nazwa as nazwa_produktu, k.nazwa as nazwa_kategorii
from zamowienia as z
inner join zamowienia_produkty as zp
on z.id = zp.zamowienie_id
inner join produkty as p
on p.id = zp.produkt_id
inner join kategorie as k
on k.kategoria_id = p.kategoria_id
group by k.kategoria_id

-- orders products categories.

select sub.kategoria_id, avg(sub.)
from (
    select k.kategoria_id as kategoria_id, count(p.id) as number_
    from zamowienia as z
    inner join zamowienia_produkty as zp
    on z.id = zp.zamowienie_id
    inner join produkty as p
    on p.id = zp.produkt_id
    inner join kategorie as k
    on k.kategoria_id = p.kategoria_id
    group by k.kategoria_id
) as sub






