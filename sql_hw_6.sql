USE lesson_4;

/*
Задание 1
Создайте таблицу users_old, аналогичную таблице users. 
Создайте процедуру, с помощью которой можно переместить любого (одного) пользователя
 из таблицы users в таблицу users_old. 
(использование транзакции с выбором commit или rollback – обязательно).
*/

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);

DROP PROCEDURE IF EXISTS sp_user_move_old;
DELIMITER //
CREATE PROCEDURE sp_user_move_old(
id_to_move BIGINT,
OUT  tran_result varchar(100))
BEGIN

DECLARE `_rollback` BIT DEFAULT b'0';

IF id_to_move NOT IN (SELECT id FROM users) OR 
	id_to_move IN (SELECT id FROM users_old) THEN
	SET `_rollback` = b'1';
END IF;

START TRANSACTION;
	 INSERT INTO users_old (id, firstname, lastname, email)
	 SELECT id, firstname, lastname, email
			FROM users
            WHERE id = id_to_move;
	DELETE FROM users WHERE id = id_to_move;

	IF `_rollback` THEN
		SET tran_result = 'Ошибка.';
		ROLLBACK;
	ELSE
		SET tran_result = 'OK';
		COMMIT;
	END IF;
 END//
DELIMITER ; 

CALL sp_user_move_old(1, @tran_result);
SELECT @tran_result;

SELECT * FROM users; -- Проверка
SELECT * FROM users_old; -- Проверка

/*
Задание 2
Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна 
возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать 
фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
*/

SELECT HOUR(NOW()); -- тестим date_part

DROP FUNCTION IF EXISTS hello;

DELIMITER //
CREATE FUNCTION hello()
RETURNS VARCHAR(20) READS SQL DATA 
BEGIN

	DECLARE hour_now INT;
    DECLARE answer VARCHAR(20);
    
    SET hour_now = (SELECT HOUR(NOW()));
    
    IF hour_now IN (0,1,2,3,4,5) THEN
		SET answer = 'Доброй ночи';
	ELSE 
		IF hour_now IN (6,7,8,9,10,11) THEN
			SET answer = 'Доброе утро';
		ELSE 
			IF hour_now IN (12,13,14,15,16,17) THEN
				SET answer = 'Добрый день';
			ELSE 
				SET answer = 'Добрый вечер';
			END IF;
		END IF;
	END IF;
    RETURN answer;
END//
DELIMITER ;

SELECT hello();

/*
Задание 3
(по желанию)* Создайте таблицу logs типа Archive. 
Пусть при каждом создании записи в таблицах users, 
communities и messages в таблицу logs помещается время и дата создания записи, 
название таблицы, идентификатор первичного ключа.
*/

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	time DATETIME DEFAULT NOW(),
    table_name VARCHAR(50),
    prim_key INT
);

DROP TRIGGER IF EXISTS log_add;

DELIMITER //
CREATE TRIGGER log_add AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name , prim_key)
	VALUES ('users', NEW.id);
END//
DELIMITER ;

INSERT INTO users (id, firstname, lastname, email) VALUES 
(1, 'Reuben', 'Nienow', 'arlo50@example.org');
SELECT * FROM users;
SELECT * FROM logs;

-- не смог разобраться как сделать триггер по трём таблицам или объеденить 3 триггера в один
-- как вариант создать 3 триггера по одному для каждой таблицы.

