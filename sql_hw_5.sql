CREATE TABLE cars
(
	id INT NOT NULL PRIMARY KEY,
    name VARCHAR(45),
    cost INT
);

INSERT cars
VALUES
	(1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
	(5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
    
SELECT *
FROM cars;

/*
Задание 1
Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов 
CREATE VIEW CheapCars AS SELECT Name FROM Cars WHERE Cost<25000;
*/

CREATE VIEW CheapCars AS 
SELECT Name 
FROM Cars 
WHERE Cost<25000;

SELECT *
FROM CheapCars;

/*
Задание 2
Изменить в существующем представлении порог для стоимости: 
пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW) 
ALTER VIEW CheapCars AS SELECT Name FROM CarsWHERE Cost<30000;
*/

ALTER VIEW CheapCars AS 
SELECT Name 
FROM Cars 
WHERE Cost<30000;

SELECT *
FROM CheapCars;

/*
Задание 3
Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди” 
*/

CREATE VIEW CheapCars2 AS 
SELECT Name 
FROM Cars 
WHERE name = 'Skoda' OR name = 'Audi';

SELECT *
FROM CheapCars2;

/*
Задание 3*
*/

SELECT *
FROM CheapCars
	JOIN CheapCars2
    USING (name);
    
/*
Добавьте новый столбец под названием «время до следующей станции». Чтобы получить это значение, мы
вычитаем время станций для пар смежных станций. Мы можем вычислить это значение без использования оконной функции SQL, но это может быть очень сложно. Проще это сделать с помощью оконной функции
LEAD . Эта функция сравнивает значения из одной строки со следующей строкой, чтобы получить
результат. В этом случае функция сравнивает значения в столбце «время» для станции со станцией сразу
после нее.
*/

DROP TABLE trains;

CREATE TABLE trains
(
	id INT NOT NULL PRIMARY KEY,
    train_id INTEGER,
	station VARCHAR(20),
    station_time DATETIME
);

INSERT INTO trains
VALUES 
	(1, 110, 'San Francisco', '2023-01-01 10:00:00'),
    (2, 110, 'Redwood City', '2023-01-01 10:54:00'),
    (3, 110, 'Palo Alti', '2023-01-01 11:02:00'),
    (4, 110, 'San Jose', '2023-01-01 12:35:00'),
    (5, 120, 'San Francisco', '2023-01-01 11:00:00'),
    (6, 120, 'Palo Alti', '2023-01-01 12:49:00'),
    (7, 120, 'San Jose', '2023-01-01 13:30:00');
    
SELECT *
FROM trains;

SELECT train_id,
	station,
    TIME(station_time) AS station_time,
    TIMEDIFF(LEAD (station_time) OVER(PARTITION BY train_id ORDER BY station_time),
    station_time) AS time_to_next_station
FROM trains;

/*
Вывести название и цену для всех анализов, которые продавались 5 февраля 2020 
и всю следующую неделю. Есть таблица анализов Analysis: 
an_id — ID анализа; an_name — название анализа; 
an_cost — себестоимость анализа; an_price — розничная цена анализа; 
an_group — группа анализов. Есть таблица групп анализов Groups: gr_id — ID группы; 
gr_name — название группы; gr_temp — температурный режим хранения. 
Есть таблица заказов Orders: ord_id — ID заказа; ord_datetime — дата и время заказа; 
ord_an — ID анализа.
*/

SELECT an_name, an_price
FROM Orders
	LEFT JOIN Analisis
    ON Orders.ord_an = Analisis.an_id
WHERE ord_datetime BETWEEN 2020-02-05 AND 2020-02-13
	


