CREATE TABLE tb_usuario (

    id_usuario SERIAL,
    tx_nome VARCHAR(255),
    tx_email VARCHAR(255),
    tx_senha VARCHAR(255),
    cd_tipousuario INTEGER,

    CONSTRAINT pk_tbusuario
        PRIMARY KEY (id_usuario),

    CONSTRAINT fk_tb_usuario_cd_tipousuario
        FOREIGN KEY (cd_tipousuario)
        REFERENCES tb_tipousuario(id_tipousuario)
		
);
CREATE TABLE tb_tipousuario (

    id_tipousuario SERIAL,
    tx_tipousuario VARCHAR(255),

    CONSTRAINT pk_tb_tipousuario
        PRIMARY KEY (id_tipousuario)
		
);


INSERT INTO tb_usuario (
    tx_nome,
    tx_email,
    tx_senha,
    cd_tipousuario
)
VALUES (
    'Samuel',
    'samuel@Gmail.com',
    '123456',
    2
);


INSERT INTO tb_tipousuario (
    tx_tipousuario
)
VALUES
    ('Usuario'),
	('Manutencao'),
    ('Admin'); 


	insert into tb_usuario(
	
	tx_abacaxi

	) 

	
	INSERT INTO tb_usuario (
    tx_nome,
    tx_email,
    tx_senha,
    cd_tipousuario
)
VALUES
    ('Carlos', 'carlos@gmail.com', '123456', 1),
    ('Joao', 'joao@gmail.com', '123456', 1),
    ('Maria', 'maria@gmail.com', '123456', 1),
    ('Ana', 'ana@gmail.com', '123456', 1),
    ('Pedro', 'pedro@gmail.com', '123456', 2),
    ('Lucas', 'lucas@gmail.com', '123456', 2),
    ('Marcos', 'marcos@gmail.com', '123456', 2),
    ('Gabriel', 'gabriel@gmail.com', '123456', 3),
    ('Juliana', 'juliana@gmail.com', '123456', 3);

SELECT *
FROM tb_usuario
	INNER JOIN tb_tipousuario ON
	tb_usuario.cd_tipousuario = 
	tb_tipousuario.id_tipousuario;

