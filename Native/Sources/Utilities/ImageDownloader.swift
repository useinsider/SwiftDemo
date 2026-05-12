//
//  ImageDownloader.swift
//  Example
//
//  Created by Insider on 24.11.2025.
//  Copyright © 2025 Insider. All rights reserved.
//

import Combine
import UIKit

public enum ImageDownloadError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidImageData
    case cancelled

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The provided URL is invalid"
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        case .invalidImageData:
            return "Downloaded data cannot be converted to an image"
        case .cancelled:
            return "Download was cancelled"
        }
    }
}

// MARK: - Download Task

/// Represents an active download task that can be cancelled
private actor DownloadTask {

    private var task: Task<UIImage, Error>?
    private(set) var isCancelled = false

    public init(task: Task<UIImage, Error>) {
        self.task = task
    }

    public func cancel() {
        task?.cancel()
        task = nil
    }

    public func result() async throws -> UIImage {
        guard let task = task else {
            throw ImageDownloadError.cancelled
        }
        return try await task.value
    }
}

// MARK: - Image Downloader

@MainActor
public final class ImageDownloader: ObservableObject {

    /// Shared singleton instance
    public static let shared = ImageDownloader()

    /// Active download tasks
    private var activeTasks: [URL: DownloadTask] = [:]

    /// URLSession configuration
    private let urlSession: URLSession = .shared

    public func downloadImage(from url: URL) async throws -> UIImage {
        // Check if there's already an active download for this URL
        if let task = activeTasks[url] {
            return try await task.result()
        }
        let downloadTask = DownloadTask(task: Task {
            defer {
                activeTasks.removeValue(forKey: url)
            }
            try Task.checkCancellation()
            let (data, response) = try await urlSession.data(from: url)
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                throw ImageDownloadError.networkError(URLError(.badServerResponse))
            }
            try Task.checkCancellation()
            guard let image = UIImage(data: data) else {
                throw ImageDownloadError.invalidImageData
            }
            return image
        })
        activeTasks[url] = downloadTask
        do {
            return try await downloadTask.result()
        } catch is CancellationError {
            throw ImageDownloadError.cancelled
        } catch {
            throw error
        }
    }

    public func cancel(for url: URL) async {
        await activeTasks[url]?.cancel()
        activeTasks.removeValue(forKey: url)
    }

    /// Cancels all active downloads
    public func cancelAllDownloads() async {
        for (url, task) in activeTasks {
            await task.cancel()
            activeTasks.removeValue(forKey: url)
        }
    }
}

// MARK: - UIImageView Extension

extension UIImageView {

    private static var downloadTaskKey: UInt8 = 0
    private static var downloadingURLKey: UInt8 = 0

    /// Currently downloading image URL stored via associated object
    private var downloadingURL: URL? {
        get {
            objc_getAssociatedObject(self, &Self.downloadingURLKey) as? URL
        }
        set {
            objc_setAssociatedObject(
                self,
                &Self.downloadingURLKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    /// Currently active download task stored via associated object
    private var downloadTask: Task<Void, Never>? {
        get {
            objc_getAssociatedObject(self, &Self.downloadTaskKey) as? Task<Void, Never>
        }
        set {
            objc_setAssociatedObject(
                self,
                &Self.downloadTaskKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    public func setImage(from url: URL, placeholder: UIImage? = nil) {
        // Cancel any existing download
        cancelDownloadingImage()

        // Set placeholder
        image = placeholder

        // Store the URL we're downloading
        downloadingURL = url

        // Create and store the download task
        downloadTask = Task { @MainActor in
            do {
                let downloadedImage = try await ImageDownloader.shared.downloadImage(from: url)
                // Only set image if the URL is still the same (not replaced by another setImage call)
                guard downloadingURL == url, !Task.isCancelled else { return }
                image = downloadedImage
                downloadingURL = nil
            } catch {
                downloadingURL = nil
            }
        }
    }

    /// Cancels the currently downloading image (if any)
    public func cancelDownloadingImage() {
        // Cancel the task
        downloadTask?.cancel()
        downloadTask = nil
        if let downloadingURL {
            Task { @MainActor in
                await ImageDownloader.shared.cancel(for: downloadingURL)
            }
            self.downloadingURL = nil
        }
    }
}
