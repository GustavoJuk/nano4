//
//  Pastas+CoreDataProperties.swift
//  nano4
//
//  Created by Gustavo Juk Ferreira Cruz on 16/08/21.
//
//

import Foundation
import CoreData


extension Pastas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pastas> {
        return NSFetchRequest<Pastas>(entityName: "Pastas")
    }

    @NSManaged public var ordem: Int64
    @NSManaged public var titulo: String?
    @NSManaged public var anotacoes: NSSet?

}

// MARK: Generated accessors for anotacoes
extension Pastas {

    @objc(addAnotacoesObject:)
    @NSManaged public func addToAnotacoes(_ value: Anotacoes)

    @objc(removeAnotacoesObject:)
    @NSManaged public func removeFromAnotacoes(_ value: Anotacoes)

    @objc(addAnotacoes:)
    @NSManaged public func addToAnotacoes(_ values: NSSet)

    @objc(removeAnotacoes:)
    @NSManaged public func removeFromAnotacoes(_ values: NSSet)

}

extension Pastas : Identifiable {

}
