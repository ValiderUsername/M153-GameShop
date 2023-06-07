use GamesShop

insert into genres (Name)
values ('Testgenre')

insert into Shops (Name)
values ('Testshop')

select * from Genres
where Name = 'Testgenre'

select * from Shops
where Name = 'Testshop'

exec DeleteUnusedData

select * from Genres
where Name = 'Testgenre'

select * from Shops
where Name = 'Testshop'

go

select * from ComparePrices('Elden Ring')