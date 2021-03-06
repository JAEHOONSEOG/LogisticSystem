DROP DATABASE logic;
CREATE DATABASE logic;
use logic;

CREATE TABLE TSN_User(
    EmailId VARCHAR(100) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Name NVARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    CreatedDate DATETIME DEFAULT NOW() NOT NULL,
	LastUpdatedDate DATETIME DEFAULT NOW() NOT NULL,
	IsAdmin BOOLEAN DEFAULT FALSE NOT NULL,
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY (EmailId)
);

CREATE TABLE TSN_Group(
	Idx  INT NOT NULL AUTO_INCREMENT,
	Name NVARCHAR(255) UNIQUE NOT NULL,
	IsDefault BOOLEAN DEFAULT FALSE NOT NULL,
	CreatedDate DATETIME DEFAULT NOW() NOT NULL,
	Creater VARCHAR(100) DEFAULT '' NOT NULL,
	LastUpdatedDate DATETIME DEFAULT NOW() NOT NULL,
	LastUpdater VARCHAR(100) DEFAULT '' NOT NULL,
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY (Idx)
);

-- User : Group = n:n
CREATE TABLE MAP_USER_GROUP(
	EmailId VARCHAR(100) NOT NULL,
	GroupId INT NOT NULL,
	
	PRIMARY KEY (EmailId,GroupId),
	FOREIGN KEY (EmailId) REFERENCES TSN_User(EmailId),
	FOREIGN KEY (GroupId) REFERENCES TSN_Group(Idx)
);

CREATE TABLE MST_ViewRole(
	CODE CHAR(4) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	
	PRIMARY KEY (CODE)
);

CREATE TABLE MST_ActionRole(
	CODE CHAR(4) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	
	PRIMARY KEY (CODE)
);

-- If it have not map of role by view, that is all permission.
CREATE TABLE MAP_VIEW_ROLE_GROUP(
	ViewCode CHAR(4) NOT NULL,
	GroupId INT NOT NULL,
	
	PRIMARY KEY (ViewCode,GroupId),
	FOREIGN KEY (ViewCode) REFERENCES MST_ViewRole(CODE),
	FOREIGN KEY (GroupId) REFERENCES TSN_Group(Idx)
);

-- If it have not map of role by view, that is all permission.
CREATE TABLE MAP_VIEW_ROLE_USER(
	ViewCode CHAR(4) NOT NULL,
	EmailId VARCHAR(100) NOT NULL,
	
	PRIMARY KEY (ViewCode,EmailId),
	FOREIGN KEY (ViewCode) REFERENCES MST_ViewRole(CODE),
	FOREIGN KEY (EmailId) REFERENCES TSN_User(EmailId)
);

-- If it have not map of role by action, that is all permission.
CREATE TABLE MAP_ACTION_ROLE_GROUP(
	RoleCode CHAR(4) NOT NULL,
	GroupId INT NOT NULL,
	
	PRIMARY KEY (RoleCode,GroupId),
	FOREIGN KEY (RoleCode) REFERENCES MST_ActionRole(CODE),
	FOREIGN KEY (GroupId) REFERENCES TSN_Group(Idx)
);

-- If it have not map of role by action, that is all permission.
CREATE TABLE MAP_ACTION_ROLE_USER(
	RoleCode CHAR(4) NOT NULL,
	EmailId VARCHAR(100) NOT NULL,
	
	PRIMARY KEY (RoleCode,EmailId),
	FOREIGN KEY (RoleCode) REFERENCES MST_ActionRole(CODE),
	FOREIGN KEY (EmailId) REFERENCES TSN_User(EmailId)
);

-- Permission map condition is next:
-- Group was had in Map_Group, User in its group was had in Map_User -> all user in group can access. it has not mean.
-- Group was not had in Map_Group, User in its group was had in Map_User -> only user can access the rule. the group can not be.
-- example SQL;
-- SELECT role.CODE,user.EmailId  
--		FROM MST_ViewRole role INNER JOIN MAP_VIEW_ROLE_GROUP map ON role.CODE = map.ViewCode
--							   INNER JOIN MAP_USER_GROUP groupmap ON map.GroupId = groupmap.GroupId
--							   INNER JOIN TSN_User user ON groupmap.GroupId = user.EmailId
-- UNION
-- SELECT role.CODE,user.EmailId 
--		FROM MST_ViewRole role INNER JOIN MAP_VIEW_ROLE_USER map ON role.CODE = map.ViewCode
--							   INNER JOIN TSN_User user ON map.EmailId = user.EmailId;



