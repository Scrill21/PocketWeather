//
//  CustomError.swift
//  PocketWeather
//
//  Created by anthony byrd on 5/13/24.
//

import Foundation

enum AlertMessage {
    case locationDisabled
    case restricted
    case denied
    
    var alertDescription: String? {
        switch self {
        case .locationDisabled:
            return "Unable to retrieve locations at this time. \nPlease try again."
        case .restricted:
            return "Your location is restricted. This may be due to parental controls."
        case .denied:
            return "Pocket Weather does not have permission to acccess your location. To change that go to your phone's Settings > Pocket Weather > Location"
        }
    }
}
