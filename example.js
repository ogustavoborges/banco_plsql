const oracledb = require('oracledb');


async function run() {

  let connection;

  try {

    connection = await oracledb.getConnection({ user: "user", password: "senha", connectionString: "banco" });

    console.log("Successfully connected to Oracle Database");

    // Create a table

    // await connection.execute(`begin
    //                             execute immediate 'drop table todoitem';
    //                             exception when others then if sqlcode <> -942 then raise; end if;
    //                           end;`);

    // await connection.execute(`create table todoitem (
    //                             id number generated always as identity,
    //                             description varchar2(4000),
    //                             creation_ts timestamp with time zone default current_timestamp,
    //                             done number(1,0),
    //                             primary key (id))`);

    // Insert some data

    // const sql = `insert into todoitem (description, done) values(:1, :2)`;

    // const rows =
    //       [ ["Task 1", 0 ],
    //         ["Task 2", 0 ],
    //         ["Task 3", 1 ],
    //         ["Task 4", 0 ],
    //         ["Task 5", 1 ] ];

    // let result = await connection.executeMany(sql, rows);

    // console.log(result.rowsAffected, "Rows Inserted");

    // connection.commit();

    // Now query the rows back






    // ------------- total de consultas realizadas por um veterinário em um animal -------------

    /*const result = await connection.execute(
      `BEGIN
        :total_dia := atendi_animal(:p1,:p2);
       END;`,
      {
        p1:  'Tirry', // Bind type is determined from the data.  Default direction is BIND_IN,
        p2:'Guilherme', 
        total_dia: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER}
      });

    console.log(result.outBinds);*/
    // ------------------------------------------------------------






    // ------------------ funcao que aplica preço de acordo com tamanho do cachorro -----------
    /* const result = await connection.execute(
     `BEGIN
       :total_dia := retorna_valb(:p1,:p2);
      END;`,
     {
       p1:  0, // Bind type is determined from the data.  Default direction is BIND_IN,
       p2:'P', 
       total_dia: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER}
     });

   console.log(result.outBinds); */
    // -----------------------------------------------------------------






    // --------------------mostra o valor faturado no dia com banho e tosa; -------------
    /*
    const result = await connection.execute(
      `BEGIN
        :total_dia :=  valor_banho(:p1);
       END;`,
      {
        p1: '19/05/2022', // Bind type is determined from the data.  Default direction is BIND_IN, 
        total_dia: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER}
      });

    console.log(result.outBinds); */
    // -----------------------------------------------------------------




    //  Mostra nome, endereco e quant de animais de todas as pessoas que têm animais de porte x; - 

    /*await connection.execute(
    `BEGIN
       DBMS_OUTPUT.ENABLE(NULL); 
     END;`);  //ativa o dbms no banco;


     await connection.execute(
      `BEGIN
        porte_pessoa(:p1);
       END;`,
      {
        p1:  'M' // Bind type is determined from the data.  Default direction is BIND_IN, 

      });

     let result;
  do {
    result = await connection.execute(
      `BEGIN
         DBMS_OUTPUT.GET_LINE(:ln, :st);
       END;`,
      { ln: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 32767 },
        st: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } });
    if (result.outBinds.st === 0)
      console.log(result.outBinds.ln);
  } while (result.outBinds.st === 0);*/

    // -----------------------------------------------------------------


    //Retorna o nome do funcionário que realizou banho do animal na data x
    /*let nome = "Leia"
    const result = await connection.execute(
      `BEGIN
        func_banho(:nome,:p2,:p3);
       END;`,
      {
        nome, // teste com variavel;
        p2:'19/05/2022', 
        p3: { dir: oracledb.BIND_OUT, type: oracledb.STRING},
      });
     
    console.log(result.outBinds);*/

    // -----------------------------------------------------------------





    // funcao que devolve o nome dos funcionarios 
    /*const result = await connection.execute(
      `BEGIN
      :cursor :=get_funcionario(:p1);
       END;`,
      {
        p1: 'F', // teste com variavel;
        cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT }
      });
    
      const resultSet1 = result.outBinds.cursor;
  
      const rows1 = await resultSet1.getRows();  // no parameter means get all rows
      console.log(rows1);
  
      await resultSet1.close(); */
    // -----------------------------------------------------------------




    /*let result;
    result = await connection.execute(`SELECT * FROM animal`, [],
                                    { resultSet: true, outFormat: oracledb.OUT_FORMAT_OBJECT }); */


    // result = await connection.execute(
    //   `select description, done from todoitem`,
    //   [],
    //   { resultSet: true, outFormat: oracledb.OUT_FORMAT_OBJECT });





    /*const rs = result.resultSet;
    let row;

    while ((row = await rs.getRow())) {
      if (row.DONE)
        console.log(row.ID_ANIMAL, "is done");
      else
        console.log(row.ID_ANIMAL);
        console.log(row.NOME);
        console.log(row.RACA, "is NOT done");
    }*/





  } catch (err) {
    console.error(err);
  } finally {
    if (connection) {
      try {
        await connection.close();
      } catch (err) {
        console.error(err);
      }
    }
  }
}

run();