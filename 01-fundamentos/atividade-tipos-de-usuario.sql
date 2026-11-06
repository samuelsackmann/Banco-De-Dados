drop table tb_usuario;

CREATE TABLE tb_tipousuario (
    cd_tipousuario   SERIAL PRIMARY KEY,
    tx_tipo          VARCHAR(20) NOT NULL UNIQUE,
    tx_descricao     VARCHAR(100)
);
  
INSERT INTO tb_tipousuario (tx_tipo, tx_descricao) VALUES
    ('comum', 'Usuário comum, acesso padrão do sistema'),
    ('adm',   'Administrador, acesso completo ao sistema');
    ------------------------------------------------------------------
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
    ------------------------------------------------------------------
	CREATE TABLE tb_status (
    id_status     SERIAL PRIMARY KEY,
    tx_status     VARCHAR(20) NOT NULL UNIQUE,
    tx_descricao  VARCHAR(100)
);

INSERT INTO tb_status (tx_status, tx_descricao) VALUES
    ('aberto',        'Ordem de serviço aberta, aguardando atendimento'),
    ('em_andamento',  'Ordem de serviço em execução'),
    ('concluido',     'Ordem de serviço finalizada'),
    ('cancelado',     'Ordem de serviço cancelada');

	  ------------------------------------------------------------------
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