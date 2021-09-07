# GBKSoft UITextField

![Preview](/Media/preview.png)

Material inspired implementation for UITextField based on design trends used in GBKSoft

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Properties](#properties)
- [Additional Info](#additional-info)
- [Delegate](#delegate)
- [ToDo](#todo)

## Requirements 
- iOS 10.0+

## Installation

### CocoaPods

To integrate GBKSoftTextField into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'GBKSoftTextField', :git => 'git@gitlab.gbksoft.net:gbksoft-mobile-department/ios/gbksofttextfield.git'
```

Then, run the following command:

```bash
$ pod install
```

## Usage

### Xib

- Add new `UITextField` in Interface Builder
- Specify `GBKSoftTextField` as Custom Class in Identity Inspector for that field
- Fill any needed properties in Attributes Inspector

### Code
```swift
    import GBKSoftTextField
    
    ...
    let firstNameTextField = GBKSoftTextField()
    firstNameTextField.placeholder = "First Name"
	// TODO: specify any other available properties
    view.addSubview(firstNameTextField)
```

## Properties

![Properties](/Media/attributes.png)

| Property | Type | Default value | Description | @IBInspectable |
| --- | --- | --- | --- | :---: |
| textPadding | CGSize | (width: 0, height: 10) | Horizontal and vertical edge insets for input field | :heavy_check_mark: |
| errorPadding | CGSize | (width: 0, height: 10) | Horizontal and vertical edge insets for input field | :heavy_check_mark: |
| underlineHeight | CGFloat | 1 | Height of underline for unfocused state  | :heavy_check_mark: |
| underlineEditingHeight | CGFloat | 2 | Height of underline for focused state | :heavy_check_mark: |
| underlineErrorHeight | CGFloat | 2 | Height of underline for field when error displayed | :heavy_check_mark: |
| placeholderColor | UIColor | UIColor.gray | Placeholder color | :heavy_check_mark: |
| titleColor | UIColor | UIColor.gray | Title color | :heavy_check_mark: |
| errorColor | UIColor | UIColor.red | Color for error message and underline when error displayed | :heavy_check_mark: |
| underlineColor | UIColor | UIColor.gray | Underline color for unfocused state | :heavy_check_mark: |
| underlineEditingColor | UIColor | UIColor.blue | Underline color for focused state | :heavy_check_mark: |
| titleAnimated | Bool | false | Define if title position animated when field change focus state  | :heavy_check_mark: |
| errorAnimated | Bool | false | Define if error message appear animated | :heavy_check_mark: |
| title | String | nil | Title of the field. If no placeholder provided it will be used as placeholder | :heavy_check_mark: |
| error | String | nil | Error message. Error message shown and underline changed color only if `error != nil` | :heavy_check_mark: |
| isInline | Bool | false | Field display mode. [More](#isInline)  | :heavy_check_mark: |
| inlineFieldOffset | CGFloat | 100 | Title width for inline mode | :heavy_check_mark: |
| buttonVisible | Bool | false | Right button visibility | :heavy_check_mark: |
| buttonImage | UIImage | nil | Right button icon | :heavy_check_mark: |
| buttonTintColor | UIColor | UIColor.gray | Right button icon tint color. Provided image always render as `template` | :heavy_check_mark: |
| clearErrorOnFocus | Bool | true | Define if error should disappear on field become first responder | :heavy_check_mark: |
| titleFont | UIFont | nil | Title font. By default will be used field font with `UIFont.labelFontSize` | :x: |
| placeholderFont | UIFont | nil | Placeholder font. By default will be used field font with `UIFont.systemFontSize` | :x: |
| errorFont | UIFont | nil | Error message font. By default will be used field font with `UIFont.labelFontSize` | :x: |

> All properties can be set globally for GBKSoftTextField.appearence()

```swift

GBKSoftTextField.appearence().titleFont = UIFont.systemFont(ofSize: 20)
GBKSoftTextField.appearence().underlineColor = .green

```

## Additional Info

### isInline 

Property `isInline` define appearance and behaviour of the field

#### isInline == false (default)

![Default example](/Media/example-default.png)

By default for empty field only placeholder and underline are displayed. On focus and when text is not empty placeholder will be hidden and title appear. Title and field stacked vertically
#### isInline == true

![Inline example](/Media/example-inline.png)

In inline mode title position is fixed for any state. Title and field stacked horizontally 


## Delegate 

In case you need to handle right button tap you should assign `GBKSoftTextFieldDelegate` as field delegate instead default  `UITextFieldDelegate`

#### Xib (recommended)
![Inline example](/Media/delegate1.png)
![Inline example](/Media/delegate2.png)

#### Code
```swift
    import GBKSoftTextField
    
    ...
    firstNameTextField.textFieldDelegate = self
    ...
    
    extension ViewController: GBKSoftTextFieldDelegate {
    ...
    }
```

In addition to default functions of `UITextFieldDelegate` this protocol provide next one
```swift
func textFieldDidTapButton(_ textField: UITextField)
```
that will be called when user tapped right button

## ToDo

- [ ] add multiline support by inheritance from UITextView
