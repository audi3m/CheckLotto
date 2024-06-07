//
//  ViewController.swift
//  CheckLotto
//
//  Created by J Oh on 6/5/24.
//

import UIKit
import Alamofire
import SnapKit

class ViewController: UIViewController {
    
    let numberPickerField = UITextField()
    let infoLabel = UILabel()
    let infoDateLabel = UILabel()
    let divider = UIView()
    let resultLabel = UILabel()
    
    let num1Label = UILabel()
    let num2Label = UILabel()
    let num3Label = UILabel()
    let num4Label = UILabel()
    let num5Label = UILabel()
    let num6Label = UILabel()
    let plusLabel = UILabel()
    let bonusLabel = UILabel()
    
    let firstAmtLabel = UILabel()
    
    let picker = UIPickerView()
    var numbers: [Int] = []
    var round: Int = 0 {
        didSet {
            resultLabel.text = "로딩중"
            numberPickerField.text = round.formatted()
            requestLotto(round: round)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        
        configHierarchy()
        configLayout()
        configUI()
        
        recentLotto { recentRound in
            self.round = recentRound
            self.numbers = Array(1...recentRound)
        }
        
    }
    
    func configHierarchy() {
        view.addSubview(numberPickerField)
        view.addSubview(infoLabel)
        view.addSubview(infoDateLabel)
        view.addSubview(divider)
        view.addSubview(resultLabel)
        
        view.addSubview(num1Label)
        view.addSubview(num2Label)
        view.addSubview(num3Label)
        view.addSubview(num4Label)
        view.addSubview(num5Label)
        view.addSubview(num6Label)
        view.addSubview(plusLabel)
        view.addSubview(bonusLabel)
        
        view.addSubview(firstAmtLabel)
    }
    
    func configLayout() {
        numberPickerField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(numberPickerField.snp.bottom).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(40)
        }
        
        infoDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(infoLabel.snp.centerY)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(divider.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        // 12312312312342342
        num1Label.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.size.equalTo(40)
        }
        
        num2Label.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(20)
            make.leading.equalTo(num1Label.snp.trailing).offset(5)
            make.size.equalTo(40)
        }
        
