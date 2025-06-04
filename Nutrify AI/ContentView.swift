//
//  ContentView.swift
//  Nutrify AI
//
//  Created by EMRE MATARACI on 4.06.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.timestamp, ascending: true)],
        animation: .default)
    private var meals: FetchedResults<Meal>

    var body: some View {
        NavigationView {
            List {
                ForEach(meals) { meal in
                    NavigationLink {
                        Text(meal.name ?? "Unnamed")
                    } label: {
                        VStack(alignment: .leading) {
                            Text(meal.name ?? "Unnamed")
                            Text(meal.timestamp!, formatter: itemFormatter)
                                .font(.caption)
                        }
                    }
                }
                .onDelete(perform: deleteMeals)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addMeal) {
                        Label("Add Meal", systemImage: "plus")
                    }
                }
            }
            Text("Select a meal")
        }
    }

    private func addMeal() {
        withAnimation {
            let newMeal = Meal(context: viewContext)
            newMeal.name = "New Meal"
            newMeal.calories = 0
            newMeal.protein = 0
            newMeal.carbs = 0
            newMeal.fat = 0
            newMeal.timestamp = Date()

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

    private func deleteMeals(offsets: IndexSet) {
        withAnimation {
            offsets.map { meals[$0] }.forEach(viewContext.delete)

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
