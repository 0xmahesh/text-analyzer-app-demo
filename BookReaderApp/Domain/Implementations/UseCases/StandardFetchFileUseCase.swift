//
//  StandardFetchFileUseCase.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation

final class StandardFetchFileUseCase: FetchFileUseCaseProtocol {
    
    private let fileRepository: FileRepositoryProtocol
    
    init(fileRepository: FileRepositoryProtocol) {
        self.fileRepository = fileRepository
    }
    
    func execute(with url: String, delegate: URLSessionDownloadDelegate) async throws -> (Bool, FileDetails?) {
        
        if let (filePath, fileName) = await fileRepository.fetchLocalFile(url: url) {
            return (true, (filePath, fileName))
        }
        
        try await fileRepository.fetchRemoteFile(url: url, delegate: delegate)
        return (true, nil)
        
    }
}
