final class ServiceLocator {
    static let shared = ServiceLocator()

    private init() {}

    func provideTaskService() -> TaskServiceProtocol {
        return TaskService.shared
    }
}
