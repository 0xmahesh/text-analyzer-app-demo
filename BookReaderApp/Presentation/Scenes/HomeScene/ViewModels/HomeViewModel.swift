//
//  HomeViewModel.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation

final class HomeViewModel: NSObject, ObservableObject {
    @Published var urlInput: String = ""
    @Published var isDownloading = false
    @Published var isProcessing = false
    @Published var isButtonDisabled = false
    @Published var downloadProgress: Double = 0
    @Published var filePath: URL?
    @Published var fileName: String?
    @Published var showHistoryButton: Bool = false
    @Published var showAlert: Bool = false
    @Published var isUnsupportedFileFormat: Bool = false
    
    private var fileManager: FileManager = .default
    private var fetchFileUseCase: FetchFileUseCaseProtocol?
    private var processFileUseCase: ProcessFileUseCaseProtocol?
    private var persistBookInfoUseCase: PersistBookInfoUseCaseProtocol?
    private var fetchBookInfoUseCase: FetchBookInfoUseCaseProtocol?
    private var fetchAllBooksUseCase: FetchAllBooksUseCaseProtocol?
    
    init(fileManager: FileManager = .default,
         fetchFileUseCase: FetchFileUseCaseProtocol,
         processFileUseCase: ProcessFileUseCaseProtocol,
         persistBookInfoUseCase: PersistBookInfoUseCaseProtocol,
         fetchBookInfoUseCase: FetchBookInfoUseCaseProtocol,
         fetchAllBooksUseCase: FetchAllBooksUseCaseProtocol) {
        self.fileManager = fileManager
        self.fetchFileUseCase = fetchFileUseCase
        self.processFileUseCase = processFileUseCase
        self.persistBookInfoUseCase = persistBookInfoUseCase
        self.fetchBookInfoUseCase = fetchBookInfoUseCase
        self.fetchAllBooksUseCase = fetchAllBooksUseCase
    }
    
    func isBookStorageEmpty() async -> Bool {
        guard let books = await fetchAllBooksUseCase?.execute() else { return false }
        return books.isEmpty
    }
}

extension HomeViewModel {
    
    @MainActor
    func didViewAppear() async {
        showHistoryButton = await !isBookStorageEmpty()
    }
    
    @MainActor
    func processText(filePath: URL, filename: String) async -> Bool {
        if (await fetchBookInfoUseCase?.execute(url: urlInput)) != nil {
            self.showHistoryButton = true
            return self.showHistoryButton
        }
        
        let result = await processFileUseCase?.execute(filePath: filePath, fileName: filename)
        if let dictionary = result?.1 {
            if let isPersistSuccess = await persistBookInfoUseCase?.execute(url: urlInput, bookInfo: Book(fileName: filename, date: Date(), url: urlInput, info: dictionary)) {
                self.showHistoryButton = isPersistSuccess
                return showHistoryButton
            }
        }
        
        return false
    }
    
    @MainActor
    func fetchFile(at url: String) async -> FileDetails? {
        self.downloadProgress = 0
        self.fileName = nil
        self.filePath = nil
        
        //self.urlInput = url
        do {
            if let result = try await fetchFileUseCase?.execute(with: url, delegate: self) {
                if result.0 {
                    self.filePath = result.1?.filePath
                    self.fileName = result.1?.fileName
                    self.isButtonDisabled = false
                    return result.1
                }
            }
        } catch let error {
            print(error)
        }
        return nil
    }
        
}

extension HomeViewModel: URLSessionDelegate, URLSessionDownloadDelegate {
        
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // Handle downloaded file
            if let originalFilename = downloadTask.originalRequest?.url?.lastPathComponent {
                let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let destinationURL = documentsURL.appendingPathComponent(originalFilename)
                do {
                    try fileManager.moveItem(at: location, to: destinationURL)
                    print("File downloaded to: \(destinationURL)")
                    DispatchQueue.main.async { [weak self] in
                        self?.filePath = destinationURL
                        self?.fileName = originalFilename
                    }
                } catch {
                    print("Error moving file: \(error)")
                }
            }
        }
        
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            // Update download progress
            let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            print(progress
            )
            DispatchQueue.main.async { [weak self] in
                self?.downloadProgress = progress
            }
        }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            showAlert = true
        }
        
    }
}
