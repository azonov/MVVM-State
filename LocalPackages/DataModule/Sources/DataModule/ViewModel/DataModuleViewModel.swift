//
//  DataModuleViewIO.swift
//  MVVMExample (iOS)
//
//  Created by Andey on 06.06.2022.
//

import Combine
import Common
import Foundation

protocol DataViewModeling: ViewModel where State == DataModuleViewState, Intent == DataModuleViewIntent {}

final class DataModuleViewModel: DataViewModeling {
    
    @Published
    private(set) var state: DataModuleViewState
    private let dataLoader: DataLoading
    private var apiCallCancellable: AnyCancellable?
    private var storeListenerCancellable: AnyCancellable?
    private var searchQueueCancellable: AnyCancellable?
    private let searchQueuePublisher = PassthroughSubject<String, Never>()
    
    // MARK: Lifecycle
    init(dataLoader: DataLoading) {
        self.dataLoader = dataLoader
        self.state = DataModuleViewState(query: "swift", content: .loading(.firstPage))
    }
    
    deinit {
        Log.info("deinit  | \(self)")
    }
    
    // MARK: Public
    func trigger(_ intent: DataModuleViewIntent) {
        switch intent {
        case .onLoad:
            subscribeForDataUpdates()
            refreshData(pagination: .firstPage)
            
        case .onRefresh:
            state.content = state.content.refresh()
            refreshData(pagination: .firstPage)
            
        case .onLoadMore:
            state.content = state.content.loadMore()
            refreshData(pagination: state.content.pagination)
            
        case .onRetry:
            refreshData(pagination: state.content.pagination)
            
        case .onAlertPresented(let isPresented):
            state.content = state.content.alert(isPresented: isPresented)
            
        case .onSearch(let text):
            searchQueuePublisher.send(text)
        }
    }
    
    // MARK: Private
    private func observeSearchInputUpdates() {
        searchQueueCancellable = searchQueuePublisher
            .removeDuplicates()
            .debounce(for: .milliseconds(700), scheduler: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.state.content = .loading(.firstPage)
            })
            .sink(receiveValue: { [weak self] text in
                guard let self = self else { return }
                self.state.query = text
                self.refreshData(pagination: .firstPage)
            })
    }
    
    private func subscribeForDataUpdates() {
        observeSearchInputUpdates()
        storeListenerCancellable = dataLoader
            .subscribeForData()
            .sink(receiveValue: weak(self, DataModuleViewModel.handleNewData))
    }
    
    private func refreshData(pagination: Pagination) {
        apiCallCancellable = dataLoader
            .refreshData(pagination: pagination, query: state.query)
            .sink(receiveCompletion: weak(self, DataModuleViewModel.handleFailure), receiveValue: {})
    }
    
    private func handleNewData(_ data: ModuleData) {
        var page = state.content.pagination.nextPage
        if case .loaded(let displayData) = state.content, displayData.isRefreshing {
            page = .firstPage.nextPage
        }
        state.content = .loaded(.init(titles: data.items.map(\.name), loadMore: .available(page)))
    }
    
    private func handleFailure(_ result: Subscribers.Completion<Error>) {
        guard case let .failure(error) = result else {
            return
        }
        switch state.content {
        case .loading, .error:
            state.content = .error(error.localizedDescription)
            
        case .loaded:
            state.content = state.content.failedRefresh()
        }
    }
}
