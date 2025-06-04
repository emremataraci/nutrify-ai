import SwiftUI
import CoreData

struct MealFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    var meal: Meal?

    @State private var name: String = ""
    @State private var nutrition: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Info")) {
                    TextField("Name", text: $name)
                    TextField("Nutrition", text: $nutrition)
                }
            }
            .navigationTitle(meal == nil ? "Add Meal" : "Edit Meal")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveMeal() }
                }
            }
        }
        .onAppear {
            if let meal = meal {
                name = meal.name ?? ""
                nutrition = meal.nutrition ?? ""
            }
        }
    }

    private func saveMeal() {
        let target = meal ?? Meal(context: viewContext)
        target.name = name
        target.nutrition = nutrition
        if meal == nil {
            target.timestamp = Date()
        }
        do {
            try viewContext.save()
            dismiss()
        } catch {
            // Handle the error appropriately in a real app
            print("Failed to save meal: \(error)")
        }
    }
}

struct MealFormView_Previews: PreviewProvider {
    static var previews: some View {
        MealFormView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
