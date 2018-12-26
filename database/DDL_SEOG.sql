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
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY (CODE)
);

CREATE TABLE MST_ActionRole(
	CODE CHAR(4) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
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
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
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
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
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
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY (CODE)
);

INSERT INTO MST_OrderType (CODE, NAME) VALUES('01', N'発注');
INSERT INTO MST_OrderType (CODE, NAME) VALUES('02', N'受注');
INSERT INTO MST_OrderType (CODE, NAME) VALUES('03', N'生産');
INSERT INTO MST_OrderType (CODE, NAME) VALUES('99', N'その他');

CREATE TABLE MST_PayType(
	CODE CHAR(2) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
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
	CompanyIdx INT(5) NOT NULL,
	ProductIdx INT(5) NOT NULL,
	BillType VARCHAR(255),
	BillDate DATETIME,
	BillMoney DECIMAL,
	BillTax DECIMAL,
	BillTotal DECIMAL,
	Creater VARCHAR(255),
	CreateDate DATETIME,
	State VARCHAR(255),
	CompanyCode VARCHAR(255),
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(Idx),
	FOREIGN KEY(CompanyIdx) REFERENCES TSN_Company (Idx),
	FOREIGN KEY(ProductIdx) REFERENCES TSN_Product (Idx),
	FOREIGN KEY(BillType) REFERENCES MST_BillType (CODE),
	FOREIGN KEY(CompanyCode) REFERENCES MST_CodeMaster (CodeKey),
	FOREIGN KEY(State) REFERENCES MST_Bill(CODE)
)

CREATE TABLE MST_BILL(
	CODE VARCHAR(255) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CODE)
)

-- Insert into MST_Bill
INSERT INTO MST_Bill (CODE, NAME) VALUES('01', N' 請求申請');
INSERT INTO MST_Bill (CODE, NAME) VALUES('02', N' 請求中');
INSERT INTO MST_Bill (CODE, NAME) VALUES('03', N' 請求済');
INSERT INTO MST_Bill (CODE, NAME) VALUES('04', N' 未支払');
INSERT INTO MST_Bill (CODE, NAME) VALUES('05', N' 支払済');

--請求の対象
CREATE TABLE MST_BillType(
	CODE VARCHAR(255) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CODE)
)

-- Insert into MST_BillType
INSERT INTO MST_BillType (CODE, NAME) VALUES('01', N' 購買費用');
INSERT INTO MST_BillType (CODE, NAME) VALUES('02', N' 運送費用');
INSERT INTO MST_BillType (CODE, NAME) VALUES('03', N' 調達費用');
INSERT INTO MST_BillType (CODE, NAME) VALUES('04', N' 管理費用');

CREATE TABLE TSN_BillSub(
	Idx INT NOT NULL AUTO_INCREMENT,
	StartDate DATETIME,
	EndDate DATETIME,
	InvoiceType VARCHAR(255),
	SendingMethod VARCHAR(255),
	State VARCHAR(255),
	Hits DECIMAL,
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(Idx),
	FOREIGN KEY(Idx) REFERENCES TSN_Bill(Idx),
	FOREIGN KEY(InvoiceType) REFERENCES MST_InvoiceType(CODE),
	FOREIGN KEY(SendingMethod) REFERENCES MST_SendingMethod(CODE),
	FOREIGN KEY(State) REFERENCES MST_BillSub(CODE)
)

--請求書種類
CREATE TABLE MST_InvoiceType(
	CODE VARCHAR(255) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CODE)
)

-- Insert into MST_InvoiceType
INSERT INTO MST_InvoiceType (CODE, NAME) VALUES('01', N' 資材請求');
INSERT INTO MST_InvoiceType (CODE, NAME) VALUES('02', N' 集荷時の発生金請求');
INSERT INTO MST_InvoiceType (CODE, NAME) VALUES('03', N' 支給請求');

--送付方式
CREATE TABLE MST_SendingMethod(
	CODE VARCHAR(255) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CODE)
)

-- Insert into MST_SendingMethod
INSERT INTO MST_SendingMethod (CODE, NAME) VALUES('01', N' FAX');
INSERT INTO MST_SendingMethod (CODE, NAME) VALUES('02', N' 郵送');
INSERT INTO MST_SendingMethod (CODE, NAME) VALUES('03', N' EDI');

--請求書作成及び送付要否
CREATE TABLE MST_BillSub(
	CODE VARCHAR(255) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CODE)
)