CREATE TABLE MST_CompanyType(
	CODE CHAR(2) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	
	PRIMARY KEY (CODE)
);
INSERT INTO MST_CompanyType (CODE,NAME) VALUES('01',N'発注社');
INSERT INTO MST_CompanyType (CODE,NAME) VALUES('02',N'受注社');
INSERT INTO MST_CompanyType (CODE,NAME) VALUES('03',N'流通社');
INSERT INTO MST_CompanyType (CODE,NAME) VALUES('04',N'御客');
INSERT INTO MST_CompanyType (CODE,NAME) VALUES('05',N'生産社');
INSERT INTO MST_CompanyType (CODE,NAME) VALUES('06',N'工場');
INSERT INTO MST_CompanyType (CODE,NAME) VALUES('07',N'OEM');


CREATE TABLE TSN_Company(
	Idx INT NOT NULL AUTO_INCREMENT,
	CompanyType CHAR(2) NOT NULL,
	CompanyName NVARCHAR(255) NOT NULL,
    CompanyAddress NVARCHAR(255) NOT NULL,
    CompanyZIPCode1 CHAR(3) NOT NULL,
	CompanyZIPCode2 CHAR(4) NOT NULL,
    CompanySecurityNumber VARCHAR(50) NOT NULL,
	CompanyPhoneNumber VARCHAR(20) NOT NULL,
    CompanyFax VARCHAR(20),
    CompanyEMail VARCHAR(100) NOT NULL,
	CreatedDate DATETIME DEFAULT NOW() NOT NULL,
	Creater VARCHAR(100) DEFAULT '' NOT NULL,
	LastUpdatedDate DATETIME DEFAULT NOW() NOT NULL,
	LastUpdater VARCHAR(100) DEFAULT '' NOT NULL,
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY (Idx),
	FOREIGN KEY (CompanyType) REFERENCES MST_CompanyType (Code)
);

CREATE TABLE TSN_Account(
	Idx INT NOT NULL AUTO_INCREMENT,
	CompanyId INT NOT NULL,
	AccountNumber VARCHAR(100) NOT NULL,
    AccountBank NVARCHAR(100) NOT NULL,
    AccountbankCode VARCHAR(20) NOT NULL,
    AccountbankCodename NVARCHAR(100) NOT NULL,
    AccountOwnername NVARCHAR(100) NOT NULL,
	CreatedDate DATETIME DEFAULT NOW() NOT NULL,
	Creater VARCHAR(100) DEFAULT '' NOT NULL,
	LastUpdatedDate DATETIME DEFAULT NOW() NOT NULL,
	LastUpdater VARCHAR(100) DEFAULT '' NOT NULL,
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY (Idx),
	FOREIGN KEY (CompanyId) REFERENCES TSN_Company (Idx)
);

CREATE TABLE MST_EmployeeType(
	CODE CHAR(2) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	
	PRIMARY KEY (CODE)
);

INSERT INTO MST_EmployeeType (CODE, NAME) VALUES('01', N'取締役');
INSERT INTO MST_EmployeeType (CODE, NAME) VALUES('02', N'社長');
INSERT INTO MST_EmployeeType (CODE, NAME) VALUES('03', N'営業部');
INSERT INTO MST_EmployeeType (CODE, NAME) VALUES('04', N'社員');
INSERT INTO MST_EmployeeType (CODE, NAME) VALUES('05', N'担当者');

CREATE TABLE TSN_Employee(
	Idx INT NOT NULL AUTO_INCREMENT,
	CompanyId INT NOT NULL,
	EmployeeType CHAR(2) NOT NULL,
	Name NVARCHAR(255) NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL,
	Email VARCHAR(100) NOT NULL,
	CreatedDate DATETIME DEFAULT NOW() NOT NULL,
	Creater VARCHAR(100) DEFAULT '' NOT NULL,
	LastUpdatedDate DATETIME DEFAULT NOW() NOT NULL,
	LastUpdater VARCHAR(100) DEFAULT '' NOT NULL,
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY (Idx),
	FOREIGN KEY (CompanyId) REFERENCES TSN_Company (Idx),
	FOREIGN KEY (EmployeeType) REFERENCES MST_EmployeeType (CODE)
);

CREATE TABLE MST_OrderType(
	CODE CHAR(2) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	
	PRIMARY KEY (CODE)
);

INSERT INTO MST_OrderType (CODE, NAME) VALUES('01', N'発注');
INSERT INTO MST_OrderType (CODE, NAME) VALUES('02', N'受注');
INSERT INTO MST_OrderType (CODE, NAME) VALUES('03', N'生産');
INSERT INTO MST_OrderType (CODE, NAME) VALUES('99', N'その他');

