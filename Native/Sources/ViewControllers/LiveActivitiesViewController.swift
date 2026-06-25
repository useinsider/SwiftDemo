//
//  LiveActivitiesViewController.swift
//  Example
//

@preconcurrency import ActivityKit
import InsiderLiveActivities
import InsiderMobile
import UIKit

// MARK: - LiveActivitiesViewController

@available(iOS 16.2, *)
public final class LiveActivitiesViewController: UIViewController {

    // MARK: - Tab identifiers

    private enum Tab: Int, CaseIterable {
        case delivery = 0
        case workout  = 1
        case match    = 2

        var title: String {
            switch self {
            case .delivery: return "Delivery"
            case .workout:  return "Workout"
            case .match:    return "Match"
            }
        }
    }

    // MARK: - Subviews

    private let segmentedControl: UISegmentedControl = {
        let items = Tab.allCases.map { $0.title }
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.isAccessibilityElement = true
        control.accessibilityLabel = "Activity Type Tabs"
        control.accessibilityIdentifier = "live_activities_tab_control"
        return control
    }()

    private let deliveryTab = DeliveryTabView()
    private let workoutTab  = WorkoutTabView()
    private let matchTab    = MatchTabView()

    private let pinnedContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .backgroundPrimary
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = CGSize(width: 0, height: 8)
        v.layer.shadowRadius = 8
        v.layer.shadowOpacity = 0.55
        v.layer.masksToBounds = false
        return v
    }()

    private let cancelAllButton: DynamicFontAwareButton = {
        let button = makeTintedDangerButton(title: "Cancel All")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Cancel All Live Activities"
        button.accessibilityIdentifier = "cancel_all_button"
        return button
    }()

    private let logTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.font = UIFont.monospacedSystemFont(ofSize: 11, weight: .regular)
        textView.style { (b: TextViewStyleBuilder) in
            b.backgroundColor(.surfacePrimary).cornerRadius(12.0)
        }
        textView.textColor = .textPrimary
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.isAccessibilityElement = true
        textView.accessibilityLabel = "Application Log"
        textView.accessibilityIdentifier = "log_text_view"
        return textView
    }()

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        sv.backgroundColor = .backgroundPrimary
        return sv
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        return stack
    }()

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss.SSS"
        return f
    }()

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Live Activities"
        view.backgroundColor = .backgroundPrimary
        setupLayout()
        setupKeyboardDismissal()
        wireTabCallbacks()
        selectTab(.delivery)
        renderLog()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLog),
            name: AppLogger.didLogNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )

        observeActivityUpdates()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activeTab()?.refresh()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bounds = pinnedContainer.bounds
        let sliverHeight: CGFloat = 2
        let sliverRect = CGRect(
            x: bounds.minX,
            y: bounds.maxY - sliverHeight,
            width: bounds.width,
            height: sliverHeight
        )
        pinnedContainer.layer.shadowPath = UIBezierPath(rect: sliverRect).cgPath
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Layout

    private func setupLayout() {
        let cancelTitle = makeSectionTitleLabel("Cancel Everything")
        let cancelSubtitle = makeSectionSubtitleLabel(
            "Stops SDK tracking for all tracked activity types. ActivityKit instances stay alive."
        )
        let cancelTextStack = UIStackView(arrangedSubviews: [cancelTitle, cancelSubtitle])
        cancelTextStack.axis = .vertical
        cancelTextStack.spacing = 2

        let cancelBlock = UIStackView(arrangedSubviews: [cancelTextStack, cancelAllButton])
        cancelBlock.axis = .vertical
        cancelBlock.spacing = 10

        let logHeader = makeHeaderLabel("Application Log")
        let clearLogButton = makeClearLogButton()
        let logHeaderRow = UIStackView(arrangedSubviews: [logHeader, clearLogButton])
        logHeaderRow.axis = .horizontal
        logHeaderRow.alignment = .center
        logHeaderRow.spacing = 6

        let logStack = UIStackView(arrangedSubviews: [logHeaderRow, logTextView])
        logStack.axis = .vertical
        logStack.spacing = 6

        let pinnedStack = UIStackView(arrangedSubviews: [cancelBlock, makeSectionDivider(), logStack])
        pinnedStack.axis = .vertical
        pinnedStack.spacing = 16
        pinnedStack.translatesAutoresizingMaskIntoConstraints = false
        pinnedStack.isLayoutMarginsRelativeArrangement = true
        pinnedStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        pinnedContainer.addSubview(pinnedStack)
        view.addSubview(pinnedContainer)

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        view.bringSubviewToFront(pinnedContainer)

        contentStack.addArrangedSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(tabChanged), for: .valueChanged)

        contentStack.addArrangedSubview(deliveryTab)
        contentStack.addArrangedSubview(workoutTab)
        contentStack.addArrangedSubview(matchTab)

        NSLayoutConstraint.activate([
            pinnedContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pinnedContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pinnedContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            pinnedStack.topAnchor.constraint(equalTo: pinnedContainer.topAnchor),
            pinnedStack.leadingAnchor.constraint(equalTo: pinnedContainer.leadingAnchor),
            pinnedStack.trailingAnchor.constraint(equalTo: pinnedContainer.trailingAnchor),
            pinnedStack.bottomAnchor.constraint(equalTo: pinnedContainer.bottomAnchor),

            scrollView.topAnchor.constraint(equalTo: pinnedContainer.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            logTextView.heightAnchor.constraint(equalToConstant: 140)
        ])

        cancelAllButton.addTarget(self, action: #selector(cancelAllPressed), for: .touchUpInside)
    }

    private func makeHeaderLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text.uppercased()
        label.style { $0.font(.h6).textColor(.textTertiary) }
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }

    private func makeClearLogButton() -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "trash",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 13, weight: .regular)
        )
        config.baseForegroundColor = .secondaryLabel
        config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Clear Application Log"
        button.accessibilityIdentifier = "clear_log_button"
        button.addTarget(self, action: #selector(clearLog), for: .touchUpInside)
        return button
    }

    // MARK: - Tab wiring

    private func wireTabCallbacks() {
        deliveryTab.onRegisterTokens = {
            guard #available(iOS 17.2, *) else {
                AppLogger.shared.log("register(Delivery): push-to-start tokens require iOS 17.2 or later", level: .warn)
                return
            }
            Task { @MainActor in
                await LiveActivitiesActions.registerPushToStartTokens(
                    forType: Activity<DeliveryActivityAttributes>.self,
                    label: "Delivery"
                )
            }
        }
        deliveryTab.onStart = { [weak self] in self?.startDeliveryActivity() }
        deliveryTab.onCancelType = {
            Task { @MainActor in
                await LiveActivitiesActions.cancel(forType: Activity<DeliveryActivityAttributes>.self, label: "Delivery")
            }
        }
        deliveryTab.onUpdateRow = { [weak self] activity in self?.presentDeliveryUpdate(for: activity) }
        deliveryTab.onEndRow = { [weak self] activity in
            self?.confirmEnd(label: "Delivery") {
                Task { @MainActor in
                    await activity.end(
                        .init(state: .init(status: .delivered, etaMinutes: 0), staleDate: nil),
                        dismissalPolicy: .immediate
                    )
                    LiveActivitiesActions.logEnded(activity, label: "Delivery")
                }
            }
        }

        workoutTab.onRegisterTokens = {
            guard #available(iOS 17.2, *) else {
                AppLogger.shared.log("register(Workout): push-to-start tokens require iOS 17.2 or later", level: .warn)
                return
            }
            Task { @MainActor in
                await LiveActivitiesActions.registerPushToStartTokens(
                    forType: Activity<WorkoutActivityAttributes>.self,
                    label: "Workout"
                )
            }
        }
        workoutTab.onStart = { [weak self] in self?.startWorkoutActivity() }
        workoutTab.onCancelType = {
            Task { @MainActor in
                await LiveActivitiesActions.cancel(forType: Activity<WorkoutActivityAttributes>.self, label: "Workout")
            }
        }
        workoutTab.onUpdateRow = { [weak self] activity in self?.presentWorkoutUpdate(for: activity) }
        workoutTab.onEndRow = { [weak self] activity in
            let state = activity.content.state
            self?.confirmEnd(label: "Workout") {
                Task { @MainActor in
                    await activity.end(
                        .init(
                            state: .init(phase: .finished, elapsedSeconds: state.elapsedSeconds, calories: state.calories),
                            staleDate: nil
                        ),
                        dismissalPolicy: .immediate
                    )
                    LiveActivitiesActions.logEnded(activity, label: "Workout")
                }
            }
        }

        matchTab.onRegisterTokens = {
            guard #available(iOS 17.2, *) else {
                AppLogger.shared.log("register(Match): push-to-start tokens require iOS 17.2 or later", level: .warn)
                return
            }
            Task { @MainActor in
                await LiveActivitiesActions.registerPushToStartTokens(
                    forType: Activity<MatchActivityAttributes>.self,
                    label: "Match"
                )
            }
        }
        matchTab.onStart = { [weak self] in self?.startMatchActivity() }
        matchTab.onCancelType = {
            Task { @MainActor in
                await LiveActivitiesActions.cancel(forType: Activity<MatchActivityAttributes>.self, label: "Match")
            }
        }
        matchTab.onUpdateRow = { [weak self] activity in self?.presentMatchUpdate(for: activity) }
        matchTab.onEndRow = { [weak self] activity in
            let state = activity.content.state
            self?.confirmEnd(label: "Match") {
                Task { @MainActor in
                    await activity.end(
                        .init(
                            state: .init(homeScore: state.homeScore, awayScore: state.awayScore, period: .fullTime, minute: 90),
                            staleDate: nil
                        ),
                        dismissalPolicy: .immediate
                    )
                    LiveActivitiesActions.logEnded(activity, label: "Match")
                }
            }
        }
    }

    // MARK: - Tab selection

    @objc private func tabChanged() {
        guard let tab = Tab(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        selectTab(tab)
    }

    private func selectTab(_ tab: Tab) {
        segmentedControl.selectedSegmentIndex = tab.rawValue
        deliveryTab.isHidden = (tab != .delivery)
        workoutTab.isHidden  = (tab != .workout)
        matchTab.isHidden    = (tab != .match)
        activeTab()?.refresh()
    }

    private func activeTab() -> Refreshable? {
        switch Tab(rawValue: segmentedControl.selectedSegmentIndex) {
        case .delivery: return deliveryTab
        case .workout:  return workoutTab
        case .match:    return matchTab
        case .none:     return nil
        }
    }

    // MARK: - Start actions

    private func startDeliveryActivity() {
        let id = InsiderLiveActivityIdentifier.auto
        let courierName = deliveryTab.courierNameField.text?.trimmingCharacters(in: .whitespaces)
        let eta = Int(deliveryTab.etaField.text ?? "30") ?? 30
        let statusIndex = deliveryTab.statusControl.selectedSegmentIndex
        let status = DeliveryStatus.allCases[max(0, min(statusIndex, DeliveryStatus.allCases.count - 1))]
        let attrs = DeliveryActivityAttributes(insiderLiveActivityId: id, courierName: courierName.flatMap { $0.isEmpty ? nil : $0 } ?? "Courier")
        let state = DeliveryActivityAttributes.ContentState(status: status, etaMinutes: eta)
        LiveActivitiesActions.startActivity(attributes: attrs, initialState: state, label: "Delivery")
        scheduleRefresh()
    }

    private func startWorkoutActivity() {
        let id = InsiderLiveActivityIdentifier.auto
        let workoutType = workoutTab.workoutTypeField.text?.trimmingCharacters(in: .whitespaces)
        let elapsed = Int(workoutTab.elapsedField.text ?? "0") ?? 0
        let calories = Int(workoutTab.caloriesField.text ?? "0") ?? 0
        let phaseIndex = workoutTab.phaseControl.selectedSegmentIndex
        let phase = WorkoutPhase.allCases[max(0, min(phaseIndex, WorkoutPhase.allCases.count - 1))]
        let attrs = WorkoutActivityAttributes(insiderLiveActivityId: id, workoutType: workoutType.flatMap { $0.isEmpty ? nil : $0 } ?? "Running")
        let state = WorkoutActivityAttributes.ContentState(phase: phase, elapsedSeconds: elapsed, calories: calories)
        LiveActivitiesActions.startActivity(attributes: attrs, initialState: state, label: "Workout")
        scheduleRefresh()
    }

    private func startMatchActivity() {
        let id = InsiderLiveActivityIdentifier.custom("ABCDEF")
        let homeTeam = matchTab.homeTeamField.text?.trimmingCharacters(in: .whitespaces)
        let awayTeam = matchTab.awayTeamField.text?.trimmingCharacters(in: .whitespaces)
        let homeScore = Int(matchTab.homeScoreField.text ?? "0") ?? 0
        let awayScore = Int(matchTab.awayScoreField.text ?? "0") ?? 0
        let minute = Int(matchTab.minuteField.text ?? "0") ?? 0
        let periodIndex = matchTab.periodControl.selectedSegmentIndex
        let period = MatchPeriod.allCases[max(0, min(periodIndex, MatchPeriod.allCases.count - 1))]
        let attrs = MatchActivityAttributes(
            insiderLiveActivityId: id,
            homeTeam: homeTeam.flatMap { $0.isEmpty ? nil : $0 } ?? "Home FC",
            awayTeam: awayTeam.flatMap { $0.isEmpty ? nil : $0 } ?? "Away FC"
        )
        let state = MatchActivityAttributes.ContentState(homeScore: homeScore, awayScore: awayScore, period: period, minute: minute)
        LiveActivitiesActions.startActivity(attributes: attrs, initialState: state, label: "Match")
        scheduleRefresh()
    }

    // MARK: - Update pickers

    private func makeStateAction(
        title: String,
        symbolName: String,
        tint: UIColor,
        handler: @escaping () -> Void
    ) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .default) { _ in handler() }
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        let image = UIImage(systemName: symbolName, withConfiguration: config)?
            .withTintColor(tint, renderingMode: .alwaysOriginal)
        action.setValue(image, forKey: "image")
        return action
    }

    private func presentUpdatePicker(
        title: String,
        currentSummary: String,
        tint: UIColor,
        configure: (UIAlertController) -> Void
    ) {
        let alert = UIAlertController(title: title, message: currentSummary, preferredStyle: .actionSheet)
        configure(alert)
        alert.addAction(UIAlertAction(title: "Close", style: .destructive))
        alert.view.tintColor = tint
        present(alert, animated: true)
    }

    private func presentDeliveryUpdate(for activity: Activity<DeliveryActivityAttributes>) {
        let current = activity.content.state
        let tint = UIColor.systemBlue
        presentUpdatePicker(
            title: "Pick a new Delivery state",
            currentSummary: "Current: \(current.status.displayName) · \(current.etaMinutes) min",
            tint: tint
        ) { alert in
            for status in DeliveryStatus.allCases {
                alert.addAction(makeStateAction(
                    title: status.displayName,
                    symbolName: status.symbolName,
                    tint: tint
                ) {
                    let nextEta = status == .delivered ? 0 : Int.random(in: 5...25)
                    Task { @MainActor in
                        await activity.update(.init(state: .init(status: status, etaMinutes: nextEta), staleDate: nil))
                        LiveActivitiesActions.logUpdated(activity, label: "Delivery")
                    }
                    self.scheduleRefresh()
                })
            }
        }
    }

    private func presentWorkoutUpdate(for activity: Activity<WorkoutActivityAttributes>) {
        let current = activity.content.state
        let tint = UIColor.systemOrange
        presentUpdatePicker(
            title: "Pick a new Workout phase",
            currentSummary: "Current: \(current.phase.displayName) · \(current.elapsedSeconds)s · \(current.calories) kcal",
            tint: tint
        ) { alert in
            for phase in WorkoutPhase.allCases {
                alert.addAction(makeStateAction(
                    title: phase.displayName,
                    symbolName: phase.symbolName,
                    tint: tint
                ) {
                    Task { @MainActor in
                        await activity.update(
                            .init(
                                state: .init(
                                    phase: phase,
                                    elapsedSeconds: current.elapsedSeconds + 30,
                                    calories: current.calories + 10
                                ),
                                staleDate: nil
                            )
                        )
                        LiveActivitiesActions.logUpdated(activity, label: "Workout")
                    }
                    self.scheduleRefresh()
                })
            }
        }
    }

    private func presentMatchUpdate(for activity: Activity<MatchActivityAttributes>) {
        let current = activity.content.state
        let tint = UIColor.systemGreen
        presentUpdatePicker(
            title: "Update Match score or period",
            currentSummary: "Score \(current.homeScore)–\(current.awayScore) · \(current.period.displayName) · \(current.minute)'",
            tint: tint
        ) { alert in
            alert.addAction(makeStateAction(
                title: "+1 \(activity.attributes.homeTeam)",
                symbolName: "plus.circle.fill",
                tint: tint
            ) {
                Task { @MainActor in
                    await activity.update(
                        .init(
                            state: .init(
                                homeScore: current.homeScore + 1,
                                awayScore: current.awayScore,
                                period: current.period,
                                minute: min(current.minute + 1, 90)
                            ),
                            staleDate: nil
                        )
                    )
                    LiveActivitiesActions.logUpdated(activity, label: "Match")
                }
                self.scheduleRefresh()
            })
            alert.addAction(makeStateAction(
                title: "+1 \(activity.attributes.awayTeam)",
                symbolName: "plus.circle.fill",
                tint: tint
            ) {
                Task { @MainActor in
                    await activity.update(
                        .init(
                            state: .init(
                                homeScore: current.homeScore,
                                awayScore: current.awayScore + 1,
                                period: current.period,
                                minute: min(current.minute + 1, 90)
                            ),
                            staleDate: nil
                        )
                    )
                    LiveActivitiesActions.logUpdated(activity, label: "Match")
                }
                self.scheduleRefresh()
            })
            for period in MatchPeriod.allCases where period != current.period {
                alert.addAction(makeStateAction(
                    title: "Set \(period.displayName)",
                    symbolName: period.symbolName,
                    tint: tint
                ) {
                    Task { @MainActor in
                        await activity.update(
                            .init(
                                state: .init(
                                    homeScore: current.homeScore,
                                    awayScore: current.awayScore,
                                    period: period,
                                    minute: current.minute
                                ),
                                staleDate: nil
                            )
                        )
                        LiveActivitiesActions.logUpdated(activity, label: "Match")
                    }
                    self.scheduleRefresh()
                })
            }
        }
    }

    private func confirmEnd(label: String, action: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "End \(label) Activity?",
            message: "The Live Activity will be removed from the Lock Screen.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "End", style: .destructive) { _ in
            action()
            self.scheduleRefresh()
        })
        present(alert, animated: true)
    }

    // MARK: - Refresh helpers

    private func scheduleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.activeTab()?.refresh()
        }
    }

    // MARK: - Activity update observation

    private func observeActivityUpdates() {
        Task { [weak self] in
            for await _ in Activity<DeliveryActivityAttributes>.activityUpdates {
                await MainActor.run { self?.deliveryTab.refresh() }
            }
        }
        Task { [weak self] in
            for await _ in Activity<WorkoutActivityAttributes>.activityUpdates {
                await MainActor.run { self?.workoutTab.refresh() }
            }
        }
        Task { [weak self] in
            for await _ in Activity<MatchActivityAttributes>.activityUpdates {
                await MainActor.run { self?.matchTab.refresh() }
            }
        }
    }

    // MARK: - Log rendering

    @objc private func onLog() { renderLog() }

    @objc private func onForeground() {
        activeTab()?.refresh()
    }

    private func renderLog() {
        let text = AppLogger.shared.entries
            .map { "\(dateFormatter.string(from: $0.timestamp))  [\($0.level.rawValue)] \($0.message)" }
            .joined(separator: "\n")
        logTextView.text = text.isEmpty ? "(no log yet — trigger an action above)" : text

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let bottom = NSRange(location: max(self.logTextView.text.count - 1, 0), length: 1)
            self.logTextView.scrollRangeToVisible(bottom)
        }
    }

    // MARK: - Keyboard dismissal

    private func setupKeyboardDismissal() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() { view.endEditing(true) }

    // MARK: - Bar button actions

    @objc private func clearLog() { AppLogger.shared.clear() }
    @objc private func cancelAllPressed() {
        Task { @MainActor in await LiveActivitiesActions.cancelAll() }
    }
}

