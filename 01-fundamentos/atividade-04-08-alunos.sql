create table tb_aluno (

	id_aluno serial,
	tx_nome varchar(255),
	tx_email varchar (255),
	nr_telefone numeric (18,0),

	constraint pk_tb_aluno primary key (id_aluno)

);
	
drop table tb_nota;
	create table tb_professor (

	id_professor serial,
	tx_nome varchar(255),
	tx_email varchar (255),
	nr_telefone numeric (18,0),

	constraint pk_tb_professor primary key (id_professor)
	

);

CREATE TABLE tb_nota (

    id_nota SERIAL,
    vl_nota NUMERIC(4,2),
    cd_aluno INTEGER,
    cd_disciplina INTEGER,

    CONSTRAINT pk_tb_nota
        PRIMARY KEY (id_nota),

    CONSTRAINT fk_tb_nota_cd_aluno
        FOREIGN KEY (cd_aluno)
        REFERENCES tb_aluno(id_aluno),

    CONSTRAINT fk_tb_nota_cd_disciplina
    FOREIGN KEY (cd_disciplina)
    REFERENCES tb_disciplina(id_disciplina)

);

CREATE TABLE tb_disciplina (

    id_disciplina SERIAL,
    tx_nome VARCHAR(255),
    vl_carga_horaria NUMERIC(6,2),
    cd_professor INTEGER,

    CONSTRAINT pk_tb_disciplina
        PRIMARY KEY (id_disciplina),

    CONSTRAINT fk_tb_disciplina_cd_professor
        FOREIGN KEY (cd_professor)
        REFERENCES tb_professor(id_professor)

);