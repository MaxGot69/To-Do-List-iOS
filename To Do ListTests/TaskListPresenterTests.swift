import XCTest
@testable import To_Do_List

class TaskListPresenterTests: XCTestCase {
    
    var presenter: TaskListPresenter!
    var mockInteractor: MockTaskListInteractor!
    var mockView: MockTaskListView!
    var mockRouter: MockTaskListRouter!
    
    override func setUp() {
        super.setUp()
        presenter = TaskListPresenter()
        mockInteractor = MockTaskListInteractor()
        mockView = MockTaskListView()
        mockRouter = MockTaskListRouter()
        
        presenter.interactor = mockInteractor
        presenter.view = mockView
        presenter.router = mockRouter
        mockInteractor.output = presenter
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        mockView = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testViewDidLoad_CallsLoadTasksFromAPI() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockInteractor.loadTasksFromAPICalled)
    }
    
    func testViewWillAppear_CallsFetchTasks() {
        // When
        presenter.viewWillAppear()
        
        // Then
        XCTAssertTrue(mockInteractor.fetchTasksCalled)
    }
    
    func testDidToggleTask_CallsToggleTask() {
        // Given
        let mockTask = createMockTask()
        
        // When
        presenter.didToggleTask(mockTask)
        
        // Then
        XCTAssertTrue(mockInteractor.toggleTaskCalled)
        XCTAssertEqual(mockInteractor.toggledTask, mockTask)
    }
    
    func testDidSearchTasks_WithEmptyQuery_CallsFetchTasks() {
        // When
        presenter.didSearchTasks("")
        
        // Then
        XCTAssertTrue(mockInteractor.fetchTasksCalled)
        XCTAssertFalse(mockInteractor.searchTasksCalled)
    }
    
    func testDidSearchTasks_WithQuery_CallsSearchTasks() {
        // When
        presenter.didSearchTasks("test")
        
        // Then
        XCTAssertTrue(mockInteractor.searchTasksCalled)
        XCTAssertEqual(mockInteractor.searchQuery, "test")
    }
    
    func testTasksLoaded_UpdatesTasksAndCallsView() {
        // Given
        let mockTasks = [createMockTask(), createMockTask()]
        
        // When
        presenter.tasksLoaded(mockTasks)
        
        // Then
        XCTAssertEqual(presenter.tasks.count, 2)
        XCTAssertTrue(mockView.showTasksCalled)
        XCTAssertEqual(mockView.shownTasks?.count, 2)
    }
    
    func testLoadingStarted_CallsViewShowLoading() {
        // When
        presenter.loadingStarted()
        
        // Then
        XCTAssertTrue(mockView.showLoadingCalled)
    }
    
    func testLoadingFinished_CallsViewHideLoading() {
        // When
        presenter.loadingFinished()
        
        // Then
        XCTAssertTrue(mockView.hideLoadingCalled)
    }
    
    func testErrorOccurred_CallsViewShowError() {
        // Given
        let errorMessage = "Test error"
        
        // When
        presenter.errorOccurred(errorMessage)
        
        // Then
        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertEqual(mockView.errorMessage, errorMessage)
    }
    
    func testTaskDeleted_CallsFetchTasks() {
        // When
        presenter.taskDeleted()
        
        // Then
        XCTAssertTrue(mockInteractor.fetchTasksCalled)
    }
    
    func testTasksSearchCompleted_UpdatesTasksAndCallsView() {
        // Given
        let mockTasks = [createMockTask()]
        
        // When
        presenter.tasksSearchCompleted(mockTasks)
        
        // Then
        XCTAssertEqual(presenter.tasks.count, 1)
        XCTAssertTrue(mockView.showSearchResultsCalled)
        XCTAssertEqual(mockView.searchResults?.count, 1)
    }
    
    func testForceReloadFromAPI_CallsInteractor() {
        // When
        presenter.forceReloadFromAPI()
        
        // Then
        XCTAssertTrue(mockInteractor.forceReloadFromAPICalled)
    }
    
    // MARK: - Helper Methods
    private func createMockTask() -> Task {
        let task = Task(context: CoreDataManager.shared.viewContext)
        task.id = "1"
        task.title = "Test Task"
        task.isCompleted = false
        task.createdDate = Date()
        return task
    }
}

// MARK: - Mock Classes
class MockTaskListInteractor: TaskListInteractorProtocol {
    var output: TaskListInteractorOutputProtocol?
    
    var loadTasksFromAPICalled = false
    var fetchTasksCalled = false
    var toggleTaskCalled = false
    var searchTasksCalled = false
    var deleteTaskCalled = false
    var forceReloadFromAPICalled = false
    
    var toggledTask: Task?
    var searchQuery: String?
    var deletedTask: Task?
    
    func loadTasksFromAPI() {
        loadTasksFromAPICalled = true
    }
    
    func fetchTasks() {
        fetchTasksCalled = true
    }
    
    func toggleTask(_ task: Task) {
        toggleTaskCalled = true
        toggledTask = task
    }
    
    func searchTasks(_ query: String) {
        searchTasksCalled = true
        searchQuery = query
    }
    
    func deleteTask(_ task: Task) {
        deleteTaskCalled = true
        deletedTask = task
    }
    
    func forceReloadFromAPI() {
        forceReloadFromAPICalled = true
    }
}

class MockTaskListView: TaskListViewProtocol {
    var showTasksCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var showErrorCalled = false
    var showSearchResultsCalled = false
    var showActionSheetCalled = false
    
    var shownTasks: [Task]?
    var errorMessage: String?
    var searchResults: [Task]?
    var actionSheetTask: Task?
    
    func showTasks(_ tasks: [Task]) {
        showTasksCalled = true
        shownTasks = tasks
    }
    
    func showLoading() {
        showLoadingCalled = true
    }
    
    func hideLoading() {
        hideLoadingCalled = true
    }
    
    func showError(_ message: String) {
        showErrorCalled = true
        errorMessage = message
    }
    
    func showSearchResults(_ tasks: [Task]) {
        showSearchResultsCalled = true
        searchResults = tasks
    }
    
    func showActionSheet(for task: Task) {
        showActionSheetCalled = true
        actionSheetTask = task
    }
}

class MockTaskListRouter: TaskListRouterProtocol {
    var navigateToTaskDetailCalled = false
    var navigateToAddTaskCalled = false
    
    var navigatedTask: Task?
    
    func navigateToTaskDetail(_ task: Task) {
        navigateToTaskDetailCalled = true
        navigatedTask = task
    }
    
    func navigateToAddTask() {
        navigateToAddTaskCalled = true
    }
} 