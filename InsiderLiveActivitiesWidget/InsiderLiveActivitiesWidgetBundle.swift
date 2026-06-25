//
//  InsiderLiveActivitiesWidgetBundle.swift
//  InsiderLiveActivitiesWidget
//

import SwiftUI
import WidgetKit

@main
internal struct InsiderLiveActivitiesWidgetBundle: WidgetBundle {

    internal var body: some Widget {
        DeliveryLiveActivity()
        WorkoutLiveActivity()
        MatchLiveActivity()
    }
}