-- Insert into MST_BillSub
INSERT INTO MST_BillSub (CODE, NAME) VALUES('01', N' 作成中');
INSERT INTO MST_BillSub (CODE, NAME) VALUES('02', N' 送付済');
INSERT INTO MST_BillSub (CODE, NAME) VALUES('03', N' 受領済');

CREATE TABLE TSN_Board(
	Idx INT NOT NULL AUTO_INCREMENT,
	Num INT,
	Type VARCHAR(255),
	Title NVARCHAR(255),
	Context NVARCHAR(255),
	Creater VARCHAR(255),
	CreateDate DATETIME,
	State VARCHAR(255),
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(Idx)
	FOREIGN KEY(State) REFERENCES MST_Board(CODE)
)

CREATE TABLE MST_Board(
	CODE VARCHAR(255) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CODE)
)

-- Insert into MST_Board
INSERT INTO MST_Board (CODE, NAME) VALUES('01', N'新規');
INSERT INTO MST_Board (CODE, NAME) VALUES('02', N'更新');
INSERT INTO MST_Board (CODE, NAME) VALUES('03', N'削除');
INSERT INTO MST_Board (CODE, NAME) VALUES('04', N'公開');
INSERT INTO MST_Board (CODE, NAME) VALUES('05', N'非公開');

CREATE TABLE TSN_Cargo(
	Idx INT NOT NULL AUTO_INCREMENT,
	ProductIndex INT(5) NOT NULL,
	ProductInput DECIMAL,
	ProductOutput DECIMAL,
	ProductMoney DECIMAL,
	Creater VARCHAR(255),
	Createdate DATETIME,
	State VARCHAR(255),
	CompanyCode VARCHAR(255),
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(Idx),
	FOREIGN KEY(ProductIndex) REFERENCES TSN_Product(Idx),
	FOREIGN KEY(CompanyCode) REFERENCES MST_CodeMaster (CodeKey),
	FOREIGN KEY(State) REFERENCES MST_Cargo(CODE)
)

CREATE TABLE TSN_CargoSub(
	Idx INT NOT NULL AUTO_INCREMENT,
	AreaCode VARCHAR(255),
	AreaName NVARCHAR(255),
	CargoSize VARCHAR(255),
	State NVARCHAR(255),
	Creater VARCHAR(255),
	CreateDate DATETIME,
	CompanyCode VARCHAR(255),
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(Idx),
	FOREIGN KEY(Idx) REFERENCES TSN_Cargo(Idx),
	FOREIGN KEY(State) REFERENCES TSN_Cargo(State),
	FOREIGN KEY(AreaCode) REFERENCES MST_Area(CODE)
)

CREATE TABLE MST_Cargo(
	CODE VARCHAR(255) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CODE)
)

--Insert into MST_Cargo
INSERT INTO MST_Cargo (CODE, NAME) VALUES('01', N'商品入庫');
INSERT INTO MST_Cargo (CODE, NAME) VALUES('02', N'商品出庫');
INSERT INTO MST_Cargo (CODE, NAME) VALUES('04', N'保管中');
INSERT INTO MST_Cargo (CODE, NAME) VALUES('05', N'取り下げ');

CREATE TABLE MST_Area(
	CODE VARCHAR(255) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CODE)
)

--Insert into MST_Area
INSERT INTO MST_Area (CODE, NAME) VALUES('01', N'北海道');
INSERT INTO MST_Area (CODE, NAME) VALUES('02', N'東北');
INSERT INTO MST_Area (CODE, NAME) VALUES('03', N'関東');
INSERT INTO MST_Area (CODE, NAME) VALUES('04', N'中部');
INSERT INTO MST_Area (CODE, NAME) VALUES('05', N'関西');
INSERT INTO MST_Area (CODE, NAME) VALUES('06', N'中国');
INSERT INTO MST_Area (CODE, NAME) VALUES('07', N'四国');
INSERT INTO MST_Area (CODE, NAME) VALUES('08', N'九州・沖縄');

CREATE TABLE TSN_Transport (
	Idx INT NOT NULL AUTO_INCREMENT,
	ProductIndex INT(5) NOT NULL,
	TransportType NVARCHAR(255),
	TransportCost DECIMAL,
	TransportStart DATETIME,
	TransportEnd DATETIME,
	State VARCHAR(255),
	Creater VARCHAR(255),
	CreateDate DATETIME,
	CompanyCode VARCHAR(255)
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(Idx),
	FOREIGN KEY(ProductIndex) REFERENCES TSN_Cargo(ProductIndex),
	FOREIGN KEY(State) REFERENCES MST_Transport(CODE)
)

CREATE TABLE MST_Transport(
	CODE VARCHAR(255) NOT NULL,
	NAME NVARCHAR(255) NOT NULL,
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CODE)
)

