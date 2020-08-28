import UIKit

class PagingPresenterHelper {
    static func calculateIndexPathsToReload(allItemsCount: Int,
                                            newItemsCount: Int,
                                            section: Int) -> [IndexPath] {

        let startIndex = allItemsCount - newItemsCount
        let endIndex = startIndex + newItemsCount

        return (startIndex ..< endIndex).map { IndexPath(row: $0, section: section) }
    }
}
