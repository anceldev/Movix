//
//  PreviewData.swift
//  Movix
//
//  Created by Ancel Dev account on 28/4/25.
//

import Foundation

struct PreviewData {
    static var user = User(
        id: UUID(),
        name: "dani",
        username: "daniMovix",
        email: "danimovix@mail.com",
        avatarPath: "avatars/054B05D9-42F6-4E7C-901B-BE82A46E7C07"
    )
    
    static let that70show = TvSerie(
        isAdult: false,
        backdropPath: "/3zRUiH8erHIgNUBTj05JT00HwsS.jpg",
        releaseDate: DateComponents(year: 1998, month: 8, day: 23).date,
        genres: [
            Genre(id: 35, name: "Comedy"),
            Genre(id: 10751, name: "Family"),
            Genre(id: 18, name: "Drama")
        ],
        genreIds: [35, 10751, 18],
        homePage: URL(string: ""),
        id: 52,
        inProduction: false,
        title: "That '70s Show",
        numberOfSeasons: 8,
        numberOfEpisodes: 200,
        originalName: "That '70s Show",
        overview: "Crank up the 8-track and flash back to a time when platform shoes and puka shells were all the rage in this hilarious retro-sitcom. For Eric, Kelso, Jackie, Hyde, Donna and Fez, a group of high school teens who spend most of their time hanging out in Eric’s basement, life in the ‘70s isn’t always so groovy. But between trying to figure out the meaning of life, avoiding their parents, and dealing with out-of-control hormones, they’ve learned one thing for sure: they’ll always get by with a little help from their friends.",
        posterPath: "/laEZvTqM80UaplUaDSCCbWhlyEV.jpg",
        seasons: [
            TvSeason(id: 94, airDate: "1998-08-23", name: "Season 1", overview: "", posterPath: "/d3jLBFnqub6rYXifgus5fkNt2H6.jpg", seasonNumer: 1, voteAverage: 7.5, episodeCount: 25),
            TvSeason(id: 93, airDate: "1999-09-28", name: "Season 2", overview: "", posterPath: "/6H4WTKooT5cBjFCmNIJKHAJDUEY.jpg", seasonNumer: 2, voteAverage: 7.4, episodeCount: 26),
            TvSeason(id: 92, airDate: "2000-10-03", name: "Season 3", overview: "", posterPath: "/yskd1fDr8CKoX2T0vUKhi8ZB1mp.jpg", seasonNumer: 3, voteAverage: 7.4, episodeCount: 25),
            TvSeason(id: 91, airDate: "2001-09-25", name: "Season 4", overview: "", posterPath: "/buXFywjr5vT4E1USc5hVoRcIaOt.jpg", seasonNumer: 4, voteAverage: 7.3, episodeCount: 25)
        ],
        voteAverage: 7.9
    )
    
    static let seasonPreview = TvSeason(
            id: 94,
            airDate: "1998-08-23",
            name: "Season 1",
            overview: "",
            posterPath: "/d3jLBFnqub6rYXifgus5fkNt2H6.jpg",
            seasonNumer: 1,
            voteAverage: 7.5,
            episodeCount: 25,
            episodes: [
                PreviewData.pilotEpisode,
                PreviewData.regularEpisode
            ]
        )
    
    static let pilotEpisode = TvEpisode(
        id: 1596,
        airDate: DateFormatter.yearMonthDay.date(from: "1998-08-23"),
        episodeNumber: 1,
        name: "That '70s Pilot",
        overview: "While Eric Forman is swiping beer for his best friends Donna Pinciotti, Michael Kelso, and Steven Hyde, his parents Red and Kitty hint that he may be getting the old Vista Cruiser.",
        stillPath: "/rCu8eTlNaYOydOegoOXEDItspE8.jpg",
        seasonNumber: 1,
        voteAverage: 7.2,
        runtime: 23
    )
    
    // Preview based on a regular episode
    static let regularEpisode = TvEpisode(
        id: 1595,
        airDate: DateFormatter.yearMonthDay.date(from: "1998-08-30"),
        episodeNumber: 2,
        name: "Eric's Birthday",
        overview: "Eric's 17th birthday is coming up and he really doesn't want a party.",
        stillPath: "/gD8vFYJwqneVsosxUedsrNEO3rf.jpg",
        seasonNumber: 1,
        voteAverage: 7.3,
        runtime: 23
    )
    static let review = Review(
        id: "1",
        author: "whatever",
        authorDetails: .init(name: "whatever", username: "what_ever", avatarPath: "/zDsL1byzwuiJvjhqW2hT6yw5OxU.jpg"),
        content: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Quo, voluptatem! Quasi, voluptates! Quo, voluptatem! Quo, voluptatem!",
        createdAt: .now
    )
    
    static var movie: Movie = .init(
        id: 533535,
        title: "Deadpool & Wolverine",
        originalTitle: "Deadpool & Wolverine",
        overview: "A listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine.",
        runtime: 128,
        releaseDate: .now,
        posterPath: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
        backdropPath: "/9l1eZiJHmhr5jIlthMdJN5WYoff.jpg",
        genres: [.init(id: 1, name: "Action"), .init(id: 2, name: "Hero")],
        budget: 250000000,
        homepageURL: URL(string: "https://www.marvel.com/movies/deadpool-and-wolverine"),
        popularity: 2178.995,
        voteAverage: 8.202,
        voteCount: 141,
        isAdult: false,
        originCountry: ["US"],
        status: "Released"
    )
    
