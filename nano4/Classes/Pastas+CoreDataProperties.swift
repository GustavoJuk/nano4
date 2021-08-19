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
    @NSManaged public var anotacoes: NSOrderedSet?

}

// MARK: Generated accessors for anotacoes
extension Pastas {

    @objc(insertObject:inAnotacoesAtIndex:)
    @NSManaged public func insertIntoAnotacoes(_ value: Anotacoes, at idx: Int)

    @objc(removeObjectFromAnotacoesAtIndex:)
    @NSManaged public func removeFromAnotacoes(at idx: Int)

    @objc(insertAnotacoes:atIndexes:)
    @NSManaged public func insertIntoAnotacoes(_ values: [Anotacoes], at indexes: NSIndexSet)

    @objc(removeAnotacoesAtIndexes:)
    @NSManaged public func removeFromAnotacoes(at indexes: NSIndexSet)

    @objc(replaceObjectInAnotacoesAtIndex:withObject:)
    @NSManaged public func replaceAnotacoes(at idx: Int, with value: Anotacoes)

    @objc(replaceAnotacoesAtIndexes:withCategorias:)
    @NSManaged public func replaceAnotacoes(at indexes: NSIndexSet, with values: [Anotacoes])
    
    @objc(addAnotacoesObject:)
    @NSManaged public func addToAnotacoes(_ value: Anotacoes)

    @objc(removeAnotacoesObject:)
    @NSManaged public func removeFromAnotacoes(_ value: Anotacoes)

    @objc(addAnotacoes:)
    @NSManaged public func addToAnotacoes(_ values: NSOrderedSet)

    @objc(removeAnotacoes:)
    @NSManaged public func removeFromAnotacoes(_ values: NSOrderedSet)

}

extension Pastas : Identifiable {

}
