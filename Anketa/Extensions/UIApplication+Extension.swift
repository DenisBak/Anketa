//
//  UIApplication+Extension.swift
//  Anketa
//
//  Created by Артём Иващенко on 31/05/24.
//

import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter {$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}