CREATE TABLE MST_PayType(
	CODE CHAR(2) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	
	PRIMARY KEY (CODE)
);

INSERT INTO MST_PayType (CODE, NAME) VALUES('01', N'現金');
INSERT INTO MST_PayType (CODE, NAME) VALUES('02', N'クレジットカード');
INSERT INTO MST_PayType (CODE, NAME) VALUES('03', N'振込');
INSERT INTO MST_PayType (CODE, NAME) VALUES('99', N'その他');

CREATE TABLE TSN_OrderTable(
	Idx INT NOT NULL AUTO_INCREMENT,
	OrderType CHAR(2) NOT NULL,
	OrderOther NVARCHAR(255) NULL,
	CompanyId INT NOT NULL,
	OrderPrice DECIMAL NOT NULL,
	OrderSaveExpectedDate DATETIME NOT NULL,
	OrderSavePlace NVARCHAR(255) NOT NULL,
	OrderDate DATETIME NOT NULL,
	PayDate DATETIME,
	PayMoney DECIMAL,
	PayType CHAR(2),
	PayOther NVARCHAR(255),
	CreatedDate DATETIME DEFAULT NOW() NOT NULL,
	Creater VARCHAR(100) DEFAULT '' NOT NULL,
	LastUpdatedDate DATETIME DEFAULT NOW() NOT NULL,
	LastUpdater VARCHAR(100) DEFAULT '' NOT NULL,
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(Idx),
	FOREIGN KEY (OrderType) REFERENCES MST_OrderType (CODE),
	FOREIGN KEY (CompanyId) REFERENCES TSN_Company (Idx),
	FOREIGN KEY (PayType) REFERENCES MST_PayType (CODE)
);

CREATE TABLE TSN_ProductType(
	Idx INT NOT NULL AUTO_INCREMENT,
	ProductTypeName NVARCHAR(255) NOT NULL,
	CreatedDate DATETIME DEFAULT NOW() NOT NULL,
	Creater VARCHAR(100) NOT NULL,
	LastUpdatedDate DATETIME DEFAULT NOW() NOT NULL,
	LastUpdater VARCHAR(100) NOT NULL NOT NULL,
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,

	PRIMARY KEY(idx)
);

CREATE TABLE TSN_Product(
	Idx INT NOT NULL AUTO_INCREMENT,
	ProductName NVARCHAR(255) NOT NULL,
	ProductType INT NOT NULL,
    ProductSpec NVARCHAR(255),
    ProductAcquirer NVARCHAR(255),
    ProductManufacturer NVARCHAR(255),
    ProductCost DECIMAL,
    ProductCostTax DECIMAL,
    ProductFactoryPrice DECIMAL,
    ProductFactoryPriceTax DECIMAL,
    ProductRetailPrice DECIMAL,
    ProductRetailPriceTax DECIMAL,
    ProductPrice DECIMAL,
    ProductPriceTax DECIMAL,
	Price DECIMAL NOT NULL,
	Tax DECIMAL NOT NULL,
    BarCode VARCHAR(255),
    QrCode VARCHAR(255),
    Other NVARCHAR(255),
    CreatedDate DATETIME DEFAULT NOW() NOT NULL,
	Creater VARCHAR(100) DEFAULT '' NOT NULL,
	LastUpdatedDate DATETIME DEFAULT NOW() NOT NULL,
	LastUpdater VARCHAR(100) DEFAULT '' NOT NULL,
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(idx),
	FOREIGN KEY (ProductType) REFERENCES TSN_ProductType (Idx)
);

CREATE TABLE TSN_OrderTableProduct(
	Idx INT NOT NULL AUTO_INCREMENT,
	OrderId INT NOT NULL,
	Sequence INT NOT NULL,
    ProductId INT NOT NULL,
    ProductAmount DECIMAL NOT NULL,
    ProductTotalPrice DECIMAL NOT NULL,
    ProductMoney DECIMAL NOT NULL,
	CreatedDate DATETIME DEFAULT NOW() NOT NULL,
	Creater VARCHAR(100) DEFAULT '' NOT NULL,
	LastUpdatedDate DATETIME DEFAULT NOW() NOT NULL,
	LastUpdater VARCHAR(100) DEFAULT '' NOT NULL,
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(Idx),
	FOREIGN KEY (OrderId) REFERENCES TSN_OrderTable (Idx),
	FOREIGN KEY (ProductId) REFERENCES TSN_Product (Idx)
);








