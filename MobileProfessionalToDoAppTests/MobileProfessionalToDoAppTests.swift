import XCTest
import Combine
@testable import MobileProfessionalToDoApp

final class TaskListViewModelTests: XCTestCase {

    class MockTaskService: TaskServiceProtocol {
        var tasks = CurrentValueSubject<[Task], Never>([])

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

    var viewModel: TaskListViewModel!
    var mockService: MockTaskService!

    override func setUp() {
        super.setUp()
        mockService = MockTaskService()
        viewModel = TaskListViewModel(taskService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testAddTask() {
        let expectation = XCTestExpectation(description: "Tarefa adicionada")

        var cancellable: AnyCancellable?
        cancellable = viewModel.$tasks.sink { tasks in
            if tasks.count == 1 {
                XCTAssertEqual(tasks.first?.title, "Comprar pão")
                expectation.fulfill()
                cancellable?.cancel()
            }
        }

        viewModel.addTask(title: "Comprar pão", description: "Ir na padaria", urgency: .high, status: .todo)

        wait(for: [expectation], timeout: 1.0)
    }


    func testUpdateTask() {
        let task = Task(id: UUID(), title: "Tarefa", description: "Antiga", urgency: .medium, status: .todo)
        mockService.add(task)

        let expectation = XCTestExpectation(description: "Tarefa atualizada")

        var cancellable: AnyCancellable?
        cancellable = viewModel.$tasks.sink { tasks in
            if let updated = tasks.first(where: { $0.id == task.id }),
               updated.title == "Atualizada" {
                XCTAssertEqual(updated.title, "Atualizada")
                expectation.fulfill()
                cancellable?.cancel()
            }
        }

        var updated = task
        updated.title = "Atualizada"
        viewModel.updateTask(updated)

        wait(for: [expectation], timeout: 1.0)
    }


    func testDeleteTask() {
        let task = Task(id: UUID(), title: "Apagar", description: "Remover essa", urgency: .low, status: .todo)
        mockService.add(task)

        viewModel.deleteTask(task)

        XCTAssertTrue(viewModel.tasks.isEmpty)
    }

    func testTasksAreOrderedByUrgency() {
        let low = Task(id: UUID(), title: "Baixa", description: "", urgency: .low, status: .todo)
        let high = Task(id: UUID(), title: "Alta", description: "", urgency: .high, status: .todo)
        let medium = Task(id: UUID(), title: "Média", description: "", urgency: .medium, status: .todo)

        mockService.add(low)
        mockService.add(high)
        mockService.add(medium)

        let expectation = XCTestExpectation(description: "Tarefas ordenadas por urgência")

        var cancellable: AnyCancellable?
        cancellable = viewModel.$tasks.sink { tasks in
            let filtered = tasks.filter { $0.status == .todo }
            if filtered.count == 3 {
                let ordered = filtered.sorted { t1, t2 in
                    let order: [TaskUrgency] = [.high, .medium, .low]
                    return order.firstIndex(of: t1.urgency)! < order.firstIndex(of: t2.urgency)!
                }

                XCTAssertEqual(ordered.map { $0.title }, ["Alta", "Média", "Baixa"])
                expectation.fulfill()
                cancellable?.cancel()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }


    func testFilterByStatus() {
        let t1 = Task(id: UUID(), title: "Tarefa 1", description: "", urgency: .low, status: .todo)
        let t2 = Task(id: UUID(), title: "Tarefa 2", description: "", urgency: .medium, status: .done)
        let t3 = Task(id: UUID(), title: "Tarefa 3", description: "", urgency: .high, status: .inProgress)

        mockService.add(t1)
        mockService.add(t2)
        mockService.add(t3)

        let expectation = XCTestExpectation(description: "Filtro por status")

        var cancellable: AnyCancellable?
        cancellable = viewModel.$tasks.sink { tasks in
            let inProgressTasks = tasks.filter { $0.status == .inProgress }
            if inProgressTasks.count == 1 {
                XCTAssertEqual(inProgressTasks.first?.title, "Tarefa 3")
                expectation.fulfill()
                cancellable?.cancel()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

}


