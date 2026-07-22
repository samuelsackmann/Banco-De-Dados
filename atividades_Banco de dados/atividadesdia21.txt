CREATE TABLE tb_usuario (
    id_usuario       SERIAL PRIMARY KEY,
    tx_nome          VARCHAR(50) NOT NULL,
    tx_cpf           VARCHAR(11) NOT NULL,
    tx_telefone      VARCHAR(15) NOT NULL,
    tx_email         VARCHAR(50) NOT NULL UNIQUE,
    tx_login         VARCHAR(50) NOT NULL,
    tx_senha         VARCHAR(50) NOT NULL,
    tx_nomeempresa   VARCHAR(50) NOT NULL,
    tx_cnpj          VARCHAR(14) NOT NULL,
    tx_localizacao   VARCHAR(50) NOT NULL,
    tx_endereco      VARCHAR(50) NOT NULL,
    cd_tipousuario   INTEGER NOT NULL REFERENCES cd_tipousuario(cd_tipousuario) DEFAULT 1
);
-----------------------------------------------------------------------------------
INSERT INTO tb_usuario (
    tx_nome, tx_cpf, tx_telefone, tx_email, tx_login, tx_senha,
    tx_nomeempresa, tx_cnpj, tx_localizacao, tx_endereco
) VALUES (
    'admin', '12345678900', '49999999999', 'admin@email.com', 'admin', 'admin',
    'Empresa Teste', '12345678000199', 'teste', 'Rua Exemplo, 123'
);
-----------------------------------------------------------------------------------
CREATE TABLE tb_ordemservico (
    id_ordem_servico   SERIAL PRIMARY KEY,
    cd_usuario         INTEGER NOT NULL REFERENCES tb_usuario(id_usuario),
    cd_status          INTEGER NOT NULL REFERENCES tb_status(id_status) DEFAULT 1,
    tx_titulo          VARCHAR(100) NOT NULL,
    tx_descricao       VARCHAR(500) NOT NULL,
    tx_empresa         VARCHAR(50) NOT NULL,
    dt_criacao         TIMESTAMP DEFAULT NOW(),
    dt_atualizacao     TIMESTAMP DEFAULT NOW()
);
	
	INSERT INTO tb_ordemservico (
	     tx_titulo, tx_descricao, tx_empresa, CD_STATUS, cd_usuario
	) VALUES (
	     'Troca de monitor', 'Monitor com tela piscando, precisa de substituição', 'Empresa Teste', 5, 1
	)


SELECT* FROM  tb_ordemservico


	 
);
-- 1) tabelas de domínio primeiro (sem dependências)
CREATE TABLE tb_tipousuario (
    cd_tipousuario   SERIAL PRIMARY KEY,
    tx_tipo          VARCHAR(20) NOT NULL UNIQUE,
    tx_descricao     VARCHAR(100)
);

INSERT INTO tb_tipousuario (tx_tipo, tx_descricao) VALUES
    ('comum', 'Usuário comum, acesso padrão do sistema'),
    ('adm',   'Administrador, acesso completo ao sistema');

CREATE TABLE tb_status (
    id_status     SERIAL PRIMARY KEY,
    tx_status     VARCHAR(20) NOT NULL UNIQUE,
    tx_descricao  VARCHAR(100)
);

INSERT INTO tb_status (tx_status, tx_descricao) VALUES
    ('aberto',       'Ordem de serviço aberta, aguardando atendimento'),
    ('em_andamento', 'Ordem de serviço em execução'),
    ('concluido',    'Ordem de serviço finalizada'),
    ('cancelado',    'Ordem de serviço cancelada');

CREATE TABLE tb_categoria (
    id_categoria   SERIAL PRIMARY KEY,
    tx_categoria   VARCHAR(20) NOT NULL UNIQUE,
    tx_descricao   VARCHAR(100)
);

INSERT INTO tb_categoria (tx_categoria, tx_descricao) VALUES
    ('informatica', 'Problemas relacionados a informática'),
    ('manutencao',  'Manutenção geral'),
    ('software',    'Problemas de software'),
    ('outros',      'Outras categorias');

CREATE TABLE tb_prioridade (
    cd_prioridade   SERIAL PRIMARY KEY,
    tx_prioridade   VARCHAR(20) NOT NULL UNIQUE,
    tx_descricao    VARCHAR(100)
);

