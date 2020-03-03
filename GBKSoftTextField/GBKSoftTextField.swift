//
//  GBKSoftTextField.swift
//  TextFieldViewTest
//
//  Created by Artem Korzh on 30.12.2019.
//  Copyright © 2019 Artem Korzh. All rights reserved.
//

import UIKit

@IBDesignable
class GBKSoftTextField: UITextField {

    // MARK: - Views

    private let placeholderLabel = UILabel()
    private let errorLabel = UILabel()
    private let underlineLayer = CALayer()

    // MARK: - IBInspectable

    @IBInspectable var textPadding: CGSize = CGSize(width: 0, height: 10)
    @IBInspectable var errorPadding: CGSize = CGSize(width: 0, height: 10)

    @IBInspectable var underlineHeight: CGFloat = 1
    @IBInspectable var underlineEditingHeight: CGFloat = 2
    @IBInspectable var underlineErrorHeight: CGFloat = 2

    @IBInspectable var placeholderColor: UIColor = .gray {
        didSet {
            updatePlaceholderColor()
        }
    }
    @IBInspectable var placeholderAnimated: Bool = false
    @IBInspectable var errorColor: UIColor = .red {
        didSet {
            layoutUnderline()
        }
    }
    @IBInspectable var errorAnimated: Bool = false
    @IBInspectable var underlineColor: UIColor = .gray {
        didSet {
            updateErrorColor()
            layoutUnderline()
        }
    }
    @IBInspectable var underlineEditingColor: UIColor = .blue {
        didSet {
            layoutUnderline()
        }
    }

    @IBInspectable var error: String? {
        didSet {
            updateErrorText()
            layoutErrorLabel(animated: errorAnimated)
        }
    }

    @IBInspectable var isInline: Bool = false

    @IBInspectable var inlineFieldOffset: CGFloat = 100

    var placeholderFont: UIFont? {
        didSet {
            updatePlaceholderFont()
        }
    }
    var errorFont: UIFont? {
        didSet {
            updateErrorFont()
        }
    }

    override var placeholder: String? {
        didSet {
            currentPlaceholder = placeholder
            updatePlaceholderText()
        }
    }

    override var font: UIFont? {
        didSet {
            updateErrorLabelPosition()
            updateFonts()
        }
    }

    // MARK: - Local properties

    private let animationDuration: TimeInterval = 0.3

    private var placeholderAnimating: Bool = false
    private var placehoderLabelTopConstraint: NSLayoutConstraint!

    private var errorAnimating: Bool = false
    private var errorLabelTopConstraint: NSLayoutConstraint!
    private var errorLabelZeroHeightConstraint: NSLayoutConstraint!

    private var currentPlaceholderFont: UIFont?
    private var currentErrorFont: UIFont?

    private var currentPlaceholder: String?

    // MARK: - Computed

    private var textRect: CGRect {
        return textRect(forBounds: bounds)
    }

    private var withError: Bool {
        return error != nil && error!.count > 0
    }

    private var shouldShowPlaceholder: Bool {
        let isEmpty = text == nil || text?.count == 0
        return !isEmpty || isFirstResponder
    }

    private var placeholderIsHidden: Bool {
        return placeholderLabel.alpha == 0
    }

    private var defaultPlaceholderFont: UIFont? {
        return font?.withSize(UIFont.labelFontSize)
    }

    private var defaultErrorFont: UIFont? {
        return font?.withSize(UIFont.labelFontSize)
    }

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override func layoutSubviews() {
        layoutUnderline()
        layoutPlaceholderLabel(animated: placeholderAnimated)
        layoutErrorLabel(animated: errorAnimated)
        super.layoutSubviews()
    }

}

// MARK: - UITextField

