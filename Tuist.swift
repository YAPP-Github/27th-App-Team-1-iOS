import ProjectDescription

let tuist = Tuist(project: .tuist(
    plugins: [
        .local(path: .relativeToRoot("Plugins/DependencyPlugin")),
        .local(path: .relativeToRoot("Plugins/ConfigPlugin")),
        .local(path: .relativeToRoot("Plugins/EnvPlugin")),
        .local(path: .relativeToRoot("Plugins/TemplatePlugin"))
    ],
    generationOptions: .options()
))
