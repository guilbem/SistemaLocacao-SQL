
-- Projeto Final - BANCO: SISTEMA DE LOCACAO DE VEiCULOS
-- Guilherme Ferreira Pinheiro Guimaraes
-- 02b_manutencao_truncate_drop

USE LOCADORA;

-- Um DROP de objeto (ex.: DROP VIEW antiga, com comentário e recriação em outro script).

-- Criando VIEW antiga para ser DROAPADA
CREATE OR REPLACE VIEW VW_RESERVAS_ATIVAS AS
SELECT IDRESERVA, DATAINICIO, DATAFIM, IDCLIENTE, IDVEICULO
FROM RESERVA
WHERE STATUSRESERVA = 'ATIVA';

-- Removendo a VIEW depreciada
DROP VIEW IF EXISTS VW_RESERVAS_ATIVAS;
-- finalidade de negocio:
-- A view VW_RESERVAS_ATIVAS antigo modelo estava obsoleta,
-- pois exibia apenas Cliente + Veículo, sem incluir Filial.
-- POR isso uma nova versão foi criada.



-- criando nova VIEW para subtituir a VIEW DEPRECIADA E QUE FOI DELETEDA
CREATE OR REPLACE VIEW VW_RESERVAS_ATIVAS AS
SELECT 
    R.IDRESERVA,
    R.DATAINICIO,
    R.DATAFIM,
    C.NOME AS NOMECLIENTE,
    C.CPF AS CPFCLIENTE,
    V.MODELO AS MODELOVEICULO,
    V.PLACA AS PLACA,
    CAT.NOME AS CATEGORIA,
    F.NOME AS FILIAL,
    F.CIDADE AS CIDADE,
    F.UF AS UF,
    R.STATUSRESERVA
FROM RESERVA R
JOIN CLIENTE C ON C.IDCLIENTE = R.IDCLIENTE
JOIN VEICULO V ON V.IDVEICULO = R.IDVEICULO
JOIN CATEGORIA CAT ON CAT.IDCATEGORIA = V.IDCATEGORIA
JOIN FILIAL F ON F.IDFILIAL = R.IDFILIAL
WHERE R.STATUSRESERVA = 'ATIVA'
ORDER BY R.DATAINICIO DESC;
-- Finalidade de negocio:
-- A antiga view VW_RESERVAS_ATIVAS estava obsoleta, pois apresentava
-- somente informações básicas de Cliente e Veículo, sem incluir dados essenciais
-- para operação e gestão, como Filial, Categoria do Veículo e datas completas da reserva.
-- Por isso, ela foi removida e uma nova versão foi criada
-- consolidando CLIENTE, VEICULO, CATEGORIA e FILIAL em um único ponto de consulta.
-- Assim a visualização das reservas ativas fica completa, atualizada e otimizada.




