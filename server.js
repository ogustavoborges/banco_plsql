const express = require("express");
const app = express();
const bodyParser = require("body-parser")
const port = 3000;
const oracledb = require('oracledb');
const { AQ_DEQ_NAV_NEXT_MSG } = require("oracledb");
const defaultpool = {
    user: "usuario",
    password: "senha",
    connectString: "host"
};

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

async function run() {

    let connection = await oracledb.getConnection(defaultpool);
    console.log("Successfully connected to Oracle Database");

}

// função para formatar retorno
function objToString(obj) {
    var str = '';
    for (var p in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, p)) {
            str += obj[p];
        }
    }
    return str;
}


app.use(express.static(__dirname +"/public"));

//Exibe o arquivo hmtl ao abri o localhost
app.get('/', (req, res) => {
    res.sendFile(__dirname + "/index.html")
});



//Nome do funcionario que deu banho no animal na data ------> PROCEDURE
app.post('/funcionario_banho', (req, res) => {
    async function func_banho(animal, data) {
        let connection;
        connection = await oracledb.getConnection(defaultpool);
        try {

            const result = await connection.execute(
                `BEGIN
                  func_banho(:animal,:data,:p3);
                 END;`,
                {
                    animal, // retorno com variavel;
                    data,
                    p3: { dir: oracledb.BIND_OUT, type: oracledb.STRING },
                });
            retorno = result.outBinds;
            console.log(retorno);
            retorno = JSON.stringify(objToString(retorno));
            console.log(result.outBinds);
            res.send("<h1>Funcionario(a): " + retorno.replace(/"/g, '') + "</h1>");
        } catch (error) {
            alert(error);
        }
    }
    func_banho(req.body.animal_func, req.body.data);
});


//Exibe informacoes das pessoas que tem animais de determinado porte ----> PROCEDURE
app.post('/pessoas', (req, res) => {
    async function porte_animal(porte) {
        let connection;
        connection = await oracledb.getConnection(defaultpool);
        try {
            await connection.execute(
                `BEGIN
       DBMS_OUTPUT.ENABLE(NULL); 
     END;`);  //ativa o dbms no banco;


            await connection.execute(
                `BEGIN
        porte_pessoa(:porte);
       END;`,
                {
                    porte 

                });
            let result;
            var nomes = [];
            do {
                result = await connection.execute(
                    `BEGIN
             DBMS_OUTPUT.GET_LINE(:ln, :st);
           END;`,
                    {
                        ln: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 32767 },
                        st: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER }
                    });
                if (result.outBinds.st === 0) {
                    nomes.push(result.outBinds.ln);

                }
            } while (result.outBinds.st === 0);


            nomes.map(nome => res.write("<h1>" + nome + "</h1>"));
            res.end();
            // "<h1>Nomes: " + nomes+ "</h1>"
        } catch (error) {
            alert(error);
        }
    }
    porte_animal(req.body.porte_animal);
});


// Total de atendimentos de um funcionario em um animal ------> FUNÇÃO
app.post('/funcionario_animal', (req, res) => {
    async function atendi_animal(animal, funcionario) {
        let connection;
        connection = await oracledb.getConnection(defaultpool);
        try {
            //chama a procedure/function do banco
            const result = await connection.execute(
                `BEGIN
                    :total_dia := atendi_animal(:animal,:funcionario);
                   END;`,
                {
                    animal,
                    funcionario,
                    total_dia: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER }
                });
            retorno = result.outBinds;
            retorno = JSON.stringify(objToString(retorno));
            console.log(result.outBinds);
            res.send("<h1>Total de consultas realizadas: " + retorno.replace(/"/g, '') + "</h1>");
        } catch (error) {
            alert(error);
        }
    }

    //passa como parametro os valores dos inputs do form
    atendi_animal(req.body.animal, req.body.funcionario_animal);


});

//Nomes dos veterinarios ou funcionarios ----> FUNÇÃO
app.post('/nome_func', (req, res) => {
    async function nome_func(vet_func) {
        let connection;

        connection = await oracledb.getConnection(defaultpool);
        try {

            const result = await connection.execute(
                `BEGIN
                :cursor :=get_funcionario(:vet_func);
                 END;`,
                {
                    vet_func, // retorno com variavel;
                    cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }
                });

            const resultSet1 = result.outBinds.cursor;

            const rows1 = await resultSet1.getRows();  // no parameter means get all rows
            console.log(rows1);

            await resultSet1.close();

            res.send("<h1>Nomes: " + rows1 + "</h1>");
        } catch (error) {
            alert(error);
        }
    }
    nome_func(req.body.vet_func);
});

