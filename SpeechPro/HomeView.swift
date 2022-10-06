//
//  HomeView.swift
//  Speech App
//
//  Created by Robert Wiebe on 5/24/22.
//

import SwiftUI

struct HomeView: View {
    let pasteboard = UIPasteboard.general
    @State var seperatedBy: SeperateSpeechBy = .lineBreaksColonsAndCommas
    @State var settingsPresented: Bool = false
    @Binding var thisSpeech: Speech
    let bgImages: [String] = ["Gold", "Red and Blue", "Purple"]
    @State var bgImage: String = "Gold"
    @State var navigationActive: Bool = false
    @State var displayedSpeech: String
    @State var isEditing: Bool = false
    init(thisSpeech: Binding<Speech>){
        self._thisSpeech = thisSpeech
        UITextView.appearance().backgroundColor = .clear
        self.displayedSpeech = thisSpeech.speechContent.wrappedValue
    }
    var body: some View {
//        NavigationView{
            VStack {
                GroupBox{
                    HStack {
                        Text("Title:")
                        TextField("speech title", text: $thisSpeech.title)
                    }
                    HStack {
                        Text("Author:")
                        TextField("speech author", text: $thisSpeech.author)
                    }
                    
                }
                
                GroupBox(label:
                            VStack(alignment: .leading, spacing: 5) {
                    Text("Type/paste your speech in here.")
                    Text("Note: Use ".localized() + String(seperatedBy.rawValue.lowercased().localized()) + " to separate chunks in present mode.".localized())
                        .font(.system(size: 15, weight: .regular))
                        .opacity(0.75)
                }
                ) {
                    Divider()
                    TextEditor(text: $displayedSpeech)
                        .frame(minWidth: 300)
                        .onTapGesture {
                            self.isEditing = true
                        }
                        .onChange(of: displayedSpeech){ newSpeech in
                            self.thisSpeech.speechContent = newSpeech
                        }
                    HStack{
                        Button(action:{pasteAndAdd()}){
                            Label("Paste", systemImage: "doc.on.clipboard")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Capsule())
                        }
                        Button(action:{displayedSpeech = ""}){
                            Label("Clear", systemImage: "xmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Capsule().foregroundColor(.gray))
                        }
                        Spacer()
                        Divider()
                        Spacer()
                        NavigationLink(destination: presentView(paragraphs: seperateParagraphs(str: thisSpeech.speechContent, seperation: seperatedBy), title: thisSpeech.title, author: thisSpeech.author, background: bgImage), isActive: $navigationActive){
                            Button(action:{
                                hideKeyboardAndSave()
                                navigationActive = true
                            }){
                                Label("Present", systemImage: "music.mic")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                .background(Capsule().foregroundColor(.orange))
                            }
                        }
                    }.frame(height: 50)
                }
                .navigationTitle(thisSpeech.title.isEmpty ? "Unnamed Speech" : thisSpeech.title)
            }.padding(.horizontal)
            .toolbar{
                if !isEditing {
                    Button(action: {settingsPresented = true}, label: {
                        Image(systemName: "gearshape")
                    })
                    .sheet(isPresented: $settingsPresented){
                        NavigationView {
                            Form{
                                Picker("Chunk seperators in speech", selection: $seperatedBy, content: {
                                    Text("Line breaks, colons and commas").tag(SeperateSpeechBy.lineBreaksColonsAndCommas)
                                    Text("Line breaks and colons").tag(SeperateSpeechBy.lineBreaksAndColons)
                                    Text("Line breaks only").tag(SeperateSpeechBy.lineBreaks)
                                }).pickerStyle(.inline)
                                Picker("Background Image", selection: $bgImage){
                                    ForEach(bgImages, id: \.self){name in
                                        HStack {
                                            Image(name)
                                                .resizable()
                                                .frame(width: 75, height: 75)
                                                .scaledToFill()
                                                .cornerRadius(15)
                                            Text(name.localized())
                                        }
                                    }
                                }.pickerStyle(.inline)
                            }.toolbar{
                                ToolbarItem(placement: .primaryAction){
                                    Button(action: {settingsPresented = false}){
                                        Text("Done")
                                    }
                                }
                        }
                        }
                }
                } else {
                    Button(action: {hideKeyboardAndSave()}){
                        Text("Done")
                    }
                }
            }
//            .ignoresSafeArea()
//        }
    }
    
    func pasteAndReplace() {
        if let string = pasteboard.string{
            displayedSpeech = string
        }
    }
    func pasteAndAdd() {
        if let string = pasteboard.string{
            displayedSpeech += string
        }
    }
    func seperateParagraphs(str: String, seperation: SeperateSpeechBy) -> [String] {
        var temp = str
        switch seperation {
        case .lineBreaks:
            temp = str
        case .lineBreaksAndColons:
            temp = str.replacingOccurrences(of: ".", with: ".\n")
        case .lineBreaksColonsAndCommas:
            temp = str.replacingOccurrences(of: ".", with: ".\n").replacingOccurrences(of: ",", with: ",\n")
        }
        return temp.components(separatedBy: .init(charactersIn: "\n")).filter{$0 != ""}.map{$0.trimmingCharacters(in: .whitespaces)}
    }
    enum SeperateSpeechBy: String{
        case lineBreaks = "Line breaks only"
        case lineBreaksAndColons = "Line breaks and colons"
        case lineBreaksColonsAndCommas = "Line breaks, colons and commas"
    }
    
    func hideKeyboardAndSave() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        self.thisSpeech.speechContent = displayedSpeech
        self.isEditing = false
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(thisSpeech: .constant(Speech(speechContent: "", title: "", author: "")))
            .preferredColorScheme(.dark)
        HomeView(thisSpeech: .constant(Speech(speechContent: "", title: "", author: "")))
            .preferredColorScheme(.dark)
            .environment(\.locale, .init(identifier: "de"))
    }
}
