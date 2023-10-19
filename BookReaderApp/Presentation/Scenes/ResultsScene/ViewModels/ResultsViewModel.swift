//
//  ResultsViewModel.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-18.
//

import Foundation

final class ResultsViewModel: NSObject, ObservableObject {
    @Published var fileName: String?
    @Published var mostFrequentWord: WordInfo?
    @Published var mostFrequentSevenCharWord: WordInfo?
    @Published var scrabbleScores: [WordInfo]?
    
    private var fetchBookInfoUseCase: FetchBookInfoUseCaseProtocol?
    
    private var urlStr: String = ""
    
    init(urlStr: String,
         fetchBookInfoUseCase: FetchBookInfoUseCaseProtocol) {
        self.urlStr = urlStr
        self.fetchBookInfoUseCase = fetchBookInfoUseCase
        super.init()
        
        defer {
            Task {
                await processResults()
            }
        }
    }
    
    @MainActor
    private func processResults() async {
        fileName = extractFileName()
        mostFrequentWord = await extractWordWithHighestFrequency()
        mostFrequentSevenCharWord = await extractMostFrequentSevenCharWord()
        scrabbleScores = await extractHighestScoringScrabbleWords()
    }
    
    private func extractFileName() -> String {
        guard let lastPath = urlStr.split(separator: "/").last else {
            return ""
        }
        return String(lastPath)
    }
    
    private func extractWordWithHighestFrequency() async -> WordInfo? {
        guard let wordInfoDict = await fetchBookInfoUseCase?.execute(url: urlStr)?.info else { return nil }
        return wordInfoDict.max(by: { $0.value.frequency < $1.value.frequency })?.value
    }
    
    private func extractMostFrequentSevenCharWord() async -> WordInfo? {
        guard let wordInfoDict = await fetchBookInfoUseCase?.execute(url: urlStr)?.info else { return nil }
        let mostFrequentSevenCharWord = wordInfoDict.filter { $0.key.count == 7 }
            .max(by: { $0.value.frequency < $1.value.frequency })
        return mostFrequentSevenCharWord?.value
    }
    
    private func extractHighestScoringScrabbleWords(limit: Int = 100) async -> [WordInfo]? {
        guard let wordInfoDict = await fetchBookInfoUseCase?.execute(url: urlStr)?.info else { return nil }
        
        let highestScoringWords = wordInfoDict.values
            .sorted { $0.scrabbleScore > $1.scrabbleScore }
            .prefix(limit)
        
        return Array(highestScoringWords)
    }
}