// MARK: - Refreshable protocol

@MainActor private protocol Refreshable: AnyObject {
    func refresh()
}

// MARK: - DeliveryTabView

@available(iOS 16.2, *)
private final class DeliveryTabView: UIStackView, Refreshable {

    var onRegisterTokens: (() -> Void)?
    var onStart: (() -> Void)?
    var onCancelType: (() -> Void)?
    var onUpdateRow: ((Activity<DeliveryActivityAttributes>) -> Void)?
    var onEndRow: ((Activity<DeliveryActivityAttributes>) -> Void)?

    let courierNameField: PaddingAwareTextField = makeTextField(placeholder: "e.g. Yusuf K.", default: "Yusuf K.")
    let statusControl: UISegmentedControl = {
        let items = DeliveryStatus.allCases.map { $0.displayName }
        let c = UISegmentedControl(items: items)
        c.selectedSegmentIndex = 0
        c.isAccessibilityElement = true
        c.accessibilityLabel = "Delivery Status"
        c.accessibilityIdentifier = "delivery_status_control"
        return c
    }()
    let etaField: PaddingAwareTextField = makeTextField(placeholder: "e.g. 30", default: "30", keyboard: .numberPad)

    private let instanceListStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 8
        return s
    }()

    private let emptyLabel: UILabel = {
        let l = UILabel()
        l.text = "No active Delivery activities."
        l.style { $0.font(.text13).textColor(.textTertiary).textAlignment(.center).numberOfLines(0) }
        return l
    }()

    private lazy var refreshButton: UIButton = makeRefreshButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = 20
        setup()
    }

    required init(coder: NSCoder) { super.init(coder: coder) }

    private func setup() {
        addArrangedSubview(makeSectionBlock(
            header: "Register Push-To-Start",
            subtitle: "Subscribes the SDK to ActivityKit push-to-start tokens for the Delivery attribute type.",
            content: makeRegisterButton(label: "Delivery")
        ))
        addArrangedSubview(makeSectionDivider())

        let formStack = UIStackView(arrangedSubviews: [
            makeSectionLabel("Courier Name"), courierNameField,
            makeSectionLabel("Status"), statusControl,
            makeSectionLabel("ETA Minutes"), etaField,
            makeStartButton(label: "Delivery")
        ])
        formStack.axis = .vertical
        formStack.spacing = 8
        addArrangedSubview(makeSectionBlock(
            header: "Start Activity",
            subtitle: "Requests a new Delivery Live Activity with the values below.",
            content: formStack
        ))
        addArrangedSubview(makeSectionDivider())

        addArrangedSubview(makeInstanceSection())
        addArrangedSubview(makeSectionDivider())

        addArrangedSubview(makeSectionBlock(
            header: "Cancel This Type",
            subtitle: "Stops SDK tracking for every Delivery activity. ActivityKit instances stay alive.",
            content: makeCancelTypeButton(label: "Delivery")
        ))

        attachToolbars(to: [courierNameField, etaField])
    }

    private func makeRegisterButton(label: String) -> UIView {
        let button = DynamicFontAwareButton(type: .system)
        button.style(with: .secondary)
        button.setTitle("Register Push-To-Start Tokens", for: .normal)
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Register \(label) Push-To-Start Tokens"
        button.accessibilityIdentifier = "register_\(label.lowercased())_tokens_button"
        button.addTarget(self, action: #selector(registerTokensTapped), for: .touchUpInside)
        return button
    }

    private func makeStartButton(label: String) -> UIView {
        let button = DynamicFontAwareButton(type: .system)
        button.style(with: .primary)
        button.setTitle("Start \(label)", for: .normal)
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Start \(label) Activity"
        button.accessibilityIdentifier = "start_\(label.lowercased())_button"
        button.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        return button
    }

    private func makeCancelTypeButton(label: String) -> UIView {
        let button = makeTintedDangerButton(title: "Cancel This Type")
        button.accessibilityLabel = "Cancel \(label) Activities"
        button.accessibilityIdentifier = "cancel_\(label.lowercased())_type_button"
        button.addTarget(self, action: #selector(cancelTypeTapped), for: .touchUpInside)
        return button
    }

    private func makeInstanceSection() -> UIView {
        let header = makeSectionHeader(
            "Active Instances",
            subtitle: "Currently tracked Delivery activities. Use the row buttons to update or end each one.",
            refreshButton: refreshButton
        )
        let container = UIStackView(arrangedSubviews: [instanceListStack, emptyLabel])
        container.axis = .vertical
        container.spacing = 8
        let section = UIStackView(arrangedSubviews: [header, container])
        section.axis = .vertical
        section.spacing = 10
        return section
    }

    func refresh() {
        instanceListStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let activities = Activity<DeliveryActivityAttributes>.activities
        emptyLabel.isHidden = !activities.isEmpty
        for activity in activities {
            let state = activity.content.state
            let row = InstanceRowView(
                symbolName: "shippingbox.fill",
                tint: .systemBlue,
                title: "\(activity.attributes.courierName) — \(state.status.displayName)",
                summary: "ETA \(state.etaMinutes) min · \(activity.attributes.insiderLiveActivityId)",
                onUpdate: { [weak self] in self?.onUpdateRow?(activity) },
                onEnd: { [weak self] in self?.onEndRow?(activity) }
            )
            instanceListStack.addArrangedSubview(row)
        }
    }

    @objc private func registerTokensTapped() { onRegisterTokens?() }
    @objc private func startTapped() { onStart?() }
    @objc private func cancelTypeTapped() { onCancelType?() }

    @objc private func refreshTapped() {
        animateRefreshButton(refreshButton)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.refresh()
            AppLogger.shared.log("Delivery: refreshed instances", level: .info)
        }
    }

    private func makeRefreshButton() -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arrow.clockwise")
        config.baseForegroundColor = .secondaryLabel
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0)
        let b = UIButton(configuration: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.isAccessibilityElement = true
        b.accessibilityLabel = "Refresh Delivery Instances"
        b.accessibilityIdentifier = "refresh_delivery_button"
        b.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
        return b
    }

    private func attachToolbars(to fields: [UITextField]) {
        for field in fields { attachToolbar(to: field) }
    }
}

