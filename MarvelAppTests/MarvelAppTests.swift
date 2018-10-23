//
//  MarvelAppTests.swift
//  MarvelAppTests
//
//  Created by Günter Hertz on 18/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import XCTest
@testable import MarvelApp

class MarvelAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testAPIPerformance() {
        let service = MarvelService()
        let expect = expectation(description: "Expecting a JSON data not nil")
        
        service.requestCharacters { error, characters in
            XCTAssertNil(error)
            XCTAssertNotNil(characters)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("ERROR: \(error)")
            }
        }
    }
    
    func testMarvelCharacterDecode() {
        let value: [String:Any] =
            [
            "code": 200,
            "status": "Ok",
            "copyright": "© 2018 MARVEL",
            "attributionText": "Data provided by Marvel. © 2018 MARVEL",
            "attributionHTML": "<a href=\"http://marvel.com\">Data provided by Marvel. © 2018 MARVEL</a>",
            "etag": "bc71ef71fdf53340ec7eb7a01eaa44ed13902b19",
            "data": [
            "offset": 0,
            "limit": 20,
            "total": 1,
            "count": 1,
            "results": [
            [
            "id": 1011142,
            "name": "Devos",
            "description": "",
            "modified": "1969-12-31T19:00:00-0500",
            "thumbnail": [
            "path": "http://i.annihil.us/u/prod/marvel/i/mg/4/20/4c002f87999a7",
            "extension": "jpg"
            ],
            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1011142",
            "comics": [
            "available": 4,
            "collectionURI": "http://gateway.marvel.com/v1/public/characters/1011142/comics",
            "items": [
            [
            "resourceURI": "http://gateway.marvel.com/v1/public/comics/4219",
            "name": "Annihilation: Ronan (2006) #2"
            ],
            [
            "resourceURI": "http://gateway.marvel.com/v1/public/comics/13208",
            "name": "Fantastic Four (1961) #382"
            ],
            [
            "resourceURI": "http://gateway.marvel.com/v1/public/comics/13209",
            "name": "Fantastic Four (1961) #383"
            ],
            [
            "resourceURI": "http://gateway.marvel.com/v1/public/comics/13229",
            "name": "Fantastic Four (1961) #400"
            ]
            ],
            "returned": 4
            ],
            "series": [
            "available": 2,
            "collectionURI": "http://gateway.marvel.com/v1/public/characters/1011142/series",
            "items": [
            [
            "resourceURI": "http://gateway.marvel.com/v1/public/series/1079",
            "name": "Annihilation: Ronan (2006)"
            ],
            [
            "resourceURI": "http://gateway.marvel.com/v1/public/series/2121",
            "name": "Fantastic Four (1961 - 1998)"
            ]
            ],
            "returned": 2
            ],
            "stories": [
            "available": 7,
            "collectionURI": "http://gateway.marvel.com/v1/public/characters/1011142/stories",
            "items": [
            [
            "resourceURI": "http://gateway.marvel.com/v1/public/stories/5935",
            "name": "Annihilation: Ronan (2006) #2",
            "type": "cover"
            ],
            [
            "resourceURI": "http://gateway.marvel.com/v1/public/stories/13197",
            "name": "Fantastic Four (1961) #382",
            "type": "cover"
            ],
            [
            "resourceURI": "http://gateway.marvel.com/v1/public/stories/13198",
            "name": "\"Captured!\"",
            "type": "interiorStory"
            ],
            [
            "resourceURI": "http://gateway.marvel.com/v1/public/stories/13203",
            "name": "Fantastic Four (1961) #383",
            "type": "cover"
            ],
            [
            "resourceURI": "http://gateway.marvel.com/v1/public/stories/13204",
            "name": "\"A World Against Them!\"",
            "type": "interiorStory"
            ],
            [
            "resourceURI": "http://gateway.marvel.com/v1/public/stories/13329",
            "name": "Fantastic Four (1961) #400",
            "type": "cover"
            ],
            [
            "resourceURI": "http://gateway.marvel.com/v1/public/stories/13332",
            "name": "Even the Watchers Can Die!",
            "type": "interiorStory"
            ]
            ],
            "returned": 7
            ],
            "events": [
            "available": 1,
            "collectionURI": "http://gateway.marvel.com/v1/public/characters/1011142/events",
            "items": [
            [
            "resourceURI": "http://gateway.marvel.com/v1/public/events/229",
            "name": "Annihilation"
            ]
            ],
            "returned": 1
            ],
            "urls": [
            [
            "type": "detail",
            "url": "http://marvel.com/characters/549/devos?utm_campaign=apiRef&utm_source=e09820648be56616b93882440fd5ab5d"
            ],
            [
            "type": "wiki",
            "url": "http://marvel.com/universe/Devos?utm_campaign=apiRef&utm_source=e09820648be56616b93882440fd5ab5d"
            ],
            [
            "type": "comiclink",
            "url": "http://marvel.com/comics/characters/1011142/devos?utm_campaign=apiRef&utm_source=e09820648be56616b93882440fd5ab5d"
            ]
            ]
            ]
            ]
            ]
            ]

        guard let json = value as? [String: Any],
            let data = json["data"] as? [String: Any],
            let results = data["results"] as? [Any] else {
                XCTFail("Fail to parse json")
                return
                
        }
        if let newData = try? JSONSerialization.data(withJSONObject: results, options: .prettyPrinted){
            if let persons = try? JSONDecoder.init().decode([MarvelCharacter].self, from: newData) {
                XCTAssertNotNil(persons, "Decode correctly")
            }
        }
    }

}