-----------------ここまで。










CREATE TABLE TSN_Bill(
	Idx INT NOT NULL AUTO_INCREMENT,
	InOrderCompany NVARCHAR(255),
	InOrderRepresentative NVARCHAR(255),
	InOrderPost NVARCHAR(255),
	InOrderAddress NVARCHAR(255),
	OrderCompany NVARCHAR(255),
	OrderPost NVARCHAR(255),
	OrderAddress NVARCHAR(255),
	BillDate DATETIME,
	BillMoney DECIMAL,
	BillTax DECIMAL,
	BillTotal DECIMAL,
	Creater VARCHAR(255),
	CreateDate DATETIME,
	State VARCHAR(255),
	CompanyCode VARCHAR(255),
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(Idx)
)

CREATE TABLE TSN_Board(
	Idx INT NOT NULL AUTO_INCREMENT,
	Num INT,
	Type VARCHAR(255),
	Title NVARCHAR(255),
	Context NVARCHAR(255),
	Creater VARCHAR(255),
	CreateDate DATETIME,
	State VARCHAR(255),
	
	PRIMARY KEY(Idx)
)

CREATE TABLE TSN_Cargo(
	Idx INT NOT NULL AUTO_INCREMENT,
	Productindex INT,
	Productinput DECIMAL,
	Productoutput DECIMAL,
	Productmoney DECIMAL,
	Creater VARCHAR(255),
	Createdate DATETIME,
	State VARCHAR(255),
	Companycode VARCHAR(255),
	
	PRIMARY KEY(Idx)
)

-- What is CodeCreator??

--Which is the key?? -> CodeKey
CREATE TABLE MST_CodeMaster(
	TblName VARCHAR(255),
	CodeKey VARCHAR(255),
	CodeName_K VARCHAR(255),
	CodeName_J VARCHAR(255)
	
	PRIMARY KEY(CodeKey)
)

CREATE TABLE TSN_Comment(
	Idx INT NOT NULL AUTO_INCREMENT,
	Boardidx INT,
	Context VARCHAR(255),
	Creater VARCHAR(255),
	Createdate VARCHAR(255),
	State VARCHAR(255),
	
	PRIMARY KEY(Idx)
)



--Which is the key?? -> UserId
CREATE TABLE Connect(
	UserId VARCHAR(255),
	ConnectDate DATETIME,
	State VARCHAR(255),
	Language VARCHAR(255),
    IpAddress VARCHAR(255),
	
	PRIMARY KEY(UserId)
)

CREATE TABLE TSN_DeliveryTable(
	Idx INT NOT NULL AUTO_INCREMENT,
	OrderCompany VARCHAR(255),
	OrderAddress VARCHAR(255),
	OrderSaveDate DateTime,
	InOrderCompany VARCHAR(255),
	InOrderRepresentative VARCHAR(255),
	CreateDate DateTime,
	Creater VARCHAR(255),
	State VARCHAR(255),
	CompanyCode VARCHAR(255),
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(Idx)
)

CREATE TABLE TSN_DeliveryTableSub(
	Idx INT NOT NULL AUTO_INCREMENT,
    DeliveryKey INT,
    Number INT,
    ProductIndex INT,
    ProductSpec NVARCHAR(255),
    ProductType NVARCHAR(255),
    ProductAmount DECIMAL,
    ProductPrice DECIMAL,
    ProductVat DECIMAL,
    ProductOther NVARCHAR(255),
    CreateDate DECIMAL,
    Creater VARCHAR(255),
    State VARCHAR(255),
    CompanyCode VARCHAR(255),
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(Idx)
)

CREATE TABLE TSN_Document(
	Idx INT NOT NULL AUTO_INCREMENT,
	DocumentCode NVARCHAR(255),
	DocumentType NVARCHAR(255),
	DocumentIndex INT,
	CreateDate DATETIME,
	Creater VARCHAR(255),
	State VARCHAR(255),
	CompanyCode VARCHAR(255),
	Creater_En VARCHAR(255),
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(Idx)
)



CREATE TABLE TSN_ProductFlow(
	Idx INT NOT NULL AUTO_INCREMENT,
    ProductIndex INT,
    ProductAmount DECIMAL,
    ProductBuyPrice DECIMAL,
	ProductSellPrice DECIMAL,
	CreteDate DATETIME,
    Creater VARCHAR(255),
    ApplyType INT,
    State VARCHAR(255),
    CompanyCode VARCHAR(255),
    Etc VARCHAR(255),
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(idx)
)