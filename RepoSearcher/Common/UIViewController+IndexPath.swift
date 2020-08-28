import UIKit

extension UIViewController {
    func isLoadingCell(for indexPath: IndexPath, viewModelsCount: Int) -> Bool {
    return indexPath.row >= viewModelsCount
  }

    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath], tableView: UITableView) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)

    return Array(indexPathsIntersection)
  }
}
