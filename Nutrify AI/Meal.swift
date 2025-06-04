import Foundation
import CoreData

@objc(Meal)
public class Meal: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var calories: Double
    @NSManaged public var protein: Double
    @NSManaged public var carbs: Double
    @NSManaged public var fat: Double
    @NSManaged public var timestamp: Date?
}

extension Meal {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        NSFetchRequest<Meal>(entityName: "Meal")
    }
}

extension Meal: Identifiable {}
