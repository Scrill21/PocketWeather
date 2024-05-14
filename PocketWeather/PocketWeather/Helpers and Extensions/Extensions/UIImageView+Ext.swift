//
//  UIImageView+Ext.swift
//  PocketWeather
//
//  Created by anthony byrd on 5/13/24.
//

import UIKit

extension UIImageView {
    func download(url: URL?) {
        DispatchQueue.global().async { [weak self] in
            guard let url = url else { return }
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
