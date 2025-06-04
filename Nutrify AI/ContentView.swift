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

    @State private var selectedMeal: Meal?


    var body: some View {
        NavigationView {
            List {
                ForEach(meals) { meal in
                    VStack(alignment: .leading) {
                        Text(meal.name ?? "Unnamed")
                            .font(.headline)
                        if let nutrition = meal.nutrition, !nutrition.isEmpty {
                            Text(nutrition)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onTapGesture {
                        selectedMeal = meal
                        showingForm = true

                    }
                }
                .onDelete(perform: deleteMeals)
            }
            .navigationTitle("Meals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { selectedMeal = nil; showingForm = true }) {

                        Label("Add Meal", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingForm) {
                MealFormView(meal: selectedMeal)
                    .environment(\.managedObjectContext, viewContext)
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

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
