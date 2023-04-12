//
//  ContentView.swift
//  Lab6
//
//  Created by 贺力 on 3/21/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

        @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \City.name, ascending: true)],
            animation: .default)
        private var items: FetchedResults<City>

    @State var insertView = false
    @State var newCityName = ""
    @State var newDescription = ""
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink{
                        VStack {
                            Image(uiImage: UIImage(data:(item.image ?? Data())) ?? UIImage())
                                .resizable()
                                .scaledToFit()
                            Spacer()
                            Text("Name of city is: \(item.name!)")
                            Spacer()
                            Text("Small description of \(item.name!)")
                            Spacer()
                        }
                        } label: {
                            Image(uiImage: UIImage(data:(item.image ?? Data())) ?? UIImage())
                                   .resizable()
                                   .scaledToFit()
                                   .frame(width: 100, height: 100)
                             Spacer()
                            Text(item.name!)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar
            {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    EditButton()
                }

                ToolbarItem
                {
                    Button(action: {
                        insertView = true
                    })
                    {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }.alert("Add City", isPresented: $insertView, actions: {
                TextField("City Name: ", text: $newCityName)
                
                Button(action: {
                    self.isShowPhotoLibrary = true
                    insertView = false
                }) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 20))

                        Text("Add city photo")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }

                HStack{

                    Button("Cancel", role: .cancel, action: {
                        insertView = false
                    })

                }
            }, message: {
                Text("Enter the information of the city")
            })
            .sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
           }
            .onChange(of: image) { newValue in
                // Perform some task
                addItem(n:newCityName)
            }

        }
        //Text("Select an item")
    }

    private func addItem(n: String) {
        withAnimation {
            let newItem = City(context: viewContext)
            newItem.name = n
            newItem.image = image.pngData()

            do {
                try viewContext.save()
                
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

