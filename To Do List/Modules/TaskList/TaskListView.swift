import SwiftUI
import CoreData

struct TaskListView: View {
    
    // MARK: - Properties
    @StateObject var presenter: TaskListPresenter
    
    // MARK: - Initialization
    init(presenter: TaskListPresenter = TaskListPresenter()) {
        self._presenter = StateObject(wrappedValue: presenter)
        setupPresenter()
    }
    
    // MARK: - Setup
    private func setupPresenter() {
        let interactor = TaskListInteractor()
        let router = TaskListRouter()
        
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(spacing: 0) {
                    // MARK: - Header
                    HStack {
                        Text("Список задач")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(Constants.Colors.primaryText))
                        
                        Spacer()
                        
                        Button(action: {
                            presenter.clearAllDataAndReload()
                        }) {
                            Image(systemName: "trash")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(Constants.Colors.accentYellow))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // MARK: - Search Bar
                    CustomSearchBar(
                        text: Binding(
                            get: { "" },
                            set: { newValue in
                                presenter.didSearchTasks(newValue)
                            }
                        ),
                        placeholder: "Поиск задач..."
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    // MARK: - Task List
                    if presenter.tasks.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "list.bullet.clipboard")
                                .font(.system(size: 60))
                                .foregroundColor(Color(Constants.Colors.secondaryText))
                            
                            Text("Нет задач")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(Color(Constants.Colors.secondaryText))
                            
                            Text("Добавьте новую задачу или загрузите из сети")
                                .font(.body)
                                .foregroundColor(Color(Constants.Colors.secondaryText))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(presenter.tasks, id: \.objectID) { task in
                                    TaskRowView(task: task) { task in
                                        presenter.didToggleTask(task)
                                    }
                                    .onTapGesture {
                                        presenter.didSelectTask(task)
                                    }
                                    .onLongPressGesture(minimumDuration: 0.5) {
                                        presenter.didLongPressTask(task)
                                    }
                                    .contentShape(Rectangle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
                .background(Color(Constants.Colors.primaryBackground))
                .navigationBarHidden(true)
            }
            
            // MARK: - Add Task Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        presenter.didTapAddTask()
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color(Constants.Colors.accentYellow))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            presenter.viewDidLoad()
        }
        .sheet(isPresented: $presenter.showAddTaskSheet) {
            AddTaskView()
        }
        .alert("Редактировать задачу", isPresented: $presenter.showEditAlert) {
            TextField("Название", text: $presenter.state.editTitle)
            TextField("Описание", text: $presenter.state.editDescription)
            Button("Сохранить") {
                presenter.saveEditedTask()
            }
            Button("Отмена", role: .cancel) {}
        }
        .confirmationDialog("Действия с задачей", isPresented: $presenter.state.showActionSheet) {
            if let selectedTask = presenter.state.selectedTask {
                Button("Редактировать") {
                    presenter.didTapEditTask(selectedTask)
                }
                
                ShareLink(
                    item: """
                    Задача: \(selectedTask.title ?? "")
                    Описание: \(selectedTask.taskDescription ?? "Нет описания")
                    Статус: \(selectedTask.isCompleted ? "Выполнено" : "Не выполнено")
                    """,
                    subject: Text("Задача из To Do List"),
                    message: Text("Поделился задачей")
                ) {
                    Label("Поделиться", systemImage: "square.and.arrow.up")
                }
                
                Button("Удалить", role: .destructive) {
                    presenter.didDeleteTask(selectedTask)
                }
            }
            Button("Отмена", role: .cancel) {}
        }
    }
}

// MARK: - Task Row View
struct TaskRowView: View {
    let task: Task
    let onToggle: (Task) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            CustomCheckbox(isCompleted: task.isCompleted) {
                onToggle(task)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title ?? "")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(task.isCompleted ? Color(Constants.Colors.secondaryText) : Color(Constants.Colors.primaryText))
                    .strikethrough(task.isCompleted)
                
                if let description = task.taskDescription, !description.isEmpty {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(Color(Constants.Colors.secondaryText))
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Text(task.createdDate?.formatted(date: .abbreviated, time: .omitted) ?? "")
                .font(.caption)
                .foregroundColor(Color(Constants.Colors.secondaryText))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(Constants.Colors.secondaryBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Preview
#Preview {
    let presenter = TaskListPresenter()
    return TaskListView(presenter: presenter)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 
