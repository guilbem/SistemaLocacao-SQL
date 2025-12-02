
-- Projeto Final - BANCO: SISTEMA DE LOCACAO DE VEiCULOS
-- Guilherme Ferreira Pinheiro Guimaraes
-- 05_queries_select

USE LOCADORA;


-- Crie 05_queries_select.sql contendo no mínimo:

-- INNER JOIN: listagem de locações com cliente, veículo e filial de retirada.
SELECT 
    L.IDLOCACAO,
    L.DATARETIRADA,
    L.DATADEVOLUCAO,
    C.NOME AS CLIENTE,
    V.PLACA AS VEICULO,
    V.MODELO,
    F.NOME AS FILIAL_RETIRADA
FROM LOCACAO L
INNER JOIN CLIENTE C ON L.IDCLIENTE = C.IDCLIENTE
INNER JOIN VEICULO V ON L.IDVEICULO = V.IDVEICULO
INNER JOIN FILIAL F ON L.IDFILIAL = F.IDFILIAL;
-- Finalidade de negocio: Listar todas as locações exibindo dados de cliente, veículo e filial onde o veículo foi retirado.




-- LEFT JOIN: veículos e sua última locação (mesmo que não tenham sido locados).
SELECT
    V.IDVEICULO,
    V.PLACA,
    V.MODELO,
    V.STATUSVEICULO,
    L.DATARETIRADA AS ULTIMA_RETIRADA,
    L.DATADEVOLUCAO AS ULTIMA_DEVOLUCAO
FROM VEICULO V
LEFT JOIN (
    SELECT 
        IDVEICULO,
        DATARETIRADA,
        DATADEVOLUCAO
    FROM LOCACAO
    WHERE (IDVEICULO, DATARETIRADA) IN (
        SELECT 
            IDVEICULO,
            MAX(DATARETIRADA)
        FROM LOCACAO
        GROUP BY IDVEICULO
    )
) L ON V.IDVEICULO = L.IDVEICULO
ORDER BY V.IDVEICULO;
-- Finalidade de negocio: Exibir todos os veículos, mesmo os que nunca foram locados, mostrando a data da última locação quando existir.




-- RIGHT JOIN: filiais e veículos (ou cenário equivalente que justifique RIGHT).
SELECT
    F.IDFILIAL,
    F.NOME AS FILIAL,
    F.CIDADE,
    V.IDVEICULO,
    V.PLACA,
    V.MODELO
FROM VEICULO V
RIGHT JOIN FILIAL F ON V.IDFILIAL = F.IDFILIAL
ORDER BY F.IDFILIAL, V.IDVEICULO;
-- Finalidade de negocio: Mostrar todas as filiais, mesmo as que ainda não possuem veículos cadastrados.






-- Agregações:

-- SUM faturamento por mês/filial;
SELECT 
    F.IDFILIAL,
    F.NOME AS FILIAL,
    DATE_FORMAT(L.DATADEVOLUCAO, '%Y-%m') AS MES,
    SUM(L.VALORFINAL) AS FATURAMENTO_TOTAL
FROM LOCACAO L
INNER JOIN FILIAL F ON L.IDFILIAL = F.IDFILIAL
WHERE L.STATUSLOCACAO = 'FINALIZADA'
GROUP BY F.IDFILIAL, MES
ORDER BY MES, F.IDFILIAL;
-- Finalidade de negocio: Calcular o faturamento total por mês e por filial,



-- MAX/MIN por categoria (ex.: maior valor de diária, menor quilometragem).
SELECT 
    C.IDCATEGORIA,
    C.NOME AS CATEGORIA,
    MAX(T.VALORDIARIA) AS MAIOR_DIARIA,
    MIN(V.KMATUAL) AS MENOR_KM_FROTA
FROM CATEGORIA C
LEFT JOIN TARIFA T ON T.IDCATEGORIA = C.IDCATEGORIA
LEFT JOIN VEICULO V ON V.IDCATEGORIA = C.IDCATEGORIA
GROUP BY C.IDCATEGORIA, C.NOME
ORDER BY C.IDCATEGORIA;

