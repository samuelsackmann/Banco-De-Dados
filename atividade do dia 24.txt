GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO perfilleitura;
revoke all privileges on all tables in schema public from perfilleitura;

CREATE ROLE joana WITH LOGIN PASSWORD '123';
CREATE DATABASE atividadesalx;

--GRANT INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO joana;

revoke all privileges on all tables in schema public from joana;

GRANT SELECT ON tb_usuario TO joana	;
GRANT SELECT ON tb_usuario TO joana	;
create table tb_usuario(
tx_usuario varchar (255)
)
