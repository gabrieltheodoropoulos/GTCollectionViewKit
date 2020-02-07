# GTCollectionViewKit

![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey)
![Language](https://img.shields.io/badge/Language-Swift-orange)
![Version](https://img.shields.io/badge/Version-1.0.0-blue)

#### Using collection views in iOS projects made easy!

## What GTCollectionViewKit does?

**GTCollectionViewKit** provides an alternative, yet simple and quite effective way to integrate collection views into your iOS projects. Its primary purpose is to *create a container view with a collection view embedded in it*, with the collection view configuration being possible through a variety of provided methods.

## What GTCollectionViewKit is?

GTCollectionViewKit is a **binary framework (.xcframework)** working in both devices and the simulator. It provides a public API through which is possible to use all available features. Find more about binary frameworks [here](https://developer.apple.com/videos/play/wwdc2019/416/).

### Integrating GTCollectionViewKit

To use GTCollectionViewKit framework in your projects:

* Download or clone this repository.
* In Xcode, select your project in the Project navigator and go to *General* tab.
* Drag and drop *GTCollectionViewKit.xcframework* into the *Frameworks, Libraries and Embedded Content* section.

![Framework Integrated](https://gtiapps.com/misc/samples/gtcollectionviewkit/gtcollectionview_integrated.png)

Add the following `import` statement to each file where GTCollectionViewKit is going to be used:

```swift
import GTCollectionViewKit
```

## GTCollectionViewKit API at a glance

GTCollectionViewKit public API offers a number of classes and protocols:

* `GTCollectionView`: The custom collection view implementation, a `UICollectionView` subclass.
* `GTCollectionViewContainer`: The container view that has a `GTCollectionView` collection view embedded in it.
* `GTCollectionViewCore`: A class with custom types that are used to specify the details of the collection view, such as the layout style, layout details, and more.
* `GTCollectionViewApplicable`: A protocol to adopt on any view controller or view subclass that is about to use `GTCollectionViewContainer` instances.
* `GTCollectionViewAdaptable`: Adopt this protocol in case you want to manually integrate and handle `GTCollectionView` in your views and not to use the `GTCollectionViewContainer` class.
* `GTCollectionViewPresets`: A collection of custom types provided for convenience.
* `GTTitleSubtitleImageCell`: A `UICollectionViewCell` subclass that can be used with NIB files. It provides IBOutlet properties for two labels and an image view.
* `GTCollectionViewDatasource`: Custom types that keep and handle the data of the collection view datasource.

*All classes, protocols, methods and properties are well documented. Use the Quick Help in Xcode to access documentation.*


## The GTCollectionViewContainer container view

There are three methods to initialize a `GTCollectionViewContainer` container view and specify the style of the embedded collection view:

```swift
createGrid(withColumns:datasource:registerElements:layoutInfo:)
// It creates a container view with a grid-based collection view.

createList(withDatasource:registerElements:layoutInfo:)
// It creates a container view with a list-based collection view.

createCollection(withLayoutRules:datasource:registerElements:layoutInfo:)
// It creates a container view with a collection view that supports different
// layout styles for various combinations of horizontal and vertical size classes.
```

All of them accept the collection view's datasource as a parameter value, as well as objects that describe the elements to register (cells, headers, footers) and the layout style of the collection view. For details see the documentation of the `GTCollectionViewCore.RegisterElement` and `GTCollectionViewCore.LayoutInfo` classes.

Last method above makes it possible to create a `GTCollectionViewContainer` view with a collection view that can have different styles depending on the specified size classes combination. For example, you can have list layout in compact vertical and regular horizontal size classes, and grid layout for regular vertical and any horizontal size classes.

**Important #1**

The returned type of all the above methods is `GTCollectionViewContainer<T>`, where T is the *type of the source data* that will be displayed on the collection view. When declaring container views as properties, then make sure to specify the datasource type as well. For example:

```swift
// Collection view's datasource is of Int type.
var cvContainer: GTCollectionViewContainer<Int>?

// Collection view's datasource type is of MyType type.
var anotherContainer: GTCollectionViewContainer<MyType>?
```

This requirement comes from the `GTCollectionView` definition (`GTCollectionView<T>`), which also requires the datasource type to be specified when initializing an object of it. Using generics that way makes it possible for GTCollectionViewKit to provide collection views that work with any type.

**Important #2**

Note that the public provided methods allowing to configure the collection view should be **chained** right after the method that initializes a `GTCollectionViewContainer` view instance. See usage examples below.

## The GTCollectionView

`GTCollectionView` is a `UICollectionView` subclass. It's possible to use it directly in your views (or view controllers) but in that case it's also required to adopt the `GTCollectionViewAdaptable` protocol and implement all required methods. Those consist of the only way to configure and handle a `GTCollectionView`; no direct access to delegate or datasource methods is provided.

When used through `GTCollectionViewContainer` views, collection view instances are accessible through the `collectionView` property of the `GTCollectionViewContainer` class.

The following is the definition of the initializer that you should use in case you integrate `GTCollectionView` directly:

```swift
public init(withAdapter adapter: T, layoutStyle: GTCollectionViewCore.LayoutStyle, gridColumns: Int)
```

`adapter` is the class that integrates the `GTCollectionView` instance and adopts the `GTCollectionViewAdaptable` protocol, `layoutStyle` specifies whether data will be displayed as a list or a grid, and `gridColumns` specifies the number of columns in case of a grid layout style.

One method you might find interesting is the `setScrollDirection(scrollVertically:)` through which you can specify the scroll direction. By default, collection view scroll is set to vertical.

## Usage examples

*For detailed examples on how to use `GTCollectionViewKit` open the demo project in Xcode and navigate through all provided samples! Here is just a taste of it.*

**Note:** In order to run the examples of the demo project, first add the GTCollectionViewKit framework to it following the steps described above in the *Integrating GTCollectionViewKit* part.

For starters, let's do some preparation:

```swift
// Declare the container view as a property:
var cvContainerView: GTCollectionViewContainer<Int>?

// Define the sample datasource: An array of Int values.
let values: [Int] = [5, 10, 2, 37, 8, 12, 44, 12, 26, 4, 32, 19]
```

The following creates a `GTCollectionViewContainer` view with a grid-based collection view. Notice that:

1. The cell to register with the collection view along with a few details is specified at first. Resulting object is used right next.
2. The container view is initialized. `datasource` parameter expects for a two-dimensional array.
3. Collection view is being configured through the public methods of the `GTCollectionViewContainer` class. These methods must be **chained** right after the creation of the container view!
4. The container view is added as a subview to another view.

```swift
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
    // The add(to:) method of the GTCollectionViewContainer class does the job.
    // It adds the container view as a subview and sets up autolayout constraints.
    cvContainerView?.add(to: self.view)
}
```

Here's another example with a list-based collection view that also has a section header and defines layout details:

```swift
func listDemo_With_Header_And_LayoutInfo() {
    // Specify a cell and a section header view to be registered
    // with the collection view.
    let registerElements = GTCollectionViewCore.RegisterElements()
    registerElements.registerClass(MyCell.self, elementKind: .cell, loadFromNib: true, customNibName: nil)
    registerElements.registerClass(MainHeaderView.self, elementKind: .header, loadFromNib: true, customNibName: nil)

    // Specify layout details.
    let layoutInfo = GTCollectionViewCore.LayoutInfo(withCellHeight: 120.0,
                                                     columnSpacing: 0.0,
                                                     rowSpacing: 24.0,
                                                     sectionInset: .zero,
                                                     makeSquare: false)

    // Initialize the GTCollectionViewContainer view.
    cvContainerView = createList(withDatasource: [values],
                                 registerElements: registerElements,
                                 layoutInfo: layoutInfo)

        // Configure cells.
        .configureCell({ (cell, data, indexPath) -> UICollectionViewCell in
            // Perform cell configuration...
            return ... // configured cell
        })

        // Configure the header view.
        .configureHeaderView({ (headerView, section) -> UIView in
            guard let view = headerView as? MyHeader else { return headerView }
            view.label?.text = "This is the Header!"
            return view
        })

        // Specify the header height.
        .setHeaderHeight({ (section) -> CGFloat in
            return 180.0
        })


    // Add the container view as a subview to self view.
    cvContainerView?.add(to: self.view)
}
```

Finally, one last example that specifies different layout for different size class combinations:

```swift
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
            // ... perform cell configuration
        })


    cvContainerView?.add(to: self.view)
}
```

## Legal statement & Copyright notice

You are allowed to use GTCollectionViewKit framework in both personal and commercial projects, and to extend it whenever that's possible. You are *not* allowed to sell it and claim ownership.

**Copyright © 2020 Gabriel Theodoropoulos**
