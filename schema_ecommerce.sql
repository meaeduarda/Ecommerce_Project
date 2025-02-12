-- criação do banco de dados do projeto  E-commerce 

create database ecommerce;
use ecommerce;

-- tabela cliente

create table clients(
		idClient int auto_increment primary key,
        Fname varchar(10),
        Minit char(3),
        Lname varchar(20),
        CPF char(11) not null,
        Address varchar(100), -- é um atributo composto / rua,cep,cidade,estado
        constraint unique_cpf_client unique (CPF) -- nomeei a constraint como unique_cpf_client
);


desc clients;
-- criar tabela produto

create table product(
		idProduct int auto_increment primary key,
        Pname varchar(20) not null,
        classification_kids bool default false, -- forma de classificar se é de criança ou não/ usei como default false
        category enum('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
        avaliação float default 0,
        size varchar(10) -- size = dimensão do produto
);
desc product;

-- criação da constraints relacionadas ao pagamento
-- Tenho mais de um tipo de pagamento e mais de uma PK 

create table payments(
	idclient int,
    idPayment int,
    typePayment enum('Boleto','Cartão','Dois cartões','Pix', 'Dinheiro'),
    limitAvailable float,
    primary key(idClient, idPayment)
);

desc orders;
-- criar tabela orders (pedidos)

create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento' not null,
    orderDescription varchar(100), -- descrição do produto
    sendValue float default 10, 
    paymentCash boolean default false, 
    constraint fk_ordes_client foreign key (idOrderClient) references clients(idClient)
			on update cascade
);

-- tabela estoque (productStorage)

create table productStorage(
	idProdStorage int auto_increment primary key not null,
    storageLocation varchar(100),
    quantity int default 0 
);

-- criar tabela supplier (fornecedor)

create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(50) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

-- criar tabela seller (vendedor)

create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(70) not null,
    AbstName varchar(50),
    CNPJ char(15),
    CPF char(9),
    location varchar(100),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

-- tabelas de relacionamentos M:N

create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);
desc productSeller;

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_product foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_order foreign key (idPOorder) references orders(idOrder)

);

create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(100) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_prodcut foreign key (idPsProduct) references product(idProduct)
);

desc productSupplier;

show tables;
show databases;
use information_schema;
show tables;
desc referential_constraints;
select * from referential_constraints where constraint_schema = 'ecommerce'; -- consulta dos referenciais das constraints