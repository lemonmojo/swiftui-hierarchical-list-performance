#if os(iOS)
import UIKit

class OutlineViewController: UIViewController {
    private enum TreeSection: CaseIterable {
        case main
    }

    private typealias DS = UICollectionViewDiffableDataSource<TreeSection, ListItem>
    private typealias DSSnapshot = NSDiffableDataSourceSnapshot<TreeSection, ListItem>
    private typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ListItem>

    private var outlineView: UICollectionView!
    private var dataSource: DS!

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

    override func loadView() {
        let config = UICollectionLayoutListConfiguration(appearance: .sidebar)
        let layout = UICollectionViewCompositionalLayout.list(using: config)

        let outlineView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        outlineView.delegate = self

        self.outlineView = outlineView
        outlineView.delegate = self

        dataSource = Self.createDataSource(with: outlineView)
        outlineView.dataSource = dataSource

        outlineView.translatesAutoresizingMaskIntoConstraints = false

        view = outlineView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        applySnapshot(treeNodes: items, to: .main)
    }
}

internal extension OutlineViewController {
    func updateItems(_ newItems: [ListItem]) {
        items = newItems
        applySnapshot(treeNodes: items, to: .main)
    }
}

extension OutlineViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let selectedItem = dataSource.itemIdentifier(for: indexPath) {
            delegate?.selectionDidChange(to: selectedItem)
        }
    }
}

private extension OutlineViewController {
    private static func createDataSource(with collectionView: UICollectionView) -> DS {
        let cellRegistration: CellRegistration = {
            CellRegistration { cell, indexPath, treeNode in
                var config = cell.defaultContentConfiguration()

                config.image = UIImage(systemName: treeNode.systemImage)
                config.text = treeNode.title

                cell.contentConfiguration = config

                cell.accessories = treeNode.children != nil ? [ .outlineDisclosure() ] : .init()
            }
        }()

        return DS(collectionView: collectionView) { collectionView, indexPath, treeNode -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                         for: indexPath,
                                                         item: treeNode)
        }
    }

    private func applySnapshot(treeNodes: [ListItem], to section: TreeSection) {
        // reset section
        var snapshot = DSSnapshot()
        snapshot.appendSections([section])

        dataSource.apply(snapshot, animatingDifferences: false)

        // initial snapshot with the root nodes
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
        sectionSnapshot.append(treeNodes)

        func addItemsRecursively(_ nodes: [ListItem], to parent: ListItem?) {
            nodes.forEach {
                if let children = $0.children,
                   !children.isEmpty {
                    sectionSnapshot.append(children, to: $0)
                    addItemsRecursively(children, to: $0)
                }
            }
        }

        addItemsRecursively(treeNodes, to: nil)

        dataSource.apply(sectionSnapshot,
                         to: section,
                         animatingDifferences:  false)
    }
}
#endif
