import XCTest
@testable import RepoSearcher

//TODO: provide more unit tests

class RepoSearcherTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let viewController = UIViewController()

        XCTAssertEqual(viewController.isLoadingCell(for: IndexPath(row: 0, section: 0),
                                                    viewModelsCount: 10), false, "isLoadingCell works incorrectly")
        XCTAssertEqual(viewController.isLoadingCell(for: IndexPath(row: 10, section: 0),
                                                    viewModelsCount: 10), true, "isLoadingCell works incorrectly")
        XCTAssertEqual(viewController.isLoadingCell(for: IndexPath(row: 10, section: 0),
                                                    viewModelsCount: 5), true, "isLoadingCell works incorrectly")


        XCTAssertEqual(PagingPresenterHelper.calculateIndexPathsToReload(allItemsCount: 7, newItemsCount: 2, section: 0),
                       [IndexPath(row: 5, section: 0), IndexPath(row: 6, section: 0)], "calculateIndexPathsToReload works incorrectly")
        XCTAssertEqual(PagingPresenterHelper.calculateIndexPathsToReload(allItemsCount: 6, newItemsCount: 0, section: 0),
                       [], "calculateIndexPathsToReload works incorrectly")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
