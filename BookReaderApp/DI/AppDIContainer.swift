//
//  AppDIContainer.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import Foundation

final class AppDIContainer: ObservableObject {
    
    //Infra
    lazy var fileDownloaderService: FileDownloaderProtocol = {
        let client = FileDownloader()
        return client
    }()
    
    lazy var dictionaryStorage: DictionaryStorage<Book> = {
        let storageUrl = Constants.storageFileName
        let storage = DictionaryStorage<Book>(storageUrl: FileManager.default.dictionaryStorageUrl(for: storageUrl))
        return storage
    }()
    
    //Repositories
    lazy var fileRepository: FileRepositoryProtocol = {
        let repository = FileRepository(networkClient: fileDownloaderService)
        return repository
    }()
    
    //Text-Processing
    lazy var englishAlphabet: ScrabbleAlphabetConfigurable = {
        let language: ScrabbleLanguages = .english
        let allowedCodePoints: Set<Int> = Constants.englishAlphabetCodePoints
        let letterScores: [Int: Int] = Constants.englishAlphabetLetterScores
        let alphabet = ScrabbleAlphabet(language: language, allowedCodePoints: allowedCodePoints, letterScores: letterScores)
        return alphabet
    }()
    
    lazy var chineseAlphabet: ScrabbleAlphabetConfigurable = {
        let language: ScrabbleLanguages = .chinese
        let allowedCodePoints: Set<Int> = Constants.chineseAlphabetCodePoints
        let letterScores: [Int: Int] = Constants.chineseAlphabetLetterScores
        let alphabet = ScrabbleAlphabet(language: language, allowedCodePoints: allowedCodePoints, letterScores: letterScores)
        return alphabet
    }()
    
    lazy var scrabbleWordScorer: ScrabbleWordScorable = {
        let scorer = ScrabbleWordScorer(alphabet: englishAlphabet)
        return scorer
    }()
    
    lazy var wordProcessor: WordProcessable = {
        let wordProcessor = WordProcessor(scrabbleWordScorer: scrabbleWordScorer,
                                          wordExtractionRegexPattern: Constants.wordExtractionRegexPattern)
        return wordProcessor
    }()
    
    lazy var fileHandler: FileHandlerProtocol = {
       let handler = FileHandler(wordCounter: wordProcessor)
        return handler
    }()
    
    //UseCases
    lazy var fetchFileUseCase: FetchFileUseCaseProtocol = {
       let useCase = StandardFetchFileUseCase(fileRepository: fileRepository)
        return useCase
    }()
    
    lazy var processFileUseCase: ProcessFileUseCaseProtocol = {
       let useCase = StandardProcessFileUseCase(fileHandler: fileHandler)
        return useCase
    }()
    
    lazy var persistBookInfoUseCase: PersistBookInfoUseCaseProtocol = {
       let useCase = StandardPersistBookInfoUseCase(storage: dictionaryStorage)
        return useCase
    }()
    
    lazy var fetchBookInfoUseCase: FetchBookInfoUseCaseProtocol = {
       let useCase = StandardFetchBookInfoUseCase(storage: dictionaryStorage)
        return useCase
    }()
    
    lazy var fetchAllBooksUseCase: FetchAllBooksUseCaseProtocol = {
       let useCase = StandardFetchAllBooksUseCase(storage: dictionaryStorage)
        return useCase
    }()
    
    //ViewModels
    func makeHomeViewModel() -> HomeViewModel {
        let vm = HomeViewModel(fetchFileUseCase: fetchFileUseCase,
                               processFileUseCase: processFileUseCase,
                               persistBookInfoUseCase: persistBookInfoUseCase,
                               fetchBookInfoUseCase: fetchBookInfoUseCase,
                               fetchAllBooksUseCase: fetchAllBooksUseCase)
        return vm
    }
    
    func makeResultsViewModel(url: String) -> ResultsViewModel {
        let vm = ResultsViewModel(urlStr: url, fetchBookInfoUseCase: fetchBookInfoUseCase)
        return vm
    }
    
    func makeHistoryViewModel() -> HistoryViewModel {
        let vm = HistoryViewModel(fetchAllBooksUseCase: fetchAllBooksUseCase)
        return vm
    }

}
