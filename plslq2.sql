---------PROCEDURES-----------
--1.1- procedure insert pessoa

CREATE or REPLACE procedure reg_pessoa (p_nome_pessoa IN VARCHAR, p_end_pessoa IN VARCHAR) IS

BEGIN
    INSERT into pessoa(id_pessoa, nome, endereco)
                VALUES(s_pessoa.nextval, p_nome_pessoa, p_end_pessoa); 
END;

--1.2- procedure insert animal 
CREATE or REPLACE procedure reg_animal (p_nome_pessoa IN VARCHAR, p_nome_animal IN VARCHAR, p_tamanho IN VARCHAR, raca IN VARCHAR, ) IS


BEGIN
    INSERT into animal(id_animal, nome, tamanho, raca, id_pessoa) 
                VALUES(s_animal.nextval, p_nome_animal, p_tamanho, raca, v_id_pessoa); 
END;

--2- procedure registrar evento de banho/consulta:
CREATE or REPLACE procedure reg_evento(p_id_animal IN NUMBER, p_id_funcionario IN NUMBER, 
                                        p_tosa IN NUMBER, p_id_vet IN NUMBER) IS
    v_animal animal%ROWTYPE;
    v_valor NUMBER;
BEGIN

    SELECT * into v_animal
        FROM animal where id_animal = p_id_animal;

    v_valor := retorna_valb(p_tosa, v_animal.tamanho);
    
    IF p_tosa IS NOT NULL THEN  
        INSERT into banho(data_banho, id_animal, id_funcionario, tosa)
                   VALUES(sysdate, p_id_animal, p_id_funcionario, p_tosa);
    END IF;


    IF p_id_vet IS NOT NULL THEN

        INSERT into consulta(data_consulta, id_consulta, id_animal, id_veterinario)
                    VALUES(sysdate, s_cons.nextval, p_id_animal, p_id_vet);
    END IF;
END;

--3 -- Retorna o nome do funcionário que realizou banho do animal na data x - funcionando
create or replace procedure func_banho (p_nome_animal in varchar2,p_data in varchar2, p_nome_func OUt varchar2) is

begin

select fb.nome
into p_nome_func
from animal a inner join banho b
using (id_animal)
inner join funcionario_banho fb
using (id_funcionario)
where a.nome = p_nome_animal and b.data_banho = p_data and tosa = 1; 
end;

variable nome varchar2(20);
exec func_banho('Lulu','19/05/2022', :nome);
print nome;

-- 4 Mostra nome, endereco e quant de animais de todas as pessoas que têm animais de porte x; - funcionando (com cursor)
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

    EXEC porte_pessoa('M');

---------- FUNÇÔES ------------------

--1->mostra o valor faturado no dia com banho e tosa; - funcionando
create or replace function valor_banho(f_data in varchar2) return number is
t_banho number;
begin
select sum(valor)
into t_banho
from banho
where data_banho = f_data;
return t_banho;
end;

variable total_dia NUMBER;
EXEC :total_dia := valor_banho('19/05/2022');
print total_dia; 


--2-> funcao que aplica preço de acordo com tamanho do cachorro
CREATE or REPLACE function retorna_valb(p_tosa IN NUMBER, p_tamanho IN CHAR) RETURN NUMBER IS
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

exec reg_evento(201, 450, 0, 400);


--3-> funcao que devolve o nome dos funcionarios (com cursor)
CREATE or REPLACE function get_funcionario(p_char IN CHAR) RETURN sys_refcursor IS
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

select get_funcionario('f') from dual;

--4-> total de consultas realizadas por um veterinário em um animal - funcionado
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


variable total_dia NUMBER;
EXEC :total_dia := atendi_animal('Tirry','Guilherme');
print total_dia;


-- TRIGGER -- 

--1-> Não deixa inserir o valor do banho se for menor que o valor definido para cada porte.
create or replace trigger valor_banho
before insert or update of valor, id_animal
on banho
for each row
declare
tam varchar2(2);

begin

select tamanho
into tam
from animal
where id_animal = :new.id_animal;

if UPPER(tam) = 'P' and :new.valor < 50 then 
    RAISE_APPLICATION_ERROR(-20000, 'Valor abaixo');
elsif UPPER(tam) = 'M' and :new.valor < 60 then 
    RAISE_APPLICATION_ERROR(-20000, 'Valor abaixo');
elsif UPPER(tam) = 'G' and :new.valor < 70 then 
    RAISE_APPLICATION_ERROR(-20000, 'Valor abaixo');
end if;
end;

--2-> Não permite inserir tamanho do animal caso não seja P, M ou G
create or replace trigger verifica_tamanho
before insert or update of tamanho
on animal
for each row
begin

    CASE 
    WHEN (UPPER(:new.tamanho) = 'P') or (UPPER(:new.tamanho) = 'M') or (UPPER(:new.tamanho) = 'G') 
    then dbms_output.put_line('tamanho valido');
    else RAISE_APPLICATION_ERROR(-20000, 'Erro');
    end case;
end;



