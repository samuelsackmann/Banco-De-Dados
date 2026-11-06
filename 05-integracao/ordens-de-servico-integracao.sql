-- ============================================================
-- LIMPEZA (rodar do zero)
-- ============================================================
DROP TABLE IF EXISTS tb_historicostatus CASCADE;
DROP TABLE IF EXISTS tb_orcamento CASCADE;
DROP TABLE IF EXISTS tb_ordemservico CASCADE;
DROP TABLE IF EXISTS tb_documento CASCADE;
DROP TABLE IF EXISTS tb_tipoprioridade CASCADE;
DROP TABLE IF EXISTS tb_tipocategoria CASCADE;
DROP TABLE IF EXISTS tb_usuario CASCADE;
DROP TABLE IF EXISTS tb_tiposusuario CASCADE;
DROP TABLE IF EXISTS tb_status CASCADE;
DROP TABLE IF EXISTS tb_empresas CASCADE;
DROP SEQUENCE IF EXISTS seq_usuario;

-- ============================================================
-- SEQUENCE ÚNICA (usada como default de todo id_ do banco)
-- ============================================================
CREATE SEQUENCE seq_usuario START WITH 1 INCREMENT BY 1;

-- ============================================================
-- TABELAS SEM DEPENDÊNCIA
-- ============================================================
CREATE TABLE tb_tiposusuario (
  id_tipousuario NUMERIC(18,0) PRIMARY KEY DEFAULT nextval('seq_usuario'),
  tx_tipo VARCHAR(10) NOT NULL UNIQUE
);
COMMENT ON TABLE tb_tiposusuario IS 'Tipos de usuário do sistema (admin, comum, tecnico)';
COMMENT ON COLUMN tb_tiposusuario.id_tipousuario IS 'Identificador único do tipo de usuário';
COMMENT ON COLUMN tb_tiposusuario.tx_tipo IS 'Nome do tipo de usuário';

CREATE TABLE tb_status (
  id_status NUMERIC(18,0) PRIMARY KEY DEFAULT nextval('seq_usuario'),
  tx_status VARCHAR(20) NOT NULL UNIQUE
);
COMMENT ON TABLE tb_status IS 'Status possíveis para orçamentos e ordens de serviço';
COMMENT ON COLUMN tb_status.id_status IS 'Identificador único do status';
COMMENT ON COLUMN tb_status.tx_status IS 'Nome do status';

CREATE TABLE tb_empresas (
  id_empresa NUMERIC(18,0) PRIMARY KEY DEFAULT nextval('seq_usuario'),
  tx_nome VARCHAR(150) NOT NULL,
  tx_cnpj VARCHAR(18),
  tx_endereco VARCHAR(255),
  tx_telefone VARCHAR(20)
);
COMMENT ON TABLE tb_empresas IS 'Empresas clientes atendidas pela empresa de manutenção';
COMMENT ON COLUMN tb_empresas.id_empresa IS 'Identificador único da empresa';
COMMENT ON COLUMN tb_empresas.tx_nome IS 'Nome da empresa cliente';
COMMENT ON COLUMN tb_empresas.tx_cnpj IS 'CNPJ da empresa cliente';
COMMENT ON COLUMN tb_empresas.tx_endereco IS 'Endereço da empresa cliente';
COMMENT ON COLUMN tb_empresas.tx_telefone IS 'Telefone de contato da empresa cliente';

CREATE TABLE tb_tipocategoria (
  id_tipocategoria NUMERIC(18,0) PRIMARY KEY DEFAULT nextval('seq_usuario'),
  tx_status VARCHAR(250)
);
COMMENT ON TABLE tb_tipocategoria IS 'Categorias de serviço disponíveis para uma ordem de serviço';
COMMENT ON COLUMN tb_tipocategoria.id_tipocategoria IS 'Identificador único da categoria';
COMMENT ON COLUMN tb_tipocategoria.tx_status IS 'Nome da categoria de serviço (ex: Informática, Software)';

CREATE TABLE tb_tipoprioridade (
  id_tipoprioridade NUMERIC(18,0) PRIMARY KEY DEFAULT nextval('seq_usuario'),
  tx_selecionado VARCHAR(250)
);
COMMENT ON TABLE tb_tipoprioridade IS 'Níveis de prioridade disponíveis para uma ordem de serviço';
COMMENT ON COLUMN tb_tipoprioridade.id_tipoprioridade IS 'Identificador único da prioridade';
COMMENT ON COLUMN tb_tipoprioridade.tx_selecionado IS 'Nome do nível de prioridade (ex: Baixa, Media, Alta)';

