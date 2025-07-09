# Documentação Técnica – Aplicativo iOS de Gerenciamento de Tarefas

## 1. Introdução

Este documento descreve a arquitetura, os padrões de projeto e as boas práticas aplicadas no desenvolvimento de um aplicativo iOS de gerenciamento de tarefas. O projeto foi desenvolvido utilizando **SwiftUI**, adotando a arquitetura **MVVM (Model-View-ViewModel)** e seguindo os princípios de **Clean Code**, **Injeção de Dependência**, **TDD (Desenvolvimento Orientado a Testes)** e aplicação de **Design Patterns**.

O aplicativo permite o cadastro, visualização, edição, organização e exclusão de tarefas, com campos como título, descrição, urgência (baixa, média, alta) e status (a fazer, em andamento, pronto). A interface é composta por três telas funcionais: listagem de tarefas, cadastro/edição e visualização detalhada.

## 2. Arquitetura Utilizada – MVVM

A arquitetura **MVVM** foi adotada com o objetivo de separar responsabilidades de forma clara e tornar o código mais testável e escalável:

- **Modelos (Model):** representam a estrutura de dados, como `Task`, `TaskStatus` e `TaskUrgency`.  
  Arquivo: `Task.swift`

- **ViewModels:** encapsulam a lógica de apresentação e regras de negócio, servindo de ponte entre a interface e os serviços de dados.  
  Arquivo: `TaskListViewModel.swift`

- **Views:** compostas por componentes SwiftUI, apresentam os dados da ViewModel ao usuário.  
  Arquivos: `TaskListView.swift`, `AddEditTaskView.swift`, `TaskDetailView.swift`

## 3. Injeção de Dependência

Foi implementada a **Injeção de Dependência** para desacoplar a ViewModel dos serviços de dados, promovendo modularidade e facilitando testes unitários. A ViewModel recebe uma instância de `TaskServiceProtocol` via construtor:

```swift
init(taskService: TaskServiceProtocol = TaskService.shared)

## 4. Design Patterns Aplicados

O projeto incorporou os seguintes **Padrões de Projeto (Design Patterns)**, utilizados para resolver problemas comuns de forma reutilizável e padronizada:

| Padrão              | Aplicação                                                                        | Arquivo                    |
|---------------------|----------------------------------------------------------------------------------|----------------------------|
| **Singleton**       | Garante uma única instância do serviço de tarefas                               | `TaskService.swift`        |
| **Observer**        | Observa alterações em `@Published var tasks` via Combine                         | `TaskListViewModel.swift`  |
| **Command**         | Botões de interface disparam ações encapsuladas como `updateTask`               | `TaskDetailView.swift`     |
| **Strategy**        | Ordenação dinâmica de tarefas por nível de urgência                              | `TaskListViewModel.swift`  |
| **Facade**          | Serviço de tarefas fornece interface simples para acesso aos dados              | `TaskService.swift`        |
| **Service Locator** | Centraliza fornecimento de dependências                                          | `ServiceLocator.swift`     |

---

## 5. Clean Code

As diretrizes de **Clean Code** foram aplicadas em todo o projeto, com foco em:

- **Nomenclaturas claras e descritivas** para variáveis, funções e tipos.
- **Funções curtas e coesas**, com uma única responsabilidade.
- **Separação de responsabilidades** entre Model, ViewModel e View.
- **Reutilização de componentes** e eliminação de duplicações.
- **Código modular**, com baixo acoplamento e alta coesão.

Essas práticas tornaram o projeto mais legível, escalável e de fácil manutenção.

---

## 6. TDD – Testes Unitários

Foi aplicado o **Desenvolvimento Orientado a Testes (TDD)** com cobertura para os principais fluxos do sistema, utilizando `XCTest` e `Combine` com `XCTestExpectation` para validar comportamentos assíncronos.

Os testes abrangem os seguintes cenários:

- Criação de tarefas
- Edição e atualização de tarefas
- Exclusão de tarefas
- Filtro por status
- Ordenação por urgência

Arquivo de testes: `TaskListViewModelTests.swift`

Exemplo de abordagem com `expectation`:

```swift
let expectation = XCTestExpectation(description: "Tarefa adicionada")
cancellable = viewModel.$tasks.sink { tasks in
    if tasks.count == 1 {
        XCTAssertEqual(tasks.first?.title, "Comprar pão")
        expectation.fulfill()
    }
}
viewModel.addTask(...)
wait(for: [expectation], timeout: 1.0)
