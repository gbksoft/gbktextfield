# GBKSoft UITextField

Реализация UITextField схожий с Material созданный согласно требоний реализуемых в команде проектов 

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Properties](#properties)
- [Additional Info](#additional-info)
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
    let firstNameTextField = GBKSoftTextField()
    firstNameTextField.placeholder = "First Name"
    ...
    view.addSubview(firstNameTextField)
```

## Properties

| Property | Type | Default value | Description | @IBInspectable |
| --- | --- | --- | --- | :---: |
| textPadding | CGSize | (width: 0, height: 10) | Отступы поля ввода от краев | [x] |
| errorPadding | CGSize | (width: 0, height: 10) | Отступы для текста с ошибкой | [x] |
| underlineHeight | CGFloat | 1 | Высота подчеркивания по умолчанию | [x] |
| underlineEditingHeight | CGFloat | 2 | Высота подчеркивания у активного поля | [x] |
| underlineErrorHeight | CGFloat | 2 | Высота подчеркивания у поля с ошибкой | [x] |
| placeholderColor | UIColor | UIColor.gray | Цвет плейсхолдера/тайтла для поля | [x] |
| errorColor | UIColor | UIColor.red | Цвет текста сообщения об ошибке и подчеркивания у поля с ошибкой | [x] |
| underlineColor | UIColor | UIColor.gray | Цвет подчеркивания по умолчанию | [x] |
| underlineEditingColor | UIColor | UIColor.blue | Цвет подчеркивания у активного поля | [x] |
| error | String | nil | Текст ошибки. Если `error == nil` то текст ошибки не отображается и подчеркивание имеет цвет по умолчанию | [x] |
| isInline | Bool | false | Режим отображения поля. [Подробнее](#isInline)  | [x] |
| inlineFieldOffset | CGFloat | 100 | Определяет ширину плейсхолдера/тайтла в инлайн режиме | [x] |
| placeholderFont | UIFont | nil | Шрифт плейсхолдера/тайтла. По умолчанию применяется шрифт установленный для текстового поля с размером `UIFont.labelFontSize` | [-] |
| errorFont | UIFont | nil | Шрифт  сообщения об ошибке. По умолчанию применяется шрифт установленный для текстового поля с размером `UIFont.labelFontSize` | [-] |
| placeholderAnimated | Bool | false | Определяет наличие анимации у перемещения плейсхолдера в тайтл и обратно  | [x] |
| errorAnimated | Bool | false | Определяет наличие анимации у появления/скрытия текста ошибки | [x] |


## Additional Info

### isInline 

Параметр `isInline` определяет внешний вид поля и его поведение

#### isInline == false (default)

По умолчанию у незаполненного поля видим только плейсхолдер и подчеркивание. При изменении значения поля плейсхолдер скрывается и появляется тайтл. Тайтл и полея для ввода расположены один над другим вертикально

#### isInline == true

В инлайн режиме плейсхолдер/тайтл неподвижен. Тайтл и поле для ввода один за другим горизонтально


## ToDo

- [ ] добавить поддержку многострочности путем наследования от UITextView
- [ ] добавить возможность указывать title отличный от placeholder
- [ ] добавить кастомизируемую кнопку как left attribute (например для показать/скрыть пароль)