//Exibe o valor do banho + tosa -------> FUNÇÃO
app.post('/preco_tam', (req, res) => {
    async function valor(tosa,tamanho) {
        let connection;
        tosa = parseInt(tosa);
        connection = await oracledb.getConnection(defaultpool);
        try {

            const result = await connection.execute(
                `BEGIN
                      :total_dia := retorna_valb(:tosa,:tamanho);
                     END;`,
                {
                  tosa,
                   tamanho,
                    total_dia: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER }
                });

            let retorno = JSON.stringify(objToString(result.outBinds));
            res.send("<h1>Valor: R$ " + retorno.replace(/"/g, '') + "</h1>");
        } catch (error) {
            alert(error);
        }
    }
   valor(req.body.tosa, req.body.tamanho);
});

//Valor faturado no dia com banho ----> FUNÇÃO
app.post('/valor_dia', (req, res) => {
    async function valor_dia(data) {
        let connection;
        connection = await oracledb.getConnection(defaultpool);
        try {

            const result = await connection.execute(
                `BEGIN
                    :total_dia := valor_banho(:data);
                     END;`,
                {
                  data,
                    total_dia: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER }
                });
    
            let retorno = JSON.stringify(objToString(result.outBinds));
            res.send("<h1>Total faturado no dia: R$ " + retorno.replace(/"/g, '') + "</h1>");
        } catch (error) {
            alert(error);
        }
    }
   valor_dia(req.body.data);
});


// ---------------- INSERTS ---------------------------------

//Insere pessoa
app.post('/insere_pessoa', (req, res) => {
    async function pessoa(nome, endereco) {
        let connection;

        connection = await oracledb.getConnection(defaultpool);
        try {
           const result = await connection.execute(
                `BEGIN
                          reg_pessoa(:nome,:endereco,:p3);
                         END;`,
                {
                    nome,
                    endereco,
                    p3: { dir: oracledb.BIND_OUT, type: oracledb.STRING}
                });
    
                let retorno = JSON.stringify(objToString(result.outBinds));
                res.send("<h1>" + retorno.replace(/"/g, '') + "</h1>");


        } catch (error) {
            alert(error);
        }
    }

    pessoa(req.body.nome, req.body.endereco);
});


//Insere animal
app.post('/insere_animal', (req, res) => {
    async function animal(nome, id, tam, raca) {
        let connection;

        connection = await oracledb.getConnection(defaultpool);
        try {
           const result =  await connection.execute(
                `BEGIN
            reg_animal(:id,:nome,:tam,:raca,:p3);
             END;`,
                {
                    nome,
                    id,
                    tam,
                    raca,
                    p3: { dir: oracledb.BIND_OUT, type: oracledb.STRING}
                }).catch(err => res.send("<h1>" +  err + "</h1>"));

                let retorno = JSON.stringify(objToString(result.outBinds));
                res.send("<h1>" + retorno.replace(/"/g, '') + "</h1>");
        } catch (error) {
            alert(error);
        }
    }

    animal(req.body.nome_animal, req.body.id_pessoa, req.body.tam, req.body.raca_animal);
});

//Insere animal
app.post('/insere_funcionario', (req, res) => {
    async function funcionario(nome,salario) {
        let connection;
        salario =  parseFloat(salario);
        connection = await oracledb.getConnection(defaultpool);
        try {
           const result =  await connection.execute(
                `BEGIN
                reg_func(:nome,:salario,:p3);
             END;`,
                {
                    nome,
                    salario,
                    p3: { dir: oracledb.BIND_OUT, type: oracledb.STRING}
                }).catch(err => res.send("<h1>" +  err + "</h1>"));

                let retorno = JSON.stringify(objToString(result.outBinds));
                res.send("<h1>" + retorno.replace(/"/g, '') + "</h1>");
        } catch (error) {
            alert(error);
        }
    }

   funcionario(req.body.nome,req.body.salario);
});


app.listen(port, () => {
    console.log('running express');
    run();

});