//
//  CustomUiButton.swift
//  nano4
//
//  Created by Gustavo Juk Ferreira Cruz on 17/08/21.
//

import UIKit

class CustomUIButton: UIButton{
    enum CustomButtonType{
        case edit
    }
    
    var indexPath: IndexPath?
    var customButtonType: CustomButtonType = .edit
    init(frame: CGRect, customButtonType: CustomButtonType) {
        super.init(frame: frame)
        self.setButtonStyle(customButtonType)
        self.customButtonType = customButtonType
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setButtonStyle(_ customButtonType: CustomButtonType){
        switch customButtonType {
        case .edit:
            self.setBackgroundImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        }
    }
}

