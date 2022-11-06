CREATE TABLE animal(
    id_animal NUMBER constraint pk_animal PRIMARY KEY,
    nome VARCHAR(15),
    tamanho CHAR, -- P, M ou G
    raca VARCHAR(16),
    id_pessoa NUMBER
);

CREATE TABLE pessoa (
    id_pessoa NUMBER constraint pk_pessoa PRIMARY KEY,
    nome VARCHAR(30),
    endereco VARCHAR(50)
);

CREATE TABLE veterinario (
    id_veterinario NUMBER PRIMARY KEY,
    nome VARCHAR(30),
    especializacao VARCHAR(15),
    salario NUMBER,
    pr_cons NUMBER
);

CREATE TABLE funcionario_banho (
    id_funcionario NUMBER PRIMARY KEY,
    nome VARCHAR(30),
    salario NUMBER
);

CREATE TABLE banho (
    id_animal NUMBER,
    id_funcionario NUMBER,
    tosa NUMBER,
    data_banho DATE,
    valor NUMBER
);

CREATE TABLE consulta (
    id_consulta NUMBER,
    data_consulta DATE,
    id_animal NUMBER,
    id_veterinario NUMBER,
    valor NUMBER
);

-------------------ALTER
ALTER TABLE animal add( 
    constraint FK_animal_id_pessoa
    FOREIGN KEY (id_pessoa) REFERENCES pessoa
    );

ALTER TABLE banho add(
    constraint FK_banho_id_animal 
    FOREIGN KEY(id_animal) REFERENCES animal (id_animal),
 
    constraint FK_banho_id_funcionario 
    FOREIGN KEY (id_funcionario) REFERENCES funcionario_banho (id_funcionario),

    constraint PK_banho PRIMARY KEY (id_animal, data_banho)
    );

ALTER TABLE consulta add(
    constraint FK_consulta_id_animal 
    FOREIGN KEY (id_animal) REFERENCES animal (id_animal),

    constraint FK_consulta_id_vet
    FOREIGN KEY (id_veterinario) REFERENCES veterinario (id_veterinario),

    constraint PK_consulta PRIMARY KEY (id_consulta)
    );


--------------SEQUENCES
CREATE SEQUENCE s_pessoa start with 100 nocache;

CREATE SEQUENCE s_animal start with 200 nocache;

CREATE SEQUENCE s_vet start with 400 nocache;

CREATE SEQUENCE s_func start with 450 nocache;

CREATE SEQUENCE s_cons start with 500 nocache;

------------------- roda ok ate aqui