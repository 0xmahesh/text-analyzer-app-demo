//
//  HomeView.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation
import SwiftUI

enum Screens {
    case home
    case results
    case history
}

struct HomeView: View {
    private let dependencyProvider: AppDIContainer
    
    @StateObject private var viewModel: HomeViewModel
    
    init(dependencyProvider: AppDIContainer) {
        self.dependencyProvider = dependencyProvider
        _viewModel = StateObject(wrappedValue: dependencyProvider.makeHomeViewModel())
    }
    
    @State var path: [Screens] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("Book Analyzer")
                    .font(.title)
                    .padding(.top, 100)
                
                TextField("Enter URL here...", text: $viewModel.urlInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(20)
                    .cornerRadius(10)
                    .padding(.top, 10)
                    .onChange(of: viewModel.urlInput, initial: false) {
                        _,_  in
                            viewModel.filePath = nil
                            viewModel.fileName = nil
                            viewModel.isDownloading = false
                    }
                
                Button(action: {
                    viewModel.isUnsupportedFileFormat = false
                    
                    if viewModel.urlInput.isEmpty || !viewModel.urlInput.isValidUrl {
                        viewModel.showAlert = true
                    } else {
                        viewModel.isButtonDisabled = true
                        viewModel.isDownloading = true
                        Task {
                            let _ = await viewModel.fetchFile(at: viewModel.urlInput)
                        }
                    }
                }) {
                    PillShapedButtonView(withTitle: "Download")
                    
                }
                .buttonStyle(PlainButtonStyle())
                .padding(20)
                .disabled(viewModel.isButtonDisabled)
                
                if viewModel.isDownloading && viewModel.filePath == nil {
                    ProgressView("Downloading...", value: viewModel.downloadProgress)
                        .padding([.trailing, .leading, .top], 20)
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(height: 50)
                }
                
                // "Process" button
                if let filePath = viewModel.filePath {
                    Button(action: {
                        viewModel.isProcessing = true
                        if let fileName = viewModel.fileName {
                            Task {
                                if await viewModel.processText(filePath: filePath, filename: fileName) {
                                    self.path = [.results]
                                    viewModel.isProcessing = false
                                }
                            }
                        }
                    }) {
                        PillShapedButtonView(withTitle: "Process")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(20)
                }
                
                if viewModel.isProcessing {
                    HStack {
                        ProgressView()
                        Spacer()
                            .frame(width: 20)
                        Text("Processing file... Please wait...")
                            .font(.system(size: 12))
                    }
                    .padding(.top, 20)
                }
                
                if viewModel.showHistoryButton {
                    Button(action: {
                        self.path = [.history]
                    }) {
                        PillShapedButtonView(withTitle: "History")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(20)
                }
                
                Spacer()
                    .frame(height: 200)
            }
            .onAppear {
                Task {
                    await viewModel.didViewAppear()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .navigationDestination(for: Screens.self) { screen in
                switch screen {
                case .results:
                    ResultsView(dependencyProvider: dependencyProvider, url: viewModel.urlInput)
                case .history:
                    HistoryView(dependencyProvider: dependencyProvider)
                default:
                    EmptyView()
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            if viewModel.urlInput.isEmpty {
                return Alert(title: Text(""), message: Text("Please enter a URL."), dismissButton: .default(Text("OK")))
            } 
            else if !viewModel.urlInput.isValidUrl {
                return Alert(
                    title: Text("Error"),
                    message: Text("Please enter a valid URL."),
                    dismissButton: .default(Text("OK"))
                )
            } else {
                return Alert(
                    title: Text("Error"),
                    message: Text("Something went wrong. Please try again."),
                    dismissButton: .default(Text("OK")) {
                        DispatchQueue.main.async {
                            viewModel.isDownloading = false
                        }
                    }
                )
            }
        }
    }
    
}

private extension String {
    var isValidUrl: Bool {
        let urlPattern = #"^(https?|ftp)://[^\s/$.?#].[^\s]*$"#
        let urlTest = NSPredicate(format: "self matches %@", urlPattern)
        return urlTest.evaluate(with: self)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dependencyProvider: AppDIContainer())
    }
}


