//
//  Feature.swift
//  ConfigPlugin
//
//  Created by 최안용 on 1/15/26.
//

import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")
let author: Template.Attribute = .required("author")
let currentDate: Template.Attribute = .required("current_date")

let template = Template(
    description: "Creates a new feature module",
    attributes: [
        nameAttribute,
        author,
        currentDate
    ],
    items: ModuleTemplate.allCases.flatMap{ $0.item }
)

enum ModuleTemplate: CaseIterable {
    case main, sources // 추후 tests/demo 등 추가
    
    var path: String {
        switch self {
        case .main:
            return .basePath
        case .sources:
            return .basePath + "/Sources"
        }
    }
    
    var item: [Template.Item] {
        switch self {
        case .main:
            return [.file(path: path + "/Project.swift", templatePath: "Project.stencil")]
        case .sources:
            return [.file(path: path + "/Empty.swift", templatePath: "Empty.stencil")]
        }
    }
}

extension String {
    static var basePath: String {
        return "Projects/Features/\(nameAttribute)Feature"
    }
}
