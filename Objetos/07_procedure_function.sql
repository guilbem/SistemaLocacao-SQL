
-- Projeto Final - BANCO: SISTEMA DE LOCACAO DE VEiCULOS
-- Guilherme Ferreira Pinheiro Guimaraes
-- 07_procedure_function

USE LOCADORA;


-- Crie 07_procedure_function.sql com:

-- PROCEDURE (exemplo: registrar devolução)
-- Entrada: p_idLocacao, p_dtDevolucao, p_kmDevolucao.
-- Regras: calcula dias, multa por atraso (quando p_dtDevolucao > dtFimPrev da reserva), atualiza valorFinal e kmDevolucao.
-- Atualiza status do veículo (ex.: “disponível”).
-- -- A PROCEDURE deve chamar a FUNCTION para compor o valorFinal.

DELIMITER $$

CREATE PROCEDURE registrar_devolucao(
    IN p_idLocacao INT,
    IN p_dtDevolucao DATETIME,
    IN p_kmDevolucao INT
)
BEGIN
    DECLARE v_valorDiaria DECIMAL(10,2);
    DECLARE v_dtFimPrev DATETIME;
    DECLARE v_diasAtraso INT DEFAULT 0;
    DECLARE v_multa DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_idVeiculo INT;

    -- Buscar dados da locacao
    SELECT 
        l.VALORDIARIA,
        r.DATAFIM,
        l.IDVEICULO
    INTO 
        v_valorDiaria,
        v_dtFimPrev,
        v_idVeiculo
    FROM LOCACAO l
    LEFT JOIN RESERVA r ON r.IDRESERVA = l.IDRESERVA
    WHERE l.IDLOCACAO = p_idLocacao;

    -- Calcular atraso
    IF p_dtDevolucao > v_dtFimPrev THEN
        SET v_diasAtraso = DATEDIFF(p_dtDevolucao, v_dtFimPrev);
    END IF;

    -- Calcular multa usando FUNCTION
    SET v_multa = calcular_multa_atraso(v_diasAtraso, v_valorDiaria);

    -- Atualizar locacao
    UPDATE LOCACAO
    SET 
        DATADEVOLUCAO = p_dtDevolucao,
        HMDEDEVOLUCAO = p_kmDevolucao,   
        MULTAS = v_multa,
        VALORFINAL = 
            (DATEDIFF(p_dtDevolucao, DATARETIRADA) + 1) * v_valorDiaria 
            + IFNULL(TAXAS,0) 
            + v_multa,
        STATUSLOCACAO = 'FINALIZADA'
    WHERE IDLOCACAO = p_idLocacao;

    -- Atualizar veiculo
    UPDATE VEICULO
    SET STATUSVEICULO = 'DISPONIVEL',
        KMATUAL = p_kmDevolucao
    WHERE IDVEICULO = v_idVeiculo;
    


END$$
DELIMITER ;


CALL registrar_devolucao(1, '2025-03-10 10:00:00', 45230);
CALL registrar_devolucao(2, '2025-03-23 22:00:00', 46230);






-- FUNCTION (exemplo: calcular_multa_atraso)
-- Entrada: diasAtraso INT, valorDiaria DECIMAL.
-- Saída: valor da multa (ex.: diasAtraso * (valorDiaria * 0.5)).
-- A PROCEDURE deve chamar a FUNCTION para compor o valorFinal.

DROP FUNCTION IF EXISTS calcular_multa_atraso;
DELIMITER $$

CREATE FUNCTION calcular_multa_atraso(
    diasAtraso INT,
    valorDiaria DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    IF diasAtraso <= 0 THEN
        RETURN 0.00;
    END IF;

    RETURN diasAtraso * (valorDiaria * 0.5);
END$$

DELIMITER ;

SELECT calcular_multa_atraso(3, 100.00) AS multa;


