//
//  speechesView.swift
//  Speech App
//
//  Created by Robert Wiebe on 5/27/22.
//

import SwiftUI

struct speechesView: View {
    @AppStorage("speeches") var speeches: [Speech] = []
    var body: some View {
        NavigationView{
            Text("Hello World")
        }
    }
}

//struct Speech: Hashable, Codable{
//    var speechContent: String
//    var title: String
//    var author: String
//}

struct speechesView_Previews: PreviewProvider {
    static var previews: some View {
        speechesView()
            .preferredColorScheme(.dark)
    }
}
