
-- Projeto Final - BANCO: SISTEMA DE LOCACAO DE VEiCULOS
-- Guilherme Ferreira Pinheiro Guimaraes
--  CONSTRAINTS

USE LOCADORA;


-- CONSTRAINTS 
-- KM devolução ≥ 0 
ALTER TABLE LOCACAO
ADD CONSTRAINT chk_km_devolucao CHECK (HMDEDEVOLUCAO >= 0);


-- Status válido para veículos 
ALTER TABLE VEICULO
ADD CONSTRAINT chk_status_veiculo
CHECK (STATUSVEICULO IN ('DISPONIVEL', 'LOCADO', 'MANUTENCAO'));


-- Valor de diária deve ser positivo 
ALTER TABLE LOCACAO
ADD CONSTRAINT chk_valor_diaria
CHECK (VALORDIARIA > 0);

