
-- Projeto Final - BANCO: SISTEMA DE LOCACAO DE VEiCULOS
-- Guilherme Ferreira Pinheiro Guimaraes
-- 02_ddl_alter.sql 

USE LOCADORA;

-- Pelo menos 2 ALTER TABLE (ex.: adicionar quilometragemRevisao em VEICULO; alterar tamanho de campo).

-- 1: ALTER TABLE – Adicionar coluna quilometragemRevisao
ALTER TABLE VEICULO
ADD COLUMN KMPROXIMAREVISAO INT ;
-- finalidade de negocio: A equipe de manutenção quer que o sistema
-- registre a quilometragem prevista para a próxima revisão preventiva de cada veículo


-- 2: ALTER TABLE – Aumentar tamanho do campo EMAIL em CLIENTE
ALTER TABLE CLIENTE
MODIFY COLUMN EMAIL VARCHAR(200);
-- finalidade de negocio:
-- O sistema passou a aceitar e-mails corporativos muito longos, O limite anterior (120) o que tornou-se insuficiente.




-- Um TRUNCATE (em tabela de staging/logs não crítica – com comentário justificando).

-- TABELA: MOViMENTO_VEICULO_LOG, criada para logs 
CREATE TABLE IF NOT EXISTS MOVIMENTO_VEICULO_LOG (
    IDLOG INT AUTO_INCREMENT PRIMARY KEY,
    DATAEVENTO DATETIME,
    DESCRICAO VARCHAR(255)
);

-- EXECUTANDO o comando trucante para limpar a tabela MOViMENTO_VEICULO_LOG
TRUNCATE TABLE MOVIMENTO_VEICULO_LOG;
-- finalidade de negocio:
-- A tabela MOVIMENTO_VEICULO_LOG foi criada para armazenar  teste internos de integração com o módulo de telemetria.

