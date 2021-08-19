//
//  Anotacoes+CoreDataProperties.swift
//  nano4
//
//  Created by Gustavo Juk Ferreira Cruz on 16/08/21.
//
//

import Foundation
import CoreData


extension Anotacoes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Anotacoes> {
        return NSFetchRequest<Anotacoes>(entityName: "Anotacoes")
    }

    @NSManaged public var titulo: String?
    @NSManaged public var notas: Notas?
    @NSManaged public var pastas: Pastas?

}

extension Anotacoes {

    @objc(addNotasObject:)
    @NSManaged public func addToNotas(_ value: Notas)

    @objc(removeAnotacoesObject:)
    @NSManaged public func removeFromNotas(_ value: Notas)

    @objc(addAnotacoes:)
    @NSManaged public func addToNotas(_ values: NSOrderedSet)

    @objc(removeAnotacoes:)
    @NSManaged public func removeFromNotas(_ values: NSOrderedSet)

}

extension Anotacoes : Identifiable {

}
