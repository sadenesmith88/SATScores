//
//  ContentView.swift
//  SATScores
//
//  Created by sade on 8/6/24.
//

import SwiftUI

let url = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json"

//Model
struct Model: Decodable, Hashable {
  let schoolName: String
  let satCriticalReadingAvgScore: String
  let satMathAvgScore: String
  let satWritingAvgScore: String

  enum CodingKeys: String, CodingKey {
    case schoolName = "school_name"
    case satCriticalReadingAvgScore = "sat_critical_reading_avg_score"
    case satMathAvgScore = "sat_math_avg_score"
    case satWritingAvgScore = "sat_writing_avg_score"
  }
}

//ViewModel
class ViewModel: ObservableObject {
  @Published var items = [Model]()

  func loadData() {
    guard let urll = URL(string: url) else { return }

    URLSession.shared.dataTask(with: urll) { (data, res, err) in

      do {
        if let data = data {

          let result = try JSONDecoder().decode([Model].self, from: data)

          DispatchQueue.main.async {
            self.items = result
          }
        } else {
          print("No data")
        }
      } catch (let error) {
        print(error)
      }
    }.resume()
  }
}

struct ContentView: View {
  @ObservedObject var viewModel = ViewModel()
  let models = [Model]()
  var body: some View {
    NavigationView {
      VStack {
        List(viewModel.items, id: \.self) { item in
          Text(item.schoolName)
          Text("Reading: \(item.satCriticalReadingAvgScore)")
          Text("Math: \(item.satMathAvgScore)")
          Text("Writing \(item.satWritingAvgScore)")
        }
      }
      .navigationTitle("Average SAT Scores")
    }
    .onAppear( perform: {
      viewModel.loadData()
    })
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
