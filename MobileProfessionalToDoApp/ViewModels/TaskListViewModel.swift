import Foundation
import Combine

class TaskListViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    private let taskService: TaskServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(taskService: TaskServiceProtocol = ServiceLocator.shared.provideTaskService()) {
        self.taskService = taskService
        taskService.tasks
            .receive(on: RunLoop.main)
            .assign(to: &$tasks)
    }

    func addTask(title: String, description: String, urgency: TaskUrgency, status: TaskStatus) {
        let newTask = Task(id: UUID(), title: title, description: description, urgency: urgency, status: status)
        taskService.add(newTask)
    }

    func updateTask(_ task: Task) {
        taskService.update(task)
    }

    func deleteTask(_ task: Task) {
        taskService.delete(task)
    }
}