extension GBKSoftTextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        var left: CGFloat
        var top: CGFloat
        var width: CGFloat = rect.size.width
        if isInline {
            top = (currentPlaceholderFont!.lineHeight - font!.lineHeight)
            left = inlineFieldOffset
            width -= left
        } else {
            top = ceil(textPadding.height) + currentPlaceholderFont!.lineHeight
            left = rect.origin.x
        }
        return CGRect(x: left, y: top, width: width, height: font!.lineHeight)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    override var intrinsicContentSize: CGSize {
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
        setupDefaults()
        setupTextField()
        setupUnderline()
        setupPlaceholderLabel()
        setupErrorLabel()
        invalidateIntrinsicContentSize()
    }

    private func setupDefaults() {
        self.currentPlaceholderFont = placeholderFont ?? defaultPlaceholderFont
        self.currentErrorFont = errorFont ?? defaultErrorFont
        self.currentPlaceholder = placeholder
    }

    private func setupTextField() {
        borderStyle = .none
        contentVerticalAlignment = .top
        clipsToBounds = false
        addTarget(self, action: #selector(didFocused(_:)), for: .editingDidBegin)
    }

    @objc func didFocused(_ sender: AnyObject) {
        self.error = nil
    }

    private func updateFonts() {
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

    private func setupPlaceholderLabel() {
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.font = currentPlaceholderFont
        updatePlaceholderText()
        updatePlaceholderColor()
        addSubview(placeholderLabel)
        setupPlaceholderConstraints()
        layoutPlaceholderLabel(animated: false)
        invalidateIntrinsicContentSize()
    }

    private func updatePlaceholderFont() {
        currentPlaceholderFont = placeholderFont ?? defaultPlaceholderFont
        placeholderLabel.font = currentPlaceholderFont
        updatePlaceholderText()
    }

    private func updatePlaceholderText() {
        if placeholderIsHidden {
            updateAttributedPlaceholder()
        }
        placeholderLabel.text = placeholder
        placeholderLabel.sizeToFit()
        invalidateIntrinsicContentSize()
    }

    private func updateAttributedPlaceholder() {
        self.attributedPlaceholder = NSAttributedString(string: currentPlaceholder ?? "", attributes: [
            NSAttributedString.Key.font: currentPlaceholderFont,
            NSAttributedString.Key.foregroundColor: placeholderColor
        ])
    }

    private func updatePlaceholderColor() {
        placeholderLabel.textColor = placeholderColor
    }

    private func setupPlaceholderConstraints() {
        clearPlaceholderConstraints()
        placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: textPadding.width).isActive = true
        if isInline {
            placeholderLabel.widthAnchor.constraint(equalToConstant: inlineFieldOffset).isActive = true
        } else {
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: textPadding.width).isActive = true
        }
        placehoderLabelTopConstraint = placeholderLabel.topAnchor.constraint(equalTo: topAnchor)
        placehoderLabelTopConstraint.isActive = true
    }

    private func clearPlaceholderConstraints() {
        placeholderLabel.removeConstraints(placeholderLabel.constraints)
        constraints.forEach { (constraint) in
            if let first = constraint.firstItem as? UILabel, first == self {
                self.removeConstraint(constraint)
            }

            if let second = constraint.secondItem as? UILabel, second == self {
                self.removeConstraint(constraint)
            }
        }
    }

    private func layoutPlaceholderLabel(animated: Bool) {
        if shouldShowPlaceholder {
            updatePlaceholderColor()
            showPlaceholderLabel(animated: animated)
        } else {
            if !isInline {
                hidePlaceholderLabel(animated: animated)
            }
        }
    }

    private func showPlaceholderLabel(animated: Bool) {
        if shouldShowPlaceholder {
            super.placeholder = nil
            attributedPlaceholder = nil
        }
        if !placeholderIsHidden || placeholderAnimating {
            return
        }

        guard animated else {
            self.placeholderLabel.alpha = 1
            return
        }

        superview?.layoutIfNeeded()
        placeholderAnimating = true
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            self.placeholderLabel.alpha = 1
            self.superview?.layoutIfNeeded()
        }) { (_) in
            self.placeholderAnimating = false
            if !self.shouldShowPlaceholder {
                self.hidePlaceholderLabel(animated: false)
            }
        }
    }

    private func hidePlaceholderLabel(animated: Bool) {
        if placeholderIsHidden || placeholderAnimating {
            return
        }

        guard animated else {
            placeholderLabel.alpha = 0
            updateAttributedPlaceholder()
            return
        }

        superview?.layoutIfNeeded()
        placeholderAnimating = true
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            self.placeholderLabel.alpha = 0
            self.superview?.layoutIfNeeded()
        }) { (_) in
            self.placeholderAnimating = false
            super.placeholder = self.currentPlaceholder
            if self.shouldShowPlaceholder {
                self.showPlaceholderLabel(animated: false)
            }
        }
    }

    // MARK: - Error

    private func setupErrorLabel() {
        errorLabel.numberOfLines = 0
        errorLabel.font = currentErrorFont
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
            errorLabelTopConstraint.constant = topErrorPadding(hidden: false)
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
}
