//
//  HotBoardHeaderView.swift
//  MainFeature
//
//  Created by Aiden.lee on 7/6/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit
import Domain

final class HotBoardHeaderView: UICollectionReusableView {

  // MARK: - Properties

  private var hotBoard: HotBoardModel?
  var hotBoardTap = PassthroughSubject<HotBoardModel, Never>()
  var cancelBag = CancelBag()

  // MARK: - UI Components

  private let hotImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = DSKitAsset.Assets.imgHot.image
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .Main.headline2
    label.textColor = DSKitAsset.Colors.white.color
    label.textAlignment = .left
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .Main.body2
    label.textColor = DSKitAsset.Colors.gray300.color
    label.textAlignment = .left
    return label
  }()

  private let shortCutImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = DSKitAsset.Assets.chevronRight.image
    imageView.tintColor = DSKitAsset.Colors.gray300.color
    return imageView
  }()

  private lazy var titleStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [hotImageView, titleLabel])
    stackView.axis = .horizontal
    stackView.spacing = 4
    stackView.alignment = .center
    return stackView
  }()

  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [titleStackView, descriptionLabel])
    stackView.axis = .vertical
    stackView.spacing = 2
    stackView.alignment = .leading
    return stackView
  }()

  private lazy var containerStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [contentStackView, shortCutImage])
    stackView.axis = .horizontal
    stackView.spacing = 4
    stackView.alignment = .center
    return stackView
  }()

  // MARK: - initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setUI()
    self.setLayout()
    self.addTapGesture()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    cancelBag = CancelBag()
  }
}

// MARK: - UI & Layout

extension HotBoardHeaderView {
  private func setUI() {
    self.backgroundColor = DSKitAsset.Colors.gray800.color
    self.layer.cornerRadius = 15
  }

  private func setLayout() {
    self.addSubviews(containerStackView)
    containerStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(16)
    }

    hotImageView.snp.makeConstraints { make in
      make.width.equalTo(38)
      make.height.equalTo(22)
    }

    shortCutImage.snp.makeConstraints { make in
      make.width.height.equalTo(24)
    }
  }
}

// MARK: - Methods

extension HotBoardHeaderView {
  private func addTapGesture() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    self.addGestureRecognizer(tapGestureRecognizer)
  }

  @objc
  private func handleTap() {
    guard let hotBoard else { return }
    self.hotBoardTap.send(hotBoard)
  }

  func initCell(_ hotBoard: HotBoardModel) {
    self.hotBoard = hotBoard
    titleLabel.text = hotBoard.title
    descriptionLabel.text = hotBoard.content
  }
}