--Insert into MST_Transport
INSERT INTO MST_Transport (CODE, NAME) VALUES('01', N'運送待機');
INSERT INTO MST_Transport (CODE, NAME) VALUES('02', N'運送中');
INSERT INTO MST_Transport (CODE, NAME) VALUES('03', N'運送済');
INSERT INTO MST_Transport (CODE, NAME) VALUES('04', N'運送遅延');
INSERT INTO MST_Transport (CODE, NAME) VALUES('05', N'運送中断');

--Which is the key?? -> CodeKey
CREATE TABLE MST_CodeMaster(
	TblName VARCHAR(255),
	CodeKey VARCHAR(255),
	CodeName_K VARCHAR(255),
	CodeName_J VARCHAR(255),
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CodeKey)
)

CREATE TABLE TSN_Comment(
	Idx INT NOT NULL AUTO_INCREMENT,
	BoardIdx INT,
	Context VARCHAR(255),
	Creater VARCHAR(255),
	Createdate VARCHAR(255),
	State VARCHAR(255),
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(Idx),
	FOREIGN KEY(BoardIdx) REFERENCES TSN_Board(Idx),
	FOREIGN KEY(State) REFERENCES MST_Comment(CODE)
)

CREATE TABLE MST_Comment(
	CODE VARCHAR(255) NOT NULL,
	NAME NVARCHAR(255) NOT NULL, 
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CODE)
)

-- Insert into MST_Comment
INSERT INTO MST_Comment (CODE, NAME) VALUES('01', N'新規');
INSERT INTO MST_Comment (CODE, NAME) VALUES('03', N'更新');
INSERT INTO MST_Comment (CODE, NAME) VALUES('03', N'削除');

--Which is the key?? -> UserId
CREATE TABLE Connect(
	UserId VARCHAR(255),
	ConnectDate DATETIME,
	State VARCHAR(255),
	Language VARCHAR(255),
    IpAddress VARCHAR(255),
	
	PRIMARY KEY(UserId),
	FOREIGN KEY(State) REFERENCES MST_Connect(CODE)
)

CREATE TABLE MST_Connect(
	CODE VARCHAR(255) NOT NULL,
	NAME NVARCHAR(255) NOT NULL, 
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CODE)
)

-- Insert into MST_Connect
INSERT INTO MST_Connect (CODE, NAME) VALUES('01', N'接続中');
INSERT INTO MST_Connect (CODE, NAME) VALUES('02', N'非接続');

CREATE TABLE TSN_DeliveryTable(
	Idx INT NOT NULL AUTO_INCREMENT,
	TransportState VARCHAR(255),
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
	
	PRIMARY KEY(Idx),
	FOREIGN KEY(TransportState) REFERENCES TSN_Transport (State),
	FOREIGN KEY(CompanyCode) REFERENCES MST_CodeMaster (CodeKey),
	FOREIGN KEY(State) REFERENCES MST_Delivery(CODE)
)

CREATE TABLE TSN_DeliveryTableSub(
	Idx INT NOT NULL AUTO_INCREMENT,
    ProductIndex INT NOT NULL,
	DeliveryKey INT,
    Number INT,
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
	
	PRIMARY KEY(Idx),
	FOREIGN KEY(ProductIndex) REFERENCES TSN_Cargo (ProductIndex),
	FOREIGN KEY(ProductAmount) REFERENCES TSN_OrderTableProduct (ProductAmount),
	FOREIGN KEY(CompanyCode) REFERENCES MST_CodeMaster (CodeKey),
	FOREIGN KEY(State) REFERENCES TSN_DeliveryTable(State)
)

CREATE TABLE MST_DeliveryTable(
	CODE VARCHAR(255) NOT NULL,
	NAME NVARCHAR(255) NOT NULL, 
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CODE)
)

--Insert into MST_Delivery
-- When TransportState is 01 or 02.
INSERT INTO MST_Delivery (CODE, NAME) VALUES('01', N'配送待機');
-- When TransportState is 03.　
INSERT INTO MST_Delivery (CODE, NAME) VALUES('02', N'配送中');  
INSERT INTO MST_Delivery (CODE, NAME) VALUES('04', N'配送済');
-- When TransportState is 04 or Delivery is delayed.
INSERT INTO MST_Delivery (CODE, NAME) VALUES('03', N'配送遅延');
-- When TransportState is 05
INSERT INTO MST_Delivery (CODE, NAME) VALUES('05', N'配送中断');
-- When Delivery is Canceled by OrderCompany or InOrderCompany.
INSERT INTO MST_Delivery (CODE, NAME) VALUES('06', N'取り下げ');


