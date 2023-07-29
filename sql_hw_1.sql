/*
Задание 2. Выведите название, производителя и цену для товаров,
количество которых превышает 2 (SQL - файл, скриншот, либо сам
код)
*/

SELECT Product_name, Manufacturer, Price
FROM phones
WHERE ProductCount> 2;


/*
Задание 3. Выведите весь ассортимент товаров марки “Samsung”
*/

SELECT * 
FROM phones
WHERE Manufacturer = 'Samsung';


/*
Задание 4.*** С помощью регулярных выражений найти:
4.1. Товары, в которых есть упоминание "Iphone"
*/

SELECT *
FROM phones
WHERE Product_name LIKE '%iphone%';


# Задание 4.2. "Samsung"

SELECT *
FROM phones
WHERE Manufacturer LIKE '%samsung%';


# Задание 4.3. Товары, в которых есть ЦИФРЫ

SELECT *
FROM phones
WHERE Product_name RLIKE '[0-9]';


# Задание 4.4. Товары, в которых есть ЦИФРА "8"

SELECT *
FROM phones
WHERE Product_name LIKE '%8%';