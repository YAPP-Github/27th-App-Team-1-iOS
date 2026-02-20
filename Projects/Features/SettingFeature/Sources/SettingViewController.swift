//
//  SettingViewController.swift
//  SettingFeature
//
//  Created by 최안용 on 2/9/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

import RIBs
import RxSwift

public protocol SettingPresentableListener: AnyObject {
    func detachSetting()
    func didTapMenu(item: SettingCellItem)
}

final class SettingViewController: UIViewController, SettingPresentable, SettingViewControllable {
    weak var listener: SettingPresentableListener?
    
    private let navigationBar = NDGLNavigationBar(
        title: "설정",
        leadingIcon: DSKitAsset.Assets.icChevronLeft3.image
    )
    private let tableView = UITableView()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        setDelegate()
        setupActions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent {
            listener?.detachSetting()
        }
    }
    
    func copyToClipboard() {
        UIPasteboard.general.string = UserDefaults.standard.string(forKey: "uuid") ?? "오류 발생"
        Toast.show(
            type: .success,
            message: "클립보드 저장이 완료되었습니다.",
            bottomPadding: 50
        )
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
    }
}

private extension SettingViewController {
    func setStyle() {
        view.backgroundColor = DSKitAsset.Colors.white.color
        
        tableView.do {
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
            $0.separatorStyle = .singleLine
            $0.separatorColor = DSKitAsset.Colors.black50.color
        }
    }
    
    func setUI() {
        view.addSubviews(navigationBar, tableView)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24.adjustedH)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SettingMenuCell.self, forCellReuseIdentifier: SettingMenuCell.cellIdentifier)
    }
    
    func setupActions() {
        navigationBar.leadingButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        SettingSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingSection.allCases[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let menu = SettingSection.allCases[indexPath.section].items[indexPath.row]
        return menu.cellType.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingMenuCell.cellIdentifier,
            for: indexPath
        ) as? SettingMenuCell else { return UITableViewCell() }
        
        let menu = SettingSection.allCases[indexPath.section].items[indexPath.row]
        let type = menu.cellType
        
        cell.configure(title: menu.title, type: type)
        
//        if menu == .notification {
//            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
//        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 25.adjusted, bottom: 0, right: 24.adjusted)
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let menu = SettingSection.allCases[indexPath.section].items[indexPath.row]
        
        switch menu.cellType {
        case .toggle, .icon:
            listener?.didTapMenu(item: menu)
        default:
            break
        }
    }
}