    static var people: People = .init(
        id: 10859,
        name: "Ryan Reynolds",
        biography: "Ryan Rodney Reynolds (born October 23, 1976) is a Canadian actor and film producer. He began his career starring in the Canadian teen soap opera Hillside (1991–1993), and had minor roles before landing the lead role on the sitcom Two Guys and a Girl between 1998 and 2001. Reynolds then starred in a range of films, including comedies such as National Lampoon's Van Wilder (2002), Waiting... (2005), and The Proposal (2009). He also performed in dramatic roles in Buried (2010), Woman in Gold (2015), and Life (2017), starred in action films such as Blade: Trinity (2004), Green Lantern (2011), 6 Underground (2019) and Free Guy (2021), and provided voice acting in the animated features The Croods (2013), Turbo (2013), Pokémon: Detective Pikachu (2019) and The Croods: A New Age (2020).\n\nReynolds' biggest commercial success came with the superhero films Deadpool (2016) and Deadpool 2 (2018), in which he played the title character. The former set numerous records at the time of its release for an R-rated comedy and his performance earned him nominations at the Critics' Choice Movie Awards and the Golden Globe Awards.",
        birthday: .now,
        gender: .male,
        homepage: nil,
        popularity:  172.40,
        profilePath: URL(string: "https://image.tmdb.org/t/p/w185/2Orm6l3z3zukF1q0AgIOUqvwLeB.jpg")
    )
    static var movieLists: [MediaList] = [
        .init(name: "Marvel", description: "Marvel favorite movies", listType: .movie, owner: Self.user, isPublic: false)
    ]

    static var cast: [Cast] = [
        Cast(id: 585982, originalName: "Roberto Gómez Bolaños", profilePath: URL(string: "https://image.tmdb.org/t/p/w185/bwSQeMmSuYd5IKZdjOtbrsfZ3jy.jpg")),
        Cast(id: 1212382, originalName: "Ramón Valdés", profilePath: URL(string: "https://image.tmdb.org/t/p/w185/qX0PkyoHTHA3IDCteeAfAKTfK2Z.jpg")),
        Cast(id: 1212383, originalName: "Carlos Villagrán", profilePath: URL(string: "https://image.tmdb.org/t/p/w185/dqXt3NlqiGEhPif49ZXU0y34EFv.jpg")),
        Cast(id: 1055889, originalName: "María Antonieta de las Nieves", profilePath: URL(string: "https://image.tmdb.org/t/p/w185/tl8ZHvWrMjieeIxbysQDiFxXUw0.jpg")),
        Cast(id: 1212381, originalName: "Florinda Meza García", profilePath: URL(string: "https://image.tmdb.org/t/p/w185/x6Ac8fSi0AS5MQjhCseRU5TgQvz.jpg")),
        Cast(id: 31324, originalName: "Rubén Aguirre", profilePath: URL(string: "https://image.tmdb.org/t/p/w185/fgdJiRzr6yOSFnT7tYipfnIbD37.jpg")),
        Cast(id: 51906, originalName: "Edgar Vivar", profilePath: URL(string: "https://image.tmdb.org/t/p/w185/frijAScYO4vIbFAMzPDJrEiklNb.jpg")),
        Cast(id: 940990, originalName: "Angelines Fernández", profilePath: URL(string: "https://image.tmdb.org/t/p/w185/tHPKmMUMUlmVO6i1j4FSuohJHPQ.jpg")),
        Cast(id: 944520, originalName: "Horacio Gómez Bolaños", profilePath: URL(string: "https://image.tmdb.org/t/p/w185/z8w7A0hj7YnMJtHaA20tMfs9ZZO.jpg")),
        Cast(id: 1764955, originalName: "Raúl 'Chato' Padilla", profilePath: URL(string: "https://image.tmdb.org/t/p/w185/dejRz0bndzDQfN56FpVulH0p2jh.jpg")),
        Cast(id: 139576, originalName: "Héctor Bonilla", profilePath: URL(string: "https://image.tmdb.org/t/p/w185/hJLMHwbFgh25yvSw0IgqQAC2Nco.jpg")),
        Cast(id: 1506547, originalName: "Abraham Stavans", profilePath: nil),
        Cast(id: 974802, originalName: "Maribel Fernández", profilePath: URL(string: "https://image.tmdb.org/t/p/w185/kwy1s0GiBRYlhctQURbwJbuNe8X.jpg")),
        Cast(id: 1714721, originalName: "Janet Arceo", profilePath: nil),
        Cast(id: 145455, originalName: "Angélica María", profilePath: URL(string: "https://image.tmdb.org/t/p/w185/5a28h0QSdyB8H0FE5YNvXoW8PcU.jpg")),
        Cast(id: 2246476, originalName: "Raúl Velasco", profilePath: nil),
        Cast(id: 5287252, originalName: "Gabriel Fernández Carrasco", profilePath: nil),
        Cast(id: 1125165, originalName: "José Antonio Mena", profilePath: URL(string: "https://image.tmdb.org/t/p/w185")),
        Cast(id: 3695140, originalName: "Edgar Wald", profilePath: URL(string: "https://image.tmdb.org/t/p/w185"))
    ]
}
