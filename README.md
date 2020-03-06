# GBKSoft UITextField

![Preview](/Media/preview.png)

Реализация UITextField схожий с Material созданный согласно требоний реализуемых в команде проектов 

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Properties](#properties)
- [Additional Info](#additional-info)
- [Delegate](#delegate)
- [ToDo](#todo)

## Requirements 
- iOS 11.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate GBKDevInfoMode into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'GBKSoftTextField', :git => 'git@gitlab.gbksoft.net:korzh-aa/gbksofttextfield.git'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

### Xib

- Добавить на вью UITextField 
- В Identity Inspector в качетсве Custom Class указать GBKSoftTextField
- В Attributes Inspector указать необходимые параметры

### Code
```swift
    import GBKSoftTextField
    
    ...
    let firstNameTextField = GBKSoftTextField()
    firstNameTextField.placeholder = "First Name"
    ...
    view.addSubview(firstNameTextField)
```

## Properties

![Properties](/Media/attributes.png)

| Property | Type | Default value | Description | @IBInspectable |
| --- | --- | --- | --- | :---: |
| textPadding | CGSize | (width: 0, height: 10) | Отступы поля ввода от краев | [x] |
| errorPadding | CGSize | (width: 0, height: 10) | Отступы для текста с ошибкой | [x] |
| underlineHeight | CGFloat | 1 | Высота подчеркивания по умолчанию | [x] |
| underlineEditingHeight | CGFloat | 2 | Высота подчеркивания у активного поля | [x] |
| underlineErrorHeight | CGFloat | 2 | Высота подчеркивания у поля с ошибкой | [x] |
| placeholderColor | UIColor | UIColor.gray | Цвет плейсхолдера для поля | [x] |
| titleColor | UIColor | UIColor.gray | Цвет тайтла для поля | [x] |
| errorColor | UIColor | UIColor.red | Цвет текста сообщения об ошибке и подчеркивания у поля с ошибкой | [x] |
| underlineColor | UIColor | UIColor.gray | Цвет подчеркивания по умолчанию | [x] |
| underlineEditingColor | UIColor | UIColor.blue | Цвет подчеркивания у активного поля | [x] |
| titleAnimated | Bool | false | Определяет наличие анимации у появления/скрытия тайтла  | [x] |
| errorAnimated | Bool | false | Определяет наличие анимации у появления/скрытия текста ошибки | [x] |
| title | String | nil | Текст тайтла | [x] |
| error | String | nil | Текст ошибки. Если `error == nil` то текст ошибки не отображается и подчеркивание имеет цвет по умолчанию | [x] |
| isInline | Bool | false | Режим отображения поля. [Подробнее](#isInline)  | [x] |
| inlineFieldOffset | CGFloat | 100 | Определяет ширину тайтла в инлайн режиме | [x] |
| buttonVisible | Bool | false | Определяет видимость кнопки справа | [x] |
| buttonImage | UIImage | nil | Иконка кнопки | [x] |
| buttonTintColor | UIColor | UIColor.gray | Цвет иконки. Изображение рисуется в режиме template | [x] |
| titleFont | UIFont | nil | Шрифт тайтла. По умолчанию применяется шрифт установленный для текстового поля с размером `UIFont.labelFontSize` | [-] |
| placeholderFont | UIFont | nil | Шрифт плейсхолдера. По умолчанию применяется шрифт установленный для текстового поля с размером `UIFont.systemFontSize` | [-] |
| errorFont | UIFont | nil | Шрифт  сообщения об ошибке. По умолчанию применяется шрифт установленный для текстового поля с размером `UIFont.labelFontSize` | [-] |


## Additional Info

### isInline 

Параметр `isInline` определяет внешний вид поля и его поведение

#### isInline == false (default)

![Default example](/Media/example-default.png)

По умолчанию у незаполненного поля видим только плейсхолдер и подчеркивание. При изменении значения поля плейсхолдер скрывается и появляется тайтл. Тайтл и полея для ввода расположены один над другим вертикально

#### isInline == true

![Inline example](/Media/example-inline.png)

В инлайн режиме плейсхолдер/тайтл неподвижен. Тайтл и поле для ввода один за другим горизонтально


## Delegate 

Для обработки нажатия на кнопку необходимо к полу привязать `textFieldDelegate` класс соответсвующий протоколу `GBKSoftTextFieldDelegate` вместо стандартного `delegate` и `UITextFieldDelegate` соответственно

#### Xib (рекомендуемый)
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

Помимо стандартным методов (`UITextFieldDelegate`) этот протокол содержит метод 
```swift
func textFieldDidTapButton(_ textField: UITextField)
```
который вызывается по нажатию на кнопку

## ToDo

- [ ] добавить поддержку многострочности путем наследования от UITextView
