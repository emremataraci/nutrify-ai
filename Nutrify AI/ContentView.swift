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
    @State private var showingForm = false

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

    private func deleteMeals(offsets: IndexSet) {
        withAnimation {
            offsets.map { meals[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
