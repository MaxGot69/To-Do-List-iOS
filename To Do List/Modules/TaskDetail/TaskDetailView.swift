import SwiftUI
import CoreData

struct TaskDetailView: View {
    let task: Task
    @StateObject var presenter: TaskDetailPresenter
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    @State private var showActionSheet = false
    
    init(task: Task) {
        self.task = task
        self._presenter = StateObject(wrappedValue: TaskDetailPresenter())
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(Constants.Colors.primaryBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation Bar
                navigationBarView
                
                // Content
                ScrollView {
                    VStack(alignment: .leading, spacing: Constants.UI.largeSpacing) {
                        // Task Title
                        titleSection
                        
                        // Task Description
                        descriptionSection
                        
                        // Task Date
                        dateSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(Constants.UI.spacing)
                }
            }
        }
        .onAppear {
            presenter.viewDidLoad()
            presenter.setTask(task)
        }
        .alert(Constants.Messages.deleteConfirmation, isPresented: $showDeleteAlert) {
            Button(Constants.Messages.cancel, role: .cancel) {}
            Button(Constants.Messages.delete, role: .destructive) {
                deleteTask()
            }
        } message: {
            Text(Constants.Messages.deleteMessage)
        }
        .confirmationDialog("Действия с задачей", isPresented: $showActionSheet) {
            Button(Constants.Messages.edit) {
                presenter.didTapEdit()
            }
            
            Button(Constants.Messages.share) {
                // Share action
            }
            
            Button(Constants.Messages.delete, role: .destructive) {
                showDeleteAlert = true
            }
        }
    }
    
    // MARK: - Navigation Bar
    private var navigationBarView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: Constants.UI.smallSpacing) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Text("Назад")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(Color(Constants.Colors.primaryText))
            }
            
            Spacer()
            
            Button(action: {
                showActionSheet = true
            }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(Constants.Colors.primaryText))
            }
        }
        .padding(.horizontal, Constants.UI.spacing)
        .padding(.vertical, Constants.UI.smallSpacing)
        .background(Color(Constants.Colors.primaryBackground))
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
            Text(task.title ?? "")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(Constants.Colors.primaryText))
                .lineLimit(nil)
        }
    }
    
    // MARK: - Description Section
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
            if let description = task.taskDescription, !description.isEmpty {
                Text(description)
                    .font(.system(size: 16))
                    .foregroundColor(Color(Constants.Colors.secondaryText))
                    .lineLimit(nil)
            }
        }
    }
    
    // MARK: - Date Section
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
            if let date = task.createdDate {
                Text(formatDate(date))
                    .font(.system(size: 14))
                    .foregroundColor(Color(Constants.Colors.secondaryText))
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.taskDate
        return formatter.string(from: date)
    }
    
    private func deleteTask() {
        presenter.didTapDelete()
    }
}

    // MARK: - TaskDetailViewProtocol Implementation
    extension TaskDetailView: TaskDetailViewProtocol {
        func showTask(_ task: Task) {
            // Task is already set in init
        }
        
        func showLoading() {
            // Loading state if needed
        }
        
        func hideLoading() {
            // Hide loading state
        }
        
        func showError(_ message: String) {
            // Show error alert
        }
        
        func taskDeleted() {
            dismiss()
        }
    }

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let task = Task(context: context)
    task.id = "preview-task"
    task.title = "Заняться спортом"
    task.taskDescription = "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!"
    task.createdDate = Date()
    task.isCompleted = false
    
    return TaskDetailView(task: task)
        .environment(\.managedObjectContext, context)
} 