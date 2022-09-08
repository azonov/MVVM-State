//
//  DataModuleView.swift
//  MVVMExample (iOS)
//
//  Created by Andey on 06.06.2022.
//

import Combine
import Common
import SwiftUI

struct DataModuleView<ViewModel: DataViewModeling>: View {
    
    @StateObject
    var viewModel: ViewModel
   
    var body: some View {
        ZStack {
            NavigationView {
                contentView(content: viewModel.state.content)
                    .refreshable { viewModel.trigger(.onRefresh) }
                    .searchable(text: searchString, placement: .toolbar)
                    .navigationTitle("SwiftUI")
            }
            .alert("Error", isPresented: isPresentedAlert, actions: {})
        }
        .onAppear { viewModel.trigger(.onLoad) }
    }
    
    private var searchString: Binding<String> {
        Binding(
            get: { viewModel.state.query },
            set: { viewModel.trigger(.onSearch($0)) }
        )
    }
    
    private var isPresentedAlert: Binding<Bool> {
        guard case .loaded(let item) = viewModel.state.content else {
            return .falseBinding
        }
        return Binding(
            get: { item.isAlertPresenting },
            set: { viewModel.trigger(.onAlertPresented($0)) }
        )
    }
    
    @ViewBuilder
    private func contentView(content: DataModuleContentViewState) -> some View {
        switch content {
        case .loaded(let item):
            List {
                ForEach(item.titles, id: \.self, content: Text.init)
                loadMore(item.loadMore)
            }
            
        case .error(let error):
            List {
                Text(error)
            }
            
        case .loading:
            ProgressView()
        }
    }
    
    @ViewBuilder
    private func loadMore(_ loadMore: DataModuleContentViewState.DisplayData.LoadMore) -> some View {
        switch loadMore {
        case .available:
            ProgressView().onAppear { viewModel.trigger(.onLoadMore) }
            
        case .unavailable:
            EmptyView()
            
        case .failed:
            Button("Retry") { viewModel.trigger(.onRetry) }
        }
    }
}
