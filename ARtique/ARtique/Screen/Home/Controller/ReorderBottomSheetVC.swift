//
//  ReorderBottomSheetVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/15.
//

import UIKit
import DynamicBottomSheet
import SnapKit
import Then

class ReorderBottomSheetVC: DynamicBottomSheetViewController {
    let orderList = ["최신순 ", "인기순 "]
    var checkedOrder = 0
    var delegate: TVCellDelegate?
    
    private var sheetTitle = UILabel()
        .then {
            $0.text = "정렬 기준"
            $0.font = .AppleSDGothicB(size: 17)
            $0.textColor = .label
        }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UINib(nibName: Identifiers.reorderTVC, bundle: nil), forCellReuseIdentifier: Identifiers.reorderTVC)
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.isScrollEnabled = false
        
        return tv
    }()
}

// MARK: - TVCellDelegat
protocol TVCellDelegate {
    func selectedTVC(sortedBy index: Int)
}

// MARK: - Configure
extension ReorderBottomSheetVC {
    override func configureView() {
        super.configureView()
        layoutView()
    }
    
    private func layoutView() {
        contentView.addSubview(sheetTitle)
        sheetTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(sheetTitle.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(-0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.height.equalTo(110)
        }
    }
}

// MARK: - UITableViewDataSource
extension ReorderBottomSheetVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.reorderTVC, for: indexPath) as? ReorderTVC else { return UITableViewCell() }
        cell.reorderTitle.text = orderList[indexPath.row]
        cell.selectionStyle = .none
        if indexPath.row == checkedOrder {
            cell.reorderTitle.textColor = .black
            cell.checkmark.isHidden = false
        } else {
            cell.reorderTitle.textColor = .gray2
            cell.checkmark.isHidden = true
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ReorderBottomSheetVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.selectedTVC(sortedBy: indexPath.row)
            dismiss(animated: true, completion: nil)
        }
    }
}
