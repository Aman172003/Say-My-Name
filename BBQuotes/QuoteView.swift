//
//  QuoteView.swift
//  BBQuotes
//
//  Created by Aman on 31/07/24.
//

import SwiftUI

struct QuoteView: View {
    let vm = ViewModel()
    let show: String
    @State var showCharacterInfo = false
    var body: some View {
//        GeometryReader is a view in SwiftUI that provides access to the size and position of the parent view.
//        GeometryReader: This is a container view that takes a closure as an argument. The closure receives a GeometryProxy (in this case, geo), which contains information about the size and position of the GeometryReader itself.
        
  //  geo: This is an instance of GeometryProxy, which provides properties like size and safeAreaInsets, giving you access to the dimensions and layout information.
        GeometryReader{ geo in
            ZStack{
//    image will scale based on the available space, making it flexible for different screen sizes.
                Image(show.lowercased().replacingOccurrences(of: " ", with: ""))
                    .resizable()
                    .frame(width: geo.size.width*2.7, height: geo.size.height * 1.2)
                
                VStack{
                    Spacer(minLength: 60)
                    VStack{
                        switch vm.status {
                        case .notStarted:
                            EmptyView()
                            
                        case .fetching:
                            ProgressView()
                            
                        case .success:
                            Text("\"\(vm.quote.quote)\"")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                                .padding(.horizontal)
                            
                            ZStack(alignment: .bottom) {
                                AsyncImage(url: vm.character.images[0]) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                                
                                Text(vm.character.name)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                            }
                            .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                            .clipShape(.rect(cornerRadius: 50))
                            .onTapGesture {
                                showCharacterInfo.toggle()
                            }
                            .sheet(isPresented: $showCharacterInfo){
                                CharacterView(character: vm.character, show: show)
                            }
                            
                        case .failed(let error):
                            Text(error.localizedDescription)
                        }
                        
                        Spacer()
                    }
                    
                    Button {
//                        task is a unit of asynchronous work
//                        though swift is synchronous, without task await can't be applied
                        Task {
                            await vm.getData(for: show)
                        }
                    } label: {
                        Text("Get Random Quotes")
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color("\(show.replacingOccurrences(of: " ", with: ""))Button"))
                            .clipShape(.rect(cornerRadius: 7))
                            .shadow(color: Color("\(show.replacingOccurrences(of: " ", with: ""))Shadow"), radius: 2)
                    }
                    Spacer(minLength: 95)
                    
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    QuoteView(show: "Breaking Bad")
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