CREATE TABLE tb_documento (
  id_documento NUMERIC(18,0) PRIMARY KEY DEFAULT nextval('seq_usuario'),
  tx_nome VARCHAR(250),
  tx_caminho VARCHAR(500),
  dt_upload TIMESTAMP DEFAULT NOW()
);
COMMENT ON TABLE tb_documento IS 'Documentos/anexos vinculados a uma ordem de serviço';
COMMENT ON COLUMN tb_documento.id_documento IS 'Identificador único do documento';
COMMENT ON COLUMN tb_documento.tx_nome IS 'Nome do arquivo enviado';
COMMENT ON COLUMN tb_documento.tx_caminho IS 'Caminho/local onde o arquivo está armazenado';
COMMENT ON COLUMN tb_documento.dt_upload IS 'Data de envio do documento';

-- ============================================================
-- USUÁRIO (depende de tb_tiposusuario)
-- ============================================================
CREATE TABLE tb_usuario (
  id_usuario NUMERIC(18,0) PRIMARY KEY DEFAULT nextval('seq_usuario'),
  tx_nome VARCHAR(255) NOT NULL,
  tx_cpf VARCHAR(14) NOT NULL UNIQUE,
  tx_telefone VARCHAR(20),
  tx_email VARCHAR(255) NOT NULL UNIQUE,
  tx_senha VARCHAR(255) NOT NULL,
  tx_nomeempresa VARCHAR(255),
  tx_cnpj VARCHAR(18),
  tx_localizacao VARCHAR(255),
  tx_endereco VARCHAR(255),
  cd_tipousuario NUMERIC(18,0) NOT NULL REFERENCES tb_tiposusuario(id_tipousuario),
  dt_criacao TIMESTAMP NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE tb_usuario IS 'Usuários do sistema (clientes, técnicos e administradores)';
COMMENT ON COLUMN tb_usuario.id_usuario IS 'Identificador único do usuário';
COMMENT ON COLUMN tb_usuario.tx_nome IS 'Nome completo do usuário';
COMMENT ON COLUMN tb_usuario.tx_cpf IS 'CPF do usuário';
COMMENT ON COLUMN tb_usuario.tx_telefone IS 'Telefone de contato do usuário';
COMMENT ON COLUMN tb_usuario.tx_email IS 'Email usado para login';
COMMENT ON COLUMN tb_usuario.tx_senha IS 'Senha do usuário (armazenada com hash, nunca em texto puro)';
COMMENT ON COLUMN tb_usuario.tx_nomeempresa IS 'Nome da empresa do usuário, quando aplicável';
COMMENT ON COLUMN tb_usuario.tx_cnpj IS 'CNPJ da empresa do usuário, quando aplicável';
COMMENT ON COLUMN tb_usuario.tx_localizacao IS 'Localização informada no cadastro';
COMMENT ON COLUMN tb_usuario.tx_endereco IS 'Endereço informado no cadastro';
COMMENT ON COLUMN tb_usuario.cd_tipousuario IS 'Tipo do usuário: referência a tb_tiposusuario';
COMMENT ON COLUMN tb_usuario.dt_criacao IS 'Data de criação do cadastro';

-- ============================================================
-- ORDEM DE SERVIÇO (depende de documento, usuário, categoria, prioridade)
-- ============================================================
CREATE TABLE tb_ordemservico (
  id_ordemservico NUMERIC(18,0) PRIMARY KEY DEFAULT nextval('seq_usuario'),
  tx_tituloservico VARCHAR(250) NOT NULL,
  tx_empresa VARCHAR(250) NOT NULL, -- tb separada (tb_empresas) no futuro
  dt_datadesejada TIMESTAMP DEFAULT NOW(),
  cd_documento NUMERIC(18,0) REFERENCES tb_documento(id_documento), -- tb separada
  cd_usuario NUMERIC(18,0) REFERENCES tb_usuario(id_usuario),
  cd_tipocategoria NUMERIC(18,0) REFERENCES tb_tipocategoria(id_tipocategoria),
  cd_tipoprioridade NUMERIC(18,0) REFERENCES tb_tipoprioridade(id_tipoprioridade),
  tx_descricao VARCHAR(250) NOT NULL
);
COMMENT ON TABLE tb_ordemservico IS 'Ordens de serviço abertas pelos usuários';
COMMENT ON COLUMN tb_ordemservico.id_ordemservico IS 'Identificador único da ordem de serviço';
COMMENT ON COLUMN tb_ordemservico.tx_tituloservico IS 'Título/resumo do serviço solicitado';
COMMENT ON COLUMN tb_ordemservico.tx_empresa IS 'Nome da empresa relacionada à ordem de serviço (texto solto por enquanto)';
COMMENT ON COLUMN tb_ordemservico.dt_datadesejada IS 'Data desejada para execução do serviço';
COMMENT ON COLUMN tb_ordemservico.cd_documento IS 'Documento/anexo vinculado à ordem de serviço';
COMMENT ON COLUMN tb_ordemservico.cd_usuario IS 'Usuário que abriu a ordem de serviço';
COMMENT ON COLUMN tb_ordemservico.cd_tipocategoria IS 'Categoria do serviço solicitado';
COMMENT ON COLUMN tb_ordemservico.cd_tipoprioridade IS 'Prioridade do serviço solicitado';
COMMENT ON COLUMN tb_ordemservico.tx_descricao IS 'Descrição detalhada do problema/serviço';

-- ============================================================
-- ORÇAMENTO (depende de ordem de serviço, usuário aprovador, status)
-- ============================================================
CREATE TABLE tb_orcamento (
  id_orcamento NUMERIC(18,0) PRIMARY KEY DEFAULT nextval('seq_usuario'),
  cd_ordemservico NUMERIC(18,0) NOT NULL REFERENCES tb_ordemservico(id_ordemservico),
  cd_usuarioaprovador NUMERIC(18,0) REFERENCES tb_usuario(id_usuario),
  vl_valor DECIMAL(10,2) NOT NULL,
  cd_status NUMERIC(18,0) NOT NULL REFERENCES tb_status(id_status),
  dt_criacao TIMESTAMP NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE tb_orcamento IS 'Orçamentos vinculados às ordens de serviço';
COMMENT ON COLUMN tb_orcamento.id_orcamento IS 'Identificador único do orçamento';
COMMENT ON COLUMN tb_orcamento.cd_ordemservico IS 'Ordem de serviço à qual o orçamento pertence';
COMMENT ON COLUMN tb_orcamento.cd_usuarioaprovador IS 'Administrador que aprovou ou rejeitou o orçamento (regra de quem pode fazer isso é aplicada no backend)';
COMMENT ON COLUMN tb_orcamento.vl_valor IS 'Valor do orçamento';
COMMENT ON COLUMN tb_orcamento.cd_status IS 'Status atual do orçamento (pendente/aprovado/rejeitado)';
COMMENT ON COLUMN tb_orcamento.dt_criacao IS 'Data de criação do orçamento';

-- ============================================================
-- HISTÓRICO DE STATUS (depende de ordem de serviço, status, usuário)
-- ============================================================
CREATE TABLE tb_historicostatus (
  id_historicostatus NUMERIC(18,0) PRIMARY KEY DEFAULT nextval('seq_usuario'),
  cd_ordemservico NUMERIC(18,0) NOT NULL REFERENCES tb_ordemservico(id_ordemservico),
  cd_statusanterior NUMERIC(18,0) REFERENCES tb_status(id_status),
  cd_statusnovo NUMERIC(18,0) NOT NULL REFERENCES tb_status(id_status),
  cd_usuariomodificador NUMERIC(18,0) REFERENCES tb_usuario(id_usuario),
  dt_alteracao TIMESTAMP NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE tb_historicostatus IS 'Histórico de mudanças de status das ordens de serviço';
COMMENT ON COLUMN tb_historicostatus.id_historicostatus IS 'Identificador único do registro de histórico';
COMMENT ON COLUMN tb_historicostatus.cd_ordemservico IS 'Ordem de serviço à qual o histórico pertence';
COMMENT ON COLUMN tb_historicostatus.cd_statusanterior IS 'Status antes da mudança (nulo quando é o status inicial)';
COMMENT ON COLUMN tb_historicostatus.cd_statusnovo IS 'Status depois da mudança';
COMMENT ON COLUMN tb_historicostatus.cd_usuariomodificador IS 'Usuário que fez a mudança de status';
COMMENT ON COLUMN tb_historicostatus.dt_alteracao IS 'Data e hora da mudança de status';

-- ============================================================
-- DADOS DE APOIO (tipos, status, categorias, prioridades)
-- ============================================================
INSERT INTO tb_tiposusuario (tx_tipo) VALUES
  ('admin'),
  ('comum'),
  ('tecnico');

INSERT INTO tb_status (tx_status) VALUES
  ('pendente'),
  ('aprovado'),
  ('rejeitado'),
  ('CRIADO'),
  ('EM_PROGRESSO'),
  ('CONFIRMADO'),
  ('FINALIZADO');

INSERT INTO tb_tipocategoria (tx_status) VALUES
  ('Selecione'),
  ('Informática'),
  ('Manutenção'),
  ('Software'),
  ('Outros');

INSERT INTO tb_tipoprioridade (tx_selecionado) VALUES
  ('Baixa'),
  ('Media'),
  ('Alta');

-- ============================================================
-- USUÁRIOS DE TESTE
-- Obs: cd_tipousuario buscado pelo nome, não pelo número,
-- porque a sequence é compartilhada e o id real pode não ser 1/2/3.
-- ============================================================
INSERT INTO tb_usuario (tx_nome, tx_cpf, tx_telefone, tx_email, tx_senha, tx_nomeempresa, tx_cnpj, tx_localizacao, tx_endereco, cd_tipousuario) VALUES
  ('Samuel', '12312312312', '47999998888', 'samuel@gmail.com', '123', 'Empresa Samuel', '12345678000199', 'casa', 'rua tal',
    (SELECT id_tipousuario FROM tb_tiposusuario WHERE tx_tipo = 'comum')),
  ('Samuel2', '11223344556', '47988887777', 'samuel2@gmail.com', '1232', 'Empresa Samuel2', '89220000000122', 'casa2', 'rua tal2',
    (SELECT id_tipousuario FROM tb_tiposusuario WHERE tx_tipo = 'tecnico')),
  ('Admin', '00000000000', '00000000000', 'admin@gmail.com', 'admin', NULL, NULL, NULL, NULL,
    (SELECT id_tipousuario FROM tb_tiposusuario WHERE tx_tipo = 'admin'));

-- ============================================================
-- EMPRESAS CLIENTES DE TESTE
-- ============================================================
INSERT INTO tb_empresas (tx_nome, tx_cnpj, tx_endereco, tx_telefone) VALUES
  ('eletrolux', '11222333000181', 'Rua A, 100', '47999991111'),
  ('flanela', '22333444000162', 'Rua B, 200', '47999992222'),
  ('kitnet', '33444555000143', 'Rua C, 300', '47999993333'),
  ('pivo', '44555666000124', 'Rua D, 400', '47999994444'),
  ('sla', '55666777000105', 'Rua E, 500', '47999995555'),
  ('roberto', '66777888000186', 'Rua F, 600', '47999996666');

-- ============================================================
-- ORÇAMENTOS E HISTÓRICO DE TESTE
-- Obs: cd_ordemservico assume que essas ordens (1 a 6) já foram
-- inseridas na tb_ordemservico antes de rodar este bloco.
-- Confira os ids reais com "SELECT * FROM tb_ordemservico;"
-- e ajuste os números abaixo se forem diferentes.
-- ============================================================
INSERT INTO tb_orcamento (cd_ordemservico, vl_valor, cd_status) VALUES
  (1, 450.00, (SELECT id_status FROM tb_status WHERE tx_status = 'pendente')),
  (2, 1200.00, (SELECT id_status FROM tb_status WHERE tx_status = 'pendente')),
  (3, 3800.00, (SELECT id_status FROM tb_status WHERE tx_status = 'aprovado')),
  (6, 2100.00, (SELECT id_status FROM tb_status WHERE tx_status = 'pendente'));

INSERT INTO tb_historicostatus (cd_ordemservico, cd_statusanterior, cd_statusnovo, cd_usuariomodificador) VALUES
  (1, NULL, (SELECT id_status FROM tb_status WHERE tx_status = 'CRIADO'), NULL),
  (2, NULL, (SELECT id_status FROM tb_status WHERE tx_status = 'EM_PROGRESSO'), NULL),
  (3, NULL, (SELECT id_status FROM tb_status WHERE tx_status = 'FINALIZADO'), NULL),
  (4, NULL, (SELECT id_status FROM tb_status WHERE tx_status = 'CONFIRMADO'), NULL),
  (5, NULL, (SELECT id_status FROM tb_status WHERE tx_status = 'CRIADO'), NULL),
  (6, NULL, (SELECT id_status FROM tb_status WHERE tx_status = 'EM_PROGRESSO'), NULL);