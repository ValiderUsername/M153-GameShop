use master

go

drop database if exists GamesShop
create database GamesShop

go

use GamesShop

go

create table Genres(
	GenreID int identity(1,1),
	Name varchar(50),
	primary key (GenreID)
);

create table Shops(
	ShopID int identity(1,1),
	Name varchar(50),
	primary key (ShopID)
);

create table Company(
	CompanyID int identity(1, 1),
	Name varchar(50),
	primary key (CompanyID),
)

create table Games (
	GameID int identity(1,1),
	Name varchar(50),
	Description varchar(5000),
	Trailer varchar(100),
	ReleaseDate Date,
	Requirements varchar(5000),
	DeveloperID int,
	PublisherID int,
	primary key (GameID),
	constraint FK_Games_Developer foreign key (DeveloperID) references Company(CompanyID),
	constraint FK_Games_Publisher foreign key (PublisherID) references Company(CompanyID)
);

create table Game_Genre (
	GameID int,
	GenreID int,
	constraint PK_GameGenre primary key (GameID, GenreID),
	constraint FK_GameGenre_Game foreign key (GameID) references Games(GameID),
	constraint FK_GameGenre_Genre foreign key (GenreID) references Genres(GenreID)
);

create table Game_Shop(
	Price int,
	GameID int,
	ShopID int,
	constraint PK_GameShop primary key (GameID, ShopID),
	constraint FK_GameShop_Game foreign key (GameID) references Games(GameID),
	constraint FK_GameShop_Shop foreign key (ShopID) references Shops(ShopID)
);