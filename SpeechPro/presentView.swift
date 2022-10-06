//
//  presentView.swift
//  Speech App
//
//  Created by Robert Wiebe on 5/20/22.
//

import SwiftUI

struct presentView: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var isRecording: Bool = false
    @State var currentTranscript: String = ""
    var paragraphs: [String]
    var title: String
    var author: String
    var background: String
    @State var scrollIndex: Int = 0
    @State var scrolls: Int = 0
    @State var centered: Bool = true
    @State var currentParagraph: String = ""
    @State var currentLastCount: Int = 0
    let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
    var body: some View {
        NavigationView {
            ZStack{
                Image(background)
                    .resizable()
                    .ignoresSafeArea()
                    .blur(radius: 25)
                    .scaleEffect(1.2)
                ScrollView(showsIndicators: false){
                    ScrollViewReader { value in
                        VStack(alignment: .leading, spacing: 0) {
                            VStack(alignment: .leading) {
                                Text("\"\(title)\"")
                                    .bold()
                                    .foregroundColor(.white)
                                Text("  by ".localized() + author)
                                    .foregroundColor(.white)
                            }.lineLimit(1)
                                .padding(.top, 100)
                                .padding(.bottom, -10)
                            Spacer()
                                .frame(height: 10)
                            ForEach(Array(paragraphs.enumerated()), id: \.offset){ index, paragraph in
                                Rectangle()
                                    .frame(height: 1)
                                    .opacity(0)
                                    Text(paragraphs[index])
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                        .shadow(radius: index == scrollIndex ? 10 : 0)
                                        .opacity(index == scrollIndex ? 1 : 0.5)
    //                                    .padding(.top, ((index == scrollIndex) ? 10 : 0))
                                        .scaleEffect(index == scrollIndex ? 1 : 0.9, anchor: .leading)
                                        .onTapGesture {
                                            if isRecording {
                                                isRecording = false
                                                speechRecognizer.reset()
                                                speechRecognizer.transcript = ""
                                                currentTranscript = ""
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                    speechRecognizer.transcribe()
                                                    isRecording = true
                                                }
                                            }
                                            scrollIndex = index
                                            
    //                                        withAnimation{
    //                                            value.scrollTo(index, anchor: UnitPoint(x: 0.5, y: 1))
    //                                        }
                                        }
                                        .id(index)
                                        .animation(.default, value: scrollIndex)
                                    
    //                            }
                            
                                
                                
                            }
                            Text("End of content.")
                                .foregroundColor(.white)
                                .padding(.top, 20)
                            Text("SpeechPro, Robert Wiebe, 2022")
                                .foregroundColor(.white.opacity(0.5))
                            Spacer()
                                .frame(height: 700)
                        }
                        .onChange(of: scrollIndex, perform: { newVal in
                            withAnimation {
                                value.scrollTo(newVal, anchor: UnitPoint(x: 0.5, y: 0.15))
                            }
                            self.currentParagraph = paragraphs[newVal]
                            self.currentLastCount = currentParagraph.removeSpecialChars().countOccurances(of: currentParagraph.lastWord())
                        })
                        .onChange(of: scrolls, perform: { newVal in
                            withAnimation {
                                value.scrollTo(scrollIndex, anchor: UnitPoint(x: 0.5, y: 0.15))
                            }
                        })
                    }
                }
                .ignoresSafeArea()
                .padding(.horizontal)
                .mask(
                    LinearGradient(colors: [.clear, .white], startPoint: UnitPoint(x: 0.5, y: 0.1), endPoint: UnitPoint(x: 0.5, y: 0.15))
                        .edgesIgnoringSafeArea(.top)
                        .allowsHitTesting(false)
                )
                VStack{
//                    Rectangle()
//                        .frame(height: -50)
//                        .edgesIgnoringSafeArea(.top)
//                        .foregroundColor(.clear)
//                        .background(.ultraThinMaterial)
                    Spacer()
                    VStack{
                    HStack{
//                        Image(systemName: "doc.append")
//                            .font(.system(size: 50))
                        VStack(alignment: .leading){
                            Text(title)
                                .font(.system(size: 30, weight: .semibold))
                            Text(author)
                                .font(.system(size: 18, weight: .regular))
                        }.frame(maxWidth: .infinity)
                            .lineLimit(1)
                        Spacer()
                        ZStack {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 35))
                            Image(systemName: "mic.slash.fill")
                                .font(.system(size: 35))
                                .mask(
                                    Rectangle().offset(x: isRecording ? 0 : -32)
                                )
                        }
                        .foregroundColor(isRecording ? .orange : .white)
                        .animation(.easeInOut(duration: 0.25), value: isRecording)
                        .onTapGesture{
                            if isRecording {
                                speechRecognizer.stopTranscribing()
                            } else {
                                speechRecognizer.reset()
                                speechRecognizer.transcribe()
                                
                            }
                            isRecording.toggle()
                        }
                        Button(action: {
                            if scrollIndex == 0{
                                scrolls += 1
                            }
                            else{
                                if isRecording {
                                    isRecording = false
                                    speechRecognizer.reset()
                                    speechRecognizer.transcript = ""
                                    currentTranscript = ""
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        speechRecognizer.transcribe()
                                        isRecording = true
                                    }
                                }
                                scrollIndex = 0
                            }
                            
                        }) {
                            Image(systemName: "platter.filled.top.and.arrow.up.iphone")
                                .font(.system(size: 50))
                                .symbolRenderingMode(.hierarchical)
                        }
                    }.foregroundColor(.white)
                        .shadow(radius: 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                    Divider()
                    HStack{
                        Spacer()
                        Button(action:{
                            if scrollIndex > 0{
                                if isRecording {
                                    isRecording = false
                                    speechRecognizer.reset()
                                    speechRecognizer.transcript = ""
                                    currentTranscript = ""
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        speechRecognizer.transcribe()
                                        isRecording = true
                                    }
                                }
                                scrollIndex -= 1
                            }
                        }){
                            Image(systemName: "arrow.backward.circle")
                                .foregroundColor(.white.opacity(scrollIndex > 0 ? 1 : 0.5))
                                .animation(.default, value: scrollIndex)
                                .font(.system(size: 60, weight: .bold))
                        }.buttonStyle(ScaleButtonStyle())
                        Spacer()
                        Button(action:{
                            scrolls += 1
                        }){
                            Image(systemName: "arrow.down.forward.and.arrow.up.backward.circle")
//                                .rotationEffect(.init(degrees: 90))
                                .foregroundColor(.white)
                                .symbolRenderingMode(.hierarchical)
                                .animation(.default, value: scrollIndex)
                                .font(.system(size: 60, weight: .bold))
                        }.buttonStyle(ScaleButtonStyle())
                        Spacer()
                        Button(action:{
                            if (scrollIndex < paragraphs.count-1) {
                                if isRecording {
                                    isRecording = false
                                    speechRecognizer.reset()
                                    speechRecognizer.transcript = ""
                                    currentTranscript = ""
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        speechRecognizer.transcribe()
                                        isRecording = true
                                    }
                                }
                                scrollIndex += 1
                            }
                        }){
                            Image(systemName: "arrow.forward.circle")
                                .foregroundColor(.white.opacity(scrollIndex < paragraphs.count-1 ? 1 : 0.5))
                                .animation(.default, value: scrollIndex)
                                .font(.system(size: 60, weight: .bold))
                        }.buttonStyle(ScaleButtonStyle())
                        Spacer()
                    }.padding(.bottom, 6)
                            
                    }
                    .zIndex(0)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30))
                    .padding(.bottom, 17)
                    .padding(.horizontal)
                }
                    .edgesIgnoringSafeArea(.bottom)
            }.navigationBarTitle("")
            .navigationBarHidden(true)
            .onReceive(timer, perform: { _ in
                if !isRecording {}
                else{
                    currentTranscript = speechRecognizer.transcript
                    if currentParagraph.count > 0 {
                        moveIfEndSaid()
                    }
                }
                
//                print("Transcript:", currentTranscript, "Paragraph:", currentParagraph)
            })
            .onAppear{
                currentParagraph = paragraphs.isEmpty ? "" : paragraphs[0]
                self.currentLastCount = currentParagraph.removeSpecialChars().countOccurances(of: currentParagraph.lastWord())
//                print(currentParagraph)
            }
            .onDisappear{
                currentTranscript = ""
                if isRecording{
                    isRecording = false
                    speechRecognizer.reset()
                }
            }
        }
    }
    
    func moveIfEndSaid() {
        var move: Bool = false
        if currentParagraph.singularLastWordInstance() {
            let lastWord = removeSpecialChars(text: currentParagraph.lastWord().lowercased())
            if currentTranscript.lowercased().filter({$0 != "'"}).components(separatedBy: " ").contains(lastWord){
                move = true
            }
        }
//        else if currentTranscript.lowercased().filter({$0 != "'" && $0 != " "}) == removeSpecialChars(text: currentParagraph.lowercased()){
//            print("in condition")
        else {
            let lastWord = currentParagraph.lastWord().lowercased().removeSpecialChars()
            if currentTranscript.removeSpecialChars().countOccurances(of: lastWord) == currentLastCount {
                move = true
            }
        }
        if !move {return}
        if scrollIndex < paragraphs.count-1{
            isRecording = false
            speechRecognizer.reset()
            speechRecognizer.transcript = ""
            currentTranscript = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                speechRecognizer.transcribe()
                isRecording = true
            }
            self.scrollIndex += 1
        }
        else{
            self.isRecording = false
            speechRecognizer.reset()
        }
    }
    func removeSpecialChars(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz")
        return String(text.filter {okayChars.contains($0) })
    }
}

struct presentView_Previews: PreviewProvider {
    static var previews: some View {
        presentView(paragraphs: ["Hi", "Yeah"], title: "Epic Speech", author: "Robert Wiebe", background: "Gold")
    }
}
