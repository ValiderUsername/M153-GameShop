use GamesShop;

select Games.GameID, Games.Name as GameName, Games.Description, Games.Trailer, Games.ReleaseDate, Games.Requirements, Dev.Name as Developer, Pub.Name as Company, coalesce(Genres.GenreList, '') as Genres, coalesce(Shops.ShopList, '') as Shops
from Games
left join (
    select Game_Genre.GameID, string_agg(Genres.Name, ', ') as GenreList
    from Game_Genre
    join Genres on Game_Genre.GenreID = Genres.GenreID
    group by Game_Genre.GameID
) Genres on Games.GameID = Genres.GameID
left join (
    select Game_Shop.GameID, string_agg(Shops.Name, ', ') as ShopList
    from Game_Shop
    join Shops on Game_Shop.ShopID = Shops.ShopID
    group by Game_Shop.GameID
) Shops on Games.GameID = Shops.GameID
left join Company Dev on Games.DeveloperID = Dev.CompanyID
left join Company Pub on Games.PublisherID = Pub.CompanyID
