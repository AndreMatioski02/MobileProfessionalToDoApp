import SwiftUI

struct TaskDetailView: View {
    @State var task: Task
    @ObservedObject var viewModel: TaskListViewModel
    @State private var showEdit = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                Text("📝 **Título:** \(task.title)")
                Text("📄 **Descrição:** \(task.description)")
                Text("🔥 **Urgência:** \(task.urgency.rawValue)")
                Text("📌 **Status Atual:** \(task.status.rawValue)")
            }
            .padding(.bottom, 8)

            Divider()

            Text("Atualizar Status:")
                .font(.headline)

            HStack(spacing: 10) {
                ForEach(TaskStatus.allCases.filter { $0 != task.status }) { statusOption in
                    Button(statusOption.rawValue) {
                        updateStatus(statusOption)
                    }
                    .buttonStyle(StatusButtonStyle(color: colorForStatus(statusOption)))
                }
            }


            Spacer()

            Divider()

            HStack(spacing: 16) {
                Button("Editar") {
                    showEdit = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("Excluir") {
                    viewModel.deleteTask(task)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal) 

        }
        .padding()
        .navigationTitle("Detalhes")
        .sheet(isPresented: $showEdit) {
            AddEditTaskView(viewModel: viewModel, task: task)
        }
    }

    private func updateStatus(_ newStatus: TaskStatus) {
        if task.status != newStatus {
            task.status = newStatus
            viewModel.updateTask(task)
        }
    }
}

struct StatusButtonStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.bold())
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(configuration.isPressed ? 0.6 : 1))
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

private func colorForStatus(_ status: TaskStatus) -> Color {
    switch status {
    case .todo: return .red
    case .inProgress: return .orange
    case .done: return .green
    }
}

