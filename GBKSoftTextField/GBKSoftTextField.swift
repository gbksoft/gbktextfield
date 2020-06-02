//
//  GBKSoftTextField.swift
//  TextFieldViewTest
//
//  Created by Artem Korzh on 30.12.2019.
//  Copyright © 2019 Artem Korzh. All rights reserved.
//

import UIKit

@IBDesignable
open class GBKSoftTextField: UITextField {

    // MARK: - Views

    private let titleLabel = UILabel()
    private let errorLabel = UILabel()
    private let underlineLayer = CALayer()
    private let rightButton = UIButton()

    // MARK: - IBInspectable

    @IBInspectable dynamic public var textPadding: CGSize = CGSize(width: 0, height: 10)
    @IBInspectable dynamic public var errorPadding: CGSize = CGSize(width: 0, height: 10)

    @IBInspectable dynamic public var underlineHeight: CGFloat = 1
    @IBInspectable dynamic public var underlineEditingHeight: CGFloat = 2
    @IBInspectable dynamic public var underlineErrorHeight: CGFloat = 2

    @IBInspectable dynamic public var placeholderColor: UIColor = .gray {
        didSet {
            if !setupCompleted {return}
            updatePlaceholderColor()
        }
    }
    @IBInspectable dynamic public var titleColor: UIColor = .gray {
        didSet {
            updateTitleColor()
        }
    }
    @IBInspectable dynamic public var errorColor: UIColor = .red {
        didSet {
            if !setupCompleted {return}
            layoutUnderline()
        }
    }
    @IBInspectable dynamic public var underlineColor: UIColor = .gray {
        didSet {
            if !setupCompleted {return}
            updateErrorColor()
            layoutUnderline()
        }
    }
    @IBInspectable dynamic public var underlineEditingColor: UIColor = .blue {
        didSet {
            if !setupCompleted {return}
            layoutUnderline()
        }
    }

    @IBInspectable dynamic public var clearErrorOnFocus: Bool = true
    @IBInspectable dynamic public var titleAnimated: Bool = false
    @IBInspectable dynamic public var errorAnimated: Bool = false

    @IBInspectable dynamic public var title: String? {
        didSet {
            if !setupCompleted {return}
            updateTitleText()
        }
    }

    @IBInspectable dynamic public var error: String? {
        didSet {
            updateErrorText()
            layoutErrorLabel(animated: errorAnimated)
        }
    }

    @IBInspectable dynamic public var isInline: Bool = false {
        didSet { print("isInline:", isInline) }
    }

    @IBInspectable dynamic public var inlineFieldOffset: CGFloat = 100 {
        didSet { setupTitleConstraints() }
    }

    @IBInspectable dynamic public var buttonVisible: Bool = false {
        didSet {
            toggleButtonVisibility()
        }
    }
    @IBInspectable dynamic public var buttonImage: UIImage? {
        didSet {
            updateRightButtonImage()
        }
    }
    @IBInspectable dynamic public var buttonTintColor: UIColor = .gray {
        didSet {
            updateRightButtonTintColor()
        }
    }

    @objc dynamic public var titleFont: UIFont? {
        didSet {
            if !setupCompleted {return}
            updateTitleFont()
        }
    }

    @objc dynamic public var placeholderFont: UIFont? {
        didSet {
            if !setupCompleted {return}
            updatePlaceholderFont()
        }
    }

    @objc dynamic public var errorFont: UIFont? {
        didSet {
            if !setupCompleted {return}
            updateErrorFont()
        }
    }

    override public var placeholder: String? {
        didSet {
            if !setupCompleted {return}
            currentPlaceholder = placeholder
            hasPlaceholder = placeholder != nil
            updateAttributedPlaceholder()
        }
    }

    override public var font: UIFont? {
        didSet {
            if !setupCompleted {return}
            updateErrorLabelPosition()
            updateFonts()
        }
    }

    // MARK: - Local properties

    private let animationDuration: TimeInterval = 0.3

    private var placeholderAnimating: Bool = false
    private var placehoderLabelTopConstraint: NSLayoutConstraint!
    private var hasPlaceholder: Bool = true

    private var errorAnimating: Bool = false
    private var errorLabelTopConstraint: NSLayoutConstraint!
    private var errorLabelZeroHeightConstraint: NSLayoutConstraint!

