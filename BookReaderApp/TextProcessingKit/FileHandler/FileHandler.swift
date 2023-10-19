//
//  FileHandler.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import Foundation

actor FileHandler: FileHandlerProtocol {
    private let chunkSize: Int
    private var wordCounter: WordProcessable
    
    init(chunkSize: Int = 512, wordCounter: WordProcessable) {
        self.chunkSize = chunkSize
        self.wordCounter = wordCounter
    }
    
    func processTextFile(at filePath: URL, filename: String) async -> (Bool, WordInfoDict?) {
        print("Processing file named: \(filename)")
        do {
            if let fileHandle = try? FileHandle(forReadingFrom: filePath),
                let newlineData = "\n".data(using: .utf8) {
                var buffer = Data()
                var partialLine = Data()
                
                while true {
                    if let chunk = try fileHandle.read(upToCount: chunkSize) {
                        buffer.append(chunk)
                        let combinedData = partialLine + buffer
                        var lineStart = combinedData.startIndex
                        
                        while let range = combinedData.range(of: newlineData, options: .anchored) {
                            if range.lowerBound >= lineStart {
                                let lineData = combinedData[lineStart..<range.lowerBound]
                                if let line = String(data: lineData, encoding: .utf8) {
                                    try await processLine(line)
                                }
                                lineStart = range.upperBound
                            } else {
                                lineStart = combinedData.index(after: lineStart)
                            }
                        }
                        
                        partialLine = combinedData[lineStart..<combinedData.endIndex]
                        buffer.removeAll(keepingCapacity: true)
                    } else {
                        if !partialLine.isEmpty {
                            if let line = String(data: partialLine, encoding: .utf8) {
                                try await processLine(line)
                            }
                        }
                        break
                    }
                }
                
                fileHandle.closeFile()
            } else {
                return (false, nil)
            }
        } catch {
            print("Error reading file: \(error)")
            return (false, nil)
        }
        return await (true, wordCounter.getWordDictionary())
    }
    
    private func processLine(_ line: String) async throws {
        try await wordCounter.countWords(in: line)
    }
}
