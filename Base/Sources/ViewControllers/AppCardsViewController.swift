//
//  AppCardsViewController.swift
//  Example
//
//  Created by Insider on 26.03.2026.
//

import UIKit
import InsiderMobile

public final class AppCardsViewController: UITableViewController {

    private var messages: [InsiderAppCardModel] = []

    private lazy var editBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(
            title: tableView.isEditing ? "Cancel" : "Edit",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(toggleEditMode)
        )
    }()

    private lazy var toggleSelectionButton: UIBarButtonItem = {
        return UIBarButtonItem(
            title: indexPathsForSelectedRows.count < messages.count ? "Select All" : "Deselect All",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(toggleSelection)
        )
    }()

    private lazy var markAsReadButton: UIBarButtonItem = {
        return UIBarButtonItem(
            title: "Mark as Read",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(markSelectedAsRead)
        )
    }()

    private lazy var markAsUnreadButton: UIBarButtonItem = {
        return UIBarButtonItem(
            title: "Mark as Unread",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(markSelectedAsUnread)
        )
    }()

    private var indexPathsForSelectedRows: [IndexPath] {
        return tableView.indexPathsForSelectedRows ?? []
    }

    @MainActor deinit {
        Insider.appCards().removeObserver(self)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "App Cards"

        tableView.register(AppCardsTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.backgroundColor = .backgroundPrimary
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsMultipleSelectionDuringEditing = true

        setupNavigationBar()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        Insider.appCards().addObserver(self)

        Task { @MainActor in
            let campaigns = try await Insider.appCards().getCampaigns()
            self.messages = campaigns.appCards
            self.tableView.reloadData()
        }
    }

    @objc private func refresh() {
        Task { @MainActor in
            if tableView.isEditing { toggleEditMode() }
            let campaigns = try await Insider.appCards().getCampaigns()
            self.refreshControl?.endRefreshing()
            self.messages = campaigns.appCards
            self.tableView.reloadData()
        }
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AppCardsTableViewCell
        let message = messages[indexPath.row]

        cell.configure(with: message) { button in
            button.click()
            Alert(title: button.text, message: "Button action executed") {
                AlertAction(title: "OK", style: .default)
            }.show(on: self)
        }
        cell.setReadStatusAction = { [weak tableView] isRead in
            Task { @MainActor in
                do {
                    if (isRead) {
                        try await message.markAsRead()
                    } else {
                        try await message.markAsUnread()
                    }
                    message.isRead.toggle()
                } catch {
                    if let cell = tableView?.cellForRow(at: indexPath) as? AppCardsTableViewCell {
                        cell.updateReadStatusIndicatorButton(isRead: message.isRead, animated: true)
                    }
                }
            }
        }
        cell.detailsButtonAction = { [unowned self] in
            let detail = AppCardDetailViewController(message: message)
            let navigation = UINavigationController(rootViewController: detail)
            navigation.modalPresentationStyle = .pageSheet
            if let sheet = navigation.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
            self.present(navigation, animated: true)
        }
        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateToolbarButtons()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            let message = messages[indexPath.row]
            message.click()
        }
    }

    public override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateToolbarButtons()
        }
    }

    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        message.view()
    }

    public override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let appCardId = messages[indexPath.row].appCardId
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self else {
                completion(false)
                return
            }
            Task { @MainActor in
                do {
                    try await Insider.appCards().delete(appCardIds: Set([appCardId]))
                    if let idx = self.messages.firstIndex(where: { $0.appCardId == appCardId }) {
                        self.messages.remove(at: idx)
                        tableView.deleteRows(at: [IndexPath(row: idx, section: 0)], with: .automatic)
                    }
                    completion(true)
                } catch {
                    completion(false)
                    Alert(title: "Error", message: "Failed to delete message: \(error.localizedDescription)") {
                        AlertAction(title: "OK", style: .default)
                    }.show(on: self)
                }
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = editBarButtonItem
        updateToolbarButtons()
    }

    @objc private func toggleEditMode() {
        let isEditing = !tableView.isEditing
        tableView.setEditing(isEditing, animated: true)
        if isEditing {
            editBarButtonItem.title = "Cancel"
            navigationItem.leftBarButtonItem = toggleSelectionButton
            toolbarItems = [markAsReadButton, .flexible(), markAsUnreadButton]
            navigationController?.setToolbarHidden(false, animated: true)
            updateToolbarButtons()
        } else {
            editBarButtonItem.title = "Edit"
            navigationItem.leftBarButtonItem = nil
            navigationController?.setToolbarHidden(true, animated: true)
            toggleSelectionButton.title = "Select All"
        }
    }

    @objc private func toggleSelection() {
        let indexPathsForSelectedRows = self.indexPathsForSelectedRows
        if indexPathsForSelectedRows.count > 0 && indexPathsForSelectedRows.count == messages.count {
            for indexPath in indexPathsForSelectedRows {
                tableView.deselectRow(at: indexPath, animated: true)
            }
            toggleSelectionButton.title = "Select All"
        } else {
            for i in 0..<messages.count {
                tableView.selectRow(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: .none)
            }
            toggleSelectionButton.title = "Deselect All"
        }
        updateToolbarButtons()
    }

    private func updateToolbarButtons() {
        let selectedCount = self.indexPathsForSelectedRows.count
        markAsReadButton.isEnabled = selectedCount > 0
        markAsUnreadButton.isEnabled = selectedCount > 0
        if selectedCount > 0 && selectedCount == messages.count {
            toggleSelectionButton.title = "Deselect All"
        } else {
            toggleSelectionButton.title = "Select All"
        }
    }

    @objc private func markSelectedAsRead() {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
        let appCardIds = selectedIndexPaths.map { messages[$0.row].appCardId }
        Task { @MainActor in
            toggleEditMode()
            do {
                try await Insider.appCards().markAsRead(appCardIds: Set(appCardIds))
                for indexPath in selectedIndexPaths {
                    messages[indexPath.row].isRead = true
                }
                tableView.reloadRows(at: selectedIndexPaths, with: .automatic)
                Alert(title: "Success") { AlertAction(title: "OK", style: .default) }.show(on: self)
            } catch {
                Alert(title: "Error", message: "Failed to mark messages as read: \(error.localizedDescription)") {
                    AlertAction(title: "OK", style: .default)
                }.show(on: self)
            }
        }
    }

    @objc private func markSelectedAsUnread() {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
        let appCardIds = selectedIndexPaths.map { messages[$0.row].appCardId }
        Task { @MainActor in
            toggleEditMode()
            do {
                try await Insider.appCards().markAsUnread(appCardIds: Set(appCardIds))
                for indexPath in selectedIndexPaths {
                    messages[indexPath.row].isRead = false
                }
                tableView.reloadRows(at: selectedIndexPaths, with: .automatic)
                Alert(title: "Success") { AlertAction(title: "OK", style: .default) }.show(on: self)
            } catch {
                Alert(title: "Error", message: "Failed to mark messages as unread: \(error.localizedDescription)") {
                    AlertAction(title: "OK", style: .default)
                }.show(on: self)
            }
        }
    }
}

extension AppCardsViewController: InsiderAppCardsObserver {

    public func appCardsDidMarkAsRead(_ appCardIds: Set<String>) {}

    public func appCardsDidMarkAsUnread(_ appCardIds: Set<String>) {}

    public func appCardsDidViewAppCard(withId appCardId: String) {}

    public func appCardsDidClickAppCard(withId appCardId: String) {}

    public func appCardsDidClickButton(withId buttonId: String, inAppCardWithId appCardId: String) {}

    public func appCardsDidDeleteAppCards(_ appCardIds: Set<String>) {}
}

extension UIBarButtonItem {

    fileprivate static func flexible() -> Self {
        return Self(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
}
