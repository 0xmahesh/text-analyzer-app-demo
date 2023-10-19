//
//  StandardProcessFileUseCase.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation

final class StandardProcessFileUseCase: ProcessFileUseCaseProtocol {
    private let fileHandler: FileHandlerProtocol
    
    init(fileHandler: FileHandlerProtocol) {
        self.fileHandler = fileHandler
    }
    
    func execute(filePath: URL, fileName: String) async -> (Bool, WordInfoDict?) {
        return await fileHandler.processTextFile(at: filePath, filename: fileName)
    }
}
