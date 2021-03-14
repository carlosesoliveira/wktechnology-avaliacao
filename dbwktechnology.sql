DROP DATABASE IF EXISTS dbwktecnology;
create database dbwktecnology charset utf8;
use dbwktecnology;

DROP TABLE IF EXISTS tbclientes;
CREATE TABLE IF NOT EXISTS tbclientes (
	cd_cliente int not null auto_increment,
    nme_cliente varchar(255) not null,
    nme_cidade varchar(50) null,
    cd_uf char(2) null,    
    PRIMARY KEY (`cd_cliente`),
    KEY `idx_clientes_nme` (`nme_cliente`)
)ENGINE innoDB default charset utf8;

insert into tbclientes (nme_cliente, nme_cidade, cd_uf) 
VALUES 
('ABC DATASAUDE SERVICOS FARMACEUTICOS LTDA','Brasilia','DF'),
('PEIXOTO E SANTOS COMERCIAL DE MEDICAMENTOS','Brasilia','DF'),
('MEGA COMERCIO DE PANIFICACAO LTDA-ME','Brasilia','DF'),
('HADCO COMERCIO DE ALIMENTOS LTDA','Brasilia','DF'),
('DROGARIA PRINCESA LTDA','Brasilia','DF'),
('DANIELE CAMELO MORAIS DO NASCIMENTO','Brasilia','DF'),
('LAVANCE COSMETICOS E SALÃO DE BELEZA LTDA ME','Brasilia','DF'),
('DD TAGUATINGA SUL ALIMENTOS LTDA   ','Brasilia','DF'),
('IRMAOS LEONEL LTDA','Brasilia','DF'),
('DROGARIA CERVO','Brasilia','DF'),
('DROGARIA GAMA CENTRAL LTDA ME','Brasilia','DF'),
('GERALDO MAGELA DE OLIVEIRA','Brasilia','DF'),
('DROGARIA REFALAVIS LTDA ME','Brasilia','DF'),
('GARBI LIVROS DIDATICOS LTDA ','Brasilia','DF'),
('SUPERMERCADO PREDIGER LTDA','Brasilia','DF'),
('GERALDA GOMES PEREIRA ME','Brasilia','DF'),
('DROGARIA OESTE LTDA EPP','Brasilia','DF'),
('SONDA DO BRASIL SA','Brasilia','DF'),
('DROGARIA VILA MARTHIAS LTDA','Brasilia','DF'),
('M5 IND TEXTIL','Brasilia','DF');

DROP TABLE IF EXISTS tbprodutos;
CREATE TABLE IF NOT EXISTS tbprodutos (
	cd_produto int not null auto_increment,
    nme_produto varchar(255) not null,
    vlr_venda float(15,2) null,
    PRIMARY KEY (`cd_produto`),
    KEY `idx_produtos_nme` (`nme_produto`)
)ENGINE innoDB default charset utf8;

insert into tbprodutos (nme_produto, vlr_venda)
values
('REPADO DUAL POINT',220.50),
('ESPELHO 4X4 BRANCO WEG',6.00),
('EPSON IMP DE CUPOM TM-T20 USB CINZA ESCURO',600.99),
('MONITOR 21.5 POL LED PCTOP MLP215HDMI HDMI PRETO',679.00),
('CABO SERIAL SWEDA  SI 300',64.90),
('PROC CORE I3-6100 3.7GHZ 3M 1151 6aG BX80662I36100',771.79),
('MINI CAIXA DE SOM MULTIMIDIA',90.00),
('ABRAÇADEIRA 2,5 X 200MM BRANCA PCT C/ 100',12.00),
('HVR INTELBRÁS MHDX 1008 COM TB',1123.20),
('HD SATA II 320GB WESTERN DIGITAL 7200',317.00),
('CABO GAVETA GERBO RJ 11',35.00),
('GATILHO DO MECANISMO GAVETA SWEDA',41.00),
('RJ 11 6 VIAS PARA GAVETA',2.00),
('SUPORTE ARTICULADO SM-SPMA 14/32 PRETO',117.29),
('PLACA DE VIDEO',153.00),
('TECLADO TEC 12 GERTEC',405.00),
('SUBCONJ. TAMPA FRONTAL SI-300S',135.00),
('SWITCH 8 PORTAS INTELBRAS',135.00),
('FRAME P/ RJ-45 BRANCO',2.00),
('ROLAMENTO GAVETA MG-40M',10.00);

DROP TABLE IF EXISTS tbpedidos;
CREATE TABLE IF NOT EXISTS tbpedidos (
	cd_pedido int not null auto_increment,
    dta_pedido datetime not null,
    cd_cliente int not null,
    vlr_total float(15,2) null,
    PRIMARY KEY (`cd_pedido`),
    KEY `idx_pedidos_data` (`dta_pedido`),
    KEY `idx_pedidos_cliente` (`cd_cliente`),
    FOREIGN KEY (`cd_cliente`) REFERENCES tbclientes (`cd_cliente`) ON DELETE NO ACTION    
)ENGINE innoDB default charset utf8;

select date_format(current_timestamp, '%Y-%m-%d %H:%i:%s') as dta_pedido;

DROP TABLE IF EXISTS tbpedidos_itens;
CREATE TABLE IF NOT EXISTS tbpedidos_itens (
	cd_item int not null auto_increment,
    cd_pedido int not null,
    cd_produto int not null,
    qtd_produto int not null default 1,
    vlr_venda float(15,2) null,
    vlr_total float(15,2) null,
    PRIMARY KEY (`cd_item`),
    KEY `idx_items_ped` (`cd_pedido`),
    KEY `idx_items_prod` (`cd_produto`),
    FOREIGN KEY (`cd_pedido`) REFERENCES tbpedidos (`cd_pedido`) ON DELETE CASCADE,
    FOREIGN KEY (`cd_produto`) REFERENCES tbprodutos (`cd_produto`) ON DELETE NO ACTION
)ENGINE innoDB default charset utf8;

-- select * from tbclientes;
-- select * from tbprodutos;

-- select * from tbpedidos;
-- select * from tbpedidos_itens;
