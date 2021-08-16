//
//  Notas+CoreDataProperties.swift
//  nano4
//
//  Created by Gustavo Juk Ferreira Cruz on 16/08/21.
//
//

import Foundation
import CoreData


extension Notas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notas> {
        return NSFetchRequest<Notas>(entityName: "Notas")
    }

    @NSManaged public var titulo: String?
    @NSManaged public var anotacoes: Anotacoes?

}

extension Notas : Identifiable {

}
