


6A. Proszę wyświetlić wszystkie zamówienia, w których liczba zamówionych produktów jest
większa niż średnia liczba produktów zamówionych we wszystkich zamówieniach.
Użyj podzapytania do obliczenia średniej liczby produktów w zamówieniach
i porównaj je z liczbą produktów w każdym zamówieniu.

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

