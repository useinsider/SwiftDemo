//
//  CollectionViewLayoutProvider.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import UIKit

@MainActor public enum CollectionViewLayoutProvider {

    @MainActor public enum Section {

        private static func header() -> NSCollectionLayoutBoundarySupplementaryItem {
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(44)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            return header
        }

        public static func horizontal(height: NSCollectionLayoutDimension) -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3.0),
                heightDimension: height
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 5.0
            section.contentInsets = NSDirectionalEdgeInsets(inset: 5.0)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = [header()]
            return section
        }

        public static func vertical(height: NSCollectionLayoutDimension) -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: height)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(5.0)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 5.0
            section.contentInsets = NSDirectionalEdgeInsets(inset: 5.0)
            section.boundarySupplementaryItems = [header()]
            return section
        }

        public static func grid(columns: Int, height: NSCollectionLayoutDimension) -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0 / CGFloat(columns)),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: height
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(5.0)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 5.0
            section.contentInsets = NSDirectionalEdgeInsets(inset: 5.0)
            section.boundarySupplementaryItems = [header()]
            return section
        }
    }
}

