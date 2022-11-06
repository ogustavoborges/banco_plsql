insert into pessoa (id_pessoa, nome, endereco)
VALUES(s_pessoa.nextval, 'Marcelle', 'av. aveiro, 44');

insert into pessoa (id_pessoa, nome, endereco)
VALUES(s_pessoa.nextval, 'Lara', 'rua rio grande, 432');

insert into pessoa (id_pessoa, nome, endereco)
VALUES(s_pessoa.nextval, 'Aline', 'rua 3 de abril, 61');

-----------------
-- valores pq tamanho : pequeno, medio, grande (usar numeros?)

insert into animal(id_animal,nome, tamanho, raca, id_pessoa) 
VALUES(s_animal.nextval, 'Leia', 'm', 'vira lata', '100');

insert into animal(id_animal,nome, tamanho, raca, id_pessoa) 
VALUES(s_animal.nextval, 'Teco', 'g', 'collie', '101');

insert into animal(id_animal,nome, tamanho, raca, id_pessoa) 
VALUES(s_animal.nextval, 'Lulu', 'p', 'collie', '102');

insert into animal(id_animal,nome, tamanho, raca, id_pessoa) 
VALUES(s_animal.nextval, 'Tirry', 'M', 'vira lata', '102');

-----------------

insert into funcionario_banho(id_funcionario, nome)
VALUES(s_func.nextval, 'Juliane');

insert into funcionario_banho(id_funcionario, nome)
VALUES(s_func.nextval, 'Paula');

----------------

insert into veterinario (id_veterinario, nome, especializacao)
VALUES(S_VET.nextval, 'Ana', 'geral');

insert into veterinario (id_veterinario, nome, especializacao)
VALUES(S_VET.nextval, 'Guilherme', 'oftalmologista');

----------------

insert into banho(data_banho,id_animal,id_funcionario, tosa, valor)
VALUES(to_date('19/05/22','dd/mm/yy'), 200, 450, 1, 70);

insert into banho(data_banho,id_animal,id_funcionario, tosa, valor)
VALUES(to_date('01/06/22','dd/mm/yy'), 200, 450, 0, 60);

----------------

-- consulta n tem valor
insert into consulta(id_consulta, data_consulta, id_animal, id_veterinario, valor)
VALUES(s_cons.nextval, to_date('02/05/22','dd/mm/yy'),203, 401, 70);

insert into consulta(id_consulta, data_consulta, id_animal, id_veterinario, valor)
VALUES(s_cons.nextval, to_date('03/07/22','dd/mm/yy'),200, 400, 50);

----------------