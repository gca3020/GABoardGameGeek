# GABoardGameGeek

[![Build Status](https://travis-ci.org/gca3020/GABoardGameGeek.svg?branch=master)](https://travis-ci.org/gca3020/GABoardGameGeek)
[![codecov.io](https://codecov.io/github/gca3020/GABoardGameGeek/coverage.svg?branch=master)](https://codecov.io/github/gca3020/GABoardGameGeek?branch=master)
[![Version](https://img.shields.io/cocoapods/v/GABoardGameGeek.svg?style=flat)](http://cocoapods.org/pods/GABoardGameGeek)
![Swift version](https://img.shields.io/badge/swift-4.0-orange.svg)
[![Platform](https://img.shields.io/cocoapods/p/GABoardGameGeek.svg?style=flat)](http://cocoadocs.org/docsets/GABoardGameGeek)
[![License](https://img.shields.io/cocoapods/l/GABoardGameGeek.svg?style=flat)](http://cocoapods.org/pods/GABoardGameGeek)
[![Twitter](https://img.shields.io/badge/twitter-@gca3020-blue.svg?style=flat)](http://twitter.com/gca3020)

BoardGameGeek XMLAPI2 Swift Framework for interacting with games and collections on BGG

## Features

- [x] Read-only access to user collections and games
- [x] Site Searching
- [x] TODO! Forums, Videos, Users, Geeklists, etc...
- [x] Comprehensive Test Coverage & Automated Coverage Reports

## Requirements

- iOS 8.0+, macOS 10.10+, tvOS 9.0+, watchOS 2.0+
- Xcode 9.0+
- Swift 4.0

## Dependencies

- [Alamofire](https://github.com/Alamofire/Alamofire)
- [SWXMLHash](https://github.com/drmohundro/SWXMLHash)

## Communication

- If you'd like to **ask a question**, use [Twitter](http://twitter.com/gca3020).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Example & Unit Tests

To run the unit tests, and see some additional usage details, clone the repo, and run `pod install` from the Example directory first.

## Installation

GABoardGameGeek is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "GABoardGameGeek"
```

## Usage

One of the things that I wanted to accomplish with this library is making the common things you 
would want to do very easy, as well as "Swifty". To that end, here are a number of the things you
can do with this library.

### Searching for a Game

One of the very first things you might want to do is to search for a game by name:

```swift
import GABoardGameGeek

GABoardGameGeek().searchFor("pandemic") { result in
    switch(result) {
    case .success(let searchResults):
        print(searchResults)
    case .failure(let error):
        print(error)
    }
}
```

Alternately, you might want to narrow down your search by only searching for exact matches, or only 
for items of a specific type, like expansions:

```swift
import GABoardGameGeek

GABoardGameGeek().searchFor("pandemic: on the brink", searchType: "boardgameexpansion", exactMatch: true) { result in
    switch(result) {
    case .success(let searchResults):
        print(searchResults)
    case .failure(let error):
        print(error)
    }
}
```

I have some plans for how the search type is specified, as these handful of strings for "type" are used 
pretty commonly throughout the API, but for now, specifying the string manually gets ths job done.

### Reading a Game by ID

Once you have a game ID, getting the details for that game is easy:

```swift
GABoardGameGeek().getGameById(12345) { result in
    switch(result) {
    case .success(let game):
        print(game)
    case .failure(let error):
        print(error)
    }
}
```

Of course, you also might want to request a bunch of games at once:

```swift
GABoardGameGeek().getGamesById([1, 232, 41415, 12]) { result in
    switch(result) {
    case .success(let gameList):
        print(gameList)
    case .failure(let error):
        print(error)
    }
}
```

Additionally, you might want game statistics. These can be requested as well for either a single 
game, or the list of games

```swift
GABoardGameGeek().getGameById(12123, stats: true) { result in
    switch(result) {
    case .success(let game):
        print(game)
    case .failure(let error):
        print(error)
    }
}
```

### Getting a User's Collection

Likewise, getting a user's collection is also quite easy. Simply specify their username. The result is an ApiResult
containing a `CollectionBoardGame` array

```swift
GABoardGameGeek().getUserCollection("userName") { result in
    switch(result) {
    case .success(let gameCollection):
        print(gameCollection)
    case .failure(let error):
        print(error)
    }
}
```

Collection requests have a number of additional, optional parameters. You can request a "brief" collection, 
which will generally be returned and parsed much quicker, especially for users with large collections, but 
will not contain as many details about a game as a standard request. You can also request a collection with
statistics, which will contain additional information about a game, such as it's overall rating, position in 
various rankings, and what this particular user has rated it.  You can even combine these two parameters, 
and request brief game details, with a subset of game statistics.

Finally, BoardGameGeek's API generally takes a while to respond to Collection Requests, especially for users
with very large collections. As a result, the call to request a collection has a default timeout of 90
seconds, during which time it will retry, as long as the server continues to respond with a `202` error code.

```swift
GABoardGameGeek().getUserCollection("userName", brief: true, stats: true, timeout: 120) { result in
    switch(result) {
    case .success(let gameCollection):
        print(gameCollection)
    case .failure(let error):
        print(error)
    }
}
```

### Handling Results

With heavy inspiration taken from common Swift libraries like Alamofire, the primary way that API results 
are returned is in an ApiResult container. This container uses Swift Generics to hold values of different
types.

If you don't like the Switch syntax, you can also access the results using some computed properties. The
following two examples are equivalent:

```swift
// Use switch to handle results/errors
GABoardGameGeek().getGameById(12123) { result in
    switch(result) {
    case .success(let game):
        print(game)
    case .failure(let error):
        print(error)
    }
}

// Use accessors to handle results/erros
GABoardGameGeek().getGameById(12123) { result in
    if(result.isSuccess) {
        print(result.value!)
    }
    else {
        print(result.error!)
    }
}
```

So feel free to choose the syntax you prefer.

### Error Handling

Whenever you are dealing with Networking APIs, there are a number of errors that can occur. I've done
my best to prevent the ones I can, but there's nothing I can do when the API goes down, or a network 
connection is unavaialable. When that happens, you can either add code to the `.failure` case of the 
`ApiResult` enum, or check `result.isFailure`. 

There are a few classes of error in the `BggError` enumeration:
- `connectionError`: Something went wrong with the network connection itself, and the API could not be reached.
- `serverNotReady`: Seen when querying a user's collection. The server is not ready yet, but our timeout has expired.
- `apiError`: There was an error in the results of the API, things like invalid usernames will cause this.
- `xmlError`: There was an error parsing the XML response from the API. If you see one of these, please [Contact Me](mailto:gca3020@users.noreply.github.com)
or create an issue with the request you were making and the detail text from the error.

---

## Changelog

See [CHANGELOG](CHANGELOG.md) for a list of all changes and their corresponding versions.

## License

GABoardGameGeek is released under the MIT license. See [LICENSE](LICENSE) for details.
