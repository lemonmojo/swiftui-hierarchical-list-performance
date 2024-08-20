#if os(macOS) && !targetEnvironment(macCatalyst)
import Cocoa
import SwiftUI

class OutlineViewController: NSViewController {
    private var outlineView: NSOutlineView!

    private var items: [ListItem]

    var delegate: (any OutlineViewDelegate)?

    init(items: [ListItem]) {
        self.items = items

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        view.translatesAutoresizingMaskIntoConstraints = false
        let scrollView = NSScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])

        outlineView = NSOutlineView()
        outlineView?.delegate = self
        outlineView?.dataSource = self

        scrollView.documentView = outlineView

        let column = NSTableColumn()
        column.title = "Test"
        outlineView?.addTableColumn(column)
    }
}

internal extension OutlineViewController {
    func updateItems(_ newItems: [ListItem]) {
        // Don't reloadData is the items haven't changed
        // reloading data removes the selection
        if items != newItems {
            items = newItems
            outlineView.reloadData()
        }
    }
}

extension OutlineViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView,
                     numberOfChildrenOfItem item: Any?) -> Int {
        guard let listItem = item as? ListItem else {
            return items.count
        }

        return listItem.children?.count ?? 0
    }

    func outlineView(_ outlineView: NSOutlineView,
                     child index: Int,
                     ofItem item: Any?) -> Any {
        if let listItem = item as? ListItem {
            if let children = listItem.children,
               index < children.count {
                return children[index]
            } else {
                fatalError()
            }
        }

        return items[index]
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let listItem = item as? ListItem,
           let children = listItem.children {
            return !children.isEmpty
        }

        return false
    }
}

extension OutlineViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView,
                     viewFor tableColumn: NSTableColumn?,
                     item: Any) -> NSView? {
        guard let listItem = item as? ListItem else {
            return nil
        }

        return NSTextField(labelWithString: listItem.title)
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        if let item = outlineView.item(atRow: outlineView.selectedRow) as? ListItem {
            delegate?.selectionDidChange(to: item)
        }
    }
}
#endif
