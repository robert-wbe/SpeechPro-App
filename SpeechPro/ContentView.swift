//
//  ContentView.swift
//  Speech App
//
//  Created by Robert Wiebe on 5/15/22.
//

import SwiftUI

struct ContentView: View {
    @State private var addSheetPresented: Bool = false
    @State var newTitle: String = ""
    @State var newAuthor: String = ""
    @AppStorage("speeches") var speeches: [Speech] = []
    init(){
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().sectionFooterHeight = 0
    }
    var body: some View {
        NavigationStack {
            List{
                ForEach(Array(speeches.enumerated()), id: \.offset){i, speech in
//                    Section{
                    NavigationLink(destination: HomeView(thisSpeech: $speeches[i])){
                        VStack(alignment: .leading) {
                            Text(speech.title)
                                .font(.largeTitle.bold())
                                .foregroundStyle(LinearGradient(colors: [.teal, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .shadow(radius: 10)
                            Text(speech.description)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 10)
                        .frame(maxHeight: 150)
                        
                    }.listRowBackground(Color.clear.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10)).background(Color.cyan.opacity(0.2), in: RoundedRectangle(cornerRadius: 10)).overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 0.5)).padding(.vertical, 5))
                    .shadow(radius: 10)
//                        .contextMenu{
//                            Button(role: .destructive, action: {
//                                speeches.remove(at: i)
//                            }){
//                                Label("Delete", systemImage: "trash")
//                            }
//                        }
                }.onDelete{ row in
                    speeches.remove(at: row[row.startIndex])
                }
                .onMove(perform: move)
            }.shadow(radius: 15)
                .navigationTitle("My Speeches")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        EditButton().foregroundColor(.primary)
                        Button(action: {
                            self.addSheetPresented = true
                        }){
                            Image(systemName: "plus").foregroundColor(.primary)
                        }.sheet(isPresented: $addSheetPresented){
                            NavigationView {
                                Form{
                                    Section(header: Text("TITLE AND AUTHOR")){
                                        TextField("Title", text: $newTitle)
                                        TextField("Author", text: $newAuthor)
                                    }
                                }
                                .navigationTitle("Add speech")
                                .toolbar{
                                    ToolbarItem(placement: .primaryAction){
                                        Button(action: {
                                            speeches.append(Speech(speechContent: "", title: newTitle, author: newAuthor))
                                            self.newTitle = ""
                                            self.newAuthor = ""
                                            self.addSheetPresented = false
                                        }){
                                            Text("Add").foregroundColor(.primary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading){
                        HStack(spacing: 0) {
                            Text("Speech")
                                .font(.title.bold())
                                .foregroundColor(.primary)
                                .shadow(radius: 5)
                            Text("Pro")
                                .font(.title.bold())
                                .foregroundStyle(LinearGradient(colors: [.teal, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .shadow(radius: 5)
                        }
                    }
                    ToolbarItem(placement: .bottomBar){
                        Text("Made by Robert Wiebe in 2022")
                    }
                }
                .background(
                    ZStack {
                        Image("Gold").resizable().ignoresSafeArea().blur(radius: 0)
                        LinearGradient(colors: [Color(uiColor: .systemBackground).opacity(0.7), .clear, .clear, Color(uiColor: .systemBackground).opacity(0.7)], startPoint: .top, endPoint: .bottom)
                            .edgesIgnoringSafeArea(.vertical)
                    }
                )
        }.overlay(
            VStack {
                if speeches.count == 0 {
                    VStack {
                    Text("Your speeches will appear here.")
                        .font(.title.bold())
                        .multilineTextAlignment(.center)
                        .foregroundStyle(LinearGradient(colors: [.teal, .blue, .cyan, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(color: .teal, radius: 20, x: 0, y: 0)
                    Divider()
                    Text("Add a speech using the \"+\" Button.")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                    }.padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal)
                }
            }
        )
        .navigationViewStyle(.stack)
    }
    func move(from source: IndexSet, to destination: Int) {
            speeches.move(fromOffsets: source, toOffset: destination)
        }
}

struct Speech: Hashable, Codable{
    var speechContent: String
    var title: String
    var author: String
    
    var description: String {
        let words = self.speechContent.components(separatedBy: .whitespacesAndNewlines).filter{$0 != ""}.count
        let paragraphs = self.speechContent.components(separatedBy: .newlines).filter{$0 != ""}.count
        return self.author + " • " + numFormat(num: paragraphs, desc: "paragraph") + " • " + numFormat(num: words, desc: "word")
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from:
data) else {
return nil
}
        self = result
    }
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
return "[]" }
        return result
    }
}
func numFormat(num: Int, desc: String) -> String{
    if num == 1{
        return String(num) + " \(desc.localized())"
    }
    else{
        return String(num) + " " + (desc + "s").localized()
    }
}
extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .environment(\.locale, .init(identifier: "en"))
        
    }
}