--  Finalidade de negocio: Obter indicadores por categoria maior valor de diária e menor quilometragem atual dos veículos.



-- GROUP BY: quantidade de locações por categoria de veículo.
SELECT
    C.IDCATEGORIA,
    C.NOME AS CATEGORIA,
    COUNT(L.IDLOCACAO) AS TOTAL_LOCACOES
FROM CATEGORIA C
LEFT JOIN VEICULO V 
       ON V.IDCATEGORIA = C.IDCATEGORIA
LEFT JOIN LOCACAO L
       ON L.IDVEICULO = V.IDVEICULO
GROUP BY C.IDCATEGORIA, C.NOME
ORDER BY TOTAL_LOCACOES DESC;
-- Finalidade de negócio: Mostrar quantas locações cada categoria de veículo gerou, auxiliando na análise de demanda da frota .




-- CASE: classificação de atraso (ex.: CASE WHEN diasAtraso > 0 THEN 'Com atraso' ELSE 'No prazo' END).
SELECT
    L.IDLOCACAO,
    C.NOME AS CLIENTE,
    V.MODELO AS VEICULO,
    R.DATAFIM AS PREVISAO_DEVOLUCAO,
    L.DATADEVOLUCAO AS DEVOLUCAO_REAL,

    -- Calculo do atraso em dias
    DATEDIFF(L.DATADEVOLUCAO, R.DATAFIM) AS DIAS_ATRASO,

    -- Classificacoo com CASE
    CASE
        WHEN L.DATADEVOLUCAO IS NULL THEN 'Em andamento'
        WHEN DATEDIFF(L.DATADEVOLUCAO, R.DATAFIM) > 0 THEN 'Com atraso'
        ELSE 'No prazo'
    END AS SITUACAO_DEVOLUCAO

FROM LOCACAO L
LEFT JOIN RESERVA R ON R.IDRESERVA = L.IDRESERVA
LEFT JOIN CLIENTE C ON C.IDCLIENTE = L.IDCLIENTE
LEFT JOIN VEICULO V ON V.IDVEICULO = L.IDVEICULO
ORDER BY DIAS_ATRASO DESC;
-- Finalidade de negocio: Identificar locações devolvidas com atraso para fins de auditoria.



-- Subconsulta: top 3 clientes por valor total locado.
SELECT
  c.IDCLIENTE,
  c.NOME,
  SUM(l.VALORFINAL) AS TOTAL_GASTO
FROM CLIENTE c
JOIN LOCACAO l ON l.IDCLIENTE = c.IDCLIENTE
GROUP BY c.IDCLIENTE, c.NOME
ORDER BY TOTAL_GASTO DESC
LIMIT 3;




-- Consultas de validação (obrigatórias)
-- Inclua no final de 05_queries_select.sql testes que mostrem:

-- Locação antes e depois da devolução (para provar a PROCEDURE).
-- Antes da devolução 
SELECT 
    IDLOCACAO,
    DATARETIRADA,
    DATADEVOLUCAO,
    HMDEDEVOLUCAO,
    VALORFINAL,
    STATUSLOCACAO
FROM LOCACAO
WHERE IDLOCACAO = 1;



-- Executa a devolução 
CALL registrar_devolucao(1, '2025-03-10 10:00:00', 45230);


--  Depois da devolução 
SELECT 
    IDLOCACAO,
    DATARETIRADA,
    DATADEVOLUCAO,
    HMDEDEVOLUCAO,
    VALORFINAL,
    STATUSLOCACAO
FROM LOCACAO
WHERE IDLOCACAO = 1;



-- Uso da VIEW em uma consulta (ex.: SELECT * FROM vw_faturamento_mensal WHERE mes='2025-11';)
SELECT *
FROM vw_faturamento_mensal
WHERE mes = '2025-11';



-- Cálculo da FUNCTION isolada (SELECT calcular_multa_atraso(2, 100.00);).
SELECT calcular_multa_atraso(2, 100.00) AS multa_calculada;


