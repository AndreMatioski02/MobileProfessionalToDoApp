# Documentação Técnica – Aplicativo iOS de Gerenciamento de Tarefas

## 1. Introdução

Este documento descreve a arquitetura, os padrões de projeto e as boas práticas aplicadas no desenvolvimento de um aplicativo iOS de gerenciamento de tarefas. O projeto foi desenvolvido utilizando **SwiftUI**, adotando a arquitetura **MVVM (Model-View-ViewModel)** e seguindo os princípios de **Clean Code**, **Injeção de Dependência**, **TDD (Desenvolvimento Orientado a Testes)** e aplicação de **Design Patterns**.

O aplicativo permite o cadastro, visualização, edição, organização e exclusão de tarefas, com campos como título, descrição, urgência (baixa, média, alta) e status (a fazer, em andamento, pronto). A interface é composta por três telas funcionais: listagem de tarefas, cadastro/edição e visualização detalhada.

## 2. Arquitetura Utilizada – MVVM

A arquitetura **MVVM** foi adotada com o objetivo de separar responsabilidades de forma clara e tornar o código mais testável e escalável:

- **Modelos (Model):** representam a estrutura de dados, como `Task`, `TaskStatus` e `TaskUrgency`.  
  📁 Arquivo: `Task.swift`

- **ViewModels:** encapsulam a lógica de apresentação e regras de negócio, servindo de ponte entre a interface e os serviços de dados.  
  📁 Arquivo: `TaskListViewModel.swift`

- **Views:** compostas por componentes SwiftUI, apresentam os dados da ViewModel ao usuário.  
  📁 Arquivos: `TaskListView.swift`, `AddEditTaskView.swift`, `TaskDetailView.swift`

## 3. Injeção de Dependência

Foi implementada a **Injeção de Dependência** para desacoplar a ViewModel dos serviços de dados, promovendo modularidade e facilitando testes unitários. A ViewModel recebe uma instância de `TaskServiceProtocol` via construtor:

```swift
init(taskService: TaskServiceProtocol = TaskService.shared)
