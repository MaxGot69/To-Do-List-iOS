import SwiftUI
import CoreData

struct AddTaskView: View {
    @StateObject var presenter: AddTaskPresenter
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var isLoading = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    init() {
        let presenter = AddTaskPresenter()
        let interactor = AddTaskInteractor()
        let router = AddTaskRouter()
        
        // Настраиваем связи
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        
        self._presenter = StateObject(wrappedValue: presenter)
    }
    

    
    var body: some View {
        ZStack {
            // Background
            Color(Constants.Colors.primaryBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation Bar
                navigationBarView
                
                // Form Content
                formContentView
            }
        }
        .onAppear {
            presenter.viewDidLoad()
        }
        .alert("Ошибка", isPresented: $showErrorAlert) {
            Button("OK") {}
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Navigation Bar
    private var navigationBarView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Text(Constants.Messages.cancel)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(Constants.Colors.primaryText))
            }
            
            Spacer()
            
            Text(Constants.Messages.addTaskTitle)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(Constants.Colors.primaryText))
            
            Spacer()
            
            Button(action: {
                saveTask()
            }) {
                Text(Constants.Messages.save)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(Constants.Colors.accentYellow))
            }
            .disabled(title.isEmpty || isLoading)
        }
        .padding(.horizontal, Constants.UI.spacing)
        .padding(.vertical, Constants.UI.smallSpacing)
        .background(Color(Constants.Colors.primaryBackground))
    }
    
    // MARK: - Form Content
    private var formContentView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.UI.largeSpacing) {
                // Title Section
                titleSection
                
                // Description Section
                descriptionSection
                
                Spacer(minLength: 100)
            }
            .padding(Constants.UI.spacing)
        }
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
            Text("Название")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(Constants.Colors.primaryText))
            
            TextField("Введите название задачи", text: $title)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 18))
                .foregroundColor(Color(Constants.Colors.primaryText))
                .padding(Constants.UI.spacing)
                .background(Color(Constants.Colors.secondaryBackground))
                .cornerRadius(Constants.UI.smallCornerRadius)
        }
    }
    
    // MARK: - Description Section
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
            Text("Описание")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(Constants.Colors.primaryText))
            
            TextField("Введите описание задачи (необязательно)", text: $description, axis: .vertical)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 16))
                .foregroundColor(Color(Constants.Colors.primaryText))
                .lineLimit(4...8)
                .padding(Constants.UI.spacing)
                .background(Color(Constants.Colors.secondaryBackground))
                .cornerRadius(Constants.UI.smallCornerRadius)
        }
    }
    
    // MARK: - Save Task
    private func saveTask() {
        print("Начинаю сохранение задачи...")
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Название задачи не может быть пустым"
            showErrorAlert = true
            return
        }
        
        let titleText = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let descriptionText = description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("Создаю задачу с названием: '\(titleText)' и описанием: '\(descriptionText ?? "nil")'")
        presenter.interactor?.createTask(title: titleText, description: descriptionText)
    }
}

// MARK: - AddTaskViewProtocol Implementation
extension AddTaskView: AddTaskViewProtocol {
    func showLoading() {
        isLoading = true
    }
    
    func hideLoading() {
        isLoading = false
    }
    
    func showError(_ message: String) {
        errorMessage = message
        showErrorAlert = true
    }
    
    func taskCreated() {
        hideLoading()
        print("Задача создана, закрываю экран")
        
        // Уведомляем о создании задачи
        NotificationCenter.default.post(name: NSNotification.Name("TaskCreated"), object: nil)
        
        dismiss()
    }
}

#Preview {
    AddTaskView()
} 