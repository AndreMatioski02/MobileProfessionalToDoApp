import Foundation

enum TaskStatus: String, CaseIterable, Identifiable {
    case todo = "A Fazer"
    case inProgress = "Em Andamento"
    case done = "Pronto"

    var id: String { rawValue }
}

enum TaskUrgency: String, CaseIterable, Identifiable {
    case low = "Baixa"
    case medium = "Média"
    case high = "Alta"

    var id: String { rawValue }
}

struct Task: Identifiable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var urgency: TaskUrgency
    var status: TaskStatus
}
