//
//  ContentView.swift
//  PRank
//
//  Created by seb's on 11/12/24.
//
import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .men

    enum Tab {
        case men
        case women
        case rankings
        case map // Nueva pestaña de mapas
    }

    var body: some View {
        TabView(selection: $selection) {
            // Vista de hombres
            CategoryHome()
                .tabItem {
                    Label("Men", systemImage: "person")
                }
                .tag(Tab.men)

            // Vista de mujeres
            WomenCategoryHome()
                .tabItem {
                    Label("Women", systemImage: "person.fill")
                }
                .tag(Tab.women)

            // Vista de gráficos
            RankingView(isForMen: true)
                .tabItem {
                    Label("Rankings", systemImage: "chart.bar")
                }
                .tag(Tab.rankings)

            // Nueva pestaña de mapa
            GymMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(Tab.map)
        }
        .background(Color("Dark"))
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(named: "Dark")
            UITabBar.appearance().barTintColor = UIColor(named: "Dark")
            UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        }
    }
}
/*

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

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

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

*/
