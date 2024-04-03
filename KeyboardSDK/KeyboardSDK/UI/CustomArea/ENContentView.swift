//
//  ENContentView.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2024/02/13.
//

import Foundation

protocol ENContentViewDelegate: AnyObject {
    func returnKeyboard()
    func goToContentLink(url: String)
}
class ENContentViewCell: UICollectionViewCell {
    static let ID: String = "ENContentViewCell"
    lazy var cellItem: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var cellImage: UIImageView = {
        let imgView: UIImageView = UIImageView()
        imgView.backgroundColor = .clear
        return imgView
    }()
    lazy var lbl: UILabel = {
        let lbl: UILabel = UILabel()
        
        lbl.textColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.key_text
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 13)
        lbl.backgroundColor = .clear
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byClipping
        return lbl
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
        self.addSubview(cellItem)
        let itemWidth: CGFloat = 60
        let itemHeight: CGFloat = 104
        let imageWidth: CGFloat = 60
        let imageHeight: CGFloat = 60
        let lblTopMargin: CGFloat = 4
        let lblHeight: CGFloat = itemHeight - imageHeight - lblTopMargin

        self.layer.cornerRadius = 8
        cellItem.translatesAutoresizingMaskIntoConstraints = false
        cellItem.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
        cellItem.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
        cellItem.addSubview(cellImage)
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        cellImage.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        cellImage.topAnchor.constraint(equalTo: cellItem.topAnchor).isActive = true
        cellImage.leadingAnchor.constraint(equalTo: cellItem.leadingAnchor).isActive = true
        cellImage.trailingAnchor.constraint(equalTo: cellItem.trailingAnchor).isActive = true
        cellItem.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.topAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: lblTopMargin).isActive = true
        lbl.heightAnchor.constraint(equalToConstant: lblHeight).isActive = true
        lbl.leadingAnchor.constraint(equalTo: cellItem.leadingAnchor).isActive = true
        lbl.trailingAnchor.constraint(equalTo: cellItem.trailingAnchor).isActive = true
        
    }
   
    func setCellData(data : ENContentAPIInnerModel){
        lbl.text = data.name + "\n"
        cellImage.loadImageAsync(with: data.imageUrl)


    }
}

class ENContentView: UIView {
    weak var delegate: ENContentViewDelegate? = nil
    var dataSource:[ENContentAPIInnerModel] = []

    

    lazy var topLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.top_line

        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view: UICollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        view.register(ENContentViewCell.self, forCellWithReuseIdentifier: ENContentViewCell.ID)
        view.backgroundColor = .clear
        return view
    }()

    
    lazy var bottomLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.top_line
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var bottomKeyboardButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.backgroundColor = .clear
        let image = UIImage.init(named: "ENBottomKeyboard", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        btn.setImage(image, for: .normal)
        btn.tintColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.key_text
        return btn
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        settingViewConstraint()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingViewConstraint()
    }
    
    func settingViewConstraint() {
        self.backgroundColor = .white
        // 탑 라인 세팅
        self.addSubview(topLine)
        topLine.translatesAutoresizingMaskIntoConstraints = false
        topLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        topLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topLine.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        // 바텀 뷰 세팅
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
        

        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topLine.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        collectionView.allowsMultipleSelection = false

        collectionView.delegate = self
        collectionView.dataSource = self
       
        dataSetting()
    }
    
    func dataSetting() {

        ENKeyboardAPIManeger.shared.getTabDetail() {[weak self] data, response, error in
            guard let self else { return }
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                if let jsonData = jsonString.data(using: .utf8) {
                    #if DEBUG
                    print("jsonString: \(jsonString)")
                    #endif

                    do {
                        let data = try JSONDecoder().decode(ENContentAPIModel.self, from: jsonData)
                        #if DEBUG
                        print("saveKeyboardTypeAPI result : \(data.Result)")
                        #endif

                        if data.Result == "true" {
                            dataSource = data.list
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                            
                            
                        }
                        
                    } catch {
                        print("error")
                    }
                }
            }
        }
    }
    
    @objc func bottomKeyboardHandler() {
        if let del = delegate {
            del.returnKeyboard()
        }
    }
    
}

struct ENContentAPIInnerModel: Codable {
    let link: String
    let name: String
    let imageUrl: String
}

struct ENContentAPIModel: Codable {
    let Result: String
    let list: [ENContentAPIInnerModel]
}

class ENTapGesture: UITapGestureRecognizer {
    var title: String?
}


extension ENContentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 60, height: 104) // 각 셀의 크기
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 10 // 섹션 내의 셀 간의 수평 간격
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10) // 콜렉션 뷰의 내부 여백
       }
}

extension ENContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
            // 여기는 텍스트 보내야함
            let targetCell = collectionView.cellForItem(at: indexPath)
            
            if let cell = targetCell as? ENContentViewCell {
                if let clip = cell.lbl.text {
                    if let del = delegate {
                        let data = dataSource[indexPath.row]
                        del.goToContentLink(url: data.link)
                    }
                }
            }
        
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ENContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ENContentViewCell.ID, for: indexPath) as? ENContentViewCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ENContentViewCell.ID, for: indexPath)
        }
        cell.backgroundColor = .clear
        cell.setCellData(data: dataSource[indexPath.row])
        cell.isSelected = false
        cell.layoutIfNeeded()
        return cell
    }
}
