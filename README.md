## Text Analyzer App

![alt text](assets/demo.gif)

### Checking out the code
```
git clone https://github.com/0xmahesh/text-analyzer-app-demo.git
```

switch to <b>main</b> branch.

### Prerequisites
- Xcode 15.0 or later

### Functionality
- Users can enter a valid URL and download it, process it, following which a summary of the text document is displayed according to the requirements.
- Tapping on "History" button allows user to view a list of historical data, where previous analysis jobs are persisted in the disk.
- A lightweight disk based persistence mechanism is implemented for saving processed data.
- A simple input validation is implemented for the user input.
- A simple error handling mechanism implemented which will show standard error alerts if something goes wrong.
- Selecting a text analysis item in History page will take the user to a new screen which shows the summary of that particular file analysis.
- An activity indicator is shown during text processing and all other buttons will be disabled.
- Swift's structured concurrency is used to implement asynchronous functionality.
- Scrabble scoring mechanism employs a unicode code-point based approach, which is configurable to support different languages.

### Architecture
- The application adopts Clean Architecture with 4 major components: Presentation layer, Data layer, Domain layer, and Infrastructure layer.
- Presentation layer is implemented using MVVM architecture with SwiftUI's built-in StateObject used for data binding.
- Dependency Injection is handled using Compositional Root pattern with constructor injection. There is room for improvement (maybe use a Resolver pattern coupled with propertyWrappers), but I wanted to keep it simple.
- Navigation is handled using SwiftUI's NavigationStack. 

### Networking
- A simple FileDownloader client written using URLSession. 

### UI
- Comprises of 3 screens. HomeView with functionalityto submit a URL, then download and process it. It also has an entry point to a view that shows historical data.
- ResultsView shows a summary of the analyzed text along with the top 100 highest scoring Scrabble words.
- HistoryView shows a list of previously processed files and metadata. Clicking on these will take user to ResultsView for a summary of the analysis job.

### Unit Testing
- Unit tests cover Text Processing classes like FileHandler, ScrabbleScorer, WordProcessor, as well as Infra layer and Data layer related classes. A few tests written for HomeViewModel as well. 