// MARK: - WorkoutTabView

@available(iOS 16.2, *)
private final class WorkoutTabView: UIStackView, Refreshable {

    var onRegisterTokens: (() -> Void)?
    var onStart: (() -> Void)?
    var onCancelType: (() -> Void)?
    var onUpdateRow: ((Activity<WorkoutActivityAttributes>) -> Void)?
    var onEndRow: ((Activity<WorkoutActivityAttributes>) -> Void)?

    let workoutTypeField: PaddingAwareTextField = makeTextField(placeholder: "e.g. Running", default: "Running")
    let phaseControl: UISegmentedControl = {
        let items = WorkoutPhase.allCases.map { $0.displayName }
        let c = UISegmentedControl(items: items)
        c.selectedSegmentIndex = 0
        c.isAccessibilityElement = true
        c.accessibilityLabel = "Workout Phase"
        c.accessibilityIdentifier = "workout_phase_control"
        return c
    }()
    let elapsedField: PaddingAwareTextField = makeTextField(placeholder: "0", default: "0", keyboard: .numberPad)
    let caloriesField: PaddingAwareTextField = makeTextField(placeholder: "0", default: "0", keyboard: .numberPad)

    private let instanceListStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 8
        return s
    }()

    private let emptyLabel: UILabel = {
        let l = UILabel()
        l.text = "No active Workout activities."
        l.style { $0.font(.text13).textColor(.textTertiary).textAlignment(.center).numberOfLines(0) }
        return l
    }()

    private lazy var refreshButton: UIButton = makeRefreshButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = 20
        setup()
    }

    required init(coder: NSCoder) { super.init(coder: coder) }

    private func setup() {
        addArrangedSubview(makeSectionBlock(
            header: "Register Push-To-Start",
            subtitle: "Subscribes the SDK to ActivityKit push-to-start tokens for the Workout attribute type.",
            content: makeRegisterButton(label: "Workout")
        ))
        addArrangedSubview(makeSectionDivider())

        let formStack = UIStackView(arrangedSubviews: [
            makeSectionLabel("Workout Type"), workoutTypeField,
            makeSectionLabel("Phase"), phaseControl,
            makeSectionLabel("Elapsed Seconds"), elapsedField,
            makeSectionLabel("Calories"), caloriesField,
            makeStartButton(label: "Workout")
        ])
        formStack.axis = .vertical
        formStack.spacing = 8
        addArrangedSubview(makeSectionBlock(
            header: "Start Activity",
            subtitle: "Requests a new Workout Live Activity with the values below.",
            content: formStack
        ))
        addArrangedSubview(makeSectionDivider())

        addArrangedSubview(makeInstanceSection())
        addArrangedSubview(makeSectionDivider())

        addArrangedSubview(makeSectionBlock(
            header: "Cancel This Type",
            subtitle: "Stops SDK tracking for every Workout activity. ActivityKit instances stay alive.",
            content: makeCancelTypeButton(label: "Workout")
        ))

        attachToolbars(to: [workoutTypeField, elapsedField, caloriesField])
    }

    private func makeRegisterButton(label: String) -> UIView {
        let button = DynamicFontAwareButton(type: .system)
        button.style(with: .secondary)
        button.setTitle("Register Push-To-Start Tokens", for: .normal)
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Register \(label) Push-To-Start Tokens"
        button.accessibilityIdentifier = "register_\(label.lowercased())_tokens_button"
        button.addTarget(self, action: #selector(registerTokensTapped), for: .touchUpInside)
        return button
    }

    private func makeStartButton(label: String) -> UIView {
        let button = DynamicFontAwareButton(type: .system)
        button.style(with: .primary)
        button.setTitle("Start \(label)", for: .normal)
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Start \(label) Activity"
        button.accessibilityIdentifier = "start_\(label.lowercased())_button"
        button.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        return button
    }

    private func makeCancelTypeButton(label: String) -> UIView {
        let button = makeTintedDangerButton(title: "Cancel This Type")
        button.accessibilityLabel = "Cancel \(label) Activities"
        button.accessibilityIdentifier = "cancel_\(label.lowercased())_type_button"
        button.addTarget(self, action: #selector(cancelTypeTapped), for: .touchUpInside)
        return button
    }

    private func makeInstanceSection() -> UIView {
        let header = makeSectionHeader(
            "Active Instances",
            subtitle: "Currently tracked Workout activities. Use the row buttons to update or end each one.",
            refreshButton: refreshButton
        )
        let container = UIStackView(arrangedSubviews: [instanceListStack, emptyLabel])
        container.axis = .vertical
        container.spacing = 8
        let section = UIStackView(arrangedSubviews: [header, container])
        section.axis = .vertical
        section.spacing = 10
        return section
    }

    func refresh() {
        instanceListStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let activities = Activity<WorkoutActivityAttributes>.activities
        emptyLabel.isHidden = !activities.isEmpty
        for activity in activities {
            let state = activity.content.state
            let row = InstanceRowView(
                symbolName: "figure.run",
                tint: .systemOrange,
                title: "\(activity.attributes.workoutType) — \(state.phase.displayName)",
                summary: "\(state.elapsedSeconds)s · \(state.calories) kcal · \(activity.attributes.insiderLiveActivityId)",
                onUpdate: { [weak self] in self?.onUpdateRow?(activity) },
                onEnd: { [weak self] in self?.onEndRow?(activity) }
            )
            instanceListStack.addArrangedSubview(row)
        }
    }

    @objc private func registerTokensTapped() { onRegisterTokens?() }
    @objc private func startTapped() { onStart?() }
    @objc private func cancelTypeTapped() { onCancelType?() }

    @objc private func refreshTapped() {
        animateRefreshButton(refreshButton)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.refresh()
            AppLogger.shared.log("Workout: refreshed instances", level: .info)
        }
    }

    private func makeRefreshButton() -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arrow.clockwise")
        config.baseForegroundColor = .secondaryLabel
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0)
        let b = UIButton(configuration: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.isAccessibilityElement = true
        b.accessibilityLabel = "Refresh Workout Instances"
        b.accessibilityIdentifier = "refresh_workout_button"
        b.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
        return b
    }

    private func attachToolbars(to fields: [UITextField]) {
        for field in fields { attachToolbar(to: field) }
    }
}

