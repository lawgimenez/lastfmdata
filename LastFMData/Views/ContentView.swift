//
//  ContentView.swift
//  LastFMData
//
//  Created by Lawrence Gimenez on 7/8/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var fmObservables = FmObservables()
    
    var body: some View {
        NavigationStack {
            TopAlbumsView()
                .environment(fmObservables)
                .onAppear {
                    fmObservables.getTopAlbums()
                }
        }
    }
}

//#Preview {
//    ContentView()
//}
