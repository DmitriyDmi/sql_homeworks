/*
1. Используя операторы языка SQL,
создайте таблицу “sales”. Заполните ее данными.
*/

DROP TABLE IF EXISTS sales;

CREATE TABLE IF NOT EXISTS sales(
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL,
    order_date DATE NOT NULL,
    count_product INT UNSIGNED
    );

INSERT sales
VALUES 
	('1', '2022-01-01', '156'),
    ('2', '2022-01-02', '180'),
    ('3', '2022-01-03', '21'),
    ('4', '2022-01-04', '124'),
    ('5', '2022-01-05', '341');
    
SELECT * FROM sales;

/*
2. Для данных таблицы “sales” укажите тип
заказа в зависимости от кол-ва :
меньше 100 - Маленький заказ
от 100 до 300 - Средний заказ
больше 300 - Большой заказ
*/

SELECT id,
CASE
	WHEN count_product < 100 THEN 'маленький заказ'
    WHEN 100 <= count_product AND count_product <= 300 THEN 'средний заказ'
    ELSE 'большой заказ'
END AS 'Тип заказа'
FROM sales;

-- вариант с IF
SELECT id, 
IF(count_product < 100, 'маленткий заказ',
	IF(count_product >=100 AND count_product <= 300, 'средний заказ', 'большой заказ'))
AS 'Тип заказа'
FROM sales;

/*
3. Создайте таблицу “orders”, заполните ее значениями. 
Покажите “полный” статус заказа, используя оператор CASE
*/

DROP TABLE IF EXISTS orders;

CREATE TABLE IF NOT EXISTS orders (
    id INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    employee_id VARCHAR(20) NOT NULL,
    amount DECIMAL(8 , 2 ),
    order_status VARCHAR(10)
)  DEFAULT CHARSET = UTF8; -- по умолчанию ставится кодировка latin1 в ВАРЧАР

INSERT orders (
	employee_id, amount, order_status)
VALUES 
	('e03', '15.00', 'OPEN'),
    ('e01', '25.50', 'OPEN'),
    ('e05', '100.70', 'CLOSED'),
    ('e02', '22.18', 'OPEN'),
    ('e04', '9.50', 'CENCELLED');
    
SELECT * FROM orders;

SELECT id, employee_id,
CASE
	WHEN order_status = 'OPEN' THEN 'Order is in open state'
    WHEN order_status = 'CLOSED' THEN 'Order is closed'
    ELSE 'Order is cancelled'
END AS full_order_status
FROM orders;

/*
4. Чем 0 отличается от NULL?

0 - это ноль. Может быть строкой или числом как целым по типу, так и дробным.

NULL - это отсутствие значение как и NaN или же неизвестное значение. 
Может принимать тип NULL.
*/