INSERT INTO tb_prioridade (tx_prioridade, tx_descricao) VALUES
    ('baixa', 'Prioridade baixa'),
    ('media', 'Prioridade média'),
    ('alta',  'Prioridade alta');

-- 2) tb_usuario, depende só de tb_tipousuario
CREATE TABLE tb_usuario (
    id_usuario       SERIAL PRIMARY KEY,
    tx_nome          VARCHAR(50) NOT NULL,
    tx_cpf           VARCHAR(11) NOT NULL,
    tx_telefone      VARCHAR(15) NOT NULL,
    tx_email         VARCHAR(50) NOT NULL UNIQUE,
    tx_login         VARCHAR(50) NOT NULL,
    tx_senha         VARCHAR(50) NOT NULL,
    tx_nomeempresa   VARCHAR(50) NOT NULL,
    tx_cnpj          VARCHAR(14) NOT NULL,
    tx_localizacao   VARCHAR(50) NOT NULL,
    tx_endereco      VARCHAR(50) NOT NULL,
    cd_tipousuario   INTEGER NOT NULL REFERENCES tb_tipousuario(cd_tipousuario) DEFAULT 1
);

INSERT INTO tb_usuario (
    tx_nome, tx_cpf, tx_telefone, tx_email, tx_login, tx_senha,
    tx_nomeempresa, tx_cnpj, tx_localizacao, tx_endereco, cd_tipousuario
) VALUES (
    'admin', '12345678900', '49999999999', 'admin@email.com', 'admin', 'admin',
    'Empresa Teste', '12345678000199', 'teste', 'Rua Exemplo, 123', 2
);

-- 3) tb_ordemservico por último, depende de todas as anteriores
CREATE TABLE tb_ordemservico (
    id_ordem_servico   SERIAL PRIMARY KEY,
    cd_usuario         INTEGER NOT NULL REFERENCES tb_usuario(id_usuario),
    cd_status          INTEGER NOT NULL REFERENCES tb_status(id_status) DEFAULT 1,
    cd_categoria       INTEGER NOT NULL REFERENCES tb_categoria(id_categoria),
    cd_prioridade      INTEGER NOT NULL REFERENCES tb_prioridade(cd_prioridade) DEFAULT 1,
    tx_titulo          VARCHAR(100) NOT NULL,
    tx_descricao       VARCHAR(500) NOT NULL,
    tx_empresa         VARCHAR(50) NOT NULL,
    dt_criacao         TIMESTAMP DEFAULT NOW(),
    dt_atualizacao     TIMESTAMP DEFAULT NOW()
);

INSERT INTO tb_ordemservico (
    tx_titulo, tx_descricao, tx_empresa, cd_status, cd_usuario, cd_categoria
) VALUES (
    'Troca de monitor', 'Monitor com tela piscando, precisa de substituição', 'Empresa Teste', 4, 1, 1
);
create table tb_calculadora (

id_valor serial not null primary key ,
vl_valor  NUMERIC(18,2)not null,
tx_operacao varchar(1) not null
)
INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '+', 504
);


INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '-', 252
);

INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '/', 20
);

INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '*', 39
);
---------------------------------------
VALUES (
    '+', 507
);


INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '-', 2587
);

INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '/', 27
);

INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '*', 33
);
---------------------------------------
VALUES (
    '+', 504
);


INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '-', 252
);

INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '/', 22
);

INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '*', 32
);

---------------------------------------
VALUES (
    '+', 502
);


INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '-', 252
);

INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '/', 2
);

INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '+', 3
);
---------------------------------------

VALUES (
    '+', 50
);


INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '-', 25
);

INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '/', 2
);

INSERT INTO tb_calculadora (
    tx_operacao,
	vl_valor
) VALUES (
    '*', 3
);
---------------------------------------

SELECT tb_ordemservico.cd_categoria, tb_categoria.tx_descricao, * FROM tb_ordemservico
inner join tb_categoria on tb_categoria.id_categoria = tb_ordemservico.cd_categoria
;
SELECT SUM(vl_valor) AS vl_total
FROM tb_calculadora
WHERE tx_operacao = '+';


select * FROM tb_calculadora
WHERE tx_operacao = '+'; 
