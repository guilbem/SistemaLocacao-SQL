
-- Projeto Final - BANCO: SISTEMA DE LOCACAO DE VEiCULOS
-- Guilherme Ferreira Pinheiro Guimaraes
-- ÍNDICES

USE LOCADORA;

-- Índice para acelerar consultas por cliente na LOCACAO 
CREATE INDEX idx_locacao_idcliente 
ON LOCACAO (IDCLIENTE);


-- Índice para acelerar JOIN LOCACAO e RESERVA 
CREATE INDEX idx_locacao_idreserva 
ON LOCACAO (IDRESERVA);


-- Índice para buscas por veículo 
CREATE INDEX idx_locacao_idveiculo 
ON LOCACAO (IDVEICULO);
