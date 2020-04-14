//
//  ViewController.swift
//  FilmLocations
//
//  Created by Benjamin Simpson on 4/13/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var films:[FilmEntryCodable] = []
    
    let section = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getDataFromFile("locations")
        tableViewSetUp()
    }

//    func getDataFromFile(_ fileName:String){
//        let path = Bundle.main.path(forResource: fileName, ofType: ".json")
//
//        if let path = path {
//          let url = URL(fileURLWithPath: path)
//          print(url)
//
//        let contents = try? Data(contentsOf: url)
//        do {
//          if let data = contents,
//          let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]] {
//            print(jsonResult)
//            for film in jsonResult{
//                let firstActor = film["actor_1"] as? String ?? ""
//                let locations = film["locations"] as? String  ?? ""
//                let releaseYear = film["release_year"] as? String  ?? ""
//                let title = film["title"] as? String  ?? ""
//                let movie = FilmEntry(firstActor: firstActor, locations: locations, releaseYear: releaseYear, title: title)
//                films.append(movie)
//            }
//            section.reloadData()
//          }
//        } catch {
//          print("Error deserializing JSON: \(error)")
//
//        }
//
//    }
//}
    
    func getDataFromFile(_ fileName:String){
        let path = Bundle.main.path(forResource: fileName, ofType: ".json")
        if let path = path {
            let url = URL(fileURLWithPath: path)
            let contents = try? Data(contentsOf: url)
            if let data = contents{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let filmsFromJSON = try decoder.decode([FilmEntryCodable].self, from: data)
                    films = filmsFromJSON
                    
                    section.reloadData()
                    
                } catch {
                    print("Parsing Failed")
                }
            }
        }
    }
    
    func tableViewSetUp() {
        view.addSubview(section)
        section.delegate = self
        section.dataSource = self
        section.translatesAutoresizingMaskIntoConstraints = false
        section.register(UINib(nibName: "MovieCellTableView", bundle: nil), forCellReuseIdentifier: "movieCell")
        section.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        section.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        section.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        section.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        cell.textLabel!.text = films[indexPath.row].locations + " " + films[indexPath.row].releaseYear.value
        return cell
    }

}

//extension FilmEntry {
//    init?(json: [String: Any]) {
//        guard let locations = json["locations"] as? String,
//            let a1 = json["actor_1"] as? String,
//            let year = json["release_year"] as? String,
//            let title = json["title"] as? String
//            else{
//                return nil
//        }
//        self.firstActor = a1
//        self.releaseYear = year
//        self.title = title
//        self.locations = locations
//    }
//}
