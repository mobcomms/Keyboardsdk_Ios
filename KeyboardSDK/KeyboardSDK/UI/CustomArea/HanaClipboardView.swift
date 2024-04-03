//
//  HanaClipboardView.swift
//  KeyboardSDK
//
//  Created by ximAir on 11/27/23.
//

import Foundation

protocol HanaClipboardViewDelegate: AnyObject {
    func returnKeyboard()
    func insertClipboardText(clipboard: String)
}

class HanaClipboardView: UIView {
    weak var delegate: HanaClipboardViewDelegate? = nil
    
    var dataSource:[String] = []
    var isHiddenSelectCheck: Bool = true
    
    lazy var topLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(red: 55/255, green: 66/255, blue: 72/255, alpha: 1)
        return view
    }()
    
    lazy var emptyTitle: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.text = "클립보드가 비어있어요"
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    lazy var emptyDesc: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.text = "복사한 내용이 여기에 표시됩니다."
        lbl.textColor = UIColor(red: 157/255, green: 170/255, blue: 176/255, alpha: 1)
        lbl.font = .systemFont(ofSize: 12, weight: .regular)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view: UICollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        view.register(HanaClipboardCell.self, forCellWithReuseIdentifier: HanaClipboardCell.ID)
        view.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
        
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
        return view
    }()
    
    lazy var bottomLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(red: 28/255, green: 31/255, blue: 33/255, alpha: 1)
        return view
    }()
    
    lazy var bottomKeyboardButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.backgroundColor = .clear
        btn.setBackgroundImage(UIImage.init(named: "hanaBottomKeyboard", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
        return btn
    }()
    
    var viewSelectHeightConstraint: NSLayoutConstraint?
    lazy var viewSelect: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var btnClipboardSelect: UIButton = {
        let btn: UIButton = UIButton(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitle("클립보드 편집", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .clear
        btn.clipsToBounds = false
        return btn
    }()
    
    var viewDeleteHeightConstraint: NSLayoutConstraint?
    lazy var viewDelete: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var btnClipboardDelete: UIButton = {
        let btn: UIButton = UIButton(type: .custom)
        btn.setTitle("선택삭제", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.setTitleColor(UIColor(red: 19/255, green: 201/255, blue: 190/255, alpha: 1), for: .normal)
        btn.setImage(UIImage.init(named: "hanaClipboardDelete", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
        btn.backgroundColor = .clear
        btn.clipsToBounds = true
        return btn
    }()
    lazy var btnCancel: UIButton = {
        let btn: UIButton = UIButton(type: .custom)
        btn.setTitle("취소", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.setTitleColor(.white, for: .normal)
        btn.clipsToBounds = false
        return btn
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    
    func initLayout() {
        self.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
        
        self.addSubview(topLine)
        
        topLine.translatesAutoresizingMaskIntoConstraints = false
        topLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        topLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topLine.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        self.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        bottomView.addSubview(bottomLine)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        bottomLine.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        bottomView.addSubview(bottomKeyboardButton)
        bottomKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        bottomKeyboardButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bottomKeyboardButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bottomKeyboardButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 18).isActive = true
        bottomKeyboardButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        bottomKeyboardButton.addTarget(self, action: #selector(bottomKeyboardHandler), for: .touchUpInside)
        
        bottomView.addSubview(viewSelect)
        viewSelect.translatesAutoresizingMaskIntoConstraints = false
        viewSelect.leadingAnchor.constraint(equalTo: bottomKeyboardButton.trailingAnchor).isActive = true
        viewSelect.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        viewSelect.topAnchor.constraint(equalTo: bottomLine.bottomAnchor).isActive = true
        viewSelectHeightConstraint = viewSelect.heightAnchor.constraint(equalToConstant: 45)
        viewSelectHeightConstraint?.isActive = true
        
        viewSelect.addSubview(btnClipboardSelect)
        btnClipboardSelect.translatesAutoresizingMaskIntoConstraints = false
        btnClipboardSelect.trailingAnchor.constraint(equalTo: viewSelect.trailingAnchor, constant: -18).isActive = true
        btnClipboardSelect.topAnchor.constraint(equalTo: viewSelect.topAnchor).isActive = true
        btnClipboardSelect.bottomAnchor.constraint(equalTo: viewSelect.bottomAnchor).isActive = true
        btnClipboardSelect.widthAnchor.constraint(equalToConstant: 70).isActive = true
        btnClipboardSelect.addTarget(self, action: #selector(btnClipboardSelectHandler), for: .touchUpInside)
        
        bottomView.addSubview(viewDelete)
        viewDelete.translatesAutoresizingMaskIntoConstraints = false
        viewDelete.leadingAnchor.constraint(equalTo: bottomKeyboardButton.trailingAnchor).isActive = true
        viewDelete.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        viewDelete.topAnchor.constraint(equalTo: bottomLine.bottomAnchor).isActive = true
        viewDeleteHeightConstraint = viewDelete.heightAnchor.constraint(equalToConstant: 45)
        viewDeleteHeightConstraint?.isActive = true
        
        viewDelete.addSubview(btnCancel)
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        btnCancel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -18).isActive = true
        btnCancel.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btnCancel.topAnchor.constraint(equalTo: viewDelete.topAnchor).isActive = true
        btnCancel.bottomAnchor.constraint(equalTo: viewDelete.bottomAnchor).isActive = true
        btnCancel.addTarget(self, action: #selector(btnCancelHandler), for: .touchUpInside)
        
        viewDelete.addSubview(btnClipboardDelete)
        btnClipboardDelete.translatesAutoresizingMaskIntoConstraints = false
        btnClipboardDelete.trailingAnchor.constraint(equalTo: btnCancel.leadingAnchor, constant: -19).isActive = true
        btnClipboardDelete.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btnClipboardDelete.topAnchor.constraint(equalTo: viewDelete.topAnchor).isActive = true
        btnClipboardDelete.bottomAnchor.constraint(equalTo: viewDelete.bottomAnchor).isActive = true
        btnClipboardDelete.addTarget(self, action: #selector(btnClipboardDeleteHandler), for: .touchUpInside)
        
        self.addSubview(emptyTitle)
        emptyTitle.translatesAutoresizingMaskIntoConstraints = false
        emptyTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        emptyTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        emptyTitle.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 22).isActive = true
        emptyTitle.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        self.addSubview(emptyDesc)
        emptyDesc.translatesAutoresizingMaskIntoConstraints = false
        emptyDesc.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        emptyDesc.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        emptyDesc.topAnchor.constraint(equalTo: emptyTitle.bottomAnchor).isActive = true
        emptyDesc.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topLine.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        dataSource = UserDefaults.standard.getSavedClipBoardData()
        
        if dataSource.isEmpty || dataSource.count == 0 {
            //print("비었다.")
            collectionView.isHidden = true
            emptyTitle.isHidden = false
            emptyDesc.isHidden = false
            
            viewSelect.isHidden = true
            
            viewDelete.isHidden = true
        } else {
           // print("있다.")
            collectionView.isHidden = false
            emptyTitle.isHidden = true
            emptyDesc.isHidden = true
            
            viewSelect.isHidden = false
            viewSelectHeightConstraint?.constant = 45
            viewDelete.isHidden = true
            viewDeleteHeightConstraint?.constant = 0
        }
    }
    
    @objc func bottomKeyboardHandler() {
        if let del = delegate {
            del.returnKeyboard()
        }
    }
    
    @objc func btnClipboardSelectHandler() {
        print("btnClipboardSelectHandler")
        collectionView.allowsMultipleSelection = true
        
        viewSelectHeightConstraint?.constant = 0
        viewSelect.isHidden = true
        
        viewDeleteHeightConstraint?.constant = 45
        viewDelete.isHidden = false
        
        btnCancel.layer.addBorder([.left], color: UIColor(red: 82/255, green: 92/255, blue: 98/255, alpha: 1), width: 1)
        
        isHiddenSelectCheck = false
        collectionView.reloadData()
    }
    
    @objc func btnCancelHandler() {
        print("btnCancelHandler")
        collectionView.allowsMultipleSelection = false
        
        viewDeleteHeightConstraint?.constant = 0
        viewDelete.isHidden = true
        
        viewSelectHeightConstraint?.constant = 45
        viewSelect.isHidden = false
        
        isHiddenSelectCheck = true
        collectionView.reloadData()
    }
    
    @objc func btnClipboardDeleteHandler() {
        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else {
            return
        }
        
        let sortedIndexPaths = selectedIndexPaths.sorted(by: { $0.item > $1.item })
        
        for indexPath in sortedIndexPaths {
            dataSource.remove(at: indexPath.item)
        }
        
        UserDefaults.standard.saveClipboardData(clipboard: dataSource)
        
        collectionView.reloadData()
        
        if dataSource.isEmpty || dataSource.count == 0 {
            collectionView.isHidden = true
            emptyTitle.isHidden = false
            emptyDesc.isHidden = false
            
            viewSelectHeightConstraint?.constant = 45
            viewSelect.isHidden = true
            
            viewDeleteHeightConstraint?.constant = 0
            viewDelete.isHidden = true
        }
    }
}

extension HanaClipboardView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 110, height: 84) // 각 셀의 크기
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 8 // 섹션 내의 셀 간의 수평 간격
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10) // 콜렉션 뷰의 내부 여백
       }
}

extension HanaClipboardView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.allowsMultipleSelection {
            
            let targetCell = collectionView.cellForItem(at: indexPath)
            
            if let cell = targetCell as? HanaClipboardCell {
                if cell.isSelected == false {
                    cell.isSelected = true
                    cell.img.image = UIImage.init(named: "hanaClipboardCheck", in: Bundle.frameworkBundle, compatibleWith: nil)
                }
            }
            
        } else {
            // 여기는 텍스트 보내야함
            let targetCell = collectionView.cellForItem(at: indexPath)
            
            if let cell = targetCell as? HanaClipboardCell {
                if let clip = cell.lbl.text {
                    if let del = delegate {
                        del.insertClipboardText(clipboard: clip)
                    }
                }
            }
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.allowsMultipleSelection {
            let targetCell = collectionView.cellForItem(at: indexPath)
            
            if let cell = targetCell as? HanaClipboardCell {
                if cell.isSelected == true {
                    cell.isSelected = false
                    cell.img.image = UIImage.init(named: "hanaClipboardUnCheck", in: Bundle.frameworkBundle, compatibleWith: nil)
                }
            }
        }
        return true
    }
}

extension HanaClipboardView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HanaClipboardCell.ID, for: indexPath) as? HanaClipboardCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: HanaClipboardCell.ID, for: indexPath)
        }
        cell.backgroundColor = .white
        cell.setLabelText(data: dataSource[indexPath.row])
        cell.img.image = UIImage.init(named: "hanaClipboardUnCheck", in: Bundle.frameworkBundle, compatibleWith: nil)
        cell.img.isHidden = isHiddenSelectCheck
        cell.isSelected = false
        
        return cell
    }
}

class HanaClipboardCell: UICollectionViewCell {
    static let ID: String = "HanaClipboardCell"
    
    lazy var lbl: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .black
        lbl.text = "no"
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.numberOfLines = 4
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    lazy var img: UIImageView = {
        let img: UIImageView = UIImageView()
        img.image = UIImage.init(named: "hanaClipboardUnCheck", in: Bundle.frameworkBundle, compatibleWith: nil)
        img.backgroundColor = .clear
        img.isHidden = true
        return img
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        settingView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingView()
    }
    
    func settingView() {
        self.addSubview(lbl)
        self.layer.cornerRadius = 8
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        lbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        lbl.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lbl.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(img)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 24).isActive = true
        img.heightAnchor.constraint(equalToConstant: 24).isActive = true
        img.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        img.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    func setLabelText(data: String) {
        lbl.text = data
    }
}
