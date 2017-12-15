# ObjectsInfoView

ObjectsInfoView is UIView subclass, that used to display objects array.

# Initialization

 `ObjectsInfoView` has the same initializers to `UIView`. And can be used from code or from Interface Builder by setting to `UIView` custom class: `ObjectsInfoView`.


### Public methods and properties

#### Images Gallery Presenter

It's object of `UIViewController`, that will used to show images gallery of object.

If this property would not be setted, `ObjectsInfoView` will present images gallery in it self.

  ```
  var imageGalleryPresenterController: UIViewController?
  ```

##### Example:

```
let vc = UIViewController()
let objectsView = ObjectsInfoView()
objectsView.imageGalleryPresenterController = vc
```

#### Setting data base

Used to set current project data base, to provide connection from `ObjectsInfoView` to data storage, for reading objects data.

WARNING: Should be used before setting objects ids array!

```
public func set(db manager: IDSManager)
```
  - Parameters: __db manager: IDSManager__ - data base object that conforms `IDSManager` protocol, and used in current bundle;


#### Theme setter

Used to set theme that conforms to `IThemeManager` (described in `IndoorModel`)

To update theme, in theme object (for example `ThemeManager` object) should be updated (overrided) next properties:
- `indoorObjectsInfoView`,
- `indoorObjectsInfoViewCell`,
- `indoorObjectsInfoViewGallery`,
- `indoorGalleryCollectionFlowLayout`.

Description:

```
public func set(theme: IThemeManager)
```

  - Parameters: __theme: IThemeManager__ - object that conforms to `IThemeManager` protocol.


#### Setting objects array

Used to set objects for displaying.

WARNING: data base should be setted first, if not, method will throw exception.

```
public func load(objects array: [Int], from id: Int?) throws
```
  - Parameters:
    - __objects array: [Int]__  - array of objects ids;
    - __from id: Int?__         - index of object in array, which view scroll to at start;


#### Setting objects by filter options

Used to set objects for displaying.

WARNING: data base should be setted first, if not, method will throw exception.

```
public func load(objectsBy filterOptions: IndoorFilterOptions, from id: IndexPath?) throws
```
  - Parameters:
    - __objectsBy filterOptions: IndoorFilterOptions__  - array of objects filter options;
    - __from id: IndexPath?__                            - indexPath of object, to which view will scroll to at start;
