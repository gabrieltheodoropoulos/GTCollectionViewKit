//
//  ViewController.swift
//  GTCollectionViewDemo
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2020 Gabriel Theodoropoulos. All rights reserved.
//

import UIKit
import GTCollectionViewKit

class ViewController: UIViewController, GTCollectionViewApplicable {

    var cvContainerView: GTCollectionViewContainer<Int>?

    var values = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        values = generateRandomValues()
        
        // Uncomment the following methods one by one to try them out.
        // Make sure to keep all others commented out!
        
        gridDemo()
        // gridDemo_With_Layout_Info()
        // gridDemo_With_Section_Header()
        // gridDemo_With_Header_And_Footer()
        // gridDemo_With_Multiple_Cells()
        
        // listDemo()
        // listDemo_HorizontalScrolling()
        // listDemo_With_Header_And_LayoutInfo()
        // listDemo_Multiple_Headers_Footers()
                
        // demo_Using_Size_Classes()
    }
    
    
    // MARK: - Grid Layout Style Methods

    func gridDemo() {
        // Create a GTCollectionViewCore.RegisterElements object for registering
        // MyCell custom cell with the collection view.
        let registerElements = GTCollectionViewCore.RegisterElements(MyCell.self,
                                                                     elementKind: .cell,
                                                                     loadFromNib: true,
                                                                     customNibName: nil)
        
        // Initialize the container view.
        cvContainerView = createGrid(withColumns: 2,
                                     datasource: [values],
                                     registerElements: registerElements,
                                     layoutInfo: nil)
            
            // Configure the cells.
            .configureCell({ (cell, data, indexPath) -> UICollectionViewCell in
                
                // Configure the cell for each index path.
                // cell is a UICollectionViewCell object, so casting to MyCell
                // is necessary so we can access its custom properties.
                guard let myCell = cell as? MyCell else {
                    return UICollectionViewCell()
                }
                
                // Populate the data matching to the current index path
                // to the title label of the cell.
                // Data is an Int number in this sample.
                myCell.titleLabel?.text = "\(data)"
                return myCell
                
            })
        
            // Handle tap actions on cells.
            .tapAction({ (indexPath) in
                print("Tapped cell at", indexPath)
            })
        
        
        // Add the container view as a subview to self view.
        // addContainerView is a local helper method defined at the end of the class.
        addContainerView()
    }
    
    
    func gridDemo_With_Layout_Info() {
        // Specify the cell class to register with the collection view.
        let registerElements = GTCollectionViewCore.RegisterElements(MyCell.self, elementKind: .cell, loadFromNib: true, customNibName: nil)
        
        
        // Create a layout info object and set custom values for the cell height,
        // column and row spacing, section inset and whether cells should be displayed
        // as squares or not automatically.
        // See the initializer's documentation for more information!
        let layoutInfo = GTCollectionViewCore.LayoutInfo(withCellHeight: 240.0,
                                                         columnSpacing: 5.0,
                                                         rowSpacing: 25.0,
                                                         sectionInset: .zero,
                                                         makeSquare: false)
        
        // Initialize the container view.
        cvContainerView = createGrid(withColumns: 2,
                                     datasource: [values],
                                     registerElements: registerElements,
                                     layoutInfo: layoutInfo)
     
            .configureCell({ (cell, data, indexPath) -> UICollectionViewCell in
                return self.configureCell(cell, withData: data)
            })
        
        
        addContainerView()
    }
     
    
    func gridDemo_With_Section_Header() {
        // Specify a cell and a section header view to be registered
        // with the collection view.
        let registerElements = GTCollectionViewCore.RegisterElements()
        registerElements.registerClass(MyCell.self, elementKind: .cell, loadFromNib: true, customNibName: nil)
        registerElements.registerClass(MainHeaderView.self, elementKind: .header, loadFromNib: true, customNibName: nil)
        
        // Create the container view which contains a grid-style collection view.
        cvContainerView = createGrid(withColumns: 3,
                                     datasource: [values],
                                     registerElements: registerElements,
                                     layoutInfo: nil)
        
            .configureCell({ (cell, data, indexPath) -> UICollectionViewCell in
                return self.configureCell(cell, withData: data)
            })
        
            // Configure the header view.
            .configureHeaderView({ (headerView, section) -> UIView in
                guard let view = headerView as? MainHeaderView else { return headerView }
                view.label?.text = "This is the Header!"
                return view
            })
        
            // Specify the header height.
            .setHeaderHeight({ (section) -> CGFloat in
                return 180.0
            })
        
        
        addContainerView()
    }
 
        
    func gridDemo_With_Header_And_Footer() {
        // Specify the elements to register with the collection view.
        // A cell, a header view and a footer view.
        // All of them are loaded from NIB files.
        let registerElements = GTCollectionViewCore.RegisterElements()
        registerElements.registerClass(MyCell.self, elementKind: .cell, loadFromNib: true, customNibName: nil)
        registerElements.registerClass(MainHeaderView.self, elementKind: .header, loadFromNib: true, customNibName: nil)
        registerElements.registerClass(FooterView.self, elementKind: .footer, loadFromNib: true, customNibName: nil)
        
        // Create a GTCollectionViewContainer view with a collection view
        // using a grid layout with 3 columns.
        cvContainerView = createGrid(withColumns: 3,
                                     datasource: [values],
                                     registerElements: registerElements,
                                     layoutInfo: nil)
        
            // Configure the cells.
            .configureCell({ (cell, data, indexPath) -> UICollectionViewCell in
                return self.configureCell(cell, withData: data)
            })

            // Configure the header view and set its height.
            .configureHeaderView({ (headerView, section) -> UIView in
                guard let view = headerView as? MainHeaderView else { return headerView }
                view.label?.text = "This is the Header!"
                return view
            })
            .setHeaderHeight({ (section) -> CGFloat in
                return 80.0
            })
        
            // Configure the footer view and set its height.
            .configureFooterView({ (footerView, section) -> UIView in
                guard let view = footerView as? FooterView else { return footerView }
                view.label.text = "This is the Footer!"
                return view
            })
            .setFooterHeight({ (section) -> CGFloat in
                return 60.0
            })
        
        
        // Add the GTCollectionViewContainer view to self view.
        addContainerView()
    }
    
    
    func gridDemo_With_Multiple_Cells() {
        let registerElements = GTCollectionViewCore.RegisterElements()
        registerElements.registerClass(MyCell.self, elementKind: .cell, loadFromNib: true, customNibName: nil)
        registerElements.registerClass(AlternativeCell.self, elementKind: .cell, loadFromNib: true, customNibName: nil)
        
        cvContainerView = createGrid(withColumns: 4,
                                     datasource: [values],
                                     registerElements: registerElements,
                                     layoutInfo: nil)
        
            .configureCell({ (cell, data, indexPath) -> UICollectionViewCell in
                if indexPath.item.isMultiple(of: 2) {
                    let myCell = cell as? MyCell
                    myCell?.titleLabel?.text = "\(data)"
                    return myCell ?? UICollectionViewCell()
                } else {
                    let alternativeCell = cell as? AlternativeCell
                    alternativeCell?.titleLabel?.text = "\(data)"
                    return alternativeCell ?? UICollectionViewCell()
                }
            })
        
            // Since there are more than one cell types to be dequeued,
            // specify them in the following method.
            // Note that it's not necessary to call the following when
            // there's just one type of cell to register.
            .dequeueCell({ (indexPath) -> UICollectionViewCell.Type in
                return indexPath.item.isMultiple(of: 2) ? MyCell.self : AlternativeCell.self
            })
        
        addContainerView()
    }
    
    
    
    // MARK: - List Layout Style Samples
    
    func listDemo() {
        // Specify the cell to register with the collection view.
        let registerElements = GTCollectionViewCore.RegisterElements(MyCell.self, elementKind: .cell, loadFromNib: true, customNibName: nil)
     
        // Specify layout details.
        let layoutInfo = GTCollectionViewCore.LayoutInfo(withCellHeight: 80.0,
                                                         columnSpacing: 0.0,
                                                         rowSpacing: 8.0,
                                                         sectionInset: .init(top: 20.0, left: 8.0, bottom: 20.0, right: 8.0),
                                                         makeSquare: false)
        
        // Create a GTCollectionViewContainer which contains a list-style
        // collection view.
        cvContainerView = createList(withDatasource: [values],
                                     registerElements: registerElements,
                                     layoutInfo: layoutInfo)
        
            .configureCell({ (cell, data, indexPath) -> UICollectionViewCell in
                // configureCell(_:withData:) is a local convenient method!
                return self.configureCell(cell, withData: data)
            })
        
            .tapAction({ (indexPath) in
                print("You tapped at", indexPath)
            })
        
        
        addContainerView()
    }
 
    
    func listDemo_HorizontalScrolling() {
        listDemo()
        cvContainerView?.collectionView?.setScrollDirection(scrollVertically: false)
    }
    
    
    func listDemo_With_Header_And_LayoutInfo() {
        // Specify a cell and a section header view to be registered
        // with the collection view.
        let registerElements = GTCollectionViewCore.RegisterElements()
        registerElements.registerClass(MyCell.self, elementKind: .cell, loadFromNib: true, customNibName: nil)
        registerElements.registerClass(MainHeaderView.self, elementKind: .header, loadFromNib: true, customNibName: nil)
        
        // Specify some layout details.
        let layoutInfo = GTCollectionViewCore.LayoutInfo(withCellHeight: 60.0,
                                                         columnSpacing: 0.0,
                                                         rowSpacing: 24.0,
                                                         sectionInset: UIEdgeInsets(top: 24.0, left: 0.0, bottom: 0.0, right: 0.0),
                                                         makeSquare: false)
        
        // Initialize the GTCollectionViewContainer view.
        cvContainerView = createList(withDatasource: [values],
                                     registerElements: registerElements,
                                     layoutInfo: layoutInfo)
        
            // Configure cells.
            .configureCell({ (cell, data, indexPath) -> UICollectionViewCell in
                return self.configureCell(cell, withData: data)
            })
        
            // Configure the header view.
            .configureHeaderView({ (headerView, section) -> UIView in
                guard let view = headerView as? MainHeaderView else { return headerView }
                view.label?.text = "This is the Header!"
                view.label?.textColor = .white
                view.backgroundColor = .clear
                return view
            })
        
            // Specify the header height.
            .setHeaderHeight({ (section) -> CGFloat in
                return 80.0
            })
        
        
        // Add the container view as a subview to self view.
        addContainerView()
    }
    
    
    func listDemo_Multiple_Headers_Footers() {
        // The collection view that will be created next will contain two sections.
        // Generate random integer numbers as the datasource for the second section.
        let additionalValues = generateRandomValues()
        
        let registerElements = GTCollectionViewCore.RegisterElements()
        
        // Specify the cell type to register with the collection view.
        registerElements.registerClass(MyCell.self, elementKind: .cell, loadFromNib: true, customNibName: nil)
        
        // Specify the header views to register with the collection view.
        registerElements.registerClass(MainHeaderView.self, elementKind: .header, loadFromNib: true, customNibName: nil)
        registerElements.registerClass(SecondaryHeaderView.self, elementKind: .header, loadFromNib: true, customNibName: nil)
        
        // Specify the footer views to register with the collection view.
        registerElements.registerClass(FooterView.self, elementKind: .footer, loadFromNib: true, customNibName: nil)
        registerElements.registerClass(AlternativeFooterView.self, elementKind: .footer, loadFromNib: true, customNibName: nil)
        
        
        // Specify the layout details.
        let layoutInfo = GTCollectionViewCore.LayoutInfo(withCellHeight: 44.0,
                                                         columnSpacing: 0.0,
                                                         rowSpacing: 8.0,
                                                         sectionInset: .init(top: 16.0, left: 10.0, bottom: 16.0, right: 10.0),
                                                         makeSquare: false)
        
        
        // The collection view will have as many sections as the elements in
        // the following array.
        let datasource = [values, additionalValues]
        
        // Create the container view with the collection view.
        cvContainerView = createList(withDatasource: datasource,
                                     registerElements: registerElements,
                                     layoutInfo: layoutInfo)
        
            // Configure cells.
            .configureCell({ (cell, data, indexPath) -> UICollectionViewCell in
                return self.configureCell(cell, withData: data)
            })
        
            // Configure the header views.
            // Notice that the section argument in the closure is used to configure
            // header views conditionally.
            .configureHeaderView({ (headerView, section) -> UIView in
                if section == 0 {
                    // If casting to the desired custom type fails then just return the
                    // headerView argument as it is.
                    guard let view = headerView as? MainHeaderView else { return headerView }
                    
                    // Configure the header view and return it.
                    view.label?.text = "Header #1"
                    view.label?.textColor = .white
                    view.backgroundColor = .clear
                    return view
                } else {
                    guard let view = headerView as? SecondaryHeaderView else { return headerView }
                    view.label?.text = "Header #2"
                    return view
                }
            })
            .setHeaderHeight({ (section) -> CGFloat in
                // Specify different heights for the header views in each section.
                return section == 0 ? 80.0 : 120.0
            })
            .dequeueHeaderView({ (section) -> UIView.Type in
                // Since there are more than on headers, it's REQUIRED to specify
                // the custom types of the header views that should be dequeued.
                // In case of the first section then dequeue the MainHeaderView,
                // otherwise the SecondaryHeaderView.
                return section == 0 ? MainHeaderView.self : SecondaryHeaderView.self
            })
        
            
            // Configure the footer views.
            // Treat footer views similarly to header views!
            .configureFooterView({ (footerView, section) -> UIView in
                if section == 0 {
                    guard let view = footerView as? FooterView else { return footerView }
                    view.label?.text = "Footer #1"
                    return view
                } else {
                    guard let view = footerView as? AlternativeFooterView else { return footerView }
                    view.label?.text = "Footer #2"
                    view.label?.textAlignment = .left
                    return view
                }
            })
            .setFooterHeight({ (section) -> CGFloat in
                return section == 0 ? 40.0 : 120.0
            })
            .dequeueFooterView({ (section) -> UIView.Type in
                return section == 0 ? FooterView.self : AlternativeFooterView.self
            })
        
        
        addContainerView()
    }
    
    
    // MARK: - Samples with Size Classes
    
    /**
     Specify different layout styles (list or grid) depending on the
     horizontal and vertical size classes of the device.
     */
    func demo_Using_Size_Classes() {
        // Specify the cell to register with the collection view.
        let registerElements = GTCollectionViewCore.RegisterElements(MyCell.self, elementKind: .cell, loadFromNib: true, customNibName: nil)

        // Specify layout rules (see GTCollectionViewCore.LayoutRule class) for various
        // size class combinations right below.

        // Rule #1:
        // Use the list layout style when the horizontal size class is Compact.
        // Passing nil to vertical size class will apply the rule to both Compact and Regular
        // vertical size classes.
        let CxAny = GTCollectionViewCore.LayoutRule(whenHorizontalSizeClassIs: .compact, andVerticalSizeClassIs: nil, applyLayoutStyle: .list, withColumns: 0)

        // Rule #2:
        // Use the grid layout style with 2 columns in Regular horizontal size class
        // and Compact vertical size class.
        let RxC = GTCollectionViewCore.LayoutRule(whenHorizontalSizeClassIs: .regular, andVerticalSizeClassIs: .compact, applyLayoutStyle: .grid, withColumns: 2)

        // Rule #3:
        // Use the grid layout style with 3 columns in Regular horizontal size class
        // and Regular vertical size class.
        let RxR = GTCollectionViewCore.LayoutRule(whenHorizontalSizeClassIs: .regular, andVerticalSizeClassIs: .regular, applyLayoutStyle: .grid, withColumns: 3)


        // Create the container view with the collection view using the
        // layout rules specified right above.
        cvContainerView = createCollection(withLayoutRules: [CxAny, RxC, RxR],
                                           datasource: [values],
                                           registerElements: registerElements,
                                           layoutInfo: nil)

            .configureCell({ (cell, data, indexPath) -> UICollectionViewCell in
                return self.configureCell(cell, withData: data)
            })


        addContainerView()
    }
    
    
    
    // MARK: - Helper Methods
    
    func generateRandomValues() -> [Int] {
        var numbers = [Int]()
        for _ in 0..<20 {
            numbers.append(Int.random(in: 0..<50))
        }
        return numbers
    }
    
    
    func configureCell(_ cell: UICollectionViewCell, withData data: Int) -> UICollectionViewCell {
        let myCell = cell as? MyCell
        myCell?.titleLabel?.text = "\(data)"
        return myCell ?? UICollectionViewCell()
    }
    
    
    func addContainerView() {
        cvContainerView?.add(to: self.view)
        cvContainerView?.backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
    }
}

