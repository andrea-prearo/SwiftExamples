//
//  TasksDataSource.swift
//  TaskList
//
//  Created by Andrea Prearo on 5/1/17.
//  Copyright © 2017 Andrea Prearo. All rights reserved.
//

import UIKit

struct TasksDataSource {
    var tasks: [Task]? = nil {
        didSet {
            if oldValue == nil {
                viewModels = initializeViewModels()
            }
        }
    }

    fileprivate var viewModels: [[TaskViewModel]] = [[]]
    fileprivate var headerViewModels: [TaskHeaderViewModel] = Priority.allValues().map {
        return TaskHeaderViewModel(sectionText: $0.asString)
    }

    public var isGrouped = false {
        didSet {
            viewModels = rearrangeTasks(isGrouped: isGrouped)
        }
    }

    // MARK: - Public Methods
    func numberOfSections() -> Int {
        return viewModels.count
    }

    func numberOfItems(inSection section: Int) -> Int {
        return viewModels[section].count
    }

    func header(for section: Int) -> TaskHeaderViewModel? {
        return headerViewModels[section]
    }

    func item(at indexPath: IndexPath) -> TaskViewModel? {
        return viewModels[indexPath.section][indexPath.row]
    }

    mutating func updateItem(at indexPath: IndexPath, checked: Bool) {
        guard let updateTask = updateTask(at: indexPath, checked: checked) else {
            return
        }
        updateTaskViewModel(at: indexPath, task: updateTask, checked: checked)
    }

    @discardableResult
    mutating func updateTask(at indexPath: IndexPath, checked: Bool) -> Task? {
        let viewModel = viewModels[indexPath.section][indexPath.row]
        let originalTask = viewModel.task
        let taskIndex: Int?
        if isGrouped {
            taskIndex = tasks?.index {
                return $0 == originalTask
            }
        } else {
            taskIndex = indexPath.row
        }
        guard let index = taskIndex else {
            return nil
        }
        let updatedTask = Task(name: originalTask.name, priority: originalTask.priority, completed: checked)
        tasks?[index] = updatedTask
        return updatedTask
    }

    @discardableResult
    mutating func updateTaskViewModel(at indexPath: IndexPath, task: Task, checked: Bool) -> TaskViewModel? {
        let updatedViewModel = TaskViewModel(task: task)
        viewModels[indexPath.section][indexPath.row] = updatedViewModel
        return updatedViewModel
    }
}

// MARK: - Private Methods
fileprivate extension TasksDataSource {
    func initializeViewModels() -> [[TaskViewModel]] {
        guard let tasks = tasks else {
            return [[]]
        }
        return [tasks.map {
            return TaskViewModel(task: $0)
        }]
    }

    func rearrangeTasks(isGrouped: Bool) -> [[TaskViewModel]] {
        guard let tasks = tasks else {
            return [[]]
        }
        let viewModels: [[TaskViewModel]]
        if isGrouped {
            var unknownPriorities = [TaskViewModel]()
            var highPriorities = [TaskViewModel]()
            var mediumPriorities = [TaskViewModel]()
            var lowPriorities = [TaskViewModel]()
            for task in tasks {
                switch task.priority {
                case .unknown:
                    unknownPriorities.append(TaskViewModel(task: task))
                case .high:
                    highPriorities.append(TaskViewModel(task: task))
                case .medium:
                    mediumPriorities.append(TaskViewModel(task: task))
                case .low:
                    lowPriorities.append(TaskViewModel(task: task))
                }
            }
            viewModels = [
                unknownPriorities,
                highPriorities,
                mediumPriorities,
                lowPriorities
            ]
        } else {
            viewModels = initializeViewModels()
        }
        return viewModels
    }
}