// MARK: - MatchTabView

@available(iOS 16.2, *)
private final class MatchTabView: UIStackView, Refreshable {

    var onRegisterTokens: (() -> Void)?
    var onStart: (() -> Void)?
    var onCancelType: (() -> Void)?
    var onUpdateRow: ((Activity<MatchActivityAttributes>) -> Void)?
    var onEndRow: ((Activity<MatchActivityAttributes>) -> Void)?

    let homeTeamField: PaddingAwareTextField  = makeTextField(placeholder: "e.g. Home FC", default: "Home FC")
    let awayTeamField: PaddingAwareTextField  = makeTextField(placeholder: "e.g. Away FC", default: "Away FC")
    let periodControl: UISegmentedControl = {
        let items = MatchPeriod.allCases.map { $0.displayName }
        let c = UISegmentedControl(items: items)
        c.selectedSegmentIndex = 0
        c.isAccessibilityElement = true
        c.accessibilityLabel = "Match Period"
        c.accessibilityIdentifier = "match_period_control"
        return c
    }()
    let homeScoreField: PaddingAwareTextField = makeTextField(placeholder: "0", default: "0", keyboard: .numberPad)
    let awayScoreField: PaddingAwareTextField = makeTextField(placeholder: "0", default: "0", keyboard: .numberPad)
    let minuteField: PaddingAwareTextField    = makeTextField(placeholder: "0", default: "0", keyboard: .numberPad)

