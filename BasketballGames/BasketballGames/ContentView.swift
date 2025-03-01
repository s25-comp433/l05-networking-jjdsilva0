//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//  Updated by Joaquim D'Silva on 3/1/25
//

import SwiftUI

struct Result: Codable {
    var team: String
    var opponent: String
    var isHomeGame: Bool
    var score: ScoreFormat
    var date: String
    var id: Int
}

struct ScoreFormat: Codable {
    var opponent: Int
    var unc: Int
}

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        Text("UNC Basketball")
            .font(.title)
            .fontWeight(.bold)
        List(results, id: \.id) { item in
            HStack {
                VStack(alignment: .leading) {
                    Text("\(item.team) vs. \(item.opponent)")
                        .font(.headline)
                    Text("\(item.date)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                    
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(item.score.unc) - \(item.score.opponent)")
                        .font(.headline)
                    Text(item.isHomeGame ? "Home" : "Away")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .task {
            await LoadData()
        }
    }
    
    func LoadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResults = try? JSONDecoder().decode([Result].self, from: data) {
                results = decodedResults
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
