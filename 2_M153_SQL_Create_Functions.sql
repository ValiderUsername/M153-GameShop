--Procedure: InsertNewGame, DeleteUnusedData
--Functions: ComparePrices, SplitStrings

use GamesShop
go

drop function if exists ComparePrices
drop function if exists SplitStrings
drop procedure if exists InsertNewGame
drop procedure if exists DeleteUnusedData
go

--Function call: SELECT * FROM ComparePrices('Name of the Game');
create Function ComparePrices
(
    @gameName varchar(50)
)
returns @result table (
    ShopName varchar(50),
    Price int
)
as
begin
    insert into @result (ShopName, Price)
    select Shops.Name, Game_Shop.Price
    from Games
    JOIN Game_Shop on Games.GameID = Game_Shop.GameID
    JOIN Shops on Game_Shop.ShopID = Shops.ShopID
    where Games.Name = @gameName
    order by Game_Shop.Price asc;

    return;
end;

go

--Select * from SplitStrings('List of items like ('item 1, item 2')')
create Function SplitStrings
(
    @StringList varchar(50)
)
returns @result table (
    itemName varchar(50)
)
as
begin
    declare @itemName varchar(50);

    while len(@StringList) > 0
    begin
        if charindex(',', @StringList) > 0
        begin
            set @itemName = substring(@StringList, 1, charindex(',', @StringList)-1);
            set @StringList = substring(@StringList, charindex(',', @StringList)+1, len(@StringList));
        end
        else
        begin
            set @itemName = @StringList;
            set @StringList = '';
        end
        insert into @result (ItemName) values (@itemName);
    end
	return
end;

go

create procedure InsertNewGame
(
    @gameName varchar(50),
    @description varchar(500),
    @trailer varchar(100),
    @releaseDate date,
    @requirements varchar(500),
    @developer varchar(50),
    @publisher varchar(50),
    @genresList varchar(max),
    @shopsList varchar(max)
)
as
begin

	--insert Dev if its not in Company
	if @developer not in (select name from Company)
	begin
		insert into Company (Name)
		values (@developer)
	end

	--insert Publisher if its not in Company
	if @publisher not in (select name from Company)
	begin
		insert into Company (Name)
		values (@publisher)
	end

    --Inserting game informations
    insert into Games (Name, Description, Trailer, ReleaseDate, Requirements, DeveloperID, PublisherID)
    values (@gameName, @description, @trailer, @releaseDate, @requirements, (select top 1 CompanyID from Company where Name = @developer), (select top 1 CompanyID from Company where Name = @publisher));

    --Get the GameID
    declare @gameID int = @@IDENTITY;

    --Parse the list of genres into a table
    declare @genres table (
        GenreName varchar(50)
    );

	insert into @genres Select * from SplitStrings(@genresList)

	--insert genres if they do not exists
    insert into Genres (Name)
    select distinct GenreName from @genres
    where GenreName NOT IN (select Name from Genres);

    --conecting Game to Genres
    insert into Game_Genre (GameID, GenreID)
    select @gameID, GenreID
    from Genres
    where Name IN (SELECT GenreName from @genres);

    --Parse the list of shops
    declare @shops table (
        ShopName varchar(50)
    );

	insert into @shops Select * from SplitStrings(@shopsList)

	--insert Shops if they do not exists
    insert into Shops (Name)
    select distinct ShopName from @shops
    where ShopName NOT IN (select Name from Shops);

    --conecting Game to Shops
    insert into Game_Shop (Price, GameID, ShopID)
    select 0, @gameID, ShopID
    from Shops
    where Name IN (select ShopName from @shops);
end;

go

create procedure DeleteUnusedData
as
begin
	delete from Genres
	where GenreID not in (
		select GenreID from Game_Genre
	)

	delete from Shops
	where ShopID not in (
		select ShopID from Game_Shop
	)

end;
