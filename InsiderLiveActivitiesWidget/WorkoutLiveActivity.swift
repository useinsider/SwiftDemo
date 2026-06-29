//
//  WorkoutLiveActivity.swift
//  InsiderLiveActivitiesWidget
//

import ActivityKit
import InsiderLiveActivities
import SwiftUI
import WidgetKit

// MARK: - Lock Screen View

internal struct WorkoutLockScreenView: View {

    internal let context: ActivityViewContext<WorkoutActivityAttributes>

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerRow
            Divider().overlay(Color.white.opacity(0.15))
            metricsRow
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var headerRow: some View {
        HStack(alignment: .center, spacing: 10) {
            phaseIcon
            workoutInfo
            Spacer(minLength: 8)
            elapsedTime
        }
    }

    private var phaseIcon: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 40, height: 40)
            Image(systemName: context.state.phase.symbolName)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white)
                .symbolEffect(.pulse, isActive: context.state.phase == .active)
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: context.state.phase)
    }

    private var workoutInfo: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(context.attributes.workoutType)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
            Text(context.state.phase.displayName)
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.white.opacity(0.6))
                .animation(.easeInOut(duration: 0.25), value: context.state.phase)
        }
    }

    private var elapsedTime: some View {
        Text(WorkoutLiveActivity.formatDuration(context.state.elapsedSeconds))
            .font(.system(size: 20, weight: .bold).monospacedDigit())
            .foregroundStyle(.white)
            .contentTransition(.numericText())
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: context.state.elapsedSeconds)
    }

    private var metricsRow: some View {
        HStack(alignment: .center, spacing: 0) {
            metricItem(
                icon: "flame.fill",
                value: "\(context.state.calories)",
                label: "kcal"
            )
            Rectangle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 1, height: 28)
            metricItem(
                icon: "heart.fill",
                value: context.state.phase == .active ? "Active" : "Rest",
                label: "Status"
            )
        }
    }

    private func metricItem(icon: String, value: String, label: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white.opacity(0.75))
            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.system(size: 15, weight: .semibold).monospacedDigit())
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: context.state.calories)
                Text(label)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundStyle(.white.opacity(0.55))
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Widget

internal struct WorkoutLiveActivity: Widget {

    public var body: some WidgetConfiguration {
        ActivityConfiguration(for: WorkoutActivityAttributes.self) { context in
            WorkoutLockScreenView(context: context)
                .containerBackground(for: .widget) {
                    LinearGradient(
                        colors: [Color(red: 0.55, green: 0.22, blue: 0.05), Color(red: 0.30, green: 0.10, blue: 0.02)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 6) {
                        Image(systemName: context.state.phase.symbolName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white)
                            .symbolEffect(.pulse, isActive: context.state.phase == .active)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(context.attributes.workoutType)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white)
                            Text(context.state.phase.displayName)
                                .font(.system(size: 11))
                                .foregroundStyle(.white.opacity(0.65))
                        }
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 1) {
                        Text(WorkoutLiveActivity.formatDuration(context.state.elapsedSeconds))
                            .font(.system(size: 18, weight: .bold).monospacedDigit())
                            .foregroundStyle(.white)
                            .contentTransition(.numericText())
                            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: context.state.elapsedSeconds)
                        Text("elapsed")
                            .font(.system(size: 11))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 16) {
                        Label("\(context.state.calories) kcal", systemImage: "flame.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.85))
                        Label(context.state.phase.displayName, systemImage: "heart.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .padding(.bottom, 6)
                }
            } compactLeading: {
                Image(systemName: context.state.phase.symbolName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
                    .symbolEffect(.pulse, isActive: context.state.phase == .active)
            } compactTrailing: {
                Text(WorkoutLiveActivity.formatDuration(context.state.elapsedSeconds))
                    .font(.system(size: 12, weight: .semibold).monospacedDigit())
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: context.state.elapsedSeconds)
            } minimal: {
                Image(systemName: context.state.phase.symbolName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
            }
        }
    }

    fileprivate static func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainder = seconds % 60
        return String(format: "%02d:%02d", minutes, remainder)
    }
}
