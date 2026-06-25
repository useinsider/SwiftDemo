//
//  DeliveryLiveActivity.swift
//  InsiderLiveActivitiesWidget
//

import ActivityKit
import InsiderLiveActivities
import SwiftUI
import WidgetKit

// MARK: - Lock Screen View

private struct DeliveryLockScreenView: View {

    internal let context: ActivityViewContext<DeliveryActivityAttributes>

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerRow
            Divider().overlay(Color.white.opacity(0.15))
            etaRow
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var headerRow: some View {
        HStack(alignment: .center, spacing: 10) {
            statusIcon
            courierInfo
            Spacer(minLength: 8)
            statusBadge
        }
    }

    private var statusIcon: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 40, height: 40)
            Image(systemName: context.state.status.symbolName)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white)
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: context.state.status)
    }

    private var courierInfo: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(context.attributes.courierName)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
            Text("Order #\(context.attributes.insiderLiveActivityId)")
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.white.opacity(0.6))
        }
    }

    private var statusBadge: some View {
        Text(context.state.status.displayName)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Capsule().fill(Color.white.opacity(0.18)))
            .animation(.easeInOut(duration: 0.25), value: context.state.status)
    }

    private var etaRow: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: "clock")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white.opacity(0.7))
            Text("Arriving in")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.white.opacity(0.7))
            Text("\(context.state.etaMinutes) min")
                .font(.system(size: 15, weight: .bold).monospacedDigit())
                .foregroundStyle(.white)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: context.state.etaMinutes)
            Spacer()
            progressDots
        }
    }

    private var progressDots: some View {
        HStack(spacing: 4) {
            ForEach(DeliveryStatus.allCases, id: \.self) { step in
                let isReached = step.progressIndex <= context.state.status.progressIndex
                Circle()
                    .fill(isReached ? Color.white : Color.white.opacity(0.25))
                    .frame(width: 6, height: 6)
                    .animation(.easeInOut(duration: 0.3), value: context.state.status)
            }
        }
    }
}

// MARK: - Widget

internal struct DeliveryLiveActivity: Widget {

    public var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliveryActivityAttributes.self) { context in
            DeliveryLockScreenView(context: context)
                .containerBackground(for: .widget) {
                    LinearGradient(
                        colors: [Color(red: 0.10, green: 0.25, blue: 0.55), Color(red: 0.06, green: 0.14, blue: 0.35)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 6) {
                        Image(systemName: context.state.status.symbolName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: context.state.status)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(context.attributes.courierName)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white)
                            Text(context.state.status.displayName)
                                .font(.system(size: 11))
                                .foregroundStyle(.white.opacity(0.65))
                        }
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 1) {
                        Text("\(context.state.etaMinutes)")
                            .font(.system(size: 22, weight: .bold).monospacedDigit())
                            .foregroundStyle(.white)
                            .contentTransition(.numericText())
                            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: context.state.etaMinutes)
                        Text("min")
                            .font(.system(size: 11))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 4) {
                        ForEach(DeliveryStatus.allCases, id: \.self) { step in
                            let isReached = step.progressIndex <= context.state.status.progressIndex
                            Capsule()
                                .fill(isReached ? Color.white : Color.white.opacity(0.2))
                                .frame(height: 3)
                                .animation(.easeInOut(duration: 0.3), value: context.state.status)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 6)
                }
            } compactLeading: {
                Image(systemName: context.state.status.symbolName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: context.state.status)
            } compactTrailing: {
                Text("\(context.state.etaMinutes)m")
                    .font(.system(size: 13, weight: .semibold).monospacedDigit())
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: context.state.etaMinutes)
            } minimal: {
                Image(systemName: context.state.status.symbolName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
            }
        }
    }
}

// MARK: - DeliveryStatus Helpers

extension DeliveryStatus {

    fileprivate var progressIndex: Int {
        switch self {
        case .pickup:         return 0
        case .inTransit:      return 1
        case .outForDelivery: return 2
        case .delivered:      return 3
        }
    }
}
