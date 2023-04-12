//
//  DetailView.swift
//  Lab6
//
//  Created by 贺力 on 3/21/23.
//

import Foundation
import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State var city: String
    @State var image: String
    @State var description: String
    var body: some View{
        VStack{
            Image(image)
                .resizable()
                .scaledToFit()
            Text("The name of the city is: " + city)
            Text("Desccription is: " + description)
        }
    }
}