--What is Document specifically?
CREATE TABLE TSN_Document(
	Idx INT NOT NULL AUTO_INCREMENT,
	DocumentCode NVARCHAR(255),
	DocumentType VARCHAR(255),
	DocumentIndex INT,
	CreateDate DATETIME,
	Creater VARCHAR(255),
	State VARCHAR(255),
	CompanyCode VARCHAR(255),
	Creater_En VARCHAR(255),
	IsDeleted BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(Idx),
	FOREIGN KEY(State) REFERENCES MST_Document(CODE),
	FOREIGN KEY(CompanyCode) REFERENCES MST_CodeMaster (CodeKey),
	FOREIGN KEY(DocumentType) REFERENCES MST_DocumentType(CODE)
)

CREATE TABLE MST_Document(
	CODE VARCHAR(255) NOT NULL,
	NAME NVARCHAR(255) NOT NULL, 
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CODE)
)

--Insert into MST_Document
INSERT INTO MST_Document (CODE, NAME) VALUES('01', N'xls');
INSERT INTO MST_Document (CODE, NAME) VALUES('02', N'xlsx');
INSERT INTO MST_Document (CODE, NAME) VALUES('03', N'pdf');
INSERT INTO MST_Document (CODE, NAME) VALUES('04', N'ppt');
INSERT INTO MST_Document (CODE, NAME) VALUES('05', N'pptx');
INSERT INTO MST_Document (CODE, NAME) VALUES('06', N'doc');
INSERT INTO MST_Document (CODE, NAME) VALUES('07', N'hwp');
INSERT INTO MST_Document (CODE, NAME) VALUES('07', N'txt');
INSERT INTO MST_Document (CODE, NAME) VALUES('08', N'zip');
INSERT INTO MST_Document (CODE, NAME) VALUES('09', N'tar');
INSERT INTO MST_Document (CODE, NAME) VALUES('10', N'rar');
INSERT INTO MST_Document (CODE, NAME) VALUES('11', N'7z');

CREATE TABLE MST_DocumentType(
	CODE VARCHAR(255) NOT NULL,
	NAME NVARCHAR(255) NOT NULL, 
	IsActive BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CODE)
)

--Insert into MST_DocumentType
INSERT INTO MST_DocumentType (CODE, NAME) VALUES('01', N'見積書');
INSERT INTO MST_DocumentType (CODE, NAME) VALUES('02', N'注文処理書');
INSERT INTO MST_DocumentType (CODE, NAME) VALUES('03', N'倉庫管理一覧');
INSERT INTO MST_DocumentType (CODE, NAME) VALUES('04', N'在庫管理一覧');
INSERT INTO MST_DocumentType (CODE, NAME) VALUES('05', N'生産計画書');
INSERT INTO MST_DocumentType (CODE, NAME) VALUES('06', N'設備管理一覧');
INSERT INTO MST_DocumentType (CODE, NAME) VALUES('07', N'購買要求書');
INSERT INTO MST_DocumentType (CODE, NAME) VALUES('08', N'納品業者評価書');
INSERT INTO MST_DocumentType (CODE, NAME) VALUES('09', N'納品日程管理書');
INSERT INTO MST_DocumentType (CODE, NAME) VALUES('10', N'財務会計報告書');
INSERT INTO MST_DocumentType (CODE, NAME) VALUES('11', N'資産会計報告書');
INSERT INTO MST_DocumentType (CODE, NAME) VALUES('12', N'管理会計報告書');
INSERT INTO MST_DocumentType (CODE, NAME) VALUES('13', N'納期計画書');
INSERT INTO MST_DocumentType (CODE, NAME) VALUES('14', N'資材管理一覧');

--What is ProductBuyPrice, ProductSellPrice
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
	
	PRIMARY KEY(idx),
	FOREIGN KEY(ProductIndex) REFERENCES TSN_Product (Idx),
	FOREIGN KEY(ProductAmount) REFERENCES TSN_DeliveryTableSub (ProductAmount),
	FOREIGN KEY(CompanyCode) REFERENCES MST_CodeMaster (CodeKey),
	FOREIGN KEY(State) REFERENCES MST_State(CODE)
)

--List of Master Tables
CREATE TABLE MST_MasterTblList(
	CODE CHAR(2) NOT NULL,
	NAME NVARCHAR(255) NOT NULL, 
	IsUsed BOOLEAN DEFAULT FALSE NOT NULL,
	
	PRIMARY KEY(CODE)
)