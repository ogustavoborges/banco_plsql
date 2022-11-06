--mínimo de 6 consultas
--4 consultas com no mínimo 3 tabelas
--3 consultas com grupo by e having

--1. quantidade de cachorros de cada tamanho
SELECT tamanho, count(tamanho) 
    FROM animal
    group by tamanho;

--2. nome da pessoa, nome do cachorro e data do ultimo banho
SELECT pessoa.nome, animal.nome, MAX(banho.data_banho)
    from pessoa inner join animal
    on pessoa.id_pessoa = animal.id_pessoa
    inner join banho
    on banho.id_animal = animal.id_animal
    group by pessoa.nome, animal.nome;

--3. id e nome dos animais que fizeram consultas com o veterinario clinico geral 
-->> procedure que checa tanto veterinario (escolhendo que especializaçao) quanto func_banho
SELECT a.id_animal, a.nome, c.data_consulta
    from animal inner join consulta
    on a.id_animal = c.id_animal
    inner join veterinario v
    on c.id_veterinario = v.id_veterinario
    where v.especializacao = 'geral';

SELECT a.id_animal, a.nome, b.data_banho
    from animal a inner join banho b
    on a.id_animal = b.id_animal
    inner join funcionario_banho f
    on b.id_funcionario = f.id_funcionario
    where f.nome = 'Paula';

--4. quant banhos por funcionario
SELECT f.id_funcionario, f.nome as funcionario, count(b.id_funcionario) 
    from funcionario_banho f inner join banho b
    on f.id_funcionario = b.id_funcionario
    where f.id_funcionario = b.id_funcionario
    group by f.id_funcionario, f.nome;

--5. algo com o valor das consultas
    --> inserir um banho e consulta junto

    