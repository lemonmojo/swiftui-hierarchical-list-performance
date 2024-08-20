import SwiftUI

struct ContentView: View {
    // Flat example data.
    /*
    private static let rootItem = ListItem.createFolder(leafsCount: 100_000,
                                                        folderIndex: 1,
                                                        leafStartIndex: 1)
    */
    // Real-world example data with folder hierarchy.

    private static let rootItem = ListItem(title: "Root", children: [
        .createFolder(leafsCount: 25_000, folderIndex: 1, leafStartIndex: 1),
        .createFolder(leafsCount: 25_000, folderIndex: 2, leafStartIndex: 25_001),
        .createFolder(leafsCount: 25_000, folderIndex: 3, leafStartIndex: 50_001),
        .createFolder(leafsCount: 25_000, folderIndex: 4, leafStartIndex: 75_001)
    ])

    @State
    private var items: [ListItem] = Self.rootItem.children ?? .init()
    
    @State
    private var selectedItem: ListItem?
    
    var body: some View {
        NavigationSplitView {
            OutlineView(items: items, selectedItem: $selectedItem)
            .toolbar {
                Button(action: {
                    print("shuffled")
                    items = items.shuffled()
                    print("items: \(items[0].title)")
                }, label: {
                    Label("Shuffle", systemImage: "shuffle.circle")
                })
            }
        } detail: {
            // Feel free to comment the whole body here out, it's still slow.
            if let item = selectedItem {
                Label("Selected item: \(item.title)", systemImage: item.systemImage)
            } else {
                Label("No item selected", systemImage: "info.circle")
            }
        }
    }
}

#Preview {
    ContentView()
}
