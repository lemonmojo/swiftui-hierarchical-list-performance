import Foundation

// MARK: - Data Model Declaration
final class ListItem {
    let id = UUID()
    let title: String
    let children: [ListItem]?
    
    var isFolder: Bool { children != nil }
    
    var systemImage: String {
        isFolder ? "folder" : "leaf"
    }
    
    init(title: String,
         children: [ListItem]) {
        self.title = title
        self.children = children
    }
    
    init(title: String) {
        self.title = title
        self.children = nil
    }
}

// MARK: - Protocol conformances
extension ListItem: Hashable, Equatable, Identifiable {
    static func == (lhs: ListItem, rhs: ListItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Generating Items
extension ListItem {
    static func createFolder(leafsCount: Int,
                             folderIndex: Int,
                             leafStartIndex: Int) -> ListItem {
        let children = createLeafs(count: leafsCount,
                                   startIndex: leafStartIndex)
        
        let folderItem = ListItem(title: "Folder #\(folderIndex)",
                                  children: children)
        
        return folderItem
    }
    
    static func createLeafs(count: Int,
                            startIndex: Int) -> [ListItem] {
        var items = [ListItem]()
        
        for idx in startIndex..<startIndex + count {
            let item = ListItem(title: "Item #\(idx)")
            items.append(item)
        }
        
        return items
    }
}
