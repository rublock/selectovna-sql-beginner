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
