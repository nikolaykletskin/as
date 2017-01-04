class AppState {
    static let shared = AppState()
    var memType: memTypes?
    
    enum memTypes {
        case simpleMem
        case expression
    }
    
    private init() {}
}

