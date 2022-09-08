import XCTest
import Combine
@testable import DataModule
import Common

final class DataModuleTests: XCTestCase {
    
    func testSuccessGenerator() throws {
        for generator in SuccessRate.allCases.map(ErrorGenerator.init) {
            var amountOfErrors = 0
            let allEvents = 12
            for _ in 1...allEvents {
                let isError = generator.isError
                if isError {
                    amountOfErrors += 1
                }
            }
            
            switch generator.successRate {
            case .successful:
                XCTAssertEqual(amountOfErrors, 0)
                
            case .failHalf:
                XCTAssertEqual(amountOfErrors, allEvents / 2)
                
            case .failQuarter:
                XCTAssertEqual(amountOfErrors, allEvents / 4)
                
            case .failThird:
                XCTAssertEqual(amountOfErrors, allEvents / 3)
            }
        }
    }
    
    //    #2
    //    Arrange:
    //    - Открываем экран
    //
    //    Act:
    //    - Листаем до следующей страницы
    //    - Ставим ответ запроса следующей страницы на паузу
    //    - Листаем в начало списка
    //    - Дергаем p2r
    //    - Получаем ответ от запроса на p2r
    //    - Отпускаем запрос следующей страницы
    //
    //    Assert:
    //    - Отображаются данные, которые пришли после p2r
    //    - Данные что пришли от следующей старницы игнорируются
    func testDataRace() {
        let api = DataLoadingStub()
        
        // - Открываем экран
        let vm = DataModuleViewModel(dataLoader: api)
        vm.trigger(.onLoad)
        api.refreshDataPromise?(.success(()))
        api.subscribeForDataPromise?(.success(.init(items: [.init(name: "test")])))
        
        // - Листаем до следующей страницы
        // - Ставим ответ запроса следующей страницы на паузу
        vm.trigger(.onLoadMore)
        
        // - Листаем в начало списка
        // - Дергаем p2r
        XCTAssert(api.cancelledRequests.isEmpty)
        vm.trigger(.onRefresh)
        // - Получаем ответ от запроса на p2r
        api.refreshDataPromise?(.success(()))
        XCTAssert(api.cancelledRequests.count == 1)
        XCTAssert(api.cancelledRequests.first! == Pagination(page: 2))
    }
    
    /// Pure expectation syntax
    func testInitialLoad() throws {
        var bag = Set<AnyCancellable>()
        let api = DataLoadingStub()
        let expectationLoading = self.expectation(description: "Loaded")
        let expectationLoaded = self.expectation(description: "Loaded")

        // - Открываем экран
        let vm = DataModuleViewModel(dataLoader: api)
        vm.$state.sink {
            switch $0.content {
            case .loaded(let value):
                XCTAssert(value.titles.first == "test")
                expectationLoaded.fulfill()
                
            case .loading(let pagination):
                XCTAssert(pagination == Pagination(page: 1))
                expectationLoading.fulfill()
                
            case .error:
                XCTAssertTrue(false)
            }
        }.store(in: &bag)
        
        vm.trigger(.onLoad)
        api.refreshDataPromise?(.success(()))
        api.subscribeForDataPromise?(.success(.init(items: [.init(name: "test")])))
        wait(for: [expectationLoaded, expectationLoading], timeout: 1)
    }
    
    /// Wait style syntax
    func testEror() throws {
        let api = DataLoadingStub()
        
        // - Открываем экран
        let vm = DataModuleViewModel(dataLoader: api)
        
        // -  Проверяем что при создании модуля передается состояние загрузки
        XCTAssert(try vm.$state.waitForFirstOutput().content == .loading(Pagination(page: 1)))
        
        vm.trigger(.onLoad)
        api.refreshDataPromise?(.success(()))
        api.subscribeForDataPromise?(.success(.init(items: [.init(name: "test")])))
        guard case DataModuleContentViewState.loaded(let data) = try vm.$state.waitForFirstOutput().content else {
            XCTAssertTrue(false)
            return
        }
        // Проверяем что состояние с корректными данными
        XCTAssertEqual(data.titles.first, "test")
        
        // Fail request on Load More
        vm.trigger(.onLoadMore)
        api.refreshDataPromise?(.failure(CoreError.notImplemented))
        guard case DataModuleContentViewState.loaded(let loadedValue) = try vm.$state.waitForFirstOutput().content,
              case DataModuleContentViewState.DisplayData.LoadMore.failed(let pagination) = loadedValue.loadMore else
        {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(pagination, Pagination(page: 2))
    }
}
