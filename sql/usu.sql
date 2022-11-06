@D:\mariana\banco2\bd2\plsql-node\sql\create.sql;
@D:\mariana\banco2\bd2\plsql-node\sql\insert.sql;
    
--1. quantidade de cachorros de cada tamanho
SELECT tamanho, count(tamanho) 
    FROM animal
    group by tamanho
    having count(tamanho) > 2;