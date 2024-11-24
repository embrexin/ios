//
//  WeatherState.swift
//  Weather
//
//  Created by Amber Xiao on 4/5/24.
//

import MapKit
import SwiftUI

/// Overall state of the game. Used by ``GameViewModel`` to communicate updates to ``GameView``.
enum GameState: Equatable {
    /// The game is loading (i.e. requesting location or restaurant data.)
    case loading
    
    /// The game ran into an error while requesting location, fetching restaurants, or retrieving motion data.
    case error
 
    /// The game is ready to start, and is waiting for the player to place the device on their forehead.
    case ready
    
    /// The game is active and displaying the given restaurant.
    case weather
    
    case doNothing
}

extension GameState {
    /// Whether the score should be shown in this state.
    var showState: Bool {
        switch self {
        case .loading, .error:
            return false
        default:
            return true
        }
    }
    
    /// The background color to use while the game is in this state.
    var background: Color {
        switch self {
        case .weather:
            return .green
        case .error:
            return .red
        default:
            return .blue
        }
    }
}
