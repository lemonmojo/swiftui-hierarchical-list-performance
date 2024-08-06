import SwiftUI

struct ContentView: View {
    // Flat example data.
    private static let rootItem = ListItem.createFolder(leafsCount: 100_000,
                                                        folderIndex: 1,
                                                        leafStartIndex: 1)
    
    // Real-world example data with folder hierarchy.
//    private static let rootItem = ListItem(title: "Root", children: [
//        .createFolder(leafsCount: 25_000, folderIndex: 1, leafStartIndex: 1),
//        .createFolder(leafsCount: 25_000, folderIndex: 2, leafStartIndex: 25_001),
//        .createFolder(leafsCount: 25_000, folderIndex: 3, leafStartIndex: 50_001),
//        .createFolder(leafsCount: 25_000, folderIndex: 4, leafStartIndex: 75_001)
//    ])
    
    @State
    private var items: [ListItem] = Self.rootItem.children ?? .init()
    
    @State
    private var selectedItem: ListItem?
    
    var body: some View {
        NavigationSplitView {
            Button {
                items = items.shuffled()
            } label: {
                Text("Shuffle")
            }

            List(items,
                 id: \.self, // Tried to use \.id, still slow.
                 children: \.children,
                 selection: $selectedItem) { item in
                Label(item.title, systemImage: item.systemImage)
                
                // Feel free to replace the Label above with constant Text, it's still slow.
//                Text("Constant")
            }
            // Tried to assign an ID to the List, still slow.
//            .id(UUID())
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
