# Movix
Project repository

Movix App is a study project.
This project takes this design as inspiration [Cinema Movix App UX/UI](https://www.behance.net/gallery/174186247/Cinema-Mobile-App-UXUI) made by [Anna Akimenko](https://www.behance.net/83c1b923)


## Movie queries

* Movie details: https://api.themoviedb.org/3/movie/{movie_id}
    * language: _string
* Movie casting: https://api.themoviedb.org/3/movie/{movie_id}/credits
   * language: _string
* Movie images: https://api.themoviedb.org/3/movie/{movie_id}/images
* Movie recomendations: https://api.themoviedb.org/3/movie/{movie_id}/recommendations
   * language: _string
   * page: _int
* Movie similar: https://api.themoviedb.org/3/movie/{movie_id}/similiar
   * language: _string
   * page: _int
* Current popular movies: https://api.themoviedb.org/3/movie/popular
    * language: _string
    * page: _int
* Trending movies: https://api.themoviedb.org/3/trending/movie/{time_window}
   * Time window: day or week _string
* Search movie: https://api.themoviedb.org/3/search/movie
    * query: Query to search _string
    * include_adult: _bool
    * language: _string
    * prymary_release_year: _string
    * page: _int
    * region: _string
    * year: _string

## People queries

117642

* Person details: https://api.themoviedb.org/3/person/{person_id}
* Person movie credits: https://api.themoviedb.org/3/person/{person_id}/movie_credits
   * language: _string


## Helper queries

* Genres: https://api.themoviedb.org/3/genre/{type}/list
    * type: 'movie' or 'tv'
    * language: en or es _string
* Language: https://api.themoviedb.org/3/configuration/languages