    private let instanceListStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 8
        return s
    }()

    private let emptyLabel: UILabel = {
        let l = UILabel()
        l.text = "No active Match activities."
        l.style { $0.font(.text13).textColor(.textTertiary).textAlignment(.center).numberOfLines(0) }
        return l
    }()

    private lazy var refreshButton: UIButton = makeRefreshButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = 20
        setup()
    }

    required init(coder: NSCoder) { super.init(coder: coder) }

    private func setup() {
        addArrangedSubview(makeSectionBlock(
            header: "Register Push-To-Start",
            subtitle: "Subscribes the SDK to ActivityKit push-to-start tokens for the Match attribute type.",
            content: makeRegisterButton(label: "Match")
        ))
        addArrangedSubview(makeSectionDivider())

        let scoreRow = UIStackView(arrangedSubviews: [homeScoreField, awayScoreField])
        scoreRow.axis = .horizontal
        scoreRow.spacing = 10
        scoreRow.distribution = .fillEqually

        let formStack = UIStackView(arrangedSubviews: [
            makeSectionLabel("Home Team"), homeTeamField,
            makeSectionLabel("Away Team"), awayTeamField,
            makeSectionLabel("Period"), periodControl,
            makeSectionLabel("Score (Home / Away)"), scoreRow,
            makeSectionLabel("Minute"), minuteField,
            makeStartButton(label: "Match")
        ])
        formStack.axis = .vertical
        formStack.spacing = 8
        addArrangedSubview(makeSectionBlock(
            header: "Start Activity",
            subtitle: "Requests a new Match Live Activity with the values below.",
            content: formStack
        ))
        addArrangedSubview(makeSectionDivider())

        addArrangedSubview(makeInstanceSection())
        addArrangedSubview(makeSectionDivider())

        addArrangedSubview(makeSectionBlock(
            header: "Cancel This Type",
            subtitle: "Stops SDK tracking for every Match activity. ActivityKit instances stay alive.",
            content: makeCancelTypeButton(label: "Match")
        ))

        attachToolbars(to: [homeTeamField, awayTeamField, homeScoreField, awayScoreField, minuteField])
    }

    private func makeRegisterButton(label: String) -> UIView {
        let button = DynamicFontAwareButton(type: .system)
        button.style(with: .secondary)
        button.setTitle("Register Push-To-Start Tokens", for: .normal)
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Register \(label) Push-To-Start Tokens"
        button.accessibilityIdentifier = "register_\(label.lowercased())_tokens_button"
        button.addTarget(self, action: #selector(registerTokensTapped), for: .touchUpInside)
        return button
    }

    private func makeStartButton(label: String) -> UIView {
        let button = DynamicFontAwareButton(type: .system)
        button.style(with: .primary)
        button.setTitle("Start \(label)", for: .normal)
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Start \(label) Activity"
        button.accessibilityIdentifier = "start_\(label.lowercased())_button"
        button.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        return button
    }

    private func makeCancelTypeButton(label: String) -> UIView {
        let button = makeTintedDangerButton(title: "Cancel This Type")
        button.accessibilityLabel = "Cancel \(label) Activities"
        button.accessibilityIdentifier = "cancel_\(label.lowercased())_type_button"
        button.addTarget(self, action: #selector(cancelTypeTapped), for: .touchUpInside)
        return button
    }

    private func makeInstanceSection() -> UIView {
        let header = makeSectionHeader(
            "Active Instances",
            subtitle: "Currently tracked Match activities. Use the row buttons to update or end each one.",
            refreshButton: refreshButton
        )
        let container = UIStackView(arrangedSubviews: [instanceListStack, emptyLabel])
        container.axis = .vertical
        container.spacing = 8
        let section = UIStackView(arrangedSubviews: [header, container])
        section.axis = .vertical
        section.spacing = 10
        return section
    }

    func refresh() {
        instanceListStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let activities = Activity<MatchActivityAttributes>.activities
        emptyLabel.isHidden = !activities.isEmpty
        for activity in activities {
            let state = activity.content.state
            let row = InstanceRowView(
                symbolName: "sportscourt.fill",
                tint: .systemGreen,
                title: "\(activity.attributes.homeTeam) \(state.homeScore) - \(state.awayScore) \(activity.attributes.awayTeam)",
                summary: "\(state.period.displayName) · \(state.minute)' · \(activity.attributes.insiderLiveActivityId)",
                onUpdate: { [weak self] in self?.onUpdateRow?(activity) },
                onEnd: { [weak self] in self?.onEndRow?(activity) }
            )
            instanceListStack.addArrangedSubview(row)
        }
    }

    @objc private func registerTokensTapped() { onRegisterTokens?() }
    @objc private func startTapped() { onStart?() }
    @objc private func cancelTypeTapped() { onCancelType?() }

    @objc private func refreshTapped() {
        animateRefreshButton(refreshButton)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.refresh()
            AppLogger.shared.log("Match: refreshed instances", level: .info)
        }
    }

    private func makeRefreshButton() -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arrow.clockwise")
        config.baseForegroundColor = .secondaryLabel
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0)
        let b = UIButton(configuration: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.isAccessibilityElement = true
        b.accessibilityLabel = "Refresh Match Instances"
        b.accessibilityIdentifier = "refresh_match_button"
        b.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
        return b
    }

    private func attachToolbars(to fields: [UITextField]) {
        for field in fields { attachToolbar(to: field) }
    }
}

