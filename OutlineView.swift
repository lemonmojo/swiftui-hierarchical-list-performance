import SwiftUI

#if os(macOS) && !targetEnvironment(macCatalyst)
import AppKit

typealias ViewControllerRepresentable = NSViewControllerRepresentable
typealias ViewController = NSViewController
#elseif os(iOS)
import UIKit

typealias ViewControllerRepresentable = UIViewControllerRepresentable
typealias ViewController = UIViewController
#endif

protocol OutlineViewDelegate {
    func selectionDidChange(to selectedItem: ListItem)
}

struct OutlineView: ViewControllerRepresentable {
    let items: [ListItem]

    @Binding var selectedItem: ListItem?

#if os(macOS) && !targetEnvironment(macCatalyst)
    func makeNSViewController(context: Context) -> some NSViewController {
        return makeViewController(context: context)
    }

    func updateNSViewController(_ nsViewController: NSViewControllerType,
                                context: Context) {
        updateViewController(nsViewController, context: context)
    }
#elseif os(iOS)
    func makeUIViewController(context: Context) -> some UIViewController {
        return makeViewController(context: context)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType,
                                context: Context) {
        updateViewController(uiViewController, context: context)
    }
#endif

    func makeViewController(context: Context) -> some ViewController {
        let viewController = OutlineViewController(items: items)
        viewController.delegate = context.coordinator

        return viewController
    }

    func updateViewController(_ viewController: ViewController,
                              context: Context) {
        guard let outlineVC = viewController as? OutlineViewController else {
            return
        }

        outlineVC.updateItems(items)
    }

    class Coordinator: OutlineViewDelegate {
        var parent: OutlineView

        init(_ parent: OutlineView) {
            self.parent = parent
        }

        func selectionDidChange(to selectedItem: ListItem) {
            parent.selectedItem = selectedItem
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
