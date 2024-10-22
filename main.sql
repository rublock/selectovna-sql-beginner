drop database if exists library;
create database library;
use library;

drop table if exists readers;
create table readers (
	READER_NUM integer AUTO_INCREMENT primary key COMMENT 'Номер читательского билета',
    READER_NAME VARCHAR(100) COMMENT 'ФИО',
    READER_ADRESS VARCHAR(100) COMMENT 'Адрес',
    READER_PHONE VARCHAR(100) not null COMMENT 'Телефон'
);

drop table if exists books;
create table books (
	BOOK_NUM integer AUTO_INCREMENT primary key COMMENT 'Шифр',
    BOOK_AUTHOR VARCHAR(100) COMMENT 'Автор',
    BOOK_NAME VARCHAR(100) COMMENT 'Название книги',
    BOOK_COUNT integer not null default 0 COMMENT 'Количество экземпляров'
);

drop table if exists books_in_use;
create table books_in_use (
	READER_NUM integer COMMENT 'Номер читательского билета',
    BOOK_NUM integer COMMENT 'Шифр книги',
    ISSUE_DATE DATE COMMENT 'Дата выдачи',
    RETURN_DATE DATE COMMENT 'Дата возврата',
    RETURN_PERIOD TINYINT NOT NULL DEFAULT 14 COMMENT 'Срок возврата, дни',
    FINE_AMOUNT decimal(10,2) NOT NULL DEFAULT 0 COMMENT 'Штраф',
    PRIMARY KEY (READER_NUM, BOOK_NUM, ISSUE_DATE),
    FOREIGN KEY (READER_NUM) REFERENCES readers(READER_NUM),
    FOREIGN KEY (BOOK_NUM) REFERENCES books(BOOK_NUM)
);

insert into readers (reader_name, reader_adress, reader_phone)
values
('Сидоров', 'ул. Ленина, 5а', '4424556'),
('Ванюшкин', 'ул. Космонавтов, д. 31, кв. 143', '4545222'),
('Дроздов', 'ул. Ленина, д. 3, кв. 13', '8955454'),
('Голубева', 'ул. Тимирязева, д. 35, кв. 18', '5454555'),
('Шишкин', 'ул. Революции, д. 16/7, кв. 45', '454564564'),
('Книголюбова', 'ул. Пушкина, д. 38', '54664545'),
('Петров', 'ул. Пушкина, д. 31, кв. 16', '6115646'),
('Паринова', null, '46488484'),
('Птичкина', 'ул. Зеленая, д. 3/7', '65545445'),
('Дроздов', 'ул. Конструкторов, д. 89, кв. 14', '546544');

insert into books (book_author, book_name, book_count)
values
('Толстой', 'Война и мир', 15),
('Достоевский', 'Идиот', 13),
('Пушкин', 'Евгений Онегин', 18),
('Пушкин', 'Руслан и Людмила', 5),
('Пушкин', 'Медный всадник', 11),
('Барто', 'Стихи детям', 1),
('Чехов', 'Вишневый сад', 8),
('Чехов', 'Дядя Ваня', 7),
('Тургенев', 'Отцы и дети', 13),
('Тургенев', 'Муму', 4);

insert into books_in_use (reader_num, book_num, issue_date, return_date)
values
(1, 1, '2023-09-15', '2023-10-17'),
(1, 8, '2023-10-17', null),
(2, 1, '2023-10-04', '2023-10-16'),
(3, 2, '2023-09-11', '2023-09-30'),
(3, 4, '2023-09-11', '2023-09-30'),
(3, 5, '2023-09-11', '2023-09-30'),
(4, 1, '2023-09-28', '2023-10-05'),
(4, 3, '2023-09-28', '2023-10-05'),
(4, 8, '2023-10-05', '2023-10-31'),
(5, 6, '2023-09-14', '2023-10-14'),
(6, 1, '2023-09-09', '2023-09-20'),
(6, 1, '2023-09-20', '2023-10-01'),
(7, 1, '2023-09-13', '2023-09-21'),
(7, 7, '2023-09-21', '2023-10-20'),
(8, 7, '2023-09-11', null);

-- Количество дней просрочки определяется как разница между Датой возврата книги и Датой выдачи
-- Если дата возврата не заполнена, значит книга еще в использовании, штраф не начисляем
update books_in_use set FINE_AMOUNT = (DATEDIFF(RETURN_DATE, ISSUE_DATE) - 14) * 8.45
where RETURN_DATE is not null and DATEDIFF(RETURN_DATE, ISSUE_DATE) > 14;

-- Конкатенация строк и переменных
select BOOK_AUTHOR, CONCAT(BOOK_NAME, CONCAT(' (', book_count, ')')) AS book_name from books;

-- Округление числа до двух знаков после запятой
select round(AVG(FINE_AMOUNT), 2) as avg_fine_amount from books_in_use;

-- Поиск минимального числа с условием
select MIN(FINE_AMOUNT) as min_fine_amount from books_in_use
where FINE_AMOUNT > 0;

-- Сортировка после выборки
SELECT book_author, COUNT(book_name) AS books_count
FROM books
GROUP BY book_author
HAVING books_count = 1;

-- Ограничение выборки
SELECT * from books
ORDER BY book_count DESC
LIMIT 3;