        num3Label.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(20)
            make.leading.equalTo(num2Label.snp.trailing).offset(5)
            make.size.equalTo(40)
        }
        
        num4Label.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(20)
            make.leading.equalTo(num3Label.snp.trailing).offset(5)
            make.size.equalTo(40)
        }
        
        num5Label.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(20)
            make.leading.equalTo(num4Label.snp.trailing).offset(5)
            make.size.equalTo(40)
        }
        
        num6Label.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(20)
            make.leading.equalTo(num5Label.snp.trailing).offset(5)
            make.size.equalTo(40)
        }
        
        plusLabel.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(20)
            make.leading.equalTo(num6Label.snp.trailing).offset(5)
            make.height.equalTo(40)
        }
        
        bonusLabel.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(20)
            make.leading.equalTo(plusLabel.snp.trailing).offset(5)
            make.size.equalTo(40)
        }
        
        firstAmtLabel.snp.makeConstraints { make in
            make.top.equalTo(num1Label.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            
        }
    }
    
    func configUI() {
        view.backgroundColor = .white
        
        // 1,122
        numberPickerField.placeholder = "회차 검색"
        numberPickerField.textAlignment = .center
        numberPickerField.borderStyle = .roundedRect
        numberPickerField.backgroundColor = .systemGray6
        numberPickerField.font = .boldSystemFont(ofSize: 20)
        numberPickerField.tintColor = .clear
        numberPickerField.inputView = picker
        
        infoLabel.text = "당첨번호 안내"
        infoLabel.font = .boldSystemFont(ofSize: 15)
        
        // 2024-06-01 추첨
        infoDateLabel.text = ""
        infoDateLabel.font = .boldSystemFont(ofSize: 13)
        infoDateLabel.textColor = .lightGray
        
        divider.backgroundColor = .systemGray5
        
        // 1122회 당첨결과
        resultLabel.text = "로딩중"
        resultLabel.font = .boldSystemFont(ofSize: 25)
        
        // 3 6 21 30 34 35 + 22
        circleText(label: num1Label)
        circleText(label: num2Label)
        circleText(label: num3Label)
        circleText(label: num4Label)
        circleText(label: num5Label)
        circleText(label: num6Label)
        circleText(label: bonusLabel)
        
        plusLabel.text = ""
        plusLabel.font = .boldSystemFont(ofSize: 25)
        
        firstAmtLabel.text = ""
        firstAmtLabel.textAlignment = .center
        firstAmtLabel.numberOfLines = 0
        firstAmtLabel.font = .systemFont(ofSize: 25)
        firstAmtLabel.textColor = .gray
        
    }
    
    func recentLotto(completion: @escaping (Int) -> Void) {
        let round = 1100
        
        func checkRound(_ currentRound: Int) {
            let url = APIKey.lottoUrl + String(currentRound)
            AF.request(url).responseDecodable(of: Lotto.self) { response in
                switch response.result {
                case .success:
                    checkRound(currentRound + 1)
                case .failure:
                    completion(currentRound - 1)
                }
            }
        }
        
        checkRound(round)
    }
    
    func defaultLotto() {
        num1Label.text = ""
        num2Label.text = ""
        num3Label.text = ""
        num4Label.text = ""
        num5Label.text = ""
        num6Label.text = ""
        bonusLabel.text = ""
        
        plusLabel.text = ""
        
        num1Label.backgroundColor = .clear
        num2Label.backgroundColor = .clear
        num3Label.backgroundColor = .clear
        num4Label.backgroundColor = .clear
        num5Label.backgroundColor = .clear
        num6Label.backgroundColor = .clear
        bonusLabel.backgroundColor = .clear
    }
    
    func configNumbers(lotto: Lotto) {
        num1Label.text = "\(lotto.drwtNo1)"
        num2Label.text = "\(lotto.drwtNo2)"
        num3Label.text = "\(lotto.drwtNo3)"
        num4Label.text = "\(lotto.drwtNo4)"
        num5Label.text = "\(lotto.drwtNo5)"
        num6Label.text = "\(lotto.drwtNo6)"
        bonusLabel.text = "\(lotto.bnusNo)"
        
        plusLabel.text = "+"
        
        num1Label.backgroundColor = numberColor(number: lotto.drwtNo1)
        num2Label.backgroundColor = numberColor(number: lotto.drwtNo2)
        num3Label.backgroundColor = numberColor(number: lotto.drwtNo3)
        num4Label.backgroundColor = numberColor(number: lotto.drwtNo4)
        num5Label.backgroundColor = numberColor(number: lotto.drwtNo5)
        num6Label.backgroundColor = numberColor(number: lotto.drwtNo6)
        bonusLabel.backgroundColor = numberColor(number: lotto.bnusNo)
    }
    
    func circleText(label: UILabel, number: Int = 0) {
        label.text = ""
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.backgroundColor = numberColor(number: number)
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 23)
    }
    
    func numberColor(number: Int) -> UIColor {
        switch number {
        case 1...10: .systemYellow
        case 11...20: .systemBlue
        case 21...30: .systemRed
        case 31...40: .systemGray
        case 41...45: .systemGreen
        default: .clear
        }
    }
}

extension ViewController {
    func requestLotto(round: Int) {
        let url = APIKey.lottoUrl + String(round)
        AF.request(url).responseDecodable(of: Lotto.self) { response in
            switch response.result {
            case .success(let value):
                print(value)
                self.resultLabel.text = "\(value.drwNo)회 당첨결과"
                self.configNumbers(lotto: value)
                self.infoDateLabel.text = value.drwDate
                self.firstAmtLabel.text = "1등 당첨금액 (\(value.firstPrzwnerCo))\n\(value.firstWinamnt.formatted())원"
                self.picker.selectRow(round-1, inComponent: 0, animated: true)
                
            case .failure(let error):
                print(error)
                self.resultLabel.text = "\(round)회 로딩 실패"
                self.infoDateLabel.text = ""
                self.firstAmtLabel.text = ""
                self.defaultLotto()
            }
        }
    }
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        numbers.count
    }
    
    // 선택했을 때
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.round = numbers[row]
    }
    
    // Picker 문자
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        numbers[row].formatted()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}


//노란색: 1-10
//파란색: 11-20
//빨간색: 21-30
//회색: 31-40
//초록색: 41-45

