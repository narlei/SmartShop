import UIKit
import HomeInterface

public final class HomeViewController: UIViewController, HomeViewControllerProtocol {
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        return table
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTaskTapped)
        )
    }()
    
    // MARK: - Properties
    private var tasks: [TaskItem] = []
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSampleTasks()
    }
    
    // MARK: - HomeViewControllerProtocol
    public func presentHome() {
        // Implementation for presenting the home view if needed
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = "Task List"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadSampleTasks() {
        tasks = [
            TaskItem(title: "Buy milk", isCompleted: false),
            TaskItem(title: "Study Swift", isCompleted: true),
            TaskItem(title: "Do exercises", isCompleted: false),
            TaskItem(title: "Read a book", isCompleted: false)
        ]
        tableView.reloadData()
    }
    
    @objc private func addTaskTapped() {
        let alert = UIAlertController(title: "New Task", 
                                    message: "Enter the task title", 
                                    preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Task title"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first,
                  let title = textField.text,
                  !title.isEmpty else { return }
            
            let newTask = TaskItem(title: title)
            self?.tasks.append(newTask)
            self?.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func toggleTask(at index: Int) {
        tasks[index].isCompleted.toggle()
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func deleteTask(at index: Int) {
        tasks.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        toggleTask(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTask(at: indexPath.row)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
