import Foundation
import Combine

protocol TaskServiceProtocol {
    var tasks: CurrentValueSubject<[Task], Never> { get }
    func add(_ task: Task)
    func update(_ task: Task)
    func delete(_ task: Task)
    func getTasks() -> [Task]
}

class TaskService: TaskServiceProtocol {
    static let shared = TaskService()
    var tasks = CurrentValueSubject<[Task], Never>([])

    private init() {}

    func add(_ task: Task) {
        tasks.value.append(task)
    }

    func update(_ task: Task) {
        if let index = tasks.value.firstIndex(where: { $0.id == task.id }) {
            tasks.value[index] = task
        }
    }

    func delete(_ task: Task) {
        tasks.value.removeAll { $0.id == task.id }
    }

    func getTasks() -> [Task] {
        return tasks.value
    }
}
