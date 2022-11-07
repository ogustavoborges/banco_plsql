select * from funcionario_banho;
select * from pessoa;

select * from veterinario;
select * from banho;
select * from consulta;
select * from veterinario;
select * from animal;

---- INSERE ANIMAL
create or replace procedure reg_animal (v_id_pessoa IN NUMBER, p_nome_animal IN VARCHAR2, p_tamanho IN VARCHAR2, raca IN VARCHAR2, status OUT VARCHAR2) IS


BEGIN
    INSERT into animal(id_animal, nome, tamanho, raca, id_pessoa) 
                VALUES(s_animal.nextval, p_nome_animal, p_tamanho, raca, v_id_pessoa); 
                commit;

            status:= 'Animal inserido com sucesso!';
END;

variable insere varchar2(100);
exec reg_animal(100,'Sol','P','Labrador',:insere);
print insere;
select * from pessoa;
select * from animal;

------ INSERE PESSOA
create or replace procedure reg_pessoa (p_nome_pessoa IN VARCHAR2, p_end_pessoa IN VARCHAR2, status OUT VARCHAR2) IS

BEGIN
    INSERT into pessoa(id_pessoa, nome, endereco)
                VALUES(s_pessoa.nextval, p_nome_pessoa, p_end_pessoa); 
commit;
    status:= 'Pessoa inserida com sucesso!';
END;
commit;

variable insere varchar2(100);
exec reg_pessoa('Kawana','Av. Japão, 777 ',:insere);
print insere;
select * from pessoa;


----- INSERE FUNCIONÁRIO
create or replace procedure reg_func(p_nome_func IN VARCHAR2, p_salario IN NUMBER, status OUT VARCHAR2) IS

BEGIN
    INSERT into funcionario_banho(id_funcionario, nome,salario)
                VALUES(s_func.nextval, p_nome_func,  p_salario); 
    commit;
    status:= 'Funcionário(a) inserido(a) com sucesso!';
END;


variable insere varchar2(100);
exec reg_func('Mariana','2100',:insere);
print insere;
select * from funcionario_banho;


----- PROCEDURES

--- Exibe infos de todas as pessoas que possuem animais com determinado porte
create or replace procedure porte_pessoa(p_tam in varchar2) is
tam varchar2(2);
cursor p_info is
select p.nome,p.endereco, count(p.id_pessoa) as animais
from pessoa p inner join animal a
on p.id_pessoa = a.id_pessoa
where UPPER(a.tamanho) = UPPER(tam)
group by  p.nome,p.endereco;
begin

tam := p_tam;
FOR r_pessoa IN p_info LOOP
 DBMS_OUTPUT.PUT_LINE('Nome: '||r_pessoa.nome||' | '||' Endereço: '|| r_pessoa.endereco||' | '|| '  Animais: '||r_pessoa.animais);
END LOOP; 
end;

set serveroutput on;
exec porte_pessoa('P');

--- Exibe o nome do funcionário que deu banho no animal na data x
create or replace procedure func_banho (p_nome_animal in varchar2,p_data in varchar2, p_nome_func OUt varchar2) is

begin

select fb.nome
into p_nome_func
from animal a inner join banho b
using (id_animal)
inner join funcionario_banho fb
using (id_funcionario)
where a.nome = p_nome_animal and b.data_banho = p_data; 
end;

variable insere varchar2(100);
exec func_banho('Leia','19/05/2022',:insere);
print insere;
select * from banho;
select * from animal;
select * from funcionario_banho;

CREATE or REPLACE procedure reg_evento(p_id_animal IN NUMBER, p_id_funcionario IN NUMBER, 
                                        p_tosa IN NUMBER, p_id_vet IN NUMBER) IS
    v_animal animal%ROWTYPE;
    v_valor NUMBER;
    
BEGIN

    SELECT * 
    into v_animal
    FROM animal where id_animal = p_id_animal;

    v_valor := retorna_valb(p_tosa, v_animal.tamanho);
    
    IF p_tosa IS NOT NULL THEN 
            v_valor := retorna_valb(p_tosa, v_animal.tamanho);
        INSERT into banho(data_banho, id_animal, id_funcionario, tosa, valor)
                   VALUES(sysdate, p_id_animal, p_id_funcionario, p_tosa,v_valor);
    END IF;


    IF p_id_vet IS NOT NULL THEN

        INSERT into consulta(data_consulta, id_consulta, id_animal, id_veterinario)
                    VALUES(sysdate, s_cons.nextval, p_id_animal, p_id_vet);
    END IF;
END;


variable insere varchar2(100);
exec  reg_evento(205,456,0,null);
print insere;
select * from banho;
select * from animal;
select * from funcionario_banho;

--- FUNÇÕES

-- Valor do banho e tosa conforme porte
create or replace function retorna_valb(p_tosa IN NUMBER, p_tamanho IN CHAR) RETURN NUMBER IS
    v_valor NUMBER;
BEGIN
        CASE
            WHEN UPPER(p_tamanho) = 'P' THEN v_valor := 50;
            WHEN UPPER(p_tamanho) = 'M' THEN v_valor := 60;
            WHEN UPPER(p_tamanho) = 'G' THEN v_valor := 70;
        END CASE;

        IF p_tosa = 1 THEN v_valor := v_valor+20; END IF;

    return v_valor;
END;

select retorna_valb(1,'P') from dual;

----- Retorna nome dos funcionários ou veterinários
create or replace function get_funcionario(p_char IN CHAR) RETURN sys_refcursor IS
    rf_cur sys_refcursor;
    v_table varchar(20);
BEGIN

    IF UPPER(p_char) = 'V' THEN
        open rf_cur FOR
        SELECT nome from veterinario
        order by nome;
    END IF;

    IF UPPER(p_char) = 'F' THEN
        open rf_cur FOR
        SELECT nome from funcionario_banho
        order by nome;
    END IF;
    return rf_cur;
END;

select get_funcionario('F') from dual;

------ Quantidade de consultas por animal
create or replace function atendi_animal (p_nome_animal in varchar2, p_nome_vet varchar2)
    return number 
    is
t_consulta number;
begin

select count(id_consulta)
into t_consulta
from consulta c inner join animal a
using (id_animal)
inner join veterinario v
using (id_veterinario)
where a.nome = p_nome_animal and v.nome = p_nome_vet; 
return t_consulta;
end;

select atendi_animal('Tirry','Guilherme') from dual;
select * from consulta;
select * from veterinario;
select * from animal;

--- Valor faturado no dia com banhos e tosas
create or replace function valor_banho(f_data in varchar2) return number is
t_banho number;
begin
select sum(valor)
into t_banho
from banho
where data_banho = f_data;
return t_banho;
end;

select valor_banho('19/05/2022') from dual;
select * from banho;


----- TRIGGERS
create or replace trigger verifica_tamanho
before insert or update of tamanho
on animal
for each row
begin

    CASE 
    WHEN (UPPER(:new.tamanho) = 'P') or (UPPER(:new.tamanho) = 'M') or (UPPER(:new.tamanho) = 'G') 
    then dbms_output.put_line('tamanho valido');
    else RAISE_APPLICATION_ERROR(-20000, 'Erro - Tamanho inválido ');
    end case;
end;

create or replace trigger sal_func
BEFORE
INSERT OR UPDATE OF salario
on funcionario_banho
for each row
DECLARE
BEGIN
    if :new.salario < 1500 or :new.salario > 2500 then
     RAISE_APPLICATION_ERROR(-20601,'Salário inválido.');
    end if;
End;