// MARK: - InstanceRowView

private final class InstanceRowView: UIView {

    init(
        symbolName: String,
        tint: UIColor,
        title: String,
        summary: String,
        onUpdate: @escaping () -> Void,
        onEnd: @escaping () -> Void
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        style(with: .card)
        buildLayout(symbolName: symbolName, tint: tint, title: title, summary: summary, onUpdate: onUpdate, onEnd: onEnd)
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }

    private func buildLayout(
        symbolName: String,
        tint: UIColor,
        title: String,
        summary: String,
        onUpdate: @escaping () -> Void,
        onEnd: @escaping () -> Void
    ) {
        let icon = UIImageView(image: UIImage(systemName: symbolName))
        icon.tintColor = tint
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isAccessibilityElement = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.style { $0.font(.h5).textColor(.textPrimary).numberOfLines(1) }

        let summaryLabel = UILabel()
        summaryLabel.text = summary
        summaryLabel.style { $0.font(.h6).textColor(.textTertiary).numberOfLines(1) }

        let textStack = UIStackView(arrangedSubviews: [titleLabel, summaryLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false

        let updateButton = makeRowButton(symbol: "arrow.triangle.2.circlepath", tint: tint, action: onUpdate)
        updateButton.isAccessibilityElement = true
        updateButton.accessibilityLabel = "Update \(title)"
        updateButton.accessibilityIdentifier = "update_row_button"

        let endButton = makeRowButton(symbol: "stop.circle", tint: .systemRed, action: onEnd)
        endButton.isAccessibilityElement = true
        endButton.accessibilityLabel = "End \(title)"
        endButton.accessibilityIdentifier = "end_row_button"

        let buttonStack = UIStackView(arrangedSubviews: [updateButton, endButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 6
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(icon)
        addSubview(textStack)
        addSubview(buttonStack)

        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 26),
            icon.heightAnchor.constraint(equalToConstant: 26),

            textStack.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: buttonStack.leadingAnchor, constant: -8),
            textStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            textStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),

            buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            buttonStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func makeRowButton(symbol: String, tint: UIColor, action: @escaping () -> Void) -> UIButton {
        var config = UIButton.Configuration.tinted()
        config.image = UIImage(systemName: symbol)
        config.baseForegroundColor = tint
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10)
        let button = UIButton(configuration: config)
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        return button
    }
}

// MARK: - Shared free functions

@MainActor
private func makeTintedDangerButton(title: String) -> DynamicFontAwareButton {
    var config = UIButton.Configuration.tinted()
    config.title = title
    config.baseBackgroundColor = .statusDanger
    config.baseForegroundColor = .statusDanger
    config.cornerStyle = .capsule
    config.contentInsets = NSDirectionalEdgeInsets(inset: 12.0)

    let button = DynamicFontAwareButton(type: .system)
    button.configuration = config
    button.setFont(.buttonLarge(emphasis: .bold))
    button.isAccessibilityElement = true
    return button
}

@MainActor
private func makeTextField(
    placeholder: String,
    default defaultValue: String,
    keyboard: UIKeyboardType = .default
) -> PaddingAwareTextField {
    let field = PaddingAwareTextField()
    field.style(with: .default)
    field.placeholder = placeholder
    field.text = defaultValue
    field.keyboardType = keyboard
    field.autocorrectionType = .no
    field.autocapitalizationType = .none
    field.clearButtonMode = .whileEditing
    field.translatesAutoresizingMaskIntoConstraints = false
    field.heightAnchor.constraint(equalToConstant: 44).isActive = true
    field.isAccessibilityElement = true
    field.accessibilityLabel = placeholder
    return field
}

@MainActor
private func makeSectionLabel(_ text: String) -> UILabel {
    let l = UILabel()
    l.text = text
    l.style { $0.font(.h6).textColor(.textTertiary) }
    l.setContentHuggingPriority(.required, for: .vertical)
    return l
}

@MainActor
private func makeSectionBlock(header: String?, subtitle: String? = nil, content: UIView) -> UIView {
    var titleViews: [UIView] = []
    if let header {
        titleViews.append(makeSectionTitleLabel(header))
    }
    if let subtitle {
        titleViews.append(makeSectionSubtitleLabel(subtitle))
    }

    if titleViews.isEmpty {
        let stack = UIStackView(arrangedSubviews: [content])
        stack.axis = .vertical
        return stack
    }

    let titleStack = UIStackView(arrangedSubviews: titleViews)
    titleStack.axis = .vertical
    titleStack.spacing = 2

    let stack = UIStackView(arrangedSubviews: [titleStack, content])
    stack.axis = .vertical
    stack.spacing = 10
    return stack
}

@MainActor
private func makeSectionHeader(
    _ text: String,
    subtitle: String? = nil,
    refreshButton: UIButton
) -> UIView {
    let titleLabel = makeSectionTitleLabel(text)
    titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    refreshButton.setContentHuggingPriority(.required, for: .horizontal)

    let spacer = UIView()
    spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
    spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    let row = UIStackView(arrangedSubviews: [titleLabel, spacer, refreshButton])
    row.axis = .horizontal
    row.alignment = .center
    row.spacing = 4

    guard let subtitle else { return row }

    let stack = UIStackView(arrangedSubviews: [row, makeSectionSubtitleLabel(subtitle)])
    stack.axis = .vertical
    stack.spacing = 2
    return stack
}

@MainActor
private func makeSectionTitleLabel(_ text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.style { $0.font(.h4).textColor(.textPrimary) }
    label.setContentHuggingPriority(.required, for: .vertical)
    return label
}

@MainActor
private func makeSectionSubtitleLabel(_ text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.style { $0.font(.text13).textColor(.textTertiary).numberOfLines(0) }
    label.setContentHuggingPriority(.required, for: .vertical)
    return label
}

@MainActor
private func makeSectionDivider() -> UIView {
    let line = UIView()
    line.translatesAutoresizingMaskIntoConstraints = false
    line.backgroundColor = .opaqueSeparator
    line.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    line.isAccessibilityElement = false
    return line
}

@MainActor
private func animateRefreshButton(_ button: UIButton) {
    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
        button.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
    } completion: { _ in
        button.imageView?.transform = .identity
    }
}

@MainActor
private func attachToolbar(to textField: UITextField) {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done = UIBarButtonItem(barButtonSystemItem: .done, target: textField, action: #selector(UITextField.resignFirstResponder))
    done.isAccessibilityElement = true
    done.accessibilityLabel = "Close Keyboard"
    toolbar.items = [flex, done]
    textField.inputAccessoryView = toolbar
}
