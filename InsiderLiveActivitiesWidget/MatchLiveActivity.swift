//
//  MatchLiveActivity.swift
//  InsiderLiveActivitiesWidget
//

import ActivityKit
import InsiderLiveActivities
import SwiftUI
import WidgetKit

// MARK: - Lock Screen View

internal struct MatchLockScreenView: View {

    internal let context: ActivityViewContext<MatchActivityAttributes>

    public var body: some View {
        VStack(spacing: 12) {
            periodRow
            Divider().overlay(Color.white.opacity(0.15))
            scoreRow
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var periodRow: some View {
        HStack(alignment: .center) {
            Image(systemName: context.state.period.symbolName)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white.opacity(0.75))
                .animation(.easeInOut(duration: 0.25), value: context.state.period)
            Text(context.state.period.displayName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 9)
                .padding(.vertical, 3)
                .background(Capsule().fill(Color.white.opacity(0.15)))
                .animation(.easeInOut(duration: 0.25), value: context.state.period)
            Spacer()
            HStack(spacing: 3) {
                Image(systemName: "clock")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(.white.opacity(0.55))
                Text("\(context.state.minute)'")
                    .font(.system(size: 13, weight: .medium).monospacedDigit())
                    .foregroundStyle(.white.opacity(0.75))
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: context.state.minute)
            }
        }
    }

    private var scoreRow: some View {
        HStack(alignment: .center, spacing: 0) {
            teamLabel(context.attributes.homeTeam, alignment: .leading)

            scoreDisplay
                .frame(minWidth: 90)

            teamLabel(context.attributes.awayTeam, alignment: .trailing)
        }
    }

    private func teamLabel(_ name: String, alignment: HorizontalAlignment) -> some View {
        Text(name)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.white)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: alignment == .leading ? .leading : .trailing)
    }

    private var scoreDisplay: some View {
        HStack(alignment: .center, spacing: 6) {
            Text("\(context.state.homeScore)")
                .font(.system(size: 26, weight: .bold).monospacedDigit())
                .foregroundStyle(.white)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: context.state.homeScore)
            Text("–")
                .font(.system(size: 20, weight: .light))
                .foregroundStyle(.white.opacity(0.5))
            Text("\(context.state.awayScore)")
                .font(.system(size: 26, weight: .bold).monospacedDigit())
                .foregroundStyle(.white)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: context.state.awayScore)
        }
    }
}

// MARK: - Widget

internal struct MatchLiveActivity: Widget {

    public var body: some WidgetConfiguration {
        ActivityConfiguration(for: MatchActivityAttributes.self) { context in
            MatchLockScreenView(context: context)
                .containerBackground(for: .widget) {
                    LinearGradient(
                        colors: [Color(red: 0.05, green: 0.35, blue: 0.18), Color(red: 0.03, green: 0.18, blue: 0.10)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(context.attributes.homeTeam)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                        Text("Home")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundStyle(.white.opacity(0.55))
                    }
                    .padding(.leading, 4)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(context.attributes.awayTeam)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                        Text("Away")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundStyle(.white.opacity(0.55))
                    }
                    .padding(.trailing, 4)
                }
                DynamicIslandExpandedRegion(.center) {
                    HStack(alignment: .center, spacing: 5) {
                        Text("\(context.state.homeScore)")
                            .font(.system(size: 22, weight: .bold).monospacedDigit())
                            .foregroundStyle(.white)
                            .contentTransition(.numericText())
                            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: context.state.homeScore)
                        Text("–")
                            .font(.system(size: 18, weight: .light))
                            .foregroundStyle(.white.opacity(0.5))
                        Text("\(context.state.awayScore)")
                            .font(.system(size: 22, weight: .bold).monospacedDigit())
                            .foregroundStyle(.white)
                            .contentTransition(.numericText())
                            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: context.state.awayScore)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 6) {
                        Image(systemName: context.state.period.symbolName)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(.white.opacity(0.65))
                        Text(context.state.period.displayName)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.75))
                        Text("·")
                            .foregroundStyle(.white.opacity(0.35))
                        Text("\(context.state.minute)'")
                            .font(.system(size: 12, weight: .medium).monospacedDigit())
                            .foregroundStyle(.white.opacity(0.75))
                            .contentTransition(.numericText())
                            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: context.state.minute)
                    }
                    .padding(.bottom, 6)
                }
            } compactLeading: {
                HStack(spacing: 3) {
                    Image(systemName: "sportscourt.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white)
                    Text(String(context.attributes.homeTeam.prefix(3)).uppercased())
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white)
                }
            } compactTrailing: {
                HStack(spacing: 3) {
                    Text("\(context.state.homeScore)-\(context.state.awayScore)")
                        .font(.system(size: 12, weight: .bold).monospacedDigit())
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: context.state.homeScore)
                }
            } minimal: {
                Image(systemName: "sportscourt.fill")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white)
            }
        }
    }
}
