//
//  GBKSoftTextFieldDelegate.swift
//  GBKSoftTextField
//
//  Created by Artem Korzh on 06.03.2020.
//  Copyright © 2020 GBKSoft. All rights reserved.
//

import UIKit

@objc public protocol GBKSoftTextFieldDelegate: UITextFieldDelegate {

    @objc optional func textFieldDidTapButton(_ textField: UITextField)
}
