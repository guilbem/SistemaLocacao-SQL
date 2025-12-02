
-- Projeto Final - BANCO: SISTEMA DE LOCACAO DE VEiCULOS
-- Guilherme Ferreira Pinheiro Guimaraes
-- 06_view.sql

USE LOCADORA;


-- Crie 06_view.sql com pelo menos 2 VISÕES úteis, por exemplo:

-- vw_faturamento_mensal(filial, mes, total)
CREATE OR REPLACE VIEW vw_faturamento_mensal AS
SELECT 
    f.IDFILIAL,
    f.NOME AS FILIAL,
    DATE_FORMAT(l.DATADEVOLUCAO, '%Y-%m') AS MES,
    SUM(l.VALORFINAL) AS TOTAL_FATURADO
FROM LOCACAO l
JOIN FILIAL f ON f.IDFILIAL = l.IDFILIAL
WHERE l.DATADEVOLUCAO IS NOT NULL   -- somente finalizadas contam no faturamento
GROUP BY 
    f.IDFILIAL,
    f.NOME,
    DATE_FORMAT(l.DATADEVOLUCAO, '%Y-%m');
-- Finalidade de negocio: Controlar o faturamento mensal por filial, ajudando na análise financeira, identificação 
-- de sazonalidade e avaliação de desempenho por unidade.
SELECT * FROM vw_faturamento_mensal WHERE MES = '2025-11';





-- vw_utilizacao_frota(categoria, totalVeiculos, emUso, disponibilidade)
CREATE OR REPLACE VIEW vw_utilizacao_frota AS
SELECT 
    c.IDCATEGORIA,
    c.NOME AS CATEGORIA,
    
    -- total de veículos cadastrados na categoria
    COUNT(v.IDVEICULO) AS TOTAL_VEICULOS,

    -- veículos em uso = locações sem DATADEVOLUCAO
    SUM(
        CASE 
            WHEN l.IDLOCACAO IS NOT NULL 
             AND l.DATADEVOLUCAO IS NULL 
            THEN 1 ELSE 0 
        END
    ) AS EM_USO,

    -- veiculos disponiveis = total - em uso
    COUNT(v.IDVEICULO) -
    SUM(
        CASE 
            WHEN l.IDLOCACAO IS NOT NULL 
             AND l.DATADEVOLUCAO IS NULL 
            THEN 1 ELSE 0 
        END
    ) AS DISPONIVEIS

FROM CATEGORIA c
LEFT JOIN VEICULO v ON v.IDCATEGORIA = c.IDCATEGORIA
LEFT JOIN LOCACAO l ON l.IDVEICULO = v.IDVEICULO
GROUP BY 
    c.IDCATEGORIA,
    c.NOME;
-- Finalidade de negocio: Oferecer uma visão geral da situação da frota por categoria,
-- mostrando quantos veículos existem, quantos estão alugados e quantos estão disponíveis para novas locações.


SELECT * FROM vw_utilizacao_frota;


--  vw_clientes

CREATE OR REPLACE VIEW vw_clientes AS
SELECT 
    c.IDCLIENTE,
    c.NOME,
    c.CPF,
    c.EMAIL,
    c.TELEFONE,
    c.ENDERECO,
    c.STATUSCLIENTE,

    TIMESTAMPDIFF(YEAR, c.DATANASCIMENTO, CURDATE()) AS IDADE,
    TIMESTAMPDIFF(DAY, c.DATACADASTRO, NOW()) AS DIAS_CADASTRADO,

    c.DATACADASTRO,
    c.DATANASCIMENTO

FROM CLIENTE c;
-- Finalidade de negocio: para facilitar a consulta rápida e organizada dos dados essenciais dos clientes, incluindo idade, tempo de
-- cadastro e status, auxiliando o setor de atendimento e gestão.


SELECT * FROM vw_clientes WHERE STATUSCLIENTE = 'ATIVO';