    private var currentTitleFont: UIFont?
    private var currentPlaceholderFont: UIFont?
    private var currentErrorFont: UIFont?

    private var currentPlaceholder: String?

    private var setupCompleted = false

    // MARK: - Computed

    private var textRect: CGRect {
        return textRect(forBounds: bounds)
    }

    private var withError: Bool {
        return error != nil && error!.count > 0
    }

    private var shouldShowTitle: Bool {
        let isEmpty = text == nil || text?.count == 0
        return hasPlaceholder || !isEmpty || isFirstResponder
    }

    private var titleIsHidden: Bool {
        return titleLabel.alpha == 0
    }

    private var defaultTitleFont: UIFont? {
        return font?.withSize(UIFont.labelFontSize)
    }

    private var defaultPlaceholderFont: UIFont? {
        return font?.withSize(UIFont.systemFontSize)
    }


    private var defaultErrorFont: UIFont? {
        return font?.withSize(UIFont.labelFontSize)
    }

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        setupPlaceholder()
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupPlaceholder()
    }

    override public func layoutSubviews() {
        layoutUnderline()
        layoutTitleLabel(animated: titleAnimated)
        layoutErrorLabel(animated: errorAnimated)
        super.layoutSubviews()
    }

    open func setupParams() {}

}

// MARK: - UITextField

extension GBKSoftTextField {

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        var left: CGFloat
        var top: CGFloat
        var width: CGFloat = rect.size.width
        let currentPlaceholderLineHeight = currentPlaceholderFont?.lineHeight ?? 0
        if isInline {
            top = (currentPlaceholderLineHeight - font!.lineHeight)
            left = inlineFieldOffset
            width -= left
        } else {
            top = ceil(textPadding.height) + currentPlaceholderLineHeight
            left = rect.origin.x
        }
        left += textPadding.width
        width -= 2 * textPadding.width
        if buttonVisible {
            width -= rightButton.bounds.width
        }

        return CGRect(x: left, y: top, width: width, height: font!.lineHeight)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    override public var intrinsicContentSize: CGSize {
        var intrinsicSize = super.intrinsicContentSize
        if !withError {
            intrinsicSize.height = underlineLayer.frame.maxY
        } else {
            intrinsicSize.height = errorLabel.frame.maxY + errorPadding.height
        }

        return intrinsicSize
    }
}

// MARK: - Setup

extension GBKSoftTextField {

    private func setupView() {
        setupParams()
        updateFonts()
        setupDefaults()
        setupTextField()
        setupUnderline()
        setupTitleLabel()
        setupErrorLabel()
        setupRightButton()
    }

    private func setupPlaceholder() {
        self.currentPlaceholder = placeholder ?? (isInline ? nil : title)
        self.hasPlaceholder = placeholder != nil
        updateTitleText()
        updateAttributedPlaceholder()
        invalidateIntrinsicContentSize()
        setupCompleted = true
    }

    private func setupDefaults() {
        self.currentPlaceholderFont = placeholderFont ?? defaultPlaceholderFont
        self.currentErrorFont = errorFont ?? defaultErrorFont
        self.titleFont = titleFont ?? defaultTitleFont
    }

    private func setupTextField() {
        borderStyle = .none
        contentVerticalAlignment = .top
        clipsToBounds = false
        addTarget(self, action: #selector(didFocused(_:)), for: .editingDidBegin)
    }

    @objc func didFocused(_ sender: AnyObject) {
        if clearErrorOnFocus {
            self.error = nil
        }
    }

    private func updateFonts() {
        updateTitleFont()
        updatePlaceholderFont()
        updateErrorFont()
    }

    // MARK: - Underline

    private func setupUnderline() {
        layoutUnderline()
        layer.addSublayer(underlineLayer)
    }

    private func layoutUnderline() {

        let underlineColor = withError ? self.errorColor :
            isFirstResponder ? self.underlineEditingColor : self.underlineColor
        underlineLayer.backgroundColor = underlineColor.cgColor

        let underlineHeight = isFirstResponder ? self.underlineEditingHeight : withError ? self.underlineErrorHeight : self.underlineHeight
        let yPos = self.textRect.maxY + textPadding.height - underlineHeight
        self.underlineLayer.frame = CGRect(x: 0, y: yPos, width: bounds.width, height: underlineHeight)
    }

    // MARK: - Placeholder

    private func updatePlaceholderFont() {
        currentPlaceholderFont = placeholderFont ?? defaultPlaceholderFont
        titleLabel.font = currentPlaceholderFont
        updatePlaceholderText()
    }

    private func updatePlaceholderText() {
        if titleIsHidden || currentPlaceholder != nil {
            updateAttributedPlaceholder()
        }
    }

    private func updateAttributedPlaceholder() {
        self.attributedPlaceholder = NSAttributedString(string: currentPlaceholder ?? "", attributes: [
            NSAttributedString.Key.font: currentPlaceholderFont,
            NSAttributedString.Key.foregroundColor: placeholderColor
        ])
    }


    // MARK: - Title

    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = textAlignment
        titleLabel.font = currentTitleFont
        titleLabel.textColor = titleColor
        updateTitleText()
        updateTitleColor()
        addSubview(titleLabel)
        setupTitleConstraints()
        layoutTitleLabel(animated: false)
        invalidateIntrinsicContentSize()
    }

