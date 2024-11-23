//
//  UnitFormatter.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 23/11/2024.
//

import Foundation

extension Double {
    
    private func convertSpeed(temp: Double, unit outputTempType: UnitSpeed) -> String {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: outputTempType)
        return formatter.string(from: input)
    }
    
    func toFormattedSpeed(unit: TemperatureUnit) -> String {
        if unit == .faranheit {
            return convertSpeed(temp: self, unit: .milesPerHour)
        } else {
            return convertSpeed(temp: self, unit: .metersPerSecond)
        }
    }
    
    private func convertTemp(temp: Double, unit outputTempType: UnitTemperature) -> String {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: outputTempType)
        return formatter.string(from: input)
    }
    
    func toFormattedTemperature(unit: TemperatureUnit) -> String {
        switch unit {
        case .celsius:
            return convertTemp(temp: self, unit: .celsius)
        case .faranheit:
            return convertTemp(temp: self, unit: .fahrenheit)
        case .kelvin:
            return convertTemp(temp: self, unit: .kelvin)
        }
    }
}

extension Int {
    func toFormattedPercent() -> String {
        return "\(self)%"
    }
}
