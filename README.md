# SwiftUI Hierarchical List Performance

This is a demo project that highlights performance issues with [hierarchical SwiftUI lists](https://developer.apple.com/documentation/swiftui/list#Creating-hierarchical-lists).

There are three main problems:

1. Rendering of the list is slow if there are many items. (Just start the app and wait for the list to be rendered.)
2. Changing the selected item is very slow. (Tap/Click an item and wait for the selection to change.)
3. Updating the list is slow. (Press the "Shuffle" button.)

On an iPhone 13 Pro, it takes 6 seconds from tapping the app icon to the list being rendered. This was timed with a release build.
Once the list has been rendered, it takes 8 seconds for the selection to change when tapping an item.
Tapping the "Shuffle" button results in a 2 seconds delay before the updated list is rendered.

All three problems are much more pronounced on macOS (tested on a Mac Studio M2) where it even takes minutes(!) for the app to become responsive.

Instruments shows that 99% of the CPU time is spent somewhere deep inside SwiftUI.
Various attempts have been made to fix the problems (as documented in the code) but none of them have been successful.