    private func updateTitleFont() {
        currentTitleFont = titleFont ?? defaultTitleFont
        titleLabel.font = currentTitleFont
        updateTitleText()
    }

    private func updateTitleText() {
        if !hasPlaceholder && titleIsHidden && !isInline {
            currentPlaceholder = title
            updateAttributedPlaceholder()
        }
        titleLabel.text = title
        titleLabel.sizeToFit()
        invalidateIntrinsicContentSize()
    }


    private func updateTitleColor() {
        titleLabel.textColor = titleColor
    }

    private func updatePlaceholderColor() {
        if attributedPlaceholder != nil {
            updateAttributedPlaceholder()
        }
    }

    private func setupTitleConstraints() {
        clearTitleConstraints()
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: textPadding.width).isActive = true
        if isInline {
            titleLabel.widthAnchor.constraint(equalToConstant: inlineFieldOffset).isActive = true
        } else {
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: textPadding.width).isActive = true
        }
        placehoderLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor)
        placehoderLabelTopConstraint.isActive = true
    }

    private func clearTitleConstraints() {
        titleLabel.removeConstraints(titleLabel.constraints)
        constraints.forEach { (constraint) in
            if let first = constraint.firstItem as? UILabel, first == self {
                self.removeConstraint(constraint)
            }

            if let second = constraint.secondItem as? UILabel, second == self {
                self.removeConstraint(constraint)
            }
        }
    }

    private func layoutTitleLabel(animated: Bool) {
        if shouldShowTitle {
            updateTitleColor()
            showTitleLabel(animated: animated)
        } else {
            if !isInline {
                hideTitleLabel(animated: animated)
            } else {
                showTitleLabel(animated: animated)
            }
        }
    }

    private func showTitleLabel(animated: Bool) {
        if shouldShowTitle && !hasPlaceholder {
            currentPlaceholder = nil
            attributedPlaceholder = nil
        }
        if !titleIsHidden || placeholderAnimating {
            return
        }

        guard animated else {
            self.titleLabel.alpha = 1
            return
        }

        superview?.layoutIfNeeded()
        placeholderAnimating = true
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            self.titleLabel.alpha = 1
            self.superview?.layoutIfNeeded()
        }) { (_) in
            self.placeholderAnimating = false
            if !self.shouldShowTitle {
                self.hideTitleLabel(animated: false)
            }
        }
    }

    private func hideTitleLabel(animated: Bool) {
        if titleIsHidden || placeholderAnimating {
            return
        }

        if !hasPlaceholder && !isInline {
            currentPlaceholder = title
        }

        guard animated else {
            titleLabel.alpha = 0
            updateAttributedPlaceholder()
            return
        }

        superview?.layoutIfNeeded()
        placeholderAnimating = true
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            self.titleLabel.alpha = 0
            self.superview?.layoutIfNeeded()
        }) { (_) in
            self.placeholderAnimating = false
            self.updateAttributedPlaceholder()
            if self.shouldShowTitle {
                self.showTitleLabel(animated: false)
            }
        }
    }

    // MARK: - Error

    private func setupErrorLabel() {
        errorLabel.numberOfLines = 0
        errorLabel.font = currentErrorFont
        errorLabel.clipsToBounds = false
        updateErrorColor()
        errorLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        errorLabel.setContentHuggingPriority(.required, for: .vertical)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        updateErrorText()
        addSubview(errorLabel)
        setupErrorConstraints()
        layoutErrorLabel(animated: false)
    }

    private func setupErrorConstraints() {
        errorLabelTopConstraint = errorLabel.topAnchor.constraint(equalTo: topAnchor, constant: topErrorPadding(hidden: !withError))
        errorLabelTopConstraint.isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -errorPadding.height).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: errorPadding.width).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: errorPadding.width).isActive = true
        updateErrorHeightConstraint(hidden: !withError)
    }

    private func updateErrorHeightConstraint(hidden: Bool) {
        if hidden {
            if errorLabelZeroHeightConstraint == nil {
                errorLabelZeroHeightConstraint = errorLabel.heightAnchor.constraint(equalToConstant: 0)
                errorLabelZeroHeightConstraint.priority = UILayoutPriority(900)
            }
            errorLabelZeroHeightConstraint.isActive = true
        } else {
            errorLabelZeroHeightConstraint?.isActive = false
        }
        self.superview?.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }

    private func updateErrorColor() {
        errorLabel.textColor = errorColor
    }

    private func updateErrorFont() {
        currentErrorFont = errorFont ?? defaultErrorFont
        errorLabel.font = currentErrorFont
        updateErrorText()
    }

    private func updateErrorText() {
        errorLabel.text = error
        errorLabel.sizeToFit()
        invalidateIntrinsicContentSize()
    }

    private func layoutErrorLabel(animated: Bool) {
        if withError {
            updateErrorColor()
            showErrorLabel(animated: animated)
        } else {
            hideErrorLabel(animated: animated)
        }
    }

    private func topErrorPadding(hidden: Bool) -> CGFloat {
        var top = underlineLayer.frame.maxY
        if !hidden {
            top += errorPadding.height
        }
        return top
    }

    private func showErrorLabel(animated: Bool) {
        if errorAnimating {
            return
        }

        guard animated else {
            errorLabel.alpha = 1
            errorLabelTopConstraint?.constant = topErrorPadding(hidden: false)
            updateErrorHeightConstraint(hidden: false)
            return
        }

        superview?.layoutIfNeeded()
        errorAnimating = true
        errorLabelTopConstraint.constant = topErrorPadding(hidden: false)
        updateErrorHeightConstraint(hidden: false)
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            self.errorLabel.alpha = 1
            self.superview?.layoutIfNeeded()
        }) { (_) in
            self.errorAnimating = false
            if !self.withError {
                self.hideErrorLabel(animated: false)
            }
        }
    }

    private func hideErrorLabel(animated: Bool) {
        if errorAnimating {
            return
        }

        guard animated else {
            errorLabel.alpha = 0
            errorLabelTopConstraint.constant = topErrorPadding(hidden: true)
            updateErrorHeightConstraint(hidden: true)
            return
        }

        superview?.layoutIfNeeded()
        errorAnimating = true
        errorLabelTopConstraint.constant = topErrorPadding(hidden: true)
        updateErrorHeightConstraint(hidden: true)
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            self.errorLabel.alpha = 0
            self.superview?.layoutIfNeeded()
        }) { (_) in
            self.errorAnimating = false
            if self.withError {
                self.showErrorLabel(animated: false)
            }
        }
    }

    private func updateErrorLabelPosition() {
        errorLabelTopConstraint?.constant = topErrorPadding(hidden: !withError)
    }

    // MARK: Button

    private func setupRightButton() {
        rightButton.imageView?.contentMode = .scaleAspectFit
        updateRightButtonImage()
        updateRightButtonTintColor()
        rightButton.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        addSubview(rightButton)
        setupRightButtonConstraints()
        toggleButtonVisibility()
    }

    @objc private func didTapButton(sender: AnyObject) {
        (self.delegate as? GBKSoftTextFieldDelegate)?.textFieldDidTapButton?(self)
    }

    private func setupRightButtonConstraints() {
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        rightButton.topAnchor.constraint(equalTo: topAnchor, constant: textRect.minY).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: textRect.height).isActive = true
    }

    private func updateRightButtonImage() {
        rightButton.setImage(buttonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
    }

    private func updateRightButtonTintColor() {
        rightButton.tintColor = buttonTintColor
    }

    private func toggleButtonVisibility() {
        rightButton.isHidden = !buttonVisible
    }

